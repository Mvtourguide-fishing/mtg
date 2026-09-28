#!/usr/bin/env node
// Task 20: data migration for the Maldives Transfers SEO platform rebuild.
// Generates supabase/migrations/20250113000200_transfers_platform_data.sql
// from real sources only:
//  - transfer-category tagging of existing transfer_route nodes, derived
//    from data already in the DB (origin = Velana Airport -> 'airport';
//    destination.is_inhabited -> 'resort'/'island') via subselects, not
//    hardcoded ids, so it's correct regardless of which environment it's
//    applied to.
//  - 7 real speedboats, transcribed verbatim from specs the site owner
//    gave directly in chat (name/capacity/length/engine/speed/facilities)
//    — never invented. The owner said "8 speedboats"; only 7 were named,
//    and that discrepancy is reported, not papered over with a fabricated
//    8th boat.
//  - 9 real province ferry routes (15 scheduled variants), transcribed
//    from release/public_html/maldives-transportation-ferry-speedboat-
//    transfers.html (the legacy site's own single ferry-schedule page,
//    confirmed via an Explore agent's exhaustive search — see this
//    script's inline FERRY_ROUTES data for the source citation on each
//    route). One header-ordering inconsistency in the legacy source
//    (route 101 alone) is normalized for internal chronological
//    consistency and flagged in a comment, not silently "fixed" away.
//
// Vehicles (car transfer fleet) are deliberately NOT seeded here — no
// legacy or owner-supplied data exists yet for the 2x4-seater/2x6-seater/
// minibus/bus fleet described in the task brief; the `vehicles` table and
// its UI are built ready to receive that data once supplied.
//
// Usage: node scripts/build-transfers-platform-v2.mjs [--commit]

import { existsSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, deterministicUuid, RELEASE_DIR, ROOT, slugify, storagePathForRelativePath, toAsciiSafe } from "./lib/legacy-shared.mjs";

const COMMIT = process.argv.includes("--commit");

function sqlString(value) {
  if (value === null || value === undefined) return "null";
  return `'${toAsciiSafe(String(value)).replace(/'/g, "''")}'`;
}
function sqlLiteral(value) {
  if (value === null || value === undefined) return "null";
  return String(value);
}
function sqlArray(values) {
  if (!values || values.length === 0) return "'{}'";
  return `ARRAY[${values.map((v) => sqlString(v)).join(", ")}]::text[]`;
}
function ltreeLabel(slug) {
  return slug.replace(/-/g, "_");
}
function nodeIdBySlug(nodeType, slug) {
  return `(select id from nodes where node_type = ${sqlString(nodeType)} and slug = ${sqlString(slug)})`;
}
function islandLocationIdByName(name) {
  const slug = slugify(name);
  return `(select l.id from locations l join nodes n on n.id = l.id where n.node_type = 'location' and l.location_type = 'island' and n.slug = ${sqlString(slug)})`;
}

// ── §1: transfer-category taxonomy + route tagging ─────────────────────

const TRANSFER_CATEGORIES = [
  { slug: "airport", title: "Airport Transfer" },
  { slug: "resort-transfer", title: "Resort Transfer" },
  { slug: "hotel-transfer", title: "Hotel Transfer" },
  { slug: "island-transfer", title: "Island Transfer" },
];

