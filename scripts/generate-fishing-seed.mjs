#!/usr/bin/env node
// Generates a Supabase SQL migration from the source-of-truth fishing data
// in data/maldives/fishing/*.json. Fishing activities reuse the common
// `activities` table (activity_category = 'fishing', exactly like
// scripts/generate-activity-seed.mjs) — this script's only genuinely new
// behavior is tagging each activity with its fishing TYPE (big game, night
// fishing, handline, ...) as a `categories` row (category_group =
// 'activity-type') via `node_categories`, per the architecture's
// "taxonomy, not boolean columns" rule (Task 7 §2).
//
// Deterministic and idempotent: every insert is keyed by slug with
// `ON CONFLICT ... DO NOTHING`, same convention as the Task 4-6 generators.
//
// Usage: node scripts/generate-fishing-seed.mjs

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const LOCATIONS_DATA_DIR = path.join(ROOT, "data", "maldives", "locations");
const FISHING_DATA_DIR = path.join(ROOT, "data", "maldives", "fishing");
const MIGRATION_PATH = path.join(
  ROOT,
  "supabase",
  "migrations",
  "20250105000100_seed_fishing.sql",
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

// Human-readable labels for every fishing type the task brief anticipated.
// Only the ones actually present in activities.json get a category row —
// this is a label lookup, not a seeding decision.
const FISHING_TYPE_LABEL = {
  big_game_fishing: "Big Game Fishing",
  sport_fishing: "Sport Fishing",
  trolling: "Trolling",
  bottom_fishing: "Bottom Fishing",
  reef_fishing: "Reef Fishing",
  night_fishing: "Night Fishing",
  handline_fishing: "Handline Fishing",
  traditional_fishing: "Traditional Fishing",
  jigging: "Jigging",
  casting: "Casting",
};

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
  const fishingActivities = loadJson(FISHING_DATA_DIR, "activities.json");
  const fishingSpots = existsSync(path.join(FISHING_DATA_DIR, "fishing_spots.json"))
    ? loadJson(FISHING_DATA_DIR, "fishing_spots.json")
    : [];

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
  const usedActivitySlugs = new Set();
  const usedCategorySlugs = new Set();
  const warnings = [];
  const lines = [];

  lines.push("-- MTG: fishing vertical seed (Task 7).");
  lines.push("-- GENERATED FILE — do not hand-edit. Source of truth:");
  lines.push("--   data/maldives/fishing/activities.json");
  lines.push("--   data/maldives/fishing/fishing_spots.json (currently empty — see SOURCES.md)");
  lines.push("--   data/maldives/fishing/SOURCES.md");
  lines.push("-- Regenerate with: node scripts/generate-fishing-seed.mjs");
  lines.push("--");
  lines.push("-- Idempotent (ON CONFLICT DO NOTHING, keyed by slug). Fishing activities use");
  lines.push("-- the same `activities` table as every other activity (activity_category =");
  lines.push("-- 'fishing') — no new tables. Fishing *type* is a categories/node_categories");
  lines.push("-- tag (category_group = 'activity-type'), not a column, matching Task 7 §2.");
  lines.push("-- Providers are reused from Task 5/6 by exact name match where they apply");
  lines.push("-- (harmless no-op insert against the existing row); no new locations are");
  lines.push("-- created — every activity resolves to an island already seeded by Task 4/5.");
  lines.push("");

  if (fishingSpots.length === 0) {
    lines.push("-- No fishing-specific site/ground locations seeded: no individually-named,");
    lines.push("-- multiply-cited fishing ground was found (see SOURCES.md). Fishing");
    lines.push("-- activities are geographically anchored to their departure island instead,");
    lines.push("-- which the existing location architecture already supports.");
    lines.push("");
  }

  // ── Fishing-type taxonomy (categories) ──────────────────────────
  const usedTypes = Array.from(new Set(fishingActivities.map((a) => a.fishing_type).filter(Boolean)));
  const typeSlugByValue = new Map();

  if (usedTypes.length > 0) {
    lines.push("-- Fishing-type taxonomy (category_group = 'activity-type') — only the types");
    lines.push("-- actually used by a sourced activity below are seeded.");
    for (const value of usedTypes) {
      const label = FISHING_TYPE_LABEL[value];
      if (!label) {
        warnings.push(`Unknown fishing_type "${value}" — no label mapping, skipping category creation`);
        continue;
      }
      const slug = assignUniqueSlug(label, usedCategorySlugs, "fishing-type");
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
  }

  // ── Providers referenced by fishing activities ──────────────────
  const distinctOperators = Array.from(
    new Set(fishingActivities.map((a) => a.operator_name).filter((n) => Boolean(n))),
  );
  const providerSlugByName = new Map();

  if (distinctOperators.length > 0) {
    lines.push("-- Providers (reused from Task 5/6 where the name matches exactly, else new)");
    for (const name of distinctOperators) {
      const slug = assignUniqueSlug(name, usedProviderSlugs, "fishing-provider");
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

  // ── Fishing activities ───────────────────────────────────────────
  lines.push("-- Fishing activities");
  let skipped = 0;
  for (const act of fishingActivities) {
    if (!act.name || !act.island_name || !act.atoll_administrative_code) {
      warnings.push(`Skipping malformed fishing activity entry: ${JSON.stringify(act)}`);
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
    const typeSlug = act.fishing_type ? typeSlugByValue.get(act.fishing_type) ?? null : null;
    const typeLabel = act.fishing_type ? FISHING_TYPE_LABEL[act.fishing_type] : null;

    const slug = assignUniqueSlug(act.name, usedActivitySlugs, act.island_name);

    let summary = `${act.name} is a${typeLabel ? ` ${typeLabel.toLowerCase()}` : " fishing"} trip on ${act.island_name}, ${atollName}.`;
    if (act.duration_minutes) summary += ` Duration: ${act.duration_minutes} minutes.`;
    if (act.operator_name) summary += ` It is operated by ${act.operator_name}.`;
    const metaTitle = `${act.name} | Maldives Fishing | MTG`;

    lines.push(`insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)`);
    lines.push(
      `values ('activity', ${sqlString(slug)}, ${sqlString(act.name)}, ${sqlString(summary)}, 'published', ${sqlString(metaTitle)}, ${sqlString(summary)}, now())`,
    );
    lines.push(`on conflict (node_type, slug) do nothing;`);
    lines.push("");

    lines.push(`insert into activities (`);
    lines.push(`  id, activity_category, operated_by_provider_id, duration_minutes, price_from, max_participants`);
    lines.push(`)`);
    lines.push(`select`);
    lines.push(`  n.id, 'fishing',`);
    lines.push(
      `  ${providerSlug ? `(select id from nodes where node_type = 'provider' and slug = ${sqlString(providerSlug)})` : "null"},`,
    );
    lines.push(`  ${sqlLiteral(act.duration_minutes)}, ${sqlLiteral(act.price_from)}, ${sqlLiteral(act.max_participants)}`);
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

    lines.push(`insert into bookable_products (id, booking_mode)`);
    lines.push(`select id, 'inquiry' from nodes where node_type = 'activity' and slug = ${sqlString(slug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");
  }

  writeFileSync(MIGRATION_PATH, lines.join("\n") + "\n");

  console.log(`Wrote ${MIGRATION_PATH}`);
  console.log(
    `Fishing types: ${usedTypes.length}, Providers referenced: ${distinctOperators.length}, Activities: ${fishingActivities.length - skipped} (skipped ${skipped})`,
  );
  if (warnings.length > 0) {
    console.log(`\nWarnings (${warnings.length}):`);
    for (const w of warnings) console.log(`  - ${w}`);
  }
}

main();
