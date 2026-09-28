#!/usr/bin/env node
// Generates a Supabase SQL migration from the source-of-truth surfing data
// in data/maldives/surfing/*.json. This is Task 9's counterpart to
// scripts/generate-diving-seed.mjs, and follows the exact same pattern,
// with the same two-kinds-of-rows split as diving.
//
//   - activities.json  -> commercial, bookable surfing ACTIVITIES. These
//     reuse the common `activities` table (activity_category = 'surfing').
//     Surf TYPE (lesson, coaching, guided trip, camp, board rental, ...) is
//     a categories/node_categories tag (category_group = 'activity-type'),
//     not a column, matching Task 7/8's "taxonomy, not booleans" rule.
//
//   - surf_breaks.json -> physical surf BREAKS (reef/point/beach breaks,
//     channels). These are NOT activities and NEVER get a bookable_products
//     row. They are `locations` rows (location_type = 'surf_break',
//     parented under their atoll — the location_type_hierarchy_rules
//     already permit atoll -> surf_break and island -> surf_break, seeded
//     since Task 3, no schema change needed). Wave/season/access detail —
//     genuinely flexible, category-specific descriptive attributes — live
//     in nodes.attributes JSONB, same pattern as diving's depth/current/
//     marine-life fields. A break's nearby island (when the source names
//     one) is recorded as a *secondary* node_locations row from the break
//     to that island; separate from the break's atoll parent_id, which is
//     the hierarchy relationship.
//
// Deterministic and idempotent: every insert is keyed by slug with
// `ON CONFLICT ... DO NOTHING`, same convention as the Task 4-8 generators.
//
// Usage: node scripts/generate-surfing-seed.mjs

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const LOCATIONS_DATA_DIR = path.join(ROOT, "data", "maldives", "locations");
const SURFING_DATA_DIR = path.join(ROOT, "data", "maldives", "surfing");
const MIGRATION_PATH = path.join(
  ROOT,
  "supabase",
  "migrations",
  "20250107000100_seed_surfing.sql",
);

// Kept in sync with scripts/generate-accommodation-seed.mjs — see that
// file's identical comment for why these aren't in islands.json.
const TASK5_RESORT_ISLANDS = [
  { name: "Vihamanaafushi", atoll_administrative_code: "K" },
  { name: "Kunfunadhoo", atoll_administrative_code: "B" },
  { name: "Velassaru", atoll_administrative_code: "K" },
  { name: "Olhuveli", atoll_administrative_code: "L" },
  { name: "Baros", atoll_administrative_code: "K" },
  { name: "Lankanfushi", atoll_administrative_code: "K" },
];

// Human-readable labels for every surf type the task brief anticipated.
// Only the ones actually present in activities.json (plus the one
// pre-existing Task 6 surfing activity, tagged below by its own product
// name) get a category row — this is a label lookup, not a seeding
// decision.
const SURF_TYPE_LABEL = {
  surf_lesson: "Surf Lessons",
  surf_coaching: "Surf Coaching",
  guided_surfing: "Guided Surfing",
  surf_excursion: "Surf Excursion",
  surf_safari: "Surf Safari",
  surf_camp: "Surf Camp",
  board_rental: "Board Rental",
};

// The one surfing activity already seeded in Task 6, before the surf-type
// taxonomy existed. Tagged here from its own product name only (no new
// facts) so the type filter isn't missing 1/10 activities.
const PRE_EXISTING_ACTIVITY_TYPE_TAGS = [{ activitySlug: "private-surf-lesson-cokes", type: "surf_lesson" }];

const VALID_BREAK_TYPES = new Set(["reef_break", "point_break", "beach_break", "channel"]);

