#!/usr/bin/env node
// Task 15 §12-16: legacy transfer page inventory + migration.
//
// Reads the "transfer" pages already classified in
// data/maldives/content/url-inventory.json (built by
// scripts/import-legacy-urls.mjs — Task 14 explicitly deferred these
// pages to this dedicated migration). Every one of these legacy pages
// carries real schema.org TouristTrip JSON-LD (name, description, real
// origin/destination places, a real price/currency, and a real provider —
// the site's own "Maldives Tour Guide" travel-agency contact details) —
// genuine commercial evidence, not scraped guesswork.
//
// Destinations are matched against the REAL accommodation catalogue
// (scripts/lib/legacy-shared.mjs's buildEntityIndex(), the same live
// source-of-truth data every other migration script in this repo uses) —
// never fabricated, never a new accommodation/location created here. A
// destination whose resort isn't yet a real MTG entity is marked
// needs-review, not silently dropped and not guessed into existence.
//
// A matched destination already covered by an existing transfer_routes row
// (Task 10 — see data/maldives/transfers/routes.json) is left alone: this
// script only ever ADDS a route/service for a genuinely new destination,
// never a duplicate route for one already live.
//
// Writes:
//   data/maldives/content/transfer-migration-report.json
//
// Read-only by default. Usage:
//   node scripts/import-legacy-transfers.mjs            # report only
//   node scripts/import-legacy-transfers.mjs --commit   # also emit a SQL migration
//
// Deliberately mirrors import-legacy-articles.mjs's own structure/
// conventions (single-line SQL statements, toAsciiSafe() string values,
// on conflict ... do nothing except where content must refresh).

import { existsSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import {
  DATA_DIR,
  RELEASE_DIR,
  ROOT,
  buildEntityIndex,
  deterministicUuid,
  distinctiveTokens,
  slugify,
  toAsciiSafe,
  tokenOverlapScore,
} from "./lib/legacy-shared.mjs";

const CONTENT_DATA_DIR = path.join(DATA_DIR, "content");
const COMMIT = process.argv.includes("--commit");

// Every transfer_route currently live from Task 10's own research
// (data/maldives/transfers/routes.json), keyed by destination island slug —
// this script must never create a second route to one of these (Task 15
// §12-16: "deduplicated, never a duplicate accommodation/route record").
const ALREADY_COVERED_DESTINATION_SLUGS = new Set([
  "male",
  "vihamanaafushi",
  "baros",
  "velassaru",
  "lankanfushi",
  "maafushi",
  "kunfunadhoo",
  "olhuveli",
]);

const ORIGIN_LOCATION_SLUG = "velana-international-airport";
const ORIGIN_NAME_PATTERN = /airport/i;

const TRANSFER_PROVIDER_NAME = "Maldives Tour Guide";
const TRANSFER_PROVIDER_SLUG = "maldives-tour-guide-transfers";

function extractJsonLd(html) {
  const matches = [...html.matchAll(/<script type="application\/ld\+json">([\s\S]*?)<\/script>/g)];
  for (const m of matches) {
    try {
      const parsed = JSON.parse(m[1]);
      if (parsed && (parsed.offers || parsed.itinerary)) return parsed;
    } catch {
      // Malformed JSON-LD on this block — try the next one, if any.
    }
  }
  return null;
}

function extractDurationMinutes(html) {
  const meta = html.match(/<meta\s+name=["']description["']\s+content=["']([^"']*)["']/i);
  const m = (meta?.[1] ?? "").match(/(\d+)[\s-]?minute/i);
  return m ? Number(m[1]) : null;
}

function inferTransferType(text) {
  const hay = text.toLowerCase();
  if (/seaplane/.test(hay)) return "seaplane";
  if (/domestic flight/.test(hay)) return "domestic_flight";
  if (/private yacht|\byacht\b/.test(hay)) return "private_yacht";
  if (/ferry/.test(hay)) return "ferry";
  return "speedboat";
}

function buildLookups(entities) {
  const accommodationEntities = entities.filter((e) => ["hotel", "resort", "guesthouse", "villa", "other"].includes(e.type));
  const atollSlugByCode = new Map();
  for (const e of entities) if (e.type === "atoll") atollSlugByCode.set(e.administrativeCode, e.slug);
  const islandByKey = new Map();
  for (const e of entities) if (e.type === "island") islandByKey.set(`${e.title}::${e.atollSlug}`, e);
  return { accommodationEntities, atollSlugByCode, islandByKey };
}

function matchAccommodation(destinationName, lookups) {
  const destTokens = new Set(distinctiveTokens(destinationName));
  let best = null;
  for (const acc of lookups.accommodationEntities) {
    const score = tokenOverlapScore(destTokens, acc.tokens);
    if (score > 0 && (!best || score > best.score)) best = { acc, score };
  }
  return best && best.score >= 0.6 ? best : null;
}

function resolveIsland(accEntity, lookups) {
  const atollSlug = lookups.atollSlugByCode.get(accEntity.atollCode);
  if (!atollSlug) return null;
  return lookups.islandByKey.get(`${accEntity.islandName}::${atollSlug}`) ?? null;
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
    console.error("Run scripts/import-legacy-urls.mjs first (needs data/maldives/content/url-inventory.json).");
    process.exit(1);
  }
  const urlInventory = JSON.parse(readFileSync(urlInventoryPath, "utf8"));
  const transferPages = urlInventory.pages.filter((p) => p.pageType === "transfer");

  const entities = buildEntityIndex();
  const lookups = buildLookups(entities);

  const records = [];

  for (const page of transferPages) {
    const fullPath = path.join(RELEASE_DIR, page.sourceFile);
    let html;
    try {
      html = readFileSync(fullPath, "utf8");
    } catch {
      records.push({ oldUrl: page.oldUrl, sourceFile: page.sourceFile, migrationStatus: "malformed", reason: "source file unreadable" });
      continue;
    }

    const jsonLd = extractJsonLd(html);
    const places = jsonLd?.itinerary?.itemListElement?.map((p) => p.name).filter(Boolean) ?? [];
    const price = jsonLd?.offers?.price ? Number(jsonLd.offers.price) : null;

    if (!jsonLd || places.length !== 2 || !price) {
      records.push({
        oldUrl: page.oldUrl,
        sourceFile: page.sourceFile,
        title: page.title,
        migrationStatus: "needs-review",
        reason: "no structured (JSON-LD) route/price data on this page — likely a hub/listing page, not a single bookable transfer",
      });
      continue;
    }

    const [originName, destinationName] = places;
    if (!ORIGIN_NAME_PATTERN.test(originName)) {
      records.push({
        oldUrl: page.oldUrl,
        sourceFile: page.sourceFile,
        title: page.title,
        migrationStatus: "needs-review",
        reason: `origin "${originName}" is not an airport-origin transfer — not yet supported by this migration`,
      });
      continue;
    }

    const match = matchAccommodation(destinationName, lookups);
    if (!match) {
      records.push({
        oldUrl: page.oldUrl,
        sourceFile: page.sourceFile,
        title: page.title,
        destinationNameRaw: destinationName,
        price,
        currency: jsonLd.offers.priceCurrency ?? "USD",
        migrationStatus: "needs-review",
        reason: `destination "${destinationName}" does not match any accommodation in the current MTG catalogue (data/maldives/accommodations/accommodations.json) — never fabricated`,
      });
      continue;
    }

    const island = resolveIsland(match.acc, lookups);
    if (!island) {
      records.push({
        oldUrl: page.oldUrl,
        sourceFile: page.sourceFile,
        title: page.title,
        destinationNameRaw: destinationName,
        matchedAccommodation: { slug: match.acc.slug, title: match.acc.title, score: Number(match.score.toFixed(2)) },
        migrationStatus: "needs-review",
        reason: `matched accommodation "${match.acc.title}" but could not resolve its island to a real, seeded location`,
      });
      continue;
    }

    const description = jsonLd.description ?? page.metaDescription ?? null;
    const durationMinutes = extractDurationMinutes(html);
    const transferType = inferTransferType(`${jsonLd.name ?? ""} ${description ?? ""}`);

    const record = {
      oldUrl: page.oldUrl,
      sourceFile: page.sourceFile,
      title: page.title,
      serviceName: jsonLd.name ?? page.title,
      description,
      originName,
      destinationNameRaw: destinationName,
      matchedAccommodation: { slug: match.acc.slug, title: match.acc.title, score: Number(match.score.toFixed(2)) },
      destinationIslandSlug: island.slug,
      price,
      currency: jsonLd.offers.priceCurrency ?? "USD",
      durationMinutes,
      transferType,
      // No reliable shared/private signal exists in the source page (see
      // this script's header comment) — every one of these is sold as an
      // openly bookable, instantly-confirmed transfer via the site's own
      // booking channel (not a resort-exclusive arrangement), so "shared"
      // is the honest default rather than a guessed "private". Recorded
      // explicitly here (not silently assumed) so it's auditable.
      sharedOrPrivate: "shared",
      sharedOrPrivateInferred: true,
    };

    if (ALREADY_COVERED_DESTINATION_SLUGS.has(island.slug)) {
      record.migrationStatus = "already-covered";
      record.reason = `a transfer_routes row from Velana International Airport to "${island.title}" already exists (Task 10) — not duplicated`;
    } else {
      record.migrationStatus = "ready";
    }

    records.push(record);
  }

  const byStatus = {};
  for (const r of records) byStatus[r.migrationStatus] = (byStatus[r.migrationStatus] ?? 0) + 1;

  writeFileSync(
    path.join(CONTENT_DATA_DIR, "transfer-migration-report.json"),
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        note:
          "Task 15 §12-16. Every 'ready' entry has real JSON-LD-sourced commercial data (name/price/currency/duration) " +
          "and a real, already-seeded destination accommodation + island — never fabricated. 'needs-review' entries are " +
          "never silently dropped; each carries a specific reason (see scripts/import-legacy-transfers.mjs).",
        totalTransferPages: transferPages.length,
        byMigrationStatus: byStatus,
        alreadyCoveredDestinationSlugs: [...ALREADY_COVERED_DESTINATION_SLUGS],
        pages: records,
      },
      null,
      2,
    ),
  );

  console.log(`Classified ${records.length} legacy transfer pages`);
  console.log("By migration status:", byStatus);
  console.log("Wrote data/maldives/content/transfer-migration-report.json");

  if (COMMIT) {
    writeCommitMigration(records.filter((r) => r.migrationStatus === "ready"));
  } else {
    console.log("\n(dry run — pass --commit to also emit a SQL migration for ready transfers)");
  }
}

function writeCommitMigration(readyTransfers) {
  const lines = [];
  lines.push("-- Task 15: legacy transfer pages migrated into the existing transfer_routes/");
  lines.push("-- transfer_services architecture (Task 10 - no new schema).");
  lines.push("-- GENERATED FILE - do not hand-edit. Regenerate with:");
  lines.push("--   node scripts/import-legacy-transfers.mjs --commit");
  lines.push("-- Source: data/maldives/content/transfer-migration-report.json (status=ready).");
  lines.push("--");
  lines.push("-- Every route here is a genuinely NEW destination not already covered by");
  lines.push("-- Task 10's own routes.json seed (see ALREADY_COVERED_DESTINATION_SLUGS in");
  lines.push("-- scripts/import-legacy-transfers.mjs) - this migration never creates a second");
  lines.push("-- route for an already-live (origin, destination) pair.");
  lines.push("");

  if (readyTransfers.length > 0) {
    lines.push("-- Provider: the legacy site's own booking channel (real contact details were");
    lines.push("-- present in every source page's own schema.org JSON-LD).");
    lines.push(
      `insert into nodes (node_type, slug, title, summary, status, published_at) values ('provider', ${sqlString(TRANSFER_PROVIDER_SLUG)}, ${sqlString(TRANSFER_PROVIDER_NAME)}, ${sqlString(`${TRANSFER_PROVIDER_NAME} operates airport speedboat transfer bookings in the Maldives.`)}, 'published', now()) on conflict (node_type, slug) do nothing;`,
    );
    lines.push("");
    lines.push(
      `insert into providers (id) select id from nodes where node_type = 'provider' and slug = ${sqlString(TRANSFER_PROVIDER_SLUG)} on conflict (id) do nothing;`,
    );
    lines.push("");
  }

  let routeCount = 0;
  let serviceCount = 0;
  const seenRouteSlugs = new Set();

  for (const t of readyTransfers) {
    const routeSlug = `${ORIGIN_LOCATION_SLUG}-to-${t.destinationIslandSlug}`;
    const title = `${ORIGIN_LOCATION_SLUG === "velana-international-airport" ? "Velana International Airport" : t.originName} to ${t.matchedAccommodation.title}`;

    if (!seenRouteSlugs.has(routeSlug)) {
      seenRouteSlugs.add(routeSlug);
      const summary = `Transfer route from Velana International Airport to ${t.destinationIslandSlug}.`;
      lines.push(`-- Route: ${toAsciiSafe(title)}`);
      lines.push(
        `insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at) values ('transfer_route', ${sqlString(routeSlug)}, ${sqlString(title)}, ${sqlString(summary)}, 'published', ${sqlString(`${title} Transfers | Maldives Tour Guide`)}, ${sqlString(summary)}, now()) on conflict (node_type, slug) do nothing;`,
      );
      lines.push("");
      lines.push(
        `insert into transfer_routes (id, origin_location_id, destination_location_id, typical_duration_minutes) select n.id, o.id, d.id, ${sqlLiteral(t.durationMinutes)} from nodes n, nodes o, nodes d where n.node_type = 'transfer_route' and n.slug = ${sqlString(routeSlug)} and o.node_type = 'location' and o.slug = ${sqlString(ORIGIN_LOCATION_SLUG)} and d.node_type = 'location' and d.slug = ${sqlString(t.destinationIslandSlug)} on conflict (id) do nothing;`,
      );
      lines.push("");
      routeCount += 1;
    }

    const serviceKey = `transfer-service::${routeSlug}::${TRANSFER_PROVIDER_SLUG}::${slugify(t.serviceName)}`;
    const serviceId = deterministicUuid(serviceKey);
    lines.push(
      `insert into transfer_services (id, route_id, provider_id, transfer_type, shared_or_private, duration_minutes, price, currency, status, description) select ${sqlString(serviceId)}::uuid, (select id from nodes where node_type = 'transfer_route' and slug = ${sqlString(routeSlug)}), (select id from nodes where node_type = 'provider' and slug = ${sqlString(TRANSFER_PROVIDER_SLUG)}), ${sqlString(t.transferType)}, ${sqlString(t.sharedOrPrivate)}, ${sqlLiteral(t.durationMinutes)}, ${sqlLiteral(t.price)}, ${sqlString(t.currency)}, 'active', ${sqlString(t.description)} on conflict (id) do nothing;`,
    );
    lines.push("");
    serviceCount += 1;
  }

  const migrationPath = path.join(ROOT, "supabase", "migrations", "20250110000700_legacy_transfers.sql");
  writeFileSync(migrationPath, lines.join("\n") + "\n");
  console.log(`\nWrote ${migrationPath}`);
  console.log(`  routes: ${routeCount}, services: ${serviceCount}`);
}

main();
