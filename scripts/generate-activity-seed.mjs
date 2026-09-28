#!/usr/bin/env node
// Generates a Supabase SQL migration from the source-of-truth activity data
// in data/maldives/activities/activities.json, resolving each activity to a
// real location (an already-seeded inhabited island from Task 4, or one of
// the resort islands Task 5 added) and, where verified, a provider (reusing
// a Task 5 provider by exact name match, or creating a new one).
//
// Deterministic and idempotent: every insert is keyed by slug with
// `ON CONFLICT ... DO NOTHING`, same convention as the Task 4/5 generators.
//
// Usage: node scripts/generate-activity-seed.mjs

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const LOCATIONS_DATA_DIR = path.join(ROOT, "data", "maldives", "locations");
const ACTIVITIES_DATA_DIR = path.join(ROOT, "data", "maldives", "activities");
const MIGRATION_PATH = path.join(
  ROOT,
  "supabase",
  "migrations",
  "20250104000100_seed_activities.sql",
);

// Resort/private islands added by scripts/generate-accommodation-seed.mjs
// (Task 5) — not present in data/maldives/locations/islands.json, which is
// deliberately inhabited-islands-only (Task 4). Keeping this small fixed
// list in sync with that migration avoids re-deriving it at generation
// time; each entry was verified as part of Task 5's sourced dataset, not
// invented here.
const TASK5_RESORT_ISLANDS = [
  { name: "Vihamanaafushi", atoll_administrative_code: "K" },
  { name: "Kunfunadhoo", atoll_administrative_code: "B" },
  { name: "Velassaru", atoll_administrative_code: "K" },
  { name: "Olhuveli", atoll_administrative_code: "L" },
  { name: "Baros", atoll_administrative_code: "K" },
  { name: "Lankanfushi", atoll_administrative_code: "K" },
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

const CATEGORY_LABEL = {
  general: "activity",
  fishing: "fishing trip",
  diving: "dive",
  surfing: "surf session",
  watersports: "watersports activity",
  excursion: "excursion",
  island_hopping: "island-hopping trip",
  spa: "spa experience",
  culture: "cultural experience",
};

function main() {
  const atolls = loadJson(LOCATIONS_DATA_DIR, "atolls.json");
  const seededIslands = loadJson(LOCATIONS_DATA_DIR, "islands.json");
  const activities = loadJson(ACTIVITIES_DATA_DIR, "activities.json");

  const atollSlugByCode = new Map();
  for (const atoll of atolls) {
    atollSlugByCode.set(atoll.administrative_code, slugify(atoll.name.replace(/\s+Atoll$/i, "")));
  }

  const islandSlugByKey = new Map(); // `${name}::${code}` -> slug
  for (const island of seededIslands) {
    islandSlugByKey.set(`${island.name}::${island.atoll_administrative_code}`, slugify(island.name));
  }
  for (const island of TASK5_RESORT_ISLANDS) {
    islandSlugByKey.set(`${island.name}::${island.atoll_administrative_code}`, slugify(island.name));
  }

  const usedProviderSlugs = new Set();
  const usedActivitySlugs = new Set();
  const warnings = [];
  const lines = [];

  lines.push("-- MTG: activity + provider seed (Task 6).");
  lines.push("-- GENERATED FILE — do not hand-edit. Source of truth:");
  lines.push("--   data/maldives/activities/activities.json");
  lines.push("--   data/maldives/activities/SOURCES.md");
  lines.push("-- Regenerate with: node scripts/generate-activity-seed.mjs");
  lines.push("--");
  lines.push("-- Idempotent (ON CONFLICT DO NOTHING, keyed by slug). Providers reuse the");
  lines.push("-- exact Task 5 provider names where an activity's operator matches one");
  lines.push("-- (the insert becomes a harmless no-op against the existing row); a genuinely");
  lines.push("-- new operator gets a new provider node. No new locations are created here —");
  lines.push("-- every activity resolves to an island already seeded by Task 4 or Task 5.");
  lines.push("");

  // ── Providers referenced by activities (dedup by name) ──────────
  const distinctOperators = Array.from(
    new Set(activities.map((a) => a.operator_name).filter((n) => Boolean(n))),
  );
  const providerSlugByName = new Map();

  if (distinctOperators.length > 0) {
    lines.push("-- Providers (reused from Task 5 where the name matches exactly, else new)");
    for (const name of distinctOperators) {
      const slug = assignUniqueSlug(name, usedProviderSlugs, "activity-provider");
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

  // ── Activities ───────────────────────────────────────────────────
  lines.push("-- Activities");
  let skipped = 0;
  for (const act of activities) {
    if (!act.name || !act.activity_category || !act.island_name || !act.atoll_administrative_code) {
      warnings.push(`Skipping malformed activity entry: ${JSON.stringify(act)}`);
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

    const slug = assignUniqueSlug(act.name, usedActivitySlugs, act.island_name);
    const label = CATEGORY_LABEL[act.activity_category] ?? "activity";
    const article = /^[aeiou]/i.test(label) ? "an" : "a";

    let summary = `${act.name} is ${article} ${label} on ${act.island_name}, ${atollName}.`;
    if (act.duration_minutes) summary += ` Duration: ${act.duration_minutes} minutes.`;
    if (act.operator_name) summary += ` It is operated by ${act.operator_name}.`;
    const metaTitle = `${act.name} | Maldives Activities | MTG`;

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
    lines.push(`  n.id, ${sqlString(act.activity_category)},`);
    lines.push(
      `  ${providerSlug ? `(select id from nodes where node_type = 'provider' and slug = ${sqlString(providerSlug)})` : "null"},`,
    );
    lines.push(
      `  ${sqlLiteral(act.duration_minutes)}, ${sqlLiteral(act.min_age)}, ${sqlString(act.difficulty)}, ${sqlLiteral(act.price_from)}, ${sqlLiteral(act.max_participants)}`,
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

    lines.push(`insert into bookable_products (id, booking_mode)`);
    lines.push(`select id, 'inquiry' from nodes where node_type = 'activity' and slug = ${sqlString(slug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");
  }

  writeFileSync(MIGRATION_PATH, lines.join("\n") + "\n");

  console.log(`Wrote ${MIGRATION_PATH}`);
  console.log(`Providers referenced: ${distinctOperators.length}, Activities: ${activities.length - skipped} (skipped ${skipped})`);
  if (warnings.length > 0) {
    console.log(`\nWarnings (${warnings.length}):`);
    for (const w of warnings) console.log(`  - ${w}`);
  }
}

main();
