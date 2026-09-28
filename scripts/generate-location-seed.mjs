#!/usr/bin/env node
// Generates a Supabase SQL migration from the source-of-truth location data
// in data/maldives/locations/*.json. Deterministic and idempotent: re-running
// it (after re-running the migration) does not create duplicate rows or
// change existing ids, because every insert is keyed by slug with
// `ON CONFLICT ... DO NOTHING`.
//
// Usage: node scripts/generate-location-seed.mjs
// Regenerates supabase/migrations/<TIMESTAMP>_seed_maldives_locations.sql
// (the timestamp is fixed below, not regenerated per run, so re-running
// this script overwrites the same migration file rather than creating a
// new one every time the source data changes).

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const DATA_DIR = path.join(ROOT, "data", "maldives", "locations");
const MIGRATION_PATH = path.join(
  ROOT,
  "supabase",
  "migrations",
  "20250102000100_seed_maldives_locations.sql",
);

function slugify(input) {
  return input
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "") // strip accents/diacritics (Malé -> Male)
    .replace(/['’]/g, "") // drop apostrophes rather than turning them into hyphens
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

function sqlString(value) {
  if (value === null || value === undefined) return "null";
  return `'${String(value).replace(/'/g, "''")}'`;
}

function ltreeLabel(slug) {
  // ltree labels only allow [A-Za-z0-9_]; slugs may contain hyphens.
  return slug.replace(/-/g, "_");
}

function loadJson(file) {
  const full = path.join(DATA_DIR, file);
  if (!existsSync(full)) {
    throw new Error(`Missing required data file: ${full}`);
  }
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
  const atolls = loadJson("atolls.json");
  const islands = loadJson("islands.json");

  const usedSlugs = new Set();
  const lines = [];
  const warnings = [];

  lines.push("-- MTG: Maldives geographic hierarchy seed (Task 4).");
  lines.push("-- GENERATED FILE — do not hand-edit. Source of truth:");
  lines.push("--   data/maldives/locations/atolls.json");
  lines.push("--   data/maldives/locations/islands.json");
  lines.push("--   data/maldives/locations/SOURCES.md");
  lines.push("-- Regenerate with: node scripts/generate-location-seed.mjs");
  lines.push("--");
  lines.push("-- Idempotent: every insert is keyed by (node_type, slug) with");
  lines.push("-- ON CONFLICT DO NOTHING, so re-applying this migration after the");
  lines.push("-- source data hasn't changed is a no-op. Hierarchy validation and");
  lines.push("-- ltree path computation are handled entirely by the triggers from");
  lines.push("-- 20250101001300_functions_triggers.sql — this file does not bypass them.");
  lines.push("");

  // ── Country ──────────────────────────────────────────────────────
  const countrySlug = "maldives";
  usedSlugs.add(countrySlug);
  // Malé City is administratively distinct from the 20 natural-atoll-based
  // divisions (see atolls.json's "MLE" entry) — worded precisely rather
  // than calling it one of the "atolls" at the country-summary level.
  const cityDivisions = atolls.filter((a) => a.administrative_code === "MLE");
  const atollDivisions = atolls.filter((a) => a.administrative_code !== "MLE");
  const countrySummary =
    cityDivisions.length > 0
      ? `The Maldives is an island nation in the Indian Ocean, organized into ${atollDivisions.length} administrative atolls plus the capital, ${cityDivisions[0].name}.`
      : `The Maldives is an island nation in the Indian Ocean, organized into ${atolls.length} administrative atolls.`;

  lines.push("-- Country");
  lines.push(`insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)`);
  lines.push(
    `values ('location', ${sqlString(countrySlug)}, ${sqlString("Maldives")}, ${sqlString(countrySummary)}, 'published', ${sqlString("Maldives Travel Guide | MTG")}, ${sqlString(countrySummary)}, now())`,
  );
  lines.push(`on conflict (node_type, slug) do nothing;`);
  lines.push("");
  lines.push(`insert into locations (id, location_type, parent_id, path)`);
  lines.push(
    `select id, 'country', null, ${sqlString(ltreeLabel(countrySlug))}::ltree from nodes where node_type = 'location' and slug = ${sqlString(countrySlug)}`,
  );
  lines.push(`on conflict (id) do nothing;`);
  lines.push("");

  // ── Atolls ───────────────────────────────────────────────────────
  lines.push("-- Atolls");
  const atollSlugByCode = new Map();
  for (const atoll of atolls) {
    if (!atoll.administrative_code || !atoll.name) {
      warnings.push(`Skipping malformed atoll entry: ${JSON.stringify(atoll)}`);
      continue;
    }
    // Slug from the name with a trailing "Atoll" stripped — "Kaafu Atoll"
    // -> "kaafu", matching the canonical slugs specified in the task brief
    // (kaafu, lhaviyani, ...). The display title keeps the full name.
    const slugBaseName = atoll.name.replace(/\s+Atoll$/i, "");
    const slug = assignUniqueSlug(slugBaseName, usedSlugs, atoll.administrative_code);
    atollSlugByCode.set(atoll.administrative_code, slug);

    const islandCount = islands.filter((i) => i.atoll_administrative_code === atoll.administrative_code).length;
    const capitalNote = atoll.capital_island ? ` Its administrative capital is ${atoll.capital_island}.` : "";
    const summary = `${atoll.name} is one of the Maldives' administrative atolls (code ${atoll.administrative_code}), comprising ${islandCount} inhabited island${islandCount === 1 ? "" : "s"}.${capitalNote}`;
    const metaTitle = `${atoll.name} | Maldives Atolls | MTG`;

    lines.push(`insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)`);
    lines.push(
      `values ('location', ${sqlString(slug)}, ${sqlString(atoll.name)}, ${sqlString(summary)}, 'published', ${sqlString(metaTitle)}, ${sqlString(summary)}, now())`,
    );
    lines.push(`on conflict (node_type, slug) do nothing;`);
    lines.push("");
    lines.push(`insert into locations (id, location_type, parent_id, path, administrative_code)`);
    lines.push(
      `select n.id, 'atoll', c.id, (c_loc.path || ${sqlString(ltreeLabel(slug))}::ltree), ${sqlString(atoll.administrative_code)}`,
    );
    lines.push(`from nodes n, nodes c join locations c_loc on c_loc.id = c.id`);
    lines.push(`where n.node_type = 'location' and n.slug = ${sqlString(slug)}`);
    lines.push(`  and c.node_type = 'location' and c.slug = ${sqlString(countrySlug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");
  }

  // ── Islands ──────────────────────────────────────────────────────
  lines.push("-- Inhabited islands");
  let skippedIslands = 0;
  for (const island of islands) {
    if (!island.name || !island.atoll_administrative_code) {
      warnings.push(`Skipping malformed island entry: ${JSON.stringify(island)}`);
      skippedIslands += 1;
      continue;
    }
    const atollSlug = atollSlugByCode.get(island.atoll_administrative_code);
    if (!atollSlug) {
      warnings.push(
        `Skipping island "${island.name}" — unknown atoll_administrative_code "${island.atoll_administrative_code}"`,
      );
      skippedIslands += 1;
      continue;
    }

    const atollName = atolls.find((a) => a.administrative_code === island.atoll_administrative_code)?.name ?? atollSlug;
    const slug = assignUniqueSlug(island.name, usedSlugs, atollSlug);
    // Defaults to true (every island in this file has historically been an
    // inhabited local island) — false only for islands.json entries that
    // explicitly override it, e.g. Kalhaidhoo/Gaadhoo, whose communities
    // relocated (2004 tsunami / an active government resettlement) and are
    // no longer inhabited, per Wikipedia/press verification.
    const isInhabited = island.is_inhabited !== false;
    const summary = isInhabited
      ? `${island.name} is an inhabited island in ${atollName}, Maldives.`
      : `${island.name} is an island in ${atollName}, Maldives, no longer inhabited after its community relocated.`;
    const metaTitle = `${island.name}, ${atollName} | Maldives Islands | MTG`;

    lines.push(`insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)`);
    lines.push(
      `values ('location', ${sqlString(slug)}, ${sqlString(island.name)}, ${sqlString(summary)}, 'published', ${sqlString(metaTitle)}, ${sqlString(summary)}, now())`,
    );
    lines.push(`on conflict (node_type, slug) do nothing;`);
    lines.push("");
    lines.push(`insert into locations (id, location_type, parent_id, path, is_inhabited)`);
    lines.push(
      `select n.id, 'island', p.id, (p_loc.path || ${sqlString(ltreeLabel(slug))}::ltree), ${isInhabited}`,
    );
    lines.push(`from nodes n, nodes p join locations p_loc on p_loc.id = p.id`);
    lines.push(`where n.node_type = 'location' and n.slug = ${sqlString(slug)}`);
    lines.push(`  and p.node_type = 'location' and p.slug = ${sqlString(atollSlug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");
  }

  writeFileSync(MIGRATION_PATH, lines.join("\n") + "\n");

  console.log(`Wrote ${MIGRATION_PATH}`);
  console.log(`Atolls: ${atolls.length}, Islands: ${islands.length - skippedIslands} (skipped ${skippedIslands})`);
  if (warnings.length > 0) {
    console.log(`\nWarnings (${warnings.length}):`);
    for (const w of warnings) console.log(`  - ${w}`);
  }
}

main();