// ── §2: speedboats — verbatim from the owner's own message, chat log
// 2026-09-20. Only facts actually stated are recorded; nothing invented.
const SPEEDBOATS = [
  {
    name: "Chill Speed",
    capacity: 8,
    lengthFeet: 25,
    engineCount: 1,
    horsepower: 250,
    topSpeedKnots: 28,
    facilities: [],
  },
  {
    name: "Jupiter 11",
    capacity: 15,
    lengthFeet: 28,
    engineCount: 2,
    horsepower: null,
    topSpeedKnots: 32,
    facilities: [],
  },
  {
    name: "Chill Speed 2",
    capacity: 18,
    lengthFeet: 30,
    engineCount: 2,
    horsepower: null,
    topSpeedKnots: 33,
    facilities: ["Toilet"],
  },
  {
    name: "Winover",
    capacity: 22,
    lengthFeet: 32,
    engineCount: 2,
    horsepower: null,
    topSpeedKnots: 35,
    facilities: ["Toilet"],
  },
  {
    name: "Seaguard",
    capacity: 22,
    lengthFeet: 36,
    engineCount: 2,
    horsepower: null,
    topSpeedKnots: 36,
    facilities: [],
  },
  {
    name: "Arriva",
    capacity: 28,
    lengthFeet: 38,
    engineCount: null,
    horsepower: null,
    topSpeedKnots: null,
    facilities: ["Air conditioning"],
  },
  {
    name: "Touring 43",
    capacity: 16,
    lengthFeet: null,
    engineCount: null,
    horsepower: null,
    topSpeedKnots: 35,
    facilities: ["VIP interior", "Air conditioning", "Toilet", "Luxury finish"],
  },
];

const CHARTER_OPTIONS = ["Hourly hire", "Destination-based charter", "Custom trip"];

function speedboatDescription(b) {
  const parts = [];
  parts.push(`${b.capacity}-seat private charter speedboat`);
  if (b.lengthFeet) parts.push(`${b.lengthFeet} ft`);
  if (b.engineCount) parts.push(`${b.engineCount === 2 ? "twin" : "single"} engine${b.horsepower ? ` (${b.horsepower} hp)` : ""}`);
  if (b.topSpeedKnots) parts.push(`top speed ${b.topSpeedKnots} knots`);
  return `${parts.join(", ")}. Available for hourly hire, destination-based charter, or a custom private trip — no fixed public price; request a charter quote.`;
}

// ── §3: ferry routes — transcribed from release/public_html/
// maldives-transportation-ferry-speedboat-transfers.html (section "Maldives
// Ferry Schedules", anchor #one). Every route below cites that single
// source file. Route 101's raw table header read "Island | Departure |
// Arrival", but every row's own values only make chronological sense as
// "Arrival | Departure" (e.g. the Kulhudhufushi turnaround shows 13:00
// before 10:15 read literally, which is backwards for a stop you arrive
// at before you leave) — normalized to Arrival|Departure to match the
// other 8 routes' internally-consistent ordering; the underlying time
// values themselves are untouched. A few island names appear with two
// legacy spellings across the same page (e.g. "Ragetheemu"/"Rasgetheemu",
// "Feridhu"/"Feridhoo", "Dhidhoo"/"Dhidhdhoo") — normalized to one
// spelling per island for lookup purposes, both variants noted here.
const SOURCE_FERRY_URL = "/maldives-transportation-ferry-speedboat-transfers.html";

// Real images from release/public_html/images/ferry/, one per numbered
// route as they actually appear alongside that route's table on the
// legacy page (confirmed present on disk before use — never a guessed
// filename). Routes 302 and 306 had two images on the legacy page; only
// the first is used as the hero here.
const FERRY_ROUTE_IMAGES = {
  "101": "images/ferry/Kulhudhufushi-ferry-transfer.webp",
  "201": "images/ferry/manadhoo-ferry-schedule.webp",
  "202": "images/ferry/noonu-atoll-ferry-transfer.webp",
  "203": "images/ferry/raa-atoll-transfer-schedule.webp",
  "301": "images/ferry/maldives-ferry-transfer-schedules.webp",
  "302": "images/ferry/alifu-atoll-ferry-transfer-schedule.webp",
  "303": "images/ferry/maldives-island-transfers-schedules.webp",
  "304-305": "images/ferry/maamigili-ferry-transfer-schedule.webp",
  "306": "images/ferry/vaavu-atoll-ferry-transfer-schedules.webp",
};

function stop(island, arrival, departure) {
  return { island, arrival, departure };
}