// Activity slugs already seeded by Task 6/7/8 (20250104000100_seed_activities.sql,
// 20250105000100_seed_fishing.sql, 20250106000100_seed_diving.sql).
// assignUniqueSlug's collision detection only sees slugs assigned *within
// this run*, so without this seed a same-named new surfing product would
// silently slugify to an already-used slug, pass its own ON CONFLICT DO
// NOTHING as a no-op, and then corrupt the pre-existing node by attaching
// a second primary location to it. See Task 8's generator for the bug this
// guards against (hit for real with "PADI Open Water Diver Course").
const PRE_EXISTING_ACTIVITY_SLUGS = [
  "advanced-open-water-diver-course",
  "big-game-fishing-trip",
  "big-game-fishing-trip-lankanfushi",
  "discover-scuba-diving",
  "discover-scuba-diving-dsd",
  "discover-scuba-diving-lankanfushi",
  "discover-scuba-diving-thulusdhoo",
  "discover-scuba-diving-velassaru",
  "fishing-is-a-family-matter",
  "fluo-night-diving",
  "full-day-snorkeling-island-hopping-tour",
  "fun-dive",
  "fun-dive-single-tank",
  "fun-dive-single-tank-thulusdhoo",
  "golden-reel-adventure",
  "guided-reef-dive",
  "male-guided-tour",
  "marlin-big-game-fishing-charter",
  "night-diver-specialty-course",
  "night-fishing-excursion",
  "night-fishing-trip",
  "padi-bubble-maker",
  "padi-open-water-diver-course",
  "padi-open-water-diver-course-kunfunadhoo",
  "padi-open-water-diver-course-thulusdhoo",
  "padi-open-water-diver-course-vihamanaafushi",
  "private-dolphin-cruise",
  "private-snorkeling-trip",
  "private-sport-fishing-trip",
  "private-surf-lesson-cokes",
  "sandbank-picnic",
  "sandbank-snorkeling-dolphin-watching-excursions",
  "snorkeling-dolphin-watching-sandbank-package",
  "soneva-soul-60-minute-spa-treatment",
  "sunset-dolphin-cruise",
  "sunset-dolphin-cruise-kunfunadhoo",
  "sunset-fishing-trip",
  "sunset-fishing-trip-maafushi",
  "sunset-reef-fishing",
  "traditional-handline-fishing-trip",
];

