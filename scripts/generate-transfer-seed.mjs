#!/usr/bin/env node
// Generates a Supabase SQL migration from the source-of-truth transfer data
// in data/maldives/transfers/*.json. Uses the transfer schema already built
// in Task 2/3 (supabase/migrations/20250101000600_transfers.sql) unchanged:
//
//   - transfer_routes  -> a `nodes` row (node_type = 'transfer_route'), the
//     canonical, SEO-indexable, directional origin -> destination entity.
//     Multiple source rows sharing the same (origin, destination) pair
//     collapse into ONE route node with several transfer_services under it
//     (e.g. two different operators both running Velana Airport -> Maafushi
//     become one route, two services).
//   - transfer_services -> NOT a node. transfer_services has no unique
//     constraint to hang an idempotent ON CONFLICT off of, so each service's
//     id is a deterministic hash of a stable key (route + operator + product
//     name) rather than a fresh random uuid — re-running this generator
//     against an unchanged source file produces the exact same ids, so
//     `on conflict (id) do nothing` is genuinely idempotent. This is the one
//     place this generator departs from the gen_random_uuid()-by-default
//     convention used elsewhere in the schema, and it's an application-layer
//     seeding choice, not a schema change.
//   - transfer_service_schedules -> matched to its service via the schema's
//     own real unique constraint (transfer_service_id, day_of_week,
//     departure_time), so it doesn't need the same trick.
//
// The one new location this task's brief explicitly allows — Velana
// International Airport — is seeded as a plain `locations` row
// (location_type = 'airport', already a valid enum value since Task 3),
// parented under the existing "Malé City" atoll-equivalent node. No schema
// change.
//
// Deterministic and idempotent: every insert is keyed (node slug, or the
// deterministic service id, or the schema's own natural keys) with
// `ON CONFLICT ... DO NOTHING`, same convention as the Task 4-9 generators.
//
// Usage: node scripts/generate-transfer-seed.mjs

