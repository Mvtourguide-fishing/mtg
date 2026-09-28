#!/usr/bin/env node
// Task 18: full legacy transfer recovery.
//
// Task 15 (scripts/import-legacy-transfers.mjs) only matched a transfer
// page's destination against the already-seeded ACCOMMODATION catalogue
// (14 entries) — correctly conservative for that task, but it meant only
// 2 of 88 legacy transfer pages produced anything, because most named
// resorts simply aren't in that small catalogue yet. Task 18's explicit
// mandate is different: recover the COMPLETE legacy transfer inventory,
// not just the slice that happens to overlap with an unrelated dataset's
// current size.
//
// This script instead matches (or, where genuinely justified, CREATES) a
// real destination LOCATION directly — using only evidence the legacy
// page itself provides:
//   - the destination's own name and real lat/lng geo-coordinates, from
//     its own schema.org JSON-LD (the same structured data Task 15 used
//     for price/duration — this script also reads its `itinerary` places)
//   - the real atoll the page's own body text names (verified against a
//     chrome-stripped page body — nav/footer menu links were confirmed
//     to be a false-positive source during this task's own investigation
//     and are explicitly excluded)
//
// A new island location is only ever created when a real atoll was found
// this way — never guessed from name similarity, never fabricated. Where
// no atoll can be recovered, the page is marked needs-review, not forced.
//
// This does NOT touch the 15 routes already seeded by Task 10
// (data/maldives/transfers/routes.json / generate-transfer-seed.mjs) —
// those remain the more rigorously independently-researched baseline.
// Where a legacy page's destination matches one of those routes' real
// destinations, this script adds its own price as an ADDITIONAL service
// on the SAME existing route (never a duplicate route) — Task 18
// explicitly wants every legitimate legacy price preserved, not silently
// dropped because a better-researched alternative already exists.
//
// Writes:
//   data/maldives/migration/transfer-legacy-recovery.json
//
// Read-only by default. Usage:
//   node scripts/rebuild-legacy-transfers.mjs            # report only
//   node scripts/rebuild-legacy-transfers.mjs --commit   # also emit SQL