const FERRY_ROUTES = [
  {
    routeNumber: "101",
    title: "Thuraakunu - Kulhudhuffushi",
    province: "Upper North Province",
    operatingDays: "Every Monday",
    origin: "Thuraakunu",
    destination: "Kulhudhuffushi",
    stops: [
      stop("Thuraakunu", null, "06:00"),
      stop("Uligamu", "06:20", "06:25"),
      stop("Mulhadhoo", "06:55", "07:00"),
      stop("Dhidhoo", "08:15", "08:20"),
      stop("Utheemu", "08:45", "08:50"),
      stop("Kulhudhuffushi", "10:15", "13:00"),
      stop("Utheemu", "14:25", "14:30"),
      stop("Dhidhoo", "14:50", "14:55"),
      stop("Mulhadhoo", "16:10", "16:15"),
      stop("Uligamu", "16:55", "17:00"),
      stop("Thuraakunu", "17:35", null),
    ],
  },
  {
    routeNumber: "201",
    title: "Henbadhoo - Manadhoo",
    province: "North Province",
    operatingDays: "Every Sat, Sun, Tue, Wed, Thu",
    origin: "Henbadhoo",
    destination: "Manadhoo",
    stops: [
      stop("Henbadhoo", null, "07:00"),
      stop("Kendhikulhudhoo", "07:10", "07:15"),
      stop("Kudafari", "07:45", "07:50"),
      stop("Maalhendhoo", "08:10", "08:15"),
      stop("Landhoo", "08:25", "08:30"),
      stop("Maafaru", "09:00", "09:05"),
      stop("Manadhoo", "09:40", "14:00"),
      stop("Maafaru", "14:35", "14:40"),
      stop("Landhoo", "15:10", "15:15"),
      stop("Maalhendhoo", "15:25", "15:30"),
      stop("Kudafari", "15:50", "15:55"),
      stop("Kendhikulhudhoo", "16:25", "16:30"),
      stop("Henbadhoo", "16:40", null),
    ],
  },
  {
    routeNumber: "202",
    title: "Velidhoo - Manadhoo",
    province: "North Province",
    operatingDays: "Every Sat, Sun, Tue, Wed, Thu",
    origin: "Velidhoo",
    destination: "Manadhoo",
    stops: [
      stop("Velidhoo", null, "07:00"),
      stop("Fohdhoo", "07:40", "07:45"),
      stop("Holhudhoo", "08:10", "08:15"),
      stop("Magoodhoo", "08:55", "09:00"),
      stop("Miladhoo", "09:10", "09:15"),
      stop("Lhohi", "09:25", "09:30"),
      stop("Manadhoo", "09:55", "14:00"),
      stop("Lhohi", "14:25", "14:30"),
      stop("Miladhoo", "14:40", "14:45"),
      stop("Magoodhoo", "14:55", "15:00"),
      stop("Holhudhoo", "15:20", "15:25"),
      stop("Fohdhoo", "15:50", "15:55"),
      stop("Velidhoo", "16:40", null),
    ],
  },
  {
    routeNumber: "203",
    title: "Alifushi - Ungoofaaru",
    province: "North Province",
    operatingDays: "Everyday except Friday",
    origin: "Alifushi",
    destination: "Ungoofaaru",
    stops: [
      stop("Alifushi", null, "06:10"),
      stop("Vaadhoo", "07:00", "07:05"),
      stop("Rasgetheemu", "07:25", "07:30"),
      stop("Angolhitheemu", "07:35", "07:40"),
      stop("Hulhudhuffaaru", "08:00", "08:05"),
      stop("Ifuru Airport", "08:25", "08:30"),
      stop("Ungoofaaru", "08:50", "14:30"),
      stop("Ifuru Airport", "14:50", "14:55"),
      stop("Hulhudhuffaaru", "15:35", "15:40"),
      stop("Angolhitheemu", "15:55", "16:00"),
      stop("Rasgetheemu", "16:10", "16:15"),
      stop("Vaadhoo", "16:35", "16:40"),
      stop("Alifushi", "17:15", null),
    ],
  },
  {
    routeNumber: "301",
    title: "Himandhoo - Rasdhoo",
    province: "North Central Province",
    operatingDays: "Sat, Sun, Mon, Wed, Thu",
    origin: "Himandhoo",
    destination: "Rasdhoo",
    stops: [
      stop("Himandhoo", null, "06:30"),
      stop("Maalhos", "07:00", "07:05"),
      stop("Feridhoo", "07:30", "07:35"),
      stop("Mathiveri", "08:30", "08:35"),
      stop("Bodufolhudhoo", "08:55", "09:00"),
      stop("Ukulhas", "09:35", "09:40"),
      stop("Rasdhoo", "10:35", "13:00"),
      stop("Ukulhas", "13:55", "14:00"),
      stop("Bodufolhudhoo", "14:35", "14:40"),
      stop("Mathiveri", "15:00", "15:05"),
      stop("Feridhoo", "16:00", "16:05"),
      stop("Maalhos", "16:30", "16:35"),
      stop("Himandhoo", "17:05", null),
    ],
  },
  {
    routeNumber: "302",
    title: "Mandhoo - Mahibadhoo",
    province: "North Central Province",
    operatingDays: "Sat, Sun, Tue, Wed, Thu",
    origin: "Mandhoo",
    destination: "Mahibadhoo",
    stops: [
      stop("Mandhoo", null, "06:30"),
      stop("Kunburudhoo", "08:05", "08:10"),
      stop("Mahibadhoo", "08:30", "08:35"),
      stop("Haggnaameedhoo", "09:15", "09:20"),
      stop("Omadhoo", "09:50", "09:55"),
      stop("Mahibadhoo", "10:10", "13:30"),
      stop("Omadhoo", "13:45", "13:50"),
      stop("Haggnaameedhoo", "14:20", "14:25"),
      stop("Mahibadhoo", "15:05", "15:10"),
      stop("Kunburudhoo", "15:30", "15:35"),
      stop("Mandhoo", "17:10", null),
    ],
  },
  {
    routeNumber: "303",
    variantLabel: "Mon & Thu",
    title: "Male - Thoddoo",
    province: "North Central Province",
    operatingDays: "Monday & Thursday",
    origin: "Male",
    destination: "Thoddoo",
    stops: [
      stop("Male", null, "09:00"),
      stop("Rasdhoo", "12:10", "12:15"),
      stop("Ukulhas", "13:05", "14:00"),
      stop("Rasdhoo", "14:50", "15:10"),
      stop("Thoddoo", "16:20", null),
    ],
  },
  {
    routeNumber: "303",
    variantLabel: "Sun & Wed",
    title: "Thoddoo - Male",
    province: "North Central Province",
    operatingDays: "Sunday & Wednesday",
    origin: "Thoddoo",
    destination: "Male",
    stops: [
      stop("Thoddoo", null, "06:30"),
      stop("Rasdhoo", "07:40", "07:45"),
      stop("Ukulhas", "08:35", "09:45"),
      stop("Rasdhoo", "10:35", "11:00"),
      stop("Male", "14:10", null),
    ],
  },
  {
    routeNumber: "303",
    variantLabel: "Sat & Tue",
    title: "Thoddoo - Rasdhoo - Thoddoo",
    province: "North Central Province",
    operatingDays: "Saturday & Tuesday",
    origin: "Thoddoo",
    destination: "Thoddoo",
    stops: [
      stop("Thoddoo", null, "07:00"),
      stop("Rasdhoo", "08:10", "15:10"),
      stop("Thoddoo", "16:20", null),
    ],
  },
  {
    routeNumber: "304-305",
    variantLabel: "Main loop",
    title: "Fenfushi - Mahibadhoo",
    province: "North Central Province",
    operatingDays: "Sat, Sun, Tue, Wed, Thu",
    origin: "Fenfushi",
    destination: "Mahibadhoo",
    stops: [
      stop("Fenfushi", null, "06:30"),
      stop("Maamigili", "06:55", "07:00"),
      stop("Dhidhdhoo", "07:25", "07:30"),
      stop("Dhigurah", "08:00", "08:05"),
      stop("Dhangethi", "08:35", "08:40"),
      stop("Mahibadhoo", "09:40", "13:45"),
      stop("Dhangethi", "14:45", "14:50"),
      stop("Dhigurah", "15:20", "15:25"),
      stop("Dhidhdhoo", "15:55", "16:00"),
      stop("Maamigili", "16:25", "16:30"),
      stop("Fenfushi", "16:55", null),
    ],
  },
  {
    routeNumber: "304-305",
    variantLabel: "Male to Mahibadhoo connector",
    title: "Male - Mahibadhoo",
    province: "North Central Province",
    operatingDays: "Sat, Mon, Wed",
    origin: "Male",
    destination: "Mahibadhoo",
    stops: [stop("Male", null, "09:00"), stop("Mahibadhoo", "13:15", null)],
  },
  {
    routeNumber: "304-305",
    variantLabel: "Mahibadhoo to Male connector",
    title: "Mahibadhoo - Male",
    province: "North Central Province",
    operatingDays: "Sun, Tue, Thu",
    origin: "Mahibadhoo",
    destination: "Male",
    stops: [stop("Mahibadhoo", null, "10:45"), stop("Male", "15:15", null)],
  },
  {
    routeNumber: "306",
    variantLabel: "Rakeedhoo to Male",
    title: "Rakeedhoo - Male",
    province: "North Central Province",
    operatingDays: "Sat, Mon, Wed",
    origin: "Rakeedhoo",
    destination: "Male",
    stops: [
      stop("Rakeedhoo", null, "07:00"),
      stop("Keyodhoo", "08:05", "08:10"),
      stop("Felidhoo", "08:20", "08:25"),
      stop("Thinadhoo", "08:35", "08:40"),
      stop("Fulidhoo", "10:05", "10:30"),
      stop("Maafushi", "12:10", "12:15"),
      stop("Male", "13:40", null),
    ],
  },
  {
    routeNumber: "306",
    variantLabel: "Male to Rakeedhoo",
    title: "Male - Rakeedhoo",
    province: "North Central Province",
    operatingDays: "Sun, Tue, Thu",
    origin: "Male",
    destination: "Rakeedhoo",
    stops: [
      stop("Male", null, "10:00"),
      stop("Maafushi", "11:25", "11:30"),
      stop("Fulidhoo", "13:10", "13:30"),
      stop("Thinadhoo", "14:55", "15:00"),
      stop("Felidhoo", "15:10", "15:15"),
      stop("Keyodhoo", "15:25", "15:30"),
      stop("Rakeedhoo", "16:35", null),
    ],
  },
];

