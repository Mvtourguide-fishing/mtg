#!/usr/bin/env node
// Stays/Resorts/Guesthouses/Hotels ecosystem, Phase 2: generates the
// Supabase seed migration for the 148 real legacy properties resolved by
// scripts/merge-accommodation-research.mjs (data/maldives/accommodations-v2/
// resolved-properties.json) — the WebSearch-verified successor to the
// original 14-entry data/maldives/accommodations/accommodations.json,
// which this migration adds to (never replaces; the 14 originals keep
// their own seed migration and are skipped here by slug).
//
// Location resolution rule (the one substantive judgment call this script
// makes beyond straight lookup): a property whose accommodationType is
// "resort" is NEVER matched against an already-seeded INHABITED island,
// even when its verified island name happens to match one by name —
// Maldivian tourism law keeps international resorts off populated local
// islands, so a name collision there is a coincidence/homonym (e.g. the
// low-confidence "Maamigili" already seeded in Raa Atoll from Task 4 is
// almost certainly not the same place as Cora Cora resort's own private
// island, also researched to "Maamigili, Raa Atoll" — kept deliberately
// distinct rather than compounding one low-confidence entry with another
// assumption). "hotel"/"guesthouse" properties DO match seeded inhabited
// islands — that's the real, expected case for budget local-island stays
// (Maafushi, Malé, Hulhumalé, Gan, Fulidhoo, ...).
//
// Multiple resorts genuinely sharing one new island (e.g. The Ritz-Carlton
// and Patina Maldives both sit on the real "Fari Islands" cluster) are
// deduped to a single new location row, same as multiple hotels sharing
// an existing inhabited island.
//
// Deterministic and idempotent: every insert is keyed by slug with
// `ON CONFLICT ... DO NOTHING`, same convention as every other generator
// in this codebase.
//
// Usage: node scripts/generate-stays-seed.mjs

import { readFileSync, writeFileSync, existsSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

import { assignUniqueSlug, slugify } from "./lib/legacy-shared.mjs";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const LOCATIONS_DATA_DIR = path.join(ROOT, "data", "maldives", "locations");
const V2_DATA_DIR = path.join(ROOT, "data", "maldives", "accommodations-v2");
const MIGRATION_PATH = path.join(ROOT, "supabase", "migrations", "20250123000200_seed_stays_properties.sql");

/** Strips diacritics for matching only (never for display) — "Malé" and
 * "male" must compare equal here, the same way slugify() already treats
 * them for slug purposes elsewhere in this codebase. */
function normalizeForMatch(input) {
  return input
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase();
}

// The three real islands administratively grouped under "Malé City"
// (MLE), not Kaafu (K) — see scripts/extract-legacy-island-content.mjs's
// identical MANUAL_MATCH_OVERRIDES comment. Research agents correctly
// identified these as "Kaafu Atoll" in the colloquial/geographic sense
// (they're often described that way), but the actual seeded location row
// uses administrative code MLE, so the match key needs this override.
const MALE_CITY_ISLAND_ATOLL_OVERRIDE = new Set(["male", "hulhumale", "villingili", "vilimale"]);

// Cora Cora's own island independently researched as "Maamigili, Raa
// Atoll" — but the seed already carries a LOW-CONFIDENCE inhabited
// "Maamigili" (Raa) row from Task 4 (its own notes field says exactly
// that: "Could not independently cross-check; verify before production
// use"). Per this script's resort/inhabited-island rule above this would
// never auto-match anyway (Cora Cora's accommodationType is "resort"),
// but it's called out explicitly here since it's the one case in this
// batch where the rule actually fires against a real, named ambiguity
// flagged earlier in this project rather than a hypothetical.
// (No code needed beyond the general rule — documented for the record.)

function sqlString(value) {
  if (value === null || value === undefined) return "null";
  return `'${String(value).replace(/'/g, "''")}'`;
}
function sqlLiteral(value) {
  if (value === null || value === undefined) return "null";
  if (typeof value === "boolean") return value ? "true" : "false";
  return String(value);
}
function ltreeLabel(slug) {
  return slug.replace(/-/g, "_");
}

/** Strips a parenthetical alternate-name suffix ("Gan (Laamu Gan)" ->
 * "Gan"), the one systematic cleanup the research output needed before
 * it's usable as a location name/slug source. */
function cleanIslandName(raw) {
  return raw.replace(/\s*\([^)]*\)\s*$/, "").trim();
}

