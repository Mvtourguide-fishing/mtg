#!/usr/bin/env node
// Generates a Supabase SQL migration from the source-of-truth diving data
// in data/maldives/diving/*.json. This is Task 8's counterpart to
// scripts/generate-fishing-seed.mjs, and follows the exact same pattern,
// with one addition: diving has TWO distinct kinds of source rows.
//
//   - activities.json  -> commercial, bookable diving ACTIVITIES. These
//     reuse the common `activities` table (activity_category = 'diving'),
//     exactly like fishing. Diving TYPE (fun dive, course, night dive, ...)
//     is a categories/node_categories tag (category_group = 'activity-type'),
//     not a column, matching Task 7's "taxonomy, not booleans" rule.
//
//   - dive_sites.json  -> physical dive SITES (reefs, thilas, channels,
//     wrecks, caves). These are NOT activities and NEVER get a
//     bookable_products row. They are `locations` rows with
//     location_type = 'dive_site', parented under their atoll (the
//     location_type_hierarchy_rules already permit atoll -> dive_site and
//     island -> dive_site, seeded since Task 3 — no schema change needed).
//     Depth/experience/current/marine-life detail — genuinely flexible,
//     category-specific descriptive attributes — live in nodes.attributes
//     JSONB, exactly as the architecture doc's own example anticipates.
//     A site's nearby island (when the source names one) is recorded as a
//     *secondary* node_locations row from the site to that island; this is
//     separate from the site's atoll parent_id, which is the hierarchy
//     relationship.
//
// Deterministic and idempotent: every insert is keyed by slug with
// `ON CONFLICT ... DO NOTHING`, same convention as the Task 4-7 generators.
//
// Usage: node scripts/generate-diving-seed.mjs

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const LOCATIONS_DATA_DIR = path.join(ROOT, "data", "maldives", "locations");
const DIVING_DATA_DIR = path.join(ROOT, "data", "maldives", "diving");
const MIGRATION_PATH = path.join(
  ROOT,
  "supabase",
  "migrations",
  "20250106000100_seed_diving.sql",
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

// Human-readable labels for every diving type the task brief anticipated.
// Only the ones actually present in activities.json (plus the three
// pre-existing Task 6 diving activities, tagged below by their own
// unambiguous product names) get a category row — this is a label lookup,
// not a seeding decision.
const DIVING_TYPE_LABEL = {
  discover_scuba_diving: "Discover Scuba Diving",
  fun_diving: "Fun Diving",
  guided_diving: "Guided Diving",
  boat_diving: "Boat Diving",
  shore_diving: "Shore Diving",
  night_diving: "Night Diving",
  wreck_diving: "Wreck Diving",
  drift_diving: "Drift Diving",
  reef_diving: "Reef Diving",
  dive_course: "Dive Courses",
  technical_diving: "Technical Diving",
  freediving: "Freediving",
};

// The three diving activities already seeded in Task 6, before the
// diving-type taxonomy existed. Tagged here from their own product names
// only (no new facts) so the type filter isn't missing 3/17 activities.
const PRE_EXISTING_ACTIVITY_TYPE_TAGS = [
  { activitySlug: "discover-scuba-diving-dsd", type: "discover_scuba_diving" },
  { activitySlug: "padi-open-water-diver-course", type: "dive_course" },
  { activitySlug: "guided-reef-dive", type: "reef_diving" },
];

const VALID_SITE_TYPES = new Set(["reef", "thila", "channel", "wreck", "pinnacle", "wall", "cave"]);

// Activity slugs already seeded by Task 6/7 (20250104000100_seed_activities.sql,
// 20250105000100_seed_fishing.sql). assignUniqueSlug's collision detection only
// sees slugs assigned *within this run*, so without this seed a same-named new
// diving product (e.g. "PADI Open Water Diver Course", which recurs across
// several real operators) would silently slugify to an already-used slug,
// pass its own ON CONFLICT DO NOTHING as a no-op, and then corrupt the
// pre-existing node by attaching a second primary location to it.
const PRE_EXISTING_ACTIVITY_SLUGS = [
  "big-game-fishing-trip",
  "big-game-fishing-trip-lankanfushi",
  "discover-scuba-diving-dsd",
  "fishing-is-a-family-matter",
  "full-day-snorkeling-island-hopping-tour",
  "golden-reel-adventure",
  "guided-reef-dive",
  "male-guided-tour",
  "marlin-big-game-fishing-charter",
  "night-fishing-excursion",
  "night-fishing-trip",
  "padi-open-water-diver-course",
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
  const divingActivities = loadJson(DIVING_DATA_DIR, "activities.json");
  const diveSites = loadJson(DIVING_DATA_DIR, "dive_sites.json");

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
  const usedSiteSlugs = new Set();
  const warnings = [];
  const lines = [];

  lines.push("-- MTG: diving vertical seed (Task 8).");
  lines.push("-- GENERATED FILE — do not hand-edit. Source of truth:");
  lines.push("--   data/maldives/diving/activities.json");
  lines.push("--   data/maldives/diving/dive_sites.json");
  lines.push("--   data/maldives/diving/SOURCES.md");
  lines.push("-- Regenerate with: node scripts/generate-diving-seed.mjs");
  lines.push("--");
  lines.push("-- Idempotent (ON CONFLICT DO NOTHING, keyed by slug). Diving activities use");
  lines.push("-- the same `activities` table as every other activity (activity_category =");
  lines.push("-- 'diving'); diving TYPE is a categories/node_categories tag (category_group =");
  lines.push("-- 'activity-type'), not a column, matching Task 7 §2. Dive SITES are physical");
  lines.push("-- locations (location_type = 'dive_site', parented under their atoll) — they");
  lines.push("-- are never activities and never get a bookable_products row. Providers are");
  lines.push("-- reused from Task 5/6/7 by exact name match where they apply (harmless no-op");
  lines.push("-- insert against the existing row).");
  lines.push("");

  // ── Diving-type taxonomy (categories) ────────────────────────────
  const usedTypes = Array.from(
    new Set([
      ...divingActivities.map((a) => a.diving_type).filter(Boolean),
      ...PRE_EXISTING_ACTIVITY_TYPE_TAGS.map((t) => t.type),
    ]),
  );
  const typeSlugByValue = new Map();

  lines.push("-- Diving-type taxonomy (category_group = 'activity-type') — only the types");
  lines.push("-- actually used by a sourced activity below (new or pre-existing) are seeded.");
  for (const value of usedTypes) {
    const label = DIVING_TYPE_LABEL[value];
    if (!label) {
      warnings.push(`Unknown diving_type "${value}" — no label mapping, skipping category creation`);
      continue;
    }
    const slug = assignUniqueSlug(label, usedCategorySlugs, "diving-type");
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

  // ── Providers referenced by diving activities ────────────────────
  const distinctOperators = Array.from(
    new Set(divingActivities.map((a) => a.operator_name).filter((n) => Boolean(n))),
  );
  const providerSlugByName = new Map();

  if (distinctOperators.length > 0) {
    lines.push("-- Providers (reused from Task 5/6/7 where the name matches exactly, else new)");
    for (const name of distinctOperators) {
      const slug = assignUniqueSlug(name, usedProviderSlugs, "diving-provider");
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

  // ── Diving activities ─────────────────────────────────────────────
  lines.push("-- Diving activities");
  let skipped = 0;
  for (const act of divingActivities) {
    if (!act.name || !act.island_name || !act.atoll_administrative_code) {
      warnings.push(`Skipping malformed diving activity entry: ${JSON.stringify(act)}`);
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
    const typeSlug = act.diving_type ? typeSlugByValue.get(act.diving_type) ?? null : null;
    const typeLabel = act.diving_type ? DIVING_TYPE_LABEL[act.diving_type] : null;

    const slug = assignUniqueSlug(act.name, usedActivitySlugs, act.island_name);

    let summary = `${act.name} is a${typeLabel ? ` ${typeLabel.toLowerCase()}` : " diving"} activity on ${act.island_name}, ${atollName}.`;
    if (act.duration_minutes) summary += ` Duration: ${act.duration_minutes} minutes.`;
    if (act.operator_name) summary += ` It is operated by ${act.operator_name}.`;
    const metaTitle = `${act.name} | Maldives Diving | MTG`;

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
    lines.push(`  n.id, 'diving',`);
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

    // Only where the source names a specific dive site this activity visits
    // (secondary location tag — the island above stays the primary).
    const visitedSiteNames = Array.isArray(act.dive_site_names) ? act.dive_site_names : [];
    for (const siteName of visitedSiteNames) {
      const siteSlug = slugify(siteName);
      lines.push(`insert into node_locations (node_id, location_id, relation)`);
      lines.push(`select n.id, l.id, 'secondary'`);
      lines.push(`from nodes n, nodes l`);
      lines.push(`where n.node_type = 'activity' and n.slug = ${sqlString(slug)}`);
      lines.push(`  and l.node_type = 'location' and l.slug = ${sqlString(siteSlug)}`);
      lines.push(`on conflict (node_id, location_id) do nothing;`);
      lines.push("");
    }

    lines.push(`insert into bookable_products (id, booking_mode)`);
    lines.push(`select id, 'inquiry' from nodes where node_type = 'activity' and slug = ${sqlString(slug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");
  }

  // ── Diving-type tags for the 3 pre-existing Task 6 diving activities ──
  lines.push("-- Diving-type tags for the pre-existing Task 6 diving activities (named");
  lines.push("-- unambiguously by their own product titles — no new facts introduced).");
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

  // ── Dive sites (locations, NOT activities — never bookable) ──────
  lines.push("-- Dive sites: physical locations, location_type = 'dive_site'. These are");
  lines.push("-- never activities and never get a bookable_products row.");
  let skippedSites = 0;
  const siteSlugByName = new Map();
  for (const site of diveSites) {
    if (!site.name || !site.atoll_administrative_code) {
      warnings.push(`Skipping malformed dive site entry: ${JSON.stringify(site)}`);
      skippedSites += 1;
      continue;
    }
    const atollSlug = atollSlugByCode.get(site.atoll_administrative_code);
    if (!atollSlug) {
      warnings.push(`Skipping dive site "${site.name}" — unknown atoll_administrative_code "${site.atoll_administrative_code}"`);
      skippedSites += 1;
      continue;
    }
    if (site.site_type && !VALID_SITE_TYPES.has(site.site_type)) {
      warnings.push(`Skipping dive site "${site.name}" — invalid site_type "${site.site_type}"`);
      skippedSites += 1;
      continue;
    }

    const atollName = atolls.find((a) => a.administrative_code === site.atoll_administrative_code)?.name ?? atollSlug;
    const slug = assignUniqueSlug(site.name, usedSiteSlugs, atollSlug);
    siteSlugByName.set(site.name, slug);

    const depthPhrase =
      site.depth_min_meters !== null && site.depth_min_meters !== undefined && site.depth_max_meters !== null && site.depth_max_meters !== undefined
        ? ` Depth ranges from approximately ${site.depth_min_meters}m to ${site.depth_max_meters}m.`
        : site.depth_max_meters !== null && site.depth_max_meters !== undefined
          ? ` Depth reaches approximately ${site.depth_max_meters}m.`
          : "";
    const summary = `${site.name} is a ${site.site_type ?? "dive site"} in ${atollName}, Maldives.${depthPhrase}`;
    const metaTitle = `${site.name} | Maldives Dive Sites | MTG`;

    const attributes = {
      site_type: site.site_type ?? null,
      depth_min_meters: site.depth_min_meters ?? null,
      depth_max_meters: site.depth_max_meters ?? null,
      experience_level: site.experience_level ?? null,
      current_notes: site.current_notes ?? null,
      marine_life_notes: site.marine_life_notes ?? null,
    };

    lines.push(
      `insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)`,
    );
    lines.push(
      `values ('location', ${sqlString(slug)}, ${sqlString(site.name)}, ${sqlString(summary)}, 'published', ${sqlString(metaTitle)}, ${sqlString(summary)}, ${sqlJsonb(attributes)}, now())`,
    );
    lines.push(`on conflict (node_type, slug) do nothing;`);
    lines.push("");

    lines.push(`insert into locations (id, location_type, parent_id, path)`);
    lines.push(
      `select n.id, 'dive_site', p.id, (p_loc.path || ${sqlString(ltreeLabel(slug))}::ltree)`,
    );
    lines.push(`from nodes n, nodes p join locations p_loc on p_loc.id = p.id`);
    lines.push(`where n.node_type = 'location' and n.slug = ${sqlString(slug)}`);
    lines.push(`  and p.node_type = 'location' and p.slug = ${sqlString(atollSlug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");

    if (site.nearby_island_name) {
      const islandKey = `${site.nearby_island_name}::${site.atoll_administrative_code}`;
      const nearbyIslandSlug = islandSlugByKey.get(islandKey);
      if (!nearbyIslandSlug) {
        warnings.push(
          `"${site.name}" names nearby island "${site.nearby_island_name}" (${site.atoll_administrative_code}) which could not be resolved — skipping the nearby-island link only`,
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

  writeFileSync(MIGRATION_PATH, lines.join("\n") + "\n");

  console.log(`Wrote ${MIGRATION_PATH}`);
  console.log(
    `Diving types: ${usedTypes.length}, Providers referenced: ${distinctOperators.length}, Activities: ${divingActivities.length - skipped} (skipped ${skipped}), Dive sites: ${diveSites.length - skippedSites} (skipped ${skippedSites})`,
  );
  if (warnings.length > 0) {
    console.log(`\nWarnings (${warnings.length}):`);
    for (const w of warnings) console.log(`  - ${w}`);
  }
}

main();