function main() {
  const lines = [];
  lines.push("-- Task 20: transfer-category tagging + speedboat fleet + ferry schedule data.");
  lines.push("-- GENERATED FILE - do not hand-edit. Regenerate with:");
  lines.push("--   node scripts/build-transfers-platform-v2.mjs --commit");
  lines.push("");

  // ── transfer-category taxonomy ──
  lines.push("-- transfer-category taxonomy (Task 20 section 22: multi-category routes)");
  for (const c of TRANSFER_CATEGORIES) {
    const id = deterministicUuid(`transfer-category::${c.slug}`);
    lines.push(
      `insert into nodes (id, node_type, slug, title, status, published_at) values (${sqlString(id)}, 'category', ${sqlString(c.slug)}, ${sqlString(c.title)}, 'published', now()) on conflict (node_type, slug) do nothing;`,
    );
    lines.push(
      `insert into categories (id, category_group, path) select id, 'transfer-category', ${sqlString(ltreeLabel(c.slug))}::ltree from nodes where node_type = 'category' and slug = ${sqlString(c.slug)} on conflict (id) do nothing;`,
    );
  }
  lines.push("");

  // ── tag every existing transfer_route with real categories, derived
  // from data already in the DB — never a hardcoded route list, so this
  // works identically for any route that exists at apply-time (Task 18's
  // 72, or any added later).
  lines.push("-- tag every transfer_route: airport (origin is an airport), resort (destination not inhabited),");
  lines.push("-- island (destination inhabited), hotel (destination inhabited AND has a real hotel/guesthouse accommodation)");
  lines.push(`insert into node_categories (node_id, category_id)
select tr.id, ${nodeIdBySlug("category", "airport")}
from transfer_routes tr
join locations ol on ol.id = tr.origin_location_id
where ol.location_type = 'airport'
on conflict do nothing;`);
  lines.push(`insert into node_categories (node_id, category_id)
select tr.id, ${nodeIdBySlug("category", "resort-transfer")}
from transfer_routes tr
join locations dl on dl.id = tr.destination_location_id
where dl.is_inhabited = false
on conflict do nothing;`);
  lines.push(`insert into node_categories (node_id, category_id)
select tr.id, ${nodeIdBySlug("category", "island-transfer")}
from transfer_routes tr
join locations dl on dl.id = tr.destination_location_id
where dl.is_inhabited = true
on conflict do nothing;`);
  lines.push(`insert into node_categories (node_id, category_id)
select distinct tr.id, ${nodeIdBySlug("category", "hotel-transfer")}
from transfer_routes tr
join locations dl on dl.id = tr.destination_location_id
join node_locations nl on nl.location_id = dl.id
join accommodations acc on acc.id = nl.node_id
where dl.is_inhabited = true and acc.accommodation_type in ('hotel', 'guesthouse')
on conflict do nothing;`);
  lines.push("");

  // ── every transfer_route can take a private-transfer inquiry (Task 20 SS29),
  // whether or not it has a distinct private transfer_service on record ──
  lines.push("-- every route can take a private-transfer inquiry (Task 20 section 29), no fixed price");
  lines.push(`insert into bookable_products (id, booking_mode, base_price, currency, max_guests)
select id, 'inquiry', null, null, null from nodes where node_type = 'transfer_route'
on conflict (id) do nothing;`);
  lines.push("");

  // ── speedboats ──
  lines.push("-- private charter speedboat fleet (7 real boats; owner stated 8 -- only 7 named, see migration report)");
  const speedboatIds = new Set();
  for (const b of SPEEDBOATS) {
    const slug = slugify(b.name);
    const id = deterministicUuid(`speedboat::${slug}`);
    speedboatIds.add(slug);
    lines.push(
      `insert into nodes (id, node_type, slug, title, summary, status, meta_title, meta_description, published_at) values (${sqlString(id)}, 'speedboat', ${sqlString(slug)}, ${sqlString(b.name)}, ${sqlString(speedboatDescription(b))}, 'published', ${sqlString(`${b.name} Private Speedboat Charter | Maldives Tour Guide`)}, ${sqlString(`Charter the ${b.name}, a ${b.capacity}-seat private speedboat in the Maldives. Hourly, destination-based, and custom charters available.`)}, now()) on conflict (node_type, slug) do nothing;`,
    );
    lines.push(
      `insert into speedboats (id, capacity, length_feet, engine_count, horsepower, top_speed_knots, facilities, charter_options) select id, ${sqlLiteral(b.capacity)}, ${sqlLiteral(b.lengthFeet)}, ${sqlLiteral(b.engineCount)}, ${sqlLiteral(b.horsepower)}, ${sqlLiteral(b.topSpeedKnots)}, ${sqlArray(b.facilities)}, ${sqlArray(CHARTER_OPTIONS)} from nodes where node_type = 'speedboat' and slug = ${sqlString(slug)} on conflict (id) do nothing;`,
    );
    lines.push(
      `insert into bookable_products (id, booking_mode, base_price, currency, max_guests) select id, 'inquiry', null, null, ${sqlLiteral(b.capacity)} from nodes where node_type = 'speedboat' and slug = ${sqlString(slug)} on conflict (id) do nothing;`,
    );
  }
  lines.push("");

  // ── ferry routes ──
  lines.push("-- real ferry route images recovered from release/public_html/images/ferry/ (Task 20 section 2)");
  const uploadManifest = [];
  const mediaIdByRelativePath = new Map();
  for (const relativePath of new Set(Object.values(FERRY_ROUTE_IMAGES))) {
    const absolutePath = path.join(RELEASE_DIR, relativePath);
    if (!existsSync(absolutePath)) {
      console.warn(`Ferry image missing on disk, skipping: ${relativePath}`);
      continue;
    }
    const mediaId = deterministicUuid(`legacy-media::${relativePath}`);
    const storagePath = storagePathForRelativePath(relativePath);
    mediaIdByRelativePath.set(relativePath, mediaId);
    uploadManifest.push({ mediaId, relativePath, storagePath });
    lines.push(
      `insert into media_assets (id, media_type, storage_path, alt_text) values (${sqlString(mediaId)}, 'image', ${sqlString(storagePath)}, ${sqlString(`Maldives province ferry schedule`)}) on conflict (id) do nothing;`,
    );
  }
  lines.push("");

  lines.push("-- province ferry schedule (information only, no booking -- Task 20 section 25)");
  const seenFerrySlugs = new Set();
  for (const r of FERRY_ROUTES) {
    const baseSlug = slugify(`ferry-${r.routeNumber}-${r.variantLabel ?? r.title}`);
    let slug = baseSlug;
    let n = 2;
    while (seenFerrySlugs.has(slug)) {
      slug = `${baseSlug}-${n}`;
      n += 1;
    }
    seenFerrySlugs.add(slug);
    const stopsJson = JSON.stringify(r.stops.map((s) => ({ island: s.island, arrival: s.arrival, departure: s.departure })));
    const heroRelativePath = FERRY_ROUTE_IMAGES[r.routeNumber];
    const heroMediaId = heroRelativePath ? mediaIdByRelativePath.get(heroRelativePath) : null;
    lines.push(
      `insert into ferry_routes (id, route_number, variant_label, title, province, operating_days, origin_location_id, destination_location_id, stops, hero_media_id, source_legacy_url, sort_order) values (${sqlString(deterministicUuid(`ferry-route::${slug}`))}, ${sqlString(r.routeNumber)}, ${sqlString(r.variantLabel ?? null)}, ${sqlString(r.title)}, ${sqlString(r.province)}, ${sqlString(r.operatingDays)}, ${islandLocationIdByName(r.origin)}, ${islandLocationIdByName(r.destination)}, ${sqlString(stopsJson)}::jsonb, ${sqlString(heroMediaId ?? null)}, ${sqlString(SOURCE_FERRY_URL)}, ${FERRY_ROUTES.indexOf(r)}) on conflict (id) do nothing;`,
    );
  }

  const sql = lines.join("\n") + "\n";

  if (COMMIT) {
    const outPath = path.join(ROOT, "supabase", "migrations", "20250113000200_transfers_platform_data.sql");
    writeFileSync(outPath, sql);
    console.log(`Wrote ${path.relative(ROOT, outPath)}`);

    // scripts/upload-legacy-media.mjs (Task 14) reads exactly this shape
    // to actually push files to Storage from an environment with real
    // Supabase access — this sandbox has neither, so writing the
    // manifest is the honest stopping point (same as every other Task
    // 14+ media manifest).
    const manifestPath = path.join(DATA_DIR, "migration", "task20-ferry-storage-manifest.json");
    writeFileSync(manifestPath, JSON.stringify({ generatedAt: new Date().toISOString(), files: uploadManifest }, null, 2));
    console.log(`Wrote ${path.relative(ROOT, manifestPath)} (${uploadManifest.length} ferry images)`);
  } else {
    console.log(sql.slice(0, 2000));
    console.log(`\n(${lines.length} lines total -- run with --commit to write the migration file)`);
  }

  console.log(`\nSpeedboats: ${SPEEDBOATS.length} (owner stated 8; 7 named)`);
  console.log(`Ferry route/variant rows: ${FERRY_ROUTES.length}`);
  console.log(`Distinct ferry route numbers: ${new Set(FERRY_ROUTES.map((r) => r.routeNumber)).size}`);
}

main();