import { load } from "cheerio";
import { existsSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import {
  DATA_DIR,
  RELEASE_DIR,
  ROOT,
  buildEntityIndex,
  deterministicUuid,
  distinctiveTokens,
  loadJson,
  slugify,
  toAsciiSafe,
  tokenOverlapScore,
} from "./lib/legacy-shared.mjs";

const CONTENT_DATA_DIR = path.join(DATA_DIR, "content");
const MIGRATION_DATA_DIR = path.join(DATA_DIR, "migration");
const COMMIT = process.argv.includes("--commit");
const CONFIDENT = 0.6;

const ORIGIN_LOCATION_SLUG = "velana-international-airport";
const ORIGIN_NAME_PATTERN = /airport/i;
const TRANSFER_PROVIDER_NAME = "Maldives Tour Guide";
const TRANSFER_PROVIDER_SLUG = "maldives-tour-guide-transfers";

// Task 10's own already-live destinations (data/maldives/transfers/routes.json)
// — never duplicated as a second route; a legacy match here adds a
// service to the EXISTING route instead (see header comment).
const ALREADY_COVERED_DESTINATION_SLUGS = new Set([
  "male", "vihamanaafushi", "baros", "velassaru", "lankanfushi", "maafushi", "kunfunadhoo", "olhuveli",
]);

// Real, verified administrative atoll a page's own body text names —
// informal tourism-region names (e.g. "North Male Atoll") folded to the
// one real administrative atoll they belong to. Built and verified
// against this task's own investigation of the actual page content
// (nav/footer chrome excluded) — see this file's header comment.
const ATOLL_NAME_TO_CODE = [
  ["North Male Atoll", "K"], ["South Male Atoll", "K"], ["North Male", "K"], ["South Male", "K"],
  ["Kaafu Atoll", "K"], ["Male Atoll", "K"],
  ["North Ari Atoll", "AA"], ["North Ari", "AA"], ["Alif Alif", "AA"],
  ["South Ari Atoll", "ADh"], ["South Ari", "ADh"], ["Alif Dhaalu", "ADh"], ["Alif Dhaal", "ADh"],
  ["Baa Atoll", "B"], ["Lhaviyani Atoll", "Lh"],
  ["Noonu Atoll", "N"], ["Raa Atoll", "R"],
  ["Haa Alifu Atoll", "HA"], ["Haa Alif Atoll", "HA"],
  ["Haa Dhaalu Atoll", "HDh"], ["Haa Dhaal Atoll", "HDh"],
  ["Shaviyani Atoll", "Sh"],
  ["Vaavu Atoll", "V"], ["Felidhu Atoll", "V"],
  ["Meemu Atoll", "M"], ["Mulaku Atoll", "M"],
  ["Faafu Atoll", "F"], ["North Nilandhe", "F"],
  ["Dhaalu Atoll", "Dh"], ["South Nilandhe", "Dh"],
  ["Thaa Atoll", "Th"], ["Kolhumadulu Atoll", "Th"],
  ["Laamu Atoll", "L"], ["Hadhdhunmathi Atoll", "L"],
  ["Gaafu Alifu Atoll", "GA"], ["North Huvadhu", "GA"],
  ["Gaafu Dhaalu Atoll", "GDh"], ["South Huvadhu", "GDh"],
  ["Gnaviyani Atoll", "Gn"], ["Fuvahmulah", "Gn"],
  ["Seenu Atoll", "S"], ["Addu Atoll", "S"], ["Addu City", "S"],
];

const NOISE_SELECTORS = ["script", "style", "nav", "header", "header2", "footer", "footer2", ".nav-sub"];

function extractJsonLd(html) {
  const matches = [...html.matchAll(/<script type="application\/ld\+json">([\s\S]*?)<\/script>/g)];
  for (const m of matches) {
    try {
      const parsed = JSON.parse(m[1]);
      if (parsed && (parsed.offers || parsed.itinerary)) return parsed;
    } catch {
      // try the next block, if any
    }
  }
  return null;
}

function extractJsPrices(html) {
  const adult = html.match(/adultPrice\s*=\s*([0-9.]+)/);
  const child = html.match(/childPrice\s*=\s*([0-9.]+)/);
  return {
    adultPrice: adult ? Number(adult[1]) : null,
    childPrice: child ? Number(child[1]) : null,
  };
}

function extractDurationMinutes(html) {
  const meta = html.match(/<meta\s+name=["']description["']\s+content=["']([^"']*)["']/i);
  const m = (meta?.[1] ?? "").match(/(\d+)[\s-]?minute/i);
  return m ? Number(m[1]) : null;
}

function extractAtollCode($) {
  const text = $("body").text().replace(/\s+/g, " ");
  for (const [pattern, code] of ATOLL_NAME_TO_CODE) {
    if (text.includes(pattern)) return code;
  }
  return null;
}

function inferTransferType(text) {
  const hay = text.toLowerCase();
  if (/seaplane/.test(hay)) return "seaplane";
  if (/domestic flight/.test(hay)) return "domestic_flight";
  if (/private yacht|\byacht\b/.test(hay)) return "private_yacht";
  if (/ferry/.test(hay)) return "ferry";
  return "speedboat";
}

function ltreeLabel(slug) {
  return slug.replace(/-/g, "_");
}

function sqlString(value) {
  if (value === null || value === undefined) return "null";
  return `'${toAsciiSafe(value).replace(/'/g, "''")}'`;
}

function sqlLiteral(value) {
  if (value === null || value === undefined) return "null";
  return String(value);
}

function main() {
  const urlInventoryPath = path.join(CONTENT_DATA_DIR, "url-inventory.json");
  if (!existsSync(urlInventoryPath)) {
    console.error("Run scripts/import-legacy-urls.mjs first.");
    process.exit(1);
  }
  const urlInventory = JSON.parse(readFileSync(urlInventoryPath, "utf8"));
  const transferPages = urlInventory.pages.filter((p) => p.pageType === "transfer");

  const entities = buildEntityIndex();
  const existingIslandEntities = entities.filter((e) => e.type === "island");
  const atolls = loadJson("locations", "atolls.json");
  const atollBySlugCode = new Map(); // code -> { slug, name }
  for (const atoll of atolls) {
    if (!atoll.administrative_code) continue;
    const slug = slugify(atoll.name.replace(/\s+Atoll$/i, ""));
    atollBySlugCode.set(atoll.administrative_code, { slug, name: atoll.name });
  }

  const records = [];
  const priceConflicts = [];

  for (const page of transferPages) {
    const fullPath = path.join(RELEASE_DIR, page.sourceFile);
    let html;
    try {
      html = readFileSync(fullPath, "utf8");
    } catch {
      continue;
    }

    const jsonLd = extractJsonLd(html);
    const places = jsonLd?.itinerary?.itemListElement?.filter((p) => p?.name) ?? [];
    if (!jsonLd || places.length !== 2) {
      records.push({ oldUrl: page.oldUrl, sourceFile: page.sourceFile, title: page.title, status: "no-destination", reason: "No structured (JSON-LD) route data with exactly one origin and one destination place — likely a hub/listing/utility page, not a single bookable transfer." });
      continue;
    }

    const [originPlace, destinationPlace] = places;
    if (!ORIGIN_NAME_PATTERN.test(originPlace.name)) {
      records.push({ oldUrl: page.oldUrl, sourceFile: page.sourceFile, title: page.title, status: "review", reason: `Origin "${originPlace.name}" is not an airport-origin transfer — not yet supported by this migration.` });
      continue;
    }

    const $ = load(html);
    for (const sel of NOISE_SELECTORS) $(sel).remove();

    const jsonLdPrice = jsonLd.offers?.price ? Number(jsonLd.offers.price) : null;
    const jsPrices = extractJsPrices(html);
    const price = jsonLdPrice ?? jsPrices.adultPrice;
    if (jsonLdPrice !== null && jsPrices.adultPrice !== null && jsonLdPrice !== jsPrices.adultPrice) {
      priceConflicts.push({ sourceFile: page.sourceFile, jsonLdPrice, jsAdultPrice: jsPrices.adultPrice, usedValue: jsonLdPrice, note: "JSON-LD price used (matches the page's own <title>/meta description); the booking-form JS adultPrice variable disagreed — flagged, not silently resolved." });
    }
    if (!price) {
      records.push({ oldUrl: page.oldUrl, sourceFile: page.sourceFile, title: page.title, status: "review", reason: "No usable price found in JSON-LD or the booking-form JavaScript — never migrated without a real price." });
      continue;
    }

    const currency = jsonLd.offers?.priceCurrency ?? "USD";
    const durationMinutes = extractDurationMinutes(html);
    const atollCode = extractAtollCode($);
    const transferType = inferTransferType(`${jsonLd.name ?? ""} ${jsonLd.description ?? ""}`);
    const destinationName = destinationPlace.name;
    const geo = destinationPlace.geo ?? null;

    // 1. Does this destination match an ALREADY-SEEDED real island
    //    (Task 4/5/10)? Use it directly, never a duplicate. Atoll-region
    //    phrases are stripped from the match text first — a resort brand
    //    name that itself embeds a region qualifier (found during this
    //    task's own investigation: "LUX* North Male Atoll" falsely
    //    matched the real island "Male" purely on the shared word "male",
    //    even though the resort isn't on that island at all) must never
    //    be scored against real islands using that leftover token.
    let matchBasis = destinationName;
    for (const [pattern] of ATOLL_NAME_TO_CODE) matchBasis = matchBasis.replaceAll(pattern, " ");
    const destTokens = new Set(distinctiveTokens(matchBasis));
    let existingMatch = null;
    for (const island of existingIslandEntities) {
      const score = tokenOverlapScore(destTokens, island.tokens);
      if (score >= CONFIDENT && (!existingMatch || score > existingMatch.score)) existingMatch = { island, score };
    }

    let islandSlug;
    let islandTitle;
    let isNewLocation = false;
    let atollSlug = null;
    let atollName = null;

    if (existingMatch) {
      islandSlug = existingMatch.island.slug;
      islandTitle = existingMatch.island.title;
      atollSlug = existingMatch.island.atollSlug;
    } else if (atollCode && atollBySlugCode.has(atollCode)) {
      const atoll = atollBySlugCode.get(atollCode);
      islandSlug = slugify(destinationName);
      islandTitle = destinationName;
      isNewLocation = true;
      atollSlug = atoll.slug;
      atollName = atoll.name;
    } else {
      records.push({ oldUrl: page.oldUrl, sourceFile: page.sourceFile, title: page.title, destinationNameRaw: destinationName, status: "review", reason: "Destination does not match an already-seeded island and no real atoll could be recovered from this page's own body text — never placed without that evidence." });
      continue;
    }

    records.push({
      oldUrl: page.oldUrl,
      sourceFile: page.sourceFile,
      title: page.title,
      serviceName: jsonLd.name ?? page.title,
      description: jsonLd.description ?? page.metaDescription ?? null,
      destinationNameRaw: destinationName,
      islandSlug,
      islandTitle,
      isNewLocation,
      atollSlug,
      atollName,
      geo: geo ? { lat: Number(geo.latitude), lng: Number(geo.longitude) } : null,
      price,
      childPrice: jsPrices.childPrice,
      currency,
      durationMinutes,
      transferType,
      sharedOrPrivate: "shared",
      alreadyCoveredRoute: ALREADY_COVERED_DESTINATION_SLUGS.has(islandSlug),
      status: "ready",
    });
  }

  const ready = records.filter((r) => r.status === "ready");
  const newLocationsCount = new Set(ready.filter((r) => r.isNewLocation).map((r) => r.islandSlug)).size;
  const byStatus = {};
  for (const r of records) byStatus[r.status] = (byStatus[r.status] ?? 0) + 1;

  const report = {
    generatedAt: new Date().toISOString(),
    note:
      "Task 18. Matches/creates real destination locations directly from each legacy transfer page's own JSON-LD " +
      "(name, price, currency, geo-coordinates) and its own body text (real atoll name) — never invented. See this " +
      "script's header comment for the full method.",
    totalTransferPages: transferPages.length,
    byStatus,
    readyServices: ready.length,
    distinctNewIslands: newLocationsCount,
    distinctDestinations: new Set(ready.map((r) => r.islandSlug)).size,
    priceConflicts,
    records,
  };
  writeFileSync(path.join(MIGRATION_DATA_DIR, "transfer-legacy-recovery.json"), JSON.stringify(report, null, 2));

  console.log(`Legacy transfer pages: ${transferPages.length}`);
  console.log("By status:", byStatus);
  console.log(`Ready services: ${ready.length}, distinct destinations: ${report.distinctDestinations} (${newLocationsCount} new islands to create)`);
  console.log(`Price conflicts found: ${priceConflicts.length}`);
  console.log("Wrote data/maldives/migration/transfer-legacy-recovery.json");

  if (COMMIT) writeCommitMigration(ready, atollBySlugCode);
  else console.log("\n(dry run — pass --commit to also emit a SQL migration)");
}

function writeCommitMigration(ready) {
  const lines = [];
  lines.push("-- Task 18: full legacy transfer recovery — new destination islands, routes,");
  lines.push("-- and services from the complete legacy transfer inventory (release/public_html/transfer/");
  lines.push("-- and related root-level pages), superseding Task 15's more conservative pass");
  lines.push("-- (supabase/migrations/20250110000700_legacy_transfers.sql, which found only 2 matches).");
  lines.push("-- GENERATED FILE - do not hand-edit. Regenerate with:");
  lines.push("--   node scripts/rebuild-legacy-transfers.mjs --commit");
  lines.push("-- Source: data/maldives/migration/transfer-legacy-recovery.json (status=ready).");
  lines.push("");

  lines.push(
    `insert into nodes (node_type, slug, title, summary, status, published_at) values ('provider', ${sqlString(TRANSFER_PROVIDER_SLUG)}, ${sqlString(TRANSFER_PROVIDER_NAME)}, ${sqlString(`${TRANSFER_PROVIDER_NAME} operates airport speedboat transfer bookings in the Maldives.`)}, 'published', now()) on conflict (node_type, slug) do nothing;`,
  );
  lines.push("");
  lines.push(
    `insert into providers (id) select id from nodes where node_type = 'provider' and slug = ${sqlString(TRANSFER_PROVIDER_SLUG)} on conflict (id) do nothing;`,
  );
  lines.push("");

  // New islands — one insert per distinct new island, first occurrence wins.
  const seenIslands = new Map();
  for (const r of ready) {
    if (!r.isNewLocation || seenIslands.has(r.islandSlug)) continue;
    seenIslands.set(r.islandSlug, r);
  }
  let newIslandCount = 0;
  for (const r of seenIslands.values()) {
    const summary = `${r.islandTitle} is an island in ${r.atollName}, Maldives.`;
    lines.push(`-- New island: ${toAsciiSafe(r.islandTitle)} (${r.atollName}) - recovered from ${r.sourceFile}`);
    lines.push(
      `insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at) values ('location', ${sqlString(r.islandSlug)}, ${sqlString(r.islandTitle)}, ${sqlString(summary)}, 'published', ${sqlString(`${r.islandTitle}, ${r.atollName} | Maldives Islands | MTG`)}, ${sqlString(summary)}, now()) on conflict (node_type, slug) do nothing;`,
    );
    lines.push("");
    lines.push(
      `insert into locations (id, location_type, parent_id, path, is_inhabited${r.geo ? ", lat, lng" : ""}) select n.id, 'island', p.id, (p_loc.path || ${sqlString(ltreeLabel(r.islandSlug))}::ltree), false${r.geo ? `, ${r.geo.lat}, ${r.geo.lng}` : ""} from nodes n, nodes p join locations p_loc on p_loc.id = p.id where n.node_type = 'location' and n.slug = ${sqlString(r.islandSlug)} and p.node_type = 'location' and p.slug = ${sqlString(r.atollSlug)} on conflict (id) do nothing;`,
    );
    lines.push("");
    newIslandCount += 1;
  }

  // Routes + services — group by destination island.
  const byIsland = new Map();
  for (const r of ready) {
    const list = byIsland.get(r.islandSlug) ?? [];
    list.push(r);
    byIsland.set(r.islandSlug, list);
  }

  let routeCount = 0;
  let serviceCount = 0;
  for (const [islandSlug, group] of byIsland) {
    const routeSlug = `${ORIGIN_LOCATION_SLUG}-to-${islandSlug}`;
    const title = `Velana International Airport to ${group[0].islandTitle}`;
    const summary = `Transfer route from Velana International Airport to ${group[0].islandTitle}.`;

    lines.push(`-- Route: ${toAsciiSafe(title)}`);
    lines.push(
      `insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at) values ('transfer_route', ${sqlString(routeSlug)}, ${sqlString(title)}, ${sqlString(summary)}, 'published', ${sqlString(`${title} Transfers | Maldives Tour Guide`)}, ${sqlString(summary)}, now()) on conflict (node_type, slug) do nothing;`,
    );
    lines.push("");
    lines.push(
      `insert into transfer_routes (id, origin_location_id, destination_location_id, typical_duration_minutes) select n.id, o.id, d.id, ${sqlLiteral(group[0].durationMinutes)} from nodes n, nodes o, nodes d where n.node_type = 'transfer_route' and n.slug = ${sqlString(routeSlug)} and o.node_type = 'location' and o.slug = ${sqlString(ORIGIN_LOCATION_SLUG)} and d.node_type = 'location' and d.slug = ${sqlString(islandSlug)} on conflict (id) do nothing;`,
    );
    lines.push("");
    routeCount += 1;

    for (const r of group) {
      const serviceKey = `transfer-service::${routeSlug}::${TRANSFER_PROVIDER_SLUG}::${slugify(r.serviceName)}`;
      const serviceId = deterministicUuid(serviceKey);
      const description = [r.description, r.childPrice ? `Child price (ages 2-11): ${r.currency} ${r.childPrice}.` : null]
        .filter(Boolean)
        .join(" ");
      lines.push(
        `insert into transfer_services (id, route_id, provider_id, transfer_type, shared_or_private, duration_minutes, price, currency, status, description) select ${sqlString(serviceId)}::uuid, (select id from nodes where node_type = 'transfer_route' and slug = ${sqlString(routeSlug)}), (select id from nodes where node_type = 'provider' and slug = ${sqlString(TRANSFER_PROVIDER_SLUG)}), ${sqlString(r.transferType)}, ${sqlString(r.sharedOrPrivate)}, ${sqlLiteral(r.durationMinutes)}, ${sqlLiteral(r.price)}, ${sqlString(r.currency)}, 'active', ${sqlString(description || null)} on conflict (id) do nothing;`,
      );
      lines.push("");
      serviceCount += 1;
    }
  }

  const migrationPath = path.join(ROOT, "supabase", "migrations", "20250112000100_legacy_transfers_rebuild.sql");
  writeFileSync(migrationPath, lines.join("\n") + "\n");
  console.log(`\nWrote ${migrationPath}`);
  console.log(`  new islands: ${newIslandCount}, routes: ${routeCount}, services: ${serviceCount}`);
}

main();