import { createHash } from "node:crypto";
import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const LOCATIONS_DATA_DIR = path.join(ROOT, "data", "maldives", "locations");
const TRANSFERS_DATA_DIR = path.join(ROOT, "data", "maldives", "transfers");
const MIGRATION_PATH = path.join(
  ROOT,
  "supabase",
  "migrations",
  "20250108000100_seed_transfers.sql",
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

// The one new location this task allows. Parented under "Malé City"
// (slug male-city, location_type='atoll', administrative_code='MLE') — the
// same administrative-division node that already parents Malé, Hulhumalé
// and Villimalé — since Hulhulé (the airport's own island) is
// administratively part of Malé City, not Kaafu Atoll, and was deliberately
// excluded from the inhabited-islands dataset as uninhabited.
const NEW_AIRPORT_LOCATIONS = [{ name: "Velana International Airport", parent_atoll_slug: "male-city" }];

const VALID_TRANSFER_TYPES = new Set(["speedboat", "seaplane", "domestic_flight", "ferry", "private_yacht", "land_transfer"]);
const VALID_SHARED_OR_PRIVATE = new Set(["shared", "private"]);

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

/** A stable, deterministic uuid-shaped string derived from `key` — NOT a
 * real RFC4122 hash (no version/variant bit-setting), just deterministic
 * and syntactically valid, which is all the `uuid` column type and
 * `ON CONFLICT (id)` idempotency need. Re-running this generator against
 * unchanged source data always produces the same id for the same service. */
function deterministicUuid(key) {
  const hex = createHash("sha1").update(key).digest("hex").slice(0, 32);
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20, 32)}`;
}

function loadJson(dir, file) {
  const full = path.join(dir, file);
  if (!existsSync(full)) throw new Error(`Missing required data file: ${full}`);
  return JSON.parse(readFileSync(full, "utf8"));
}

function main() {
  const atolls = loadJson(LOCATIONS_DATA_DIR, "atolls.json");
  const seededIslands = loadJson(LOCATIONS_DATA_DIR, "islands.json");
  const routeEntries = loadJson(TRANSFERS_DATA_DIR, "routes.json");
  const scheduleEntries = existsSync(path.join(TRANSFERS_DATA_DIR, "schedules.json"))
    ? loadJson(TRANSFERS_DATA_DIR, "schedules.json")
    : [];

  const atollSlugByCode = new Map();
  for (const atoll of atolls) {
    atollSlugByCode.set(atoll.administrative_code, slugify(atoll.name.replace(/\s+Atoll$/i, "")));
  }

  // Location slug lookup, keyed by `${name}::${atollCode}` exactly like
  // every prior task's generator — covers inhabited islands, Task 5 resort
  // islands, AND (new here) the one allowed airport location.
  const locationSlugByKey = new Map();
  const locationTypeByKey = new Map();
  for (const island of seededIslands) {
    const key = `${island.name}::${island.atoll_administrative_code}`;
    locationSlugByKey.set(key, slugify(island.name));
    locationTypeByKey.set(key, "island");
  }
  for (const island of TASK5_RESORT_ISLANDS) {
    const key = `${island.name}::${island.atoll_administrative_code}`;
    locationSlugByKey.set(key, slugify(island.name));
    locationTypeByKey.set(key, "island");
  }
  for (const airport of NEW_AIRPORT_LOCATIONS) {
    const key = `${airport.name}::MLE`;
    locationSlugByKey.set(key, slugify(airport.name));
    locationTypeByKey.set(key, "airport");
  }

  const warnings = [];
  const lines = [];

  lines.push("-- MTG: transfers seed (Task 10).");
  lines.push("-- GENERATED FILE — do not hand-edit. Source of truth:");
  lines.push("--   data/maldives/transfers/routes.json");
  lines.push("--   data/maldives/transfers/schedules.json");
  lines.push("--   data/maldives/transfers/SOURCES.md");
  lines.push("-- Regenerate with: node scripts/generate-transfer-seed.mjs");
  lines.push("--");
  lines.push("-- Idempotent. Node-backed rows (the airport location, each transfer_routes");
  lines.push("-- node) use ON CONFLICT (node_type, slug) DO NOTHING as usual. transfer_services");
  lines.push("-- has no natural unique key, so each service's id is a deterministic hash of a");
  lines.push("-- stable (route, operator, product) key instead of a fresh random uuid — see");
  lines.push("-- this script's own header comment for why. transfer_service_schedules uses the");
  lines.push("-- schema's own real unique constraint (transfer_service_id, day_of_week,");
  lines.push("-- departure_time). transfer_services are NEVER inserted into bookable_products —");
  lines.push("-- they are not nodes; see src/lib/transfers/repository.ts's header comment for");
  lines.push("-- how they connect to booking instead (bookings.transfer_service_id, already");
  lines.push("-- built in Task 2/3, unchanged here).");
  lines.push("");

  // ── New airport location(s) ───────────────────────────────────────
  lines.push("-- New location: the one airport this task's brief allows (Hulhulé, the real");
  lines.push("-- island Velana International Airport sits on, is uninhabited and was");
  lines.push("-- deliberately excluded from the Task 4 islands dataset).");
  for (const airport of NEW_AIRPORT_LOCATIONS) {
    const slug = slugify(airport.name);
    const summary = `${airport.name} is the Maldives' main international gateway airport.`;
    const metaTitle = `${airport.name} | Maldives Transfers | MTG`;

    lines.push(`insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)`);
    lines.push(
      `values ('location', ${sqlString(slug)}, ${sqlString(airport.name)}, ${sqlString(summary)}, 'published', ${sqlString(metaTitle)}, ${sqlString(summary)}, now())`,
    );
    lines.push(`on conflict (node_type, slug) do nothing;`);
    lines.push("");
    lines.push(`insert into locations (id, location_type, parent_id, path)`);
    lines.push(`select n.id, 'airport', p.id, (p_loc.path || ${sqlString(ltreeLabel(slug))}::ltree)`);
    lines.push(`from nodes n, nodes p join locations p_loc on p_loc.id = p.id`);
    lines.push(`where n.node_type = 'location' and n.slug = ${sqlString(slug)}`);
    lines.push(`  and p.node_type = 'location' and p.slug = ${sqlString(airport.parent_atoll_slug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");
  }

  // ── Providers referenced by transfer services ─────────────────────
  const usedProviderSlugs = new Set();
  const distinctOperators = Array.from(new Set(routeEntries.map((r) => r.operator_name).filter(Boolean)));
  const providerSlugByName = new Map();

  if (distinctOperators.length > 0) {
    lines.push("-- Providers (reused from Task 5/6/7/8/9 where the name matches exactly, else new)");
    for (const name of distinctOperators) {
      const slug = slugify(name);
      usedProviderSlugs.add(slug);
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

  // ── Resolve each source entry's origin/destination to a real, known
  //    location slug + type, skipping (with a warning) anything that can't
  //    be resolved — never guessing a new location into existence. ──────
  function resolveEndpoint(name, type, atollCode, label) {
    const key = `${name}::${atollCode}`;
    const slug = locationSlugByKey.get(key);
    const resolvedType = locationTypeByKey.get(key);
    if (!slug) {
      warnings.push(`Could not resolve ${label} "${name}" (${atollCode}, expected type ${type}) against known locations`);
      return null;
    }
    if (resolvedType !== type) {
      warnings.push(`${label} "${name}" (${atollCode}) resolved as location_type "${resolvedType}", entry says "${type}" — using the resolved type`);
    }
    return slug;
  }

  // ── Group source entries into unique (origin, destination) routes ──
  const routesByKey = new Map(); // key -> { originSlug, destinationSlug, entries: [...] }
  let skippedEntries = 0;

  for (const entry of routeEntries) {
    if (
      !entry.origin_name ||
      !entry.destination_name ||
      !entry.service_name ||
      !entry.operator_name ||
      entry.price === null ||
      entry.price === undefined
    ) {
      warnings.push(`Skipping malformed/incomplete route entry: ${JSON.stringify(entry).slice(0, 200)}`);
      skippedEntries += 1;
      continue;
    }
    if (!VALID_TRANSFER_TYPES.has(entry.transfer_type)) {
      warnings.push(`Skipping "${entry.service_name}" — invalid transfer_type "${entry.transfer_type}"`);
      skippedEntries += 1;
      continue;
    }
    if (!VALID_SHARED_OR_PRIVATE.has(entry.shared_or_private)) {
      warnings.push(`Skipping "${entry.service_name}" — invalid shared_or_private "${entry.shared_or_private}"`);
      skippedEntries += 1;
      continue;
    }

    const originSlug = resolveEndpoint(entry.origin_name, entry.origin_type, entry.origin_atoll_administrative_code, "origin");
    const destinationSlug = resolveEndpoint(
      entry.destination_name,
      entry.destination_type,
      entry.destination_atoll_administrative_code,
      "destination",
    );
    if (!originSlug || !destinationSlug) {
      skippedEntries += 1;
      continue;
    }
    if (originSlug === destinationSlug) {
      warnings.push(`Skipping "${entry.service_name}" — origin and destination resolve to the same location (${originSlug})`);
      skippedEntries += 1;
      continue;
    }
    const providerSlug = providerSlugByName.get(entry.operator_name);
    if (!providerSlug) {
      warnings.push(`Skipping "${entry.service_name}" — operator "${entry.operator_name}" was not resolved to a provider`);
      skippedEntries += 1;
      continue;
    }

    const routeKey = `${originSlug}::${destinationSlug}`;
    if (!routesByKey.has(routeKey)) {
      routesByKey.set(routeKey, { originSlug, destinationSlug, entries: [] });
    }
    routesByKey.get(routeKey).entries.push({ ...entry, providerSlug });
  }

  // ── Transfer routes + services ──────────────────────────────────────
  lines.push("-- Transfer routes (directional) and their services");
  let routeCount = 0;
  let serviceCount = 0;

  for (const [, route] of routesByKey) {
    const routeSlug = `${route.originSlug}-to-${route.destinationSlug}`;
    const originName = route.entries[0].origin_name;
    const destinationName = route.entries[0].destination_name;
    const title = `${originName} to ${destinationName}`;
    const first = route.entries[0];
    const summary = `Transfer route from ${originName} to ${destinationName}.`;
    const metaTitle = `${title} Transfers | Maldives Tour Guide`;

    lines.push(`insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)`);
    lines.push(
      `values ('transfer_route', ${sqlString(routeSlug)}, ${sqlString(title)}, ${sqlString(summary)}, 'published', ${sqlString(metaTitle)}, ${sqlString(summary)}, now())`,
    );
    lines.push(`on conflict (node_type, slug) do nothing;`);
    lines.push("");

    lines.push(`insert into transfer_routes (id, origin_location_id, destination_location_id, distance_km, typical_duration_minutes)`);
    lines.push(`select n.id, o.id, d.id, ${sqlLiteral(first.distance_km)}, ${sqlLiteral(first.typical_duration_minutes)}`);
    lines.push(`from nodes n, nodes o, nodes d`);
    lines.push(`where n.node_type = 'transfer_route' and n.slug = ${sqlString(routeSlug)}`);
    lines.push(`  and o.node_type = 'location' and o.slug = ${sqlString(route.originSlug)}`);
    lines.push(`  and d.node_type = 'location' and d.slug = ${sqlString(route.destinationSlug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");
    routeCount += 1;

    for (const entry of route.entries) {
      const serviceKey = `transfer-service::${routeSlug}::${entry.providerSlug}::${slugify(entry.service_name)}`;
      const serviceId = deterministicUuid(serviceKey);

      lines.push(`insert into transfer_services (`);
      lines.push(`  id, route_id, provider_id, transfer_type, vehicle_type, shared_or_private, duration_minutes,`);
      lines.push(`  price, currency, capacity, luggage_allowance, status, pickup_instructions, dropoff_instructions,`);
      lines.push(`  booking_requirements, cancellation_policy, description`);
      lines.push(`)`);
      lines.push(`select`);
      lines.push(`  ${sqlString(serviceId)}::uuid,`);
      lines.push(`  (select id from nodes where node_type = 'transfer_route' and slug = ${sqlString(routeSlug)}),`);
      lines.push(`  (select id from nodes where node_type = 'provider' and slug = ${sqlString(entry.providerSlug)}),`);
      lines.push(`  ${sqlString(entry.transfer_type)}, ${entry.vehicle_type ? sqlString(entry.vehicle_type) : "null"}, ${sqlString(entry.shared_or_private)},`);
      lines.push(`  ${sqlLiteral(entry.duration_minutes)}, ${sqlLiteral(entry.price)}, ${sqlString(entry.currency)}, ${sqlLiteral(entry.capacity)},`);
      lines.push(`  ${entry.luggage_allowance ? sqlString(entry.luggage_allowance) : "null"}, ${sqlString(entry.status ?? "active")},`);
      lines.push(`  ${entry.pickup_instructions ? sqlString(entry.pickup_instructions) : "null"}, ${entry.dropoff_instructions ? sqlString(entry.dropoff_instructions) : "null"},`);
      lines.push(`  ${entry.booking_requirements ? sqlString(entry.booking_requirements) : "null"}, ${entry.cancellation_policy ? sqlString(entry.cancellation_policy) : "null"},`);
      lines.push(`  ${entry.description ? sqlString(entry.description) : "null"}`);
      lines.push(`on conflict (id) do nothing;`);
      lines.push("");
      serviceCount += 1;

      // ── Schedules for this exact service, matched by service_name +
      //    operator_name in schedules.json ──
      const schedules = scheduleEntries.filter(
        (s) => s.service_name === entry.service_name && s.operator_name === entry.operator_name,
      );
      for (const schedule of schedules) {
        lines.push(`insert into transfer_service_schedules (`);
        lines.push(`  transfer_service_id, day_of_week, departure_time, arrival_time, duration_minutes, status`);
        lines.push(`)`);
        lines.push(
          `values (${sqlString(serviceId)}::uuid, ${sqlLiteral(schedule.day_of_week)}, ${schedule.departure_time ? sqlString(schedule.departure_time) : "null"}, ${schedule.arrival_time ? sqlString(schedule.arrival_time) : "null"}, ${sqlLiteral(schedule.duration_minutes)}, 'active')`,
        );
        lines.push(`on conflict (transfer_service_id, day_of_week, departure_time) do nothing;`);
        lines.push("");
      }
    }
  }

  writeFileSync(MIGRATION_PATH, lines.join("\n") + "\n");

  console.log(`Wrote ${MIGRATION_PATH}`);
  console.log(
    `Airport locations: ${NEW_AIRPORT_LOCATIONS.length}, Providers: ${distinctOperators.length}, Routes: ${routeCount}, Services: ${serviceCount} (skipped ${skippedEntries} entries), Schedules: ${scheduleEntries.length}`,
  );
  if (warnings.length > 0) {
    console.log(`\nWarnings (${warnings.length}):`);
    for (const w of warnings) console.log(`  - ${w}`);
  }
}

main();