function slugify(input) {
  return input
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/['’]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

function ltreeLabel(slug) {
  return slug.replace(/-/g, "_");
}

function sqlString(value) {
  if (value === null || value === undefined) return "null";
  return `'${String(value).replace(/'/g, "''")}'`;
}

function sqlLiteral(value) {
  if (value === null || value === undefined) return "null";
  if (typeof value === "boolean") return value ? "true" : "false";
  return String(value);
}

function sqlJsonb(obj) {
  const cleaned = Object.fromEntries(Object.entries(obj).filter(([, v]) => v !== null && v !== undefined));
  if (Object.keys(cleaned).length === 0) return "'{}'::jsonb";
  return `${sqlString(JSON.stringify(cleaned))}::jsonb`;
}

function loadJson(dir, file) {
  const full = path.join(dir, file);
  if (!existsSync(full)) throw new Error(`Missing required data file: ${full}`);
  return JSON.parse(readFileSync(full, "utf8"));
}

function assignUniqueSlug(name, existingSlugs, disambiguator) {
  let slug = slugify(name);
  if (!existingSlugs.has(slug)) {
    existingSlugs.add(slug);
    return slug;
  }
  const withDisambiguator = `${slug}-${slugify(disambiguator)}`;
  if (!existingSlugs.has(withDisambiguator)) {
    existingSlugs.add(withDisambiguator);
    return withDisambiguator;
  }
  let n = 2;
  let candidate = `${withDisambiguator}-${n}`;
  while (existingSlugs.has(candidate)) {
    n += 1;
    candidate = `${withDisambiguator}-${n}`;
  }
  existingSlugs.add(candidate);
  return candidate;
}

function main() {
  const atolls = loadJson(LOCATIONS_DATA_DIR, "atolls.json");
  const seededIslands = loadJson(LOCATIONS_DATA_DIR, "islands.json");
  const surfingActivities = loadJson(SURFING_DATA_DIR, "activities.json");
  const surfBreaks = loadJson(SURFING_DATA_DIR, "surf_breaks.json");

  const atollSlugByCode = new Map();
  for (const atoll of atolls) {
    atollSlugByCode.set(atoll.administrative_code, slugify(atoll.name.replace(/\s+Atoll$/i, "")));
  }

  const islandSlugByKey = new Map();
  for (const island of seededIslands) {
    islandSlugByKey.set(`${island.name}::${island.atoll_administrative_code}`, slugify(island.name));
  }
  for (const island of TASK5_RESORT_ISLANDS) {
    islandSlugByKey.set(`${island.name}::${island.atoll_administrative_code}`, slugify(island.name));
  }

  const usedProviderSlugs = new Set();
  const usedActivitySlugs = new Set(PRE_EXISTING_ACTIVITY_SLUGS);
  const usedCategorySlugs = new Set();
  const usedBreakSlugs = new Set();
  const warnings = [];
  const lines = [];

  lines.push("-- MTG: surfing vertical seed (Task 9).");
  lines.push("-- GENERATED FILE — do not hand-edit. Source of truth:");
  lines.push("--   data/maldives/surfing/activities.json");
  lines.push("--   data/maldives/surfing/surf_breaks.json");
  lines.push("--   data/maldives/surfing/SOURCES.md");
  lines.push("-- Regenerate with: node scripts/generate-surfing-seed.mjs");
  lines.push("--");
  lines.push("-- Idempotent (ON CONFLICT DO NOTHING, keyed by slug). Surfing activities use");
  lines.push("-- the same `activities` table as every other activity (activity_category =");
  lines.push("-- 'surfing'); surf TYPE is a categories/node_categories tag (category_group =");
  lines.push("-- 'activity-type'), not a column, matching Task 7/8 §2. Surf BREAKS are");
  lines.push("-- physical locations (location_type = 'surf_break', parented under their");
  lines.push("-- atoll) — they are never activities and never get a bookable_products row.");
  lines.push("-- Providers are reused from Task 5/6/7/8 by exact name match where they apply");
  lines.push("-- (harmless no-op insert against the existing row).");
  lines.push("");

  // ── Surf-type taxonomy (categories) ──────────────────────────────
  const usedTypes = Array.from(
    new Set([
      ...surfingActivities.map((a) => a.surf_type).filter(Boolean),
      ...PRE_EXISTING_ACTIVITY_TYPE_TAGS.map((t) => t.type),
    ]),
  );
  const typeSlugByValue = new Map();

  lines.push("-- Surf-type taxonomy (category_group = 'activity-type') — only the types");
  lines.push("-- actually used by a sourced activity below (new or pre-existing) are seeded.");
  for (const value of usedTypes) {
    const label = SURF_TYPE_LABEL[value];
    if (!label) {
      warnings.push(`Unknown surf_type "${value}" — no label mapping, skipping category creation`);
      continue;
    }
    const slug = assignUniqueSlug(label, usedCategorySlugs, "surf-type");
    typeSlugByValue.set(value, slug);

    lines.push(`insert into nodes (node_type, slug, title, status, published_at)`);
    lines.push(`values ('category', ${sqlString(slug)}, ${sqlString(label)}, 'published', now())`);
    lines.push(`on conflict (node_type, slug) do nothing;`);
    lines.push("");
    lines.push(`insert into categories (id, category_group, path)`);
    lines.push(
      `select id, 'activity-type', ${sqlString(ltreeLabel(slug))}::ltree from nodes where node_type = 'category' and slug = ${sqlString(slug)}`,
    );
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");
  }

  // ── Providers referenced by surfing activities ────────────────────
  const distinctOperators = Array.from(
    new Set(surfingActivities.map((a) => a.operator_name).filter((n) => Boolean(n))),
  );
  const providerSlugByName = new Map();

  if (distinctOperators.length > 0) {
    lines.push("-- Providers (reused from Task 5/6/7/8 where the name matches exactly, else new)");
    for (const name of distinctOperators) {
      const slug = assignUniqueSlug(name, usedProviderSlugs, "surfing-provider");
      providerSlugByName.set(name, slug);
      const summary = `${name} operates activities and services in the Maldives.`;

      lines.push(`insert into nodes (node_type, slug, title, summary, status, published_at)`);
      lines.push(`values ('provider', ${sqlString(slug)}, ${sqlString(name)}, ${sqlString(summary)}, 'published', now())`);
      lines.push(`on conflict (node_type, slug) do nothing;`);
      lines.push("");
      lines.push(`insert into providers (id)`);
      lines.push(`select id from nodes where node_type = 'provider' and slug = ${sqlString(slug)}`);
      lines.push(`on conflict (id) do nothing;`);
      lines.push("");
    }
  }

  // ── Surf breaks (locations, NOT activities — never bookable). Seeded
  // BEFORE surfing activities below: an activity's surf_break_names
  // secondary node_locations link is resolved by a `select ... where
  // slug = ...` against an already-existing row — if the break didn't
  // exist yet at that point in the migration, the select would silently
  // return zero rows and the link would no-op rather than error.
  lines.push("-- Surf breaks: physical locations, location_type = 'surf_break'. These are");
  lines.push("-- never activities and never get a bookable_products row.");
  let skippedBreaks = 0;
  for (const brk of surfBreaks) {
    if (!brk.name || !brk.atoll_administrative_code) {
      warnings.push(`Skipping malformed surf break entry: ${JSON.stringify(brk)}`);
      skippedBreaks += 1;
      continue;
    }
    const atollSlug = atollSlugByCode.get(brk.atoll_administrative_code);
    if (!atollSlug) {
      warnings.push(`Skipping surf break "${brk.name}" — unknown atoll_administrative_code "${brk.atoll_administrative_code}"`);
      skippedBreaks += 1;
      continue;
    }
    if (brk.break_type && !VALID_BREAK_TYPES.has(brk.break_type)) {
      warnings.push(`Skipping surf break "${brk.name}" — invalid break_type "${brk.break_type}"`);
      skippedBreaks += 1;
      continue;
    }

    const atollName = atolls.find((a) => a.administrative_code === brk.atoll_administrative_code)?.name ?? atollSlug;
    const slug = assignUniqueSlug(brk.name, usedBreakSlugs, atollSlug);

    const typeLabel = brk.break_type ? brk.break_type.replace("_", " ") : "surf break";
    const summary = `${brk.name} is a ${typeLabel} in ${atollName}, Maldives.`;
    const metaTitle = `${brk.name} | Maldives Surf Breaks | MTG`;

    const attributes = {
      break_type: brk.break_type ?? null,
      difficulty: brk.difficulty ?? null,
      wave_notes: brk.wave_notes ?? null,
      season_notes: brk.season_notes ?? null,
      access_notes: brk.access_notes ?? null,
    };

    lines.push(
      `insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)`,
    );
    lines.push(
      `values ('location', ${sqlString(slug)}, ${sqlString(brk.name)}, ${sqlString(summary)}, 'published', ${sqlString(metaTitle)}, ${sqlString(summary)}, ${sqlJsonb(attributes)}, now())`,
    );
    lines.push(`on conflict (node_type, slug) do nothing;`);
    lines.push("");

    lines.push(`insert into locations (id, location_type, parent_id, path)`);
    lines.push(
      `select n.id, 'surf_break', p.id, (p_loc.path || ${sqlString(ltreeLabel(slug))}::ltree)`,
    );
    lines.push(`from nodes n, nodes p join locations p_loc on p_loc.id = p.id`);
    lines.push(`where n.node_type = 'location' and n.slug = ${sqlString(slug)}`);
    lines.push(`  and p.node_type = 'location' and p.slug = ${sqlString(atollSlug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");

    if (brk.nearby_island_name) {
      const islandKey = `${brk.nearby_island_name}::${brk.atoll_administrative_code}`;
      const nearbyIslandSlug = islandSlugByKey.get(islandKey);
      if (!nearbyIslandSlug) {
        warnings.push(
          `"${brk.name}" names nearby island "${brk.nearby_island_name}" (${brk.atoll_administrative_code}) which could not be resolved — skipping the nearby-island link only`,
        );
      } else {
        lines.push(`insert into node_locations (node_id, location_id, relation)`);
        lines.push(`select n.id, l.id, 'secondary'`);
        lines.push(`from nodes n, nodes l`);
        lines.push(`where n.node_type = 'location' and n.slug = ${sqlString(slug)}`);
        lines.push(`  and l.node_type = 'location' and l.slug = ${sqlString(nearbyIslandSlug)}`);
        lines.push(`on conflict (node_id, location_id) do nothing;`);
        lines.push("");
      }
    }
  }

  // ── Surfing activities ─────────────────────────────────────────────
  lines.push("-- Surfing activities");
  let skipped = 0;
  for (const act of surfingActivities) {
    if (!act.name || !act.island_name || !act.atoll_administrative_code) {
      warnings.push(`Skipping malformed surfing activity entry: ${JSON.stringify(act)}`);
      skipped += 1;
      continue;
    }

    const key = `${act.island_name}::${act.atoll_administrative_code}`;
    const islandSlug = islandSlugByKey.get(key);
    if (!islandSlug) {
      warnings.push(
        `Skipping "${act.name}" — could not resolve island "${act.island_name}" (${act.atoll_administrative_code}) against Task 4/5 locations`,
      );
      skipped += 1;
      continue;
    }

    const atollName = atolls.find((a) => a.administrative_code === act.atoll_administrative_code)?.name ?? act.atoll_administrative_code;
    const providerSlug = act.operator_name ? providerSlugByName.get(act.operator_name) ?? null : null;
    const typeSlug = act.surf_type ? typeSlugByValue.get(act.surf_type) ?? null : null;
    const typeLabel = act.surf_type ? SURF_TYPE_LABEL[act.surf_type] : null;

    const slug = assignUniqueSlug(act.name, usedActivitySlugs, act.island_name);

    let summary = `${act.name} is a${typeLabel ? ` ${typeLabel.toLowerCase()}` : " surfing"} activity on ${act.island_name}, ${atollName}.`;
    if (act.duration_minutes) summary += ` Duration: ${act.duration_minutes} minutes.`;
    if (act.operator_name) summary += ` It is operated by ${act.operator_name}.`;
    const metaTitle = `${act.name} | Maldives Surfing | MTG`;

    lines.push(`insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)`);
    lines.push(
      `values ('activity', ${sqlString(slug)}, ${sqlString(act.name)}, ${sqlString(summary)}, 'published', ${sqlString(metaTitle)}, ${sqlString(summary)}, now())`,
    );
    lines.push(`on conflict (node_type, slug) do nothing;`);
    lines.push("");

    lines.push(`insert into activities (`);
    lines.push(`  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants`);
    lines.push(`)`);
    lines.push(`select`);
    lines.push(`  n.id, 'surfing',`);
    lines.push(
      `  ${providerSlug ? `(select id from nodes where node_type = 'provider' and slug = ${sqlString(providerSlug)})` : "null"},`,
    );
    lines.push(
      `  ${sqlLiteral(act.duration_minutes)}, ${sqlLiteral(act.min_age)}, ${act.difficulty ? sqlString(act.difficulty) : "null"}, ${sqlLiteral(act.price_from)}, ${sqlLiteral(act.max_participants)}`,
    );
    lines.push(`from nodes n where n.node_type = 'activity' and n.slug = ${sqlString(slug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");

    lines.push(`insert into node_locations (node_id, location_id, relation)`);
    lines.push(`select n.id, l.id, 'primary'`);
    lines.push(`from nodes n, nodes l`);
    lines.push(`where n.node_type = 'activity' and n.slug = ${sqlString(slug)}`);
    lines.push(`  and l.node_type = 'location' and l.slug = ${sqlString(islandSlug)}`);
    lines.push(`on conflict (node_id, location_id) do nothing;`);
    lines.push("");

    if (typeSlug) {
      lines.push(`insert into node_categories (node_id, category_id)`);
      lines.push(`select n.id, c.id`);
      lines.push(`from nodes n, nodes c`);
      lines.push(`where n.node_type = 'activity' and n.slug = ${sqlString(slug)}`);
      lines.push(`  and c.node_type = 'category' and c.slug = ${sqlString(typeSlug)}`);
      lines.push(`on conflict (node_id, category_id) do nothing;`);
      lines.push("");
    }

    // Only where the source names a specific surf break this activity
    // visits (secondary location tag — the island above stays primary).
    const visitedBreakNames = Array.isArray(act.surf_break_names) ? act.surf_break_names : [];
    for (const breakName of visitedBreakNames) {
      const breakSlug = slugify(breakName);
      lines.push(`insert into node_locations (node_id, location_id, relation)`);
      lines.push(`select n.id, l.id, 'secondary'`);
      lines.push(`from nodes n, nodes l`);
      lines.push(`where n.node_type = 'activity' and n.slug = ${sqlString(slug)}`);
      lines.push(`  and l.node_type = 'location' and l.slug = ${sqlString(breakSlug)}`);
      lines.push(`on conflict (node_id, location_id) do nothing;`);
      lines.push("");
    }

    lines.push(`insert into bookable_products (id, booking_mode)`);
    lines.push(`select id, 'inquiry' from nodes where node_type = 'activity' and slug = ${sqlString(slug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");
  }

  // ── Surf-type tags for the pre-existing Task 6 surfing activity ──
  lines.push("-- Surf-type tag for the pre-existing Task 6 surfing activity (named");
  lines.push("-- unambiguously by its own product title — no new facts introduced).");
  for (const tag of PRE_EXISTING_ACTIVITY_TYPE_TAGS) {
    const typeSlug = typeSlugByValue.get(tag.type);
    if (!typeSlug) continue;
    lines.push(`insert into node_categories (node_id, category_id)`);
    lines.push(`select n.id, c.id`);
    lines.push(`from nodes n, nodes c`);
    lines.push(`where n.node_type = 'activity' and n.slug = ${sqlString(tag.activitySlug)}`);
    lines.push(`  and c.node_type = 'category' and c.slug = ${sqlString(typeSlug)}`);
    lines.push(`on conflict (node_id, category_id) do nothing;`);
    lines.push("");
  }

  writeFileSync(MIGRATION_PATH, lines.join("\n") + "\n");

  console.log(`Wrote ${MIGRATION_PATH}`);
  console.log(
    `Surf types: ${usedTypes.length}, Providers referenced: ${distinctOperators.length}, Activities: ${surfingActivities.length - skipped} (skipped ${skipped}), Surf breaks: ${surfBreaks.length - skippedBreaks} (skipped ${skippedBreaks})`,
  );
  if (warnings.length > 0) {
    console.log(`\nWarnings (${warnings.length}):`);
    for (const w of warnings) console.log(`  - ${w}`);
  }
}

main();