function loadJson(dir, file) {
  const full = path.join(dir, file);
  if (!existsSync(full)) throw new Error(`Missing required data file: ${full}`);
  return JSON.parse(readFileSync(full, "utf8"));
}

function main() {
  const atolls = loadJson(LOCATIONS_DATA_DIR, "atolls.json");
  const seededIslands = loadJson(LOCATIONS_DATA_DIR, "islands.json");
  const properties = loadJson(V2_DATA_DIR, "resolved-properties.json");

  const atollSlugByCode = new Map();
  const atollNameByCode = new Map();
  for (const atoll of atolls) {
    atollSlugByCode.set(atoll.administrative_code, slugify(atoll.name.replace(/\s+Atoll$/i, "")));
    atollNameByCode.set(atoll.administrative_code, atoll.name);
  }

  const seededIslandSlug = new Map(); // `${normalizedName}::${code}` -> slug
  for (const island of seededIslands) {
    seededIslandSlug.set(`${normalizeForMatch(island.name)}::${island.atoll_administrative_code}`, slugify(island.name));
  }

  const usedAccommodationSlugs = new Set();
  const usedNewIslandSlugs = new Set();
  const newIslandByKey = new Map(); // `${cleanName.toLowerCase()}::${code}` -> { slug, name, atollCode }
  const warnings = [];
  const lines = [];

  lines.push("-- MTG: Stays ecosystem seed — 148 real resort/hotel/guesthouse");
  lines.push("-- properties, migrated from the legacy site (Phase 1-2 of the Stays");
  lines.push("-- ecosystem task).");
  lines.push("-- GENERATED FILE — do not hand-edit. Source of truth:");
  lines.push("--   data/maldives/accommodations-v2/resolved-properties.json");
  lines.push("--   (built by scripts/extract-legacy-accommodations.mjs +");
  lines.push("--    scripts/merge-accommodation-research.mjs from WebSearch-verified");
  lines.push("--    atoll/island research — see resolution-review.json for the 2");
  lines.push("--    properties deliberately excluded: an ambiguous 'Crystal Beach'");
  lines.push("--    among 3 same-named guesthouses, and 'Vakarufalhi', rebranded to");
  lines.push("--    NOVA Maldives in 2019 and kept under its current name only.)");
  lines.push("-- Regenerate with: node scripts/generate-stays-seed.mjs");
  lines.push("--");
  lines.push("-- Adds to, never replaces, the original 14-property seed from Task 5");
  lines.push("-- (20250103000100_seed_accommodations.sql) — idempotent, ON CONFLICT DO");
  lines.push("-- NOTHING keyed by slug, same convention as every other generator here.");
  lines.push("--");
  lines.push("-- No providers are assigned: unlike Task 5's activities/fishing data,");
  lines.push("-- the legacy resort/hotel pages never name a distinct booking operator");
  lines.push("-- for the property itself (only in-page booking WIDGETS, already");
  lines.push("-- confirmed non-content by the Phase 1 audit) — leaving");
  lines.push("-- operated_by_provider_id null here is the honest reflection of that,");
  lines.push("-- not an oversight.");
  lines.push("");

  // Pass 1: resolve every property's island (existing inhabited island for
  // hotel/guesthouse types, or a new/deduped resort-island for resorts —
  // see header comment for why resorts never match an inhabited island).
  // Properties flagged mergeIntoExistingSlug are the same real resort as
  // an already-seeded Task 5 accommodation (see
  // merge-accommodation-research.mjs's MERGE_INTO_EXISTING_SLUG comment)
  // — they skip island/accommodation creation entirely and are enriched
  // in place further down instead.
  const resolved = [];
  const mergeList = [];
  for (const p of properties) {
    if (p.mergeIntoExistingSlug) {
      mergeList.push(p);
      continue;
    }
    const cleanIsland = cleanIslandName(p.islandName);
    const atollSlug = atollSlugByCode.get(p.atollCode);
    if (!atollSlug) {
      warnings.push(`Skipping "${p.name}" (${p.folder}) — unknown atoll code "${p.atollCode}"`);
      continue;
    }

    const normalizedIsland = normalizeForMatch(cleanIsland);
    let islandSlug = null;
    if (p.accommodationType !== "resort") {
      const lookupCode = MALE_CITY_ISLAND_ATOLL_OVERRIDE.has(normalizedIsland) ? "MLE" : p.atollCode;
      islandSlug = seededIslandSlug.get(`${normalizedIsland}::${lookupCode}`) ?? null;
    }

    if (!islandSlug) {
      // New (or shared, e.g. Fari Islands) uninhabited resort/private island.
      const key = `${normalizedIsland}::${p.atollCode}`;
      let entry = newIslandByKey.get(key);
      if (!entry) {
        const slug = assignUniqueSlug(cleanIsland, usedNewIslandSlugs, atollSlug);
        entry = { slug, name: cleanIsland, atollCode: p.atollCode };
        newIslandByKey.set(key, entry);
      }
      islandSlug = entry.slug;
    }

    resolved.push({ ...p, cleanIsland, atollSlug, islandSlug });
  }

  // ── New resort/private islands (deduped) ────────────────────────
  lines.push("-- New private/resort islands not covered by the Task 4 inhabited-islands");
  lines.push("-- seed or the Task 5 six-resort-island set (deduped — e.g. Fari Islands");
  lines.push("-- is shared by two resorts and gets exactly one row here).");
  for (const { slug, name, atollCode } of newIslandByKey.values()) {
    const atollSlug = atollSlugByCode.get(atollCode);
    const atollName = atollNameByCode.get(atollCode) ?? atollSlug;
    const summary = `${name} is a resort island in ${atollName}, Maldives.`;

    lines.push(`insert into nodes (node_type, slug, title, summary, status, published_at)`);
    lines.push(`values ('location', ${sqlString(slug)}, ${sqlString(name)}, ${sqlString(summary)}, 'published', now())`);
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

  // ── Accommodations + rooms ───────────────────────────────────────
  lines.push("-- Accommodations");
  let skipped = 0;
  let roomCount = 0;
  for (const p of resolved) {
    const slug = assignUniqueSlug(p.name, usedAccommodationSlugs, p.cleanIsland);
    const atollName = atollNameByCode.get(p.atollCode) ?? p.atollSlug;
    const typeLabel = { resort: "resort", hotel: "hotel", guesthouse: "guesthouse" }[p.accommodationType] ?? "property";

    const firstParagraph = p.descriptionParagraphs?.[0] ?? null;
    const summary = firstParagraph ?? `${p.name} is a ${typeLabel} on ${p.cleanIsland}, ${atollName}.`;
    const metaTitle = `${p.name} | Maldives ${typeLabel[0].toUpperCase()}${typeLabel.slice(1)}s | MTG`;

    lines.push(`-- ${p.folder}`);
    lines.push(`insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)`);
    lines.push(
      `values ('accommodation', ${sqlString(slug)}, ${sqlString(p.name)}, ${sqlString(summary)}, 'published', ${sqlString(metaTitle)}, ${sqlString(summary)}, ${sqlString(
        JSON.stringify({ overview_paragraphs: p.descriptionParagraphs ?? [] }),
      )}::jsonb, now())`,
    );
    lines.push(`on conflict (node_type, slug) do nothing;`);
    lines.push("");

    lines.push(`insert into accommodations (`);
    lines.push(`  id, accommodation_type, star_rating, price_from, video_youtube_id, currency`);
    lines.push(`)`);
    lines.push(`select`);
    lines.push(`  n.id, ${sqlString(p.accommodationType)}, ${sqlLiteral(p.starRating)}, ${sqlLiteral(p.priceFrom)}, ${sqlString(p.videoId)}, ${sqlString(p.priceCurrency ?? "USD")}`);
    lines.push(`from nodes n where n.node_type = 'accommodation' and n.slug = ${sqlString(slug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");

    lines.push(`insert into node_locations (node_id, location_id, relation)`);
    lines.push(`select n.id, l.id, 'primary'`);
    lines.push(`from nodes n, nodes l`);
    lines.push(`where n.node_type = 'accommodation' and n.slug = ${sqlString(slug)}`);
    lines.push(`  and l.node_type = 'location' and l.slug = ${sqlString(p.islandSlug)}`);
    lines.push(`on conflict (node_id, location_id) do nothing;`);
    lines.push("");

    lines.push(`insert into bookable_products (id, booking_mode)`);
    lines.push(`select id, 'inquiry' from nodes where node_type = 'accommodation' and slug = ${sqlString(slug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");

    for (const [i, room] of (p.rooms ?? []).entries()) {
      lines.push(`insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)`);
      lines.push(`select id, ${sqlString(room.name)}, ${sqlLiteral(room.priceFrom)}, ${sqlString(room.currency ?? "USD")}, ${sqlString(room.bedType)}, ${sqlLiteral(room.maxOccupancy)}, ${i}`);
      lines.push(`from nodes where node_type = 'accommodation' and slug = ${sqlString(slug)}`);
      lines.push(`on conflict (accommodation_id, name) do nothing;`);
      lines.push("");
      roomCount += 1;
    }
  }

  // ── Enrich already-seeded Task 5 accommodations ──────────────────
  // Same real resorts/hotels as above — see mergeIntoExistingSlug's own
  // comment. No new node, no new island, no node_locations row (the
  // existing one is already correct); just the fields Task 5 never had
  // (price_from, video, rooms, overview paragraphs) added to the
  // existing row.
  if (mergeList.length > 0) {
    lines.push("-- Enriching already-seeded Task 5 accommodations with this round's");
    lines.push("-- real price/video/room/overview data (same physical resorts — see");
    lines.push("-- mergeIntoExistingSlug in merge-accommodation-research.mjs).");
    for (const p of mergeList) {
      const existingSlug = p.mergeIntoExistingSlug;
      lines.push(`-- ${p.folder} -> ${existingSlug}`);
      lines.push(`update accommodations set`);
      lines.push(`  price_from = coalesce(accommodations.price_from, ${sqlLiteral(p.priceFrom)}),`);
      lines.push(`  video_youtube_id = coalesce(accommodations.video_youtube_id, ${sqlString(p.videoId)})`);
      lines.push(`from nodes n where n.id = accommodations.id and n.node_type = 'accommodation' and n.slug = ${sqlString(existingSlug)};`);
      lines.push("");

      if ((p.descriptionParagraphs ?? []).length > 0) {
        lines.push(`update nodes set attributes = attributes || ${sqlString(JSON.stringify({ overview_paragraphs: p.descriptionParagraphs }))}::jsonb`);
        lines.push(`where node_type = 'accommodation' and slug = ${sqlString(existingSlug)} and not (attributes ? 'overview_paragraphs');`);
        lines.push("");
      }

      for (const [i, room] of (p.rooms ?? []).entries()) {
        lines.push(`insert into accommodation_rooms (accommodation_id, name, price_from, price_currency, bed_type, max_occupancy, sort_order)`);
        lines.push(`select id, ${sqlString(room.name)}, ${sqlLiteral(room.priceFrom)}, ${sqlString(room.currency ?? "USD")}, ${sqlString(room.bedType)}, ${sqlLiteral(room.maxOccupancy)}, ${i}`);
        lines.push(`from nodes where node_type = 'accommodation' and slug = ${sqlString(existingSlug)}`);
        lines.push(`on conflict (accommodation_id, name) do nothing;`);
        lines.push("");
        roomCount += 1;
      }
    }
  }

  writeFileSync(MIGRATION_PATH, lines.join("\n") + "\n");

  console.log(`New resort islands: ${newIslandByKey.size}`);
  console.log(`Accommodations: ${resolved.length - skipped} (skipped ${skipped}), Merged into existing: ${mergeList.length}, Rooms: ${roomCount}`);
  if (warnings.length > 0) {
    console.log(`\nWarnings (${warnings.length}):`);
    for (const w of warnings) console.log(`  - ${w}`);
  }
  console.log(`\nWrote ${MIGRATION_PATH}`);
}

main();
