#!/usr/bin/env node
// Generates a Supabase SQL migration from the source-of-truth accommodation
// data in data/maldives/accommodations/*.json, resolving each accommodation
// to a real location (an already-seeded inhabited island from Task 4, or a
// newly-added resort/private island) and, where verified, a provider.
//
// Deterministic and idempotent: every insert is keyed by slug with
// `ON CONFLICT ... DO NOTHING`, same convention as
// scripts/generate-location-seed.mjs.
//
// Usage: node scripts/generate-accommodation-seed.mjs

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const LOCATIONS_DATA_DIR = path.join(ROOT, "data", "maldives", "locations");
const ACCOMMODATIONS_DATA_DIR = path.join(ROOT, "data", "maldives", "accommodations");
const MIGRATION_PATH = path.join(
  ROOT,
  "supabase",
  "migrations",
  "20250103000100_seed_accommodations.sql",
);

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
  // For non-string SQL literals: booleans, numbers, or null.
  if (value === null || value === undefined) return "null";
  if (typeof value === "boolean") return value ? "true" : "false";
  return String(value);
}

function ltreeLabel(slug) {
  return slug.replace(/-/g, "_");
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
  const accommodations = loadJson(ACCOMMODATIONS_DATA_DIR, "accommodations.json");
  const providers = loadJson(ACCOMMODATIONS_DATA_DIR, "providers.json");

  // Atoll administrative_code -> its already-seeded slug (same "strip
  // trailing Atoll" rule as generate-location-seed.mjs, so this matches
  // the real seeded slugs exactly).
  const atollSlugByCode = new Map();
  for (const atoll of atolls) {
    atollSlugByCode.set(atoll.administrative_code, slugify(atoll.name.replace(/\s+Atoll$/i, "")));
  }

  // Inhabited-island (name, atoll code) -> its already-seeded slug, so
  // accommodations on real Task 4 islands resolve without creating any
  // new location rows.
  const seededIslandSlug = new Map();
  for (const island of seededIslands) {
    seededIslandSlug.set(`${island.name}::${island.atoll_administrative_code}`, slugify(island.name));
  }

  const usedProviderSlugs = new Set();
  const usedAccommodationSlugs = new Set();
  const usedNewIslandSlugs = new Set();
  const warnings = [];
  const lines = [];

  lines.push("-- MTG: accommodation + provider seed (Task 5).");
  lines.push("-- GENERATED FILE — do not hand-edit. Source of truth:");
  lines.push("--   data/maldives/accommodations/accommodations.json");
  lines.push("--   data/maldives/accommodations/providers.json");
  lines.push("--   data/maldives/accommodations/SOURCES.md");
  lines.push("-- Regenerate with: node scripts/generate-accommodation-seed.mjs");
  lines.push("--");
  lines.push("-- Idempotent (ON CONFLICT DO NOTHING, keyed by slug). Some accommodations");
  lines.push("-- are on private/resort islands that Task 4 deliberately excluded (it only");
  lines.push("-- seeded INHABITED islands); this migration adds those specific resort");
  lines.push("-- islands as real, sourced location rows (is_inhabited = false) rather than");
  lines.push("-- inventing an accommodation-specific location — see data/maldives/");
  lines.push("-- accommodations/SOURCES.md for how each was verified.");
  lines.push("");

  // ── Providers ────────────────────────────────────────────────────
  lines.push("-- Providers");
  const providerSlugByName = new Map();
  for (const provider of providers) {
    if (!provider.name) {
      warnings.push(`Skipping malformed provider entry: ${JSON.stringify(provider)}`);
      continue;
    }
    const slug = assignUniqueSlug(provider.name, usedProviderSlugs, "provider");
    providerSlugByName.set(provider.name, slug);
    const summary = `${provider.name} operates accommodation properties in the Maldives.`;

    lines.push(`insert into nodes (node_type, slug, title, summary, status, published_at)`);
    lines.push(`values ('provider', ${sqlString(slug)}, ${sqlString(provider.name)}, ${sqlString(summary)}, 'published', now())`);
    lines.push(`on conflict (node_type, slug) do nothing;`);
    lines.push("");
    lines.push(`insert into providers (id, website_url)`);
    lines.push(
      `select id, ${sqlString(provider.website_url)} from nodes where node_type = 'provider' and slug = ${sqlString(slug)}`,
    );
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");
  }

  // ── New resort/private-island locations ─────────────────────────
  lines.push("-- Resort/private islands not covered by the Task 4 inhabited-islands seed");
  const newIslandSlugByKey = new Map(); // `${name}::${code}` -> slug
  for (const acc of accommodations) {
    if (acc.island_is_inhabited !== false) continue;
    const key = `${acc.island_name}::${acc.atoll_administrative_code}`;
    if (newIslandSlugByKey.has(key)) continue; // already queued (shared island)
    if (seededIslandSlug.has(key)) continue; // shouldn't happen, but don't duplicate if it does

    const atollSlug = atollSlugByCode.get(acc.atoll_administrative_code);
    if (!atollSlug) {
      warnings.push(`Skipping resort island "${acc.island_name}" — unknown atoll code "${acc.atoll_administrative_code}"`);
      continue;
    }

    const slug = assignUniqueSlug(acc.island_name, usedNewIslandSlugs, atollSlug);
    newIslandSlugByKey.set(key, slug);
    const atollName = atolls.find((a) => a.administrative_code === acc.atoll_administrative_code)?.name ?? atollSlug;
    const summary = `${acc.island_name} is a resort island in ${atollName}, Maldives.`;

    lines.push(`insert into nodes (node_type, slug, title, summary, status, published_at)`);
    lines.push(`values ('location', ${sqlString(slug)}, ${sqlString(acc.island_name)}, ${sqlString(summary)}, 'published', now())`);
    lines.push(`on conflict (node_type, slug) do nothing;`);
    lines.push("");
    lines.push(`insert into locations (id, location_type, parent_id, path, is_inhabited)`);
    lines.push(`select n.id, 'island', p.id, (p_loc.path || ${sqlString(ltreeLabel(slug))}::ltree), false`);
    lines.push(`from nodes n, nodes p join locations p_loc on p_loc.id = p.id`);
    lines.push(`where n.node_type = 'location' and n.slug = ${sqlString(slug)}`);
    lines.push(`  and p.node_type = 'location' and p.slug = ${sqlString(atollSlug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");
  }

  // ── Accommodations ───────────────────────────────────────────────
  lines.push("-- Accommodations");
  let skipped = 0;
  for (const acc of accommodations) {
    if (!acc.name || !acc.accommodation_type || !acc.island_name || !acc.atoll_administrative_code) {
      warnings.push(`Skipping malformed accommodation entry: ${JSON.stringify(acc)}`);
      skipped += 1;
      continue;
    }

    const key = `${acc.island_name}::${acc.atoll_administrative_code}`;
    const islandSlug = acc.island_is_inhabited === false ? newIslandSlugByKey.get(key) : seededIslandSlug.get(key);
    if (!islandSlug) {
      warnings.push(`Skipping "${acc.name}" — could not resolve island "${acc.island_name}" (${acc.atoll_administrative_code})`);
      skipped += 1;
      continue;
    }

    const atollName = atolls.find((a) => a.administrative_code === acc.atoll_administrative_code)?.name ?? acc.atoll_administrative_code;
    const providerSlug = acc.operator_name ? providerSlugByName.get(acc.operator_name) ?? null : null;
    if (acc.operator_name && !providerSlug) {
      warnings.push(`"${acc.name}" references operator_name "${acc.operator_name}" not found in providers.json — leaving provider unset`);
    }

    const slug = assignUniqueSlug(acc.name, usedAccommodationSlugs, acc.island_name);

    const typeLabel = { hotel: "hotel", resort: "resort", guesthouse: "guesthouse", villa: "villa", other: "property" }[
      acc.accommodation_type
    ];
    let summary = `${acc.name} is a ${typeLabel} on ${acc.island_name}, ${atollName}.`;
    if (acc.star_rating) summary += ` It is a ${acc.star_rating}-star property.`;
    if (acc.operator_name) summary += ` It is operated by ${acc.operator_name}.`;
    const metaTitle = `${acc.name} | Maldives ${typeLabel[0].toUpperCase()}${typeLabel.slice(1)}s | MTG`;

    lines.push(`insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)`);
    lines.push(
      `values ('accommodation', ${sqlString(slug)}, ${sqlString(acc.name)}, ${sqlString(summary)}, 'published', ${sqlString(metaTitle)}, ${sqlString(summary)}, now())`,
    );
    lines.push(`on conflict (node_type, slug) do nothing;`);
    lines.push("");

    lines.push(`insert into accommodations (`);
    lines.push(`  id, accommodation_type, operated_by_provider_id, star_rating, room_count, all_inclusive, overwater_villas`);
    lines.push(`)`);
    lines.push(`select`);
    lines.push(`  n.id, ${sqlString(acc.accommodation_type)},`);
    lines.push(
      `  ${providerSlug ? `(select id from nodes where node_type = 'provider' and slug = ${sqlString(providerSlug)})` : "null"},`,
    );
    lines.push(`  ${sqlLiteral(acc.star_rating)}, ${sqlLiteral(acc.room_count)}, ${sqlLiteral(acc.all_inclusive)}, ${sqlLiteral(acc.overwater_villas)}`);
    lines.push(`from nodes n where n.node_type = 'accommodation' and n.slug = ${sqlString(slug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");

    lines.push(`insert into node_locations (node_id, location_id, relation)`);
    lines.push(`select n.id, l.id, 'primary'`);
    lines.push(`from nodes n, nodes l`);
    lines.push(`where n.node_type = 'accommodation' and n.slug = ${sqlString(slug)}`);
    lines.push(`  and l.node_type = 'location' and l.slug = ${sqlString(islandSlug)}`);
    lines.push(`on conflict (node_id, location_id) do nothing;`);
    lines.push("");

    lines.push(`insert into bookable_products (id, booking_mode)`);
    lines.push(`select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = ${sqlString(slug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");
  }

  writeFileSync(MIGRATION_PATH, lines.join("\n") + "\n");

  console.log(`Wrote ${MIGRATION_PATH}`);
  console.log(`Providers: ${providers.length}, Accommodations: ${accommodations.length - skipped} (skipped ${skipped}), New resort islands: ${newIslandSlugByKey.size}`);
  if (warnings.length > 0) {
    console.log(`\nWarnings (${warnings.length}):`);
    for (const w of warnings) console.log(`  - ${w}`);
  }
}

main();
