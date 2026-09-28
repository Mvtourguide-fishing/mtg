#!/usr/bin/env node
// Generates a Supabase SQL migration from the source-of-truth package data
// in data/maldives/packages/packages.json. Uses the package schema already
// built in Task 2/3 (supabase/migrations/20250101000700_packages.sql)
// unchanged — no new tables, no new columns:
//
//   - packages          -> a `nodes` row (node_type = 'package'), the
//     canonical, SEO-indexable itinerary entity.
//   - package_itinerary_stages -> day-range stages under a package, matched
//     idempotently by the schema's own real unique constraint
//     (package_id, stage_number).
//   - package_itinerary_items  -> individual stage components that
//     REFERENCE existing accommodation/activity nodes (component_type =
//     'node') or Task 10 transfer_services (component_type =
//     'transfer_service') — never duplicated data. This table has no
//     natural unique key (same problem Task 10 hit with transfer_services),
//     so each item's id is a deterministic hash of a stable
//     (package, stage, sort_order, role) key rather than a fresh random
//     uuid, exactly like Task 10's transfer_services trick — see that
//     script's identical comment.
//
// Every package in this dataset is MTG-curated (operator_name is always
// null in the source data — see data/maldives/packages/SOURCES.md), so
// operated_by_provider_id is always null and no provider nodes are created
// here. Transfer items resolve their transfer_service_id using the EXACT
// same deterministic-hash formula as scripts/generate-transfer-seed.mjs
// (transfer-service::<routeSlug>::<providerSlug>::<slugify(serviceName)>),
// so it only succeeds when that service was actually seeded by Task 10 —
// never fabricating a transfer that doesn't exist.
//
// price_from/currency are always null: no per-night accommodation rate
// exists anywhere in this schema, so there is no real, verified figure to
// sum into a package total (see SOURCES.md "Why no package has a price").
//
// Deterministic and idempotent: node-backed rows use
// ON CONFLICT (node_type, slug) DO NOTHING, stages use the schema's own
// (package_id, stage_number) unique constraint, items use their
// deterministic id, same convention as every Task 4-10 generator.
//
// Usage: node scripts/generate-package-seed.mjs

import { createHash } from "node:crypto";
import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const LOCATIONS_DATA_DIR = path.join(ROOT, "data", "maldives", "locations");
const PACKAGES_DATA_DIR = path.join(ROOT, "data", "maldives", "packages");
const MIGRATION_PATH = path.join(ROOT, "supabase", "migrations", "20250109000100_seed_packages.sql");

// Kept in sync with scripts/generate-accommodation-seed.mjs and
// scripts/generate-transfer-seed.mjs — see either file's identical comment
// for why these resort islands aren't in islands.json.
const TASK5_RESORT_ISLANDS = [
  { name: "Vihamanaafushi", atoll_administrative_code: "K" },
  { name: "Kunfunadhoo", atoll_administrative_code: "B" },
  { name: "Velassaru", atoll_administrative_code: "K" },
  { name: "Olhuveli", atoll_administrative_code: "L" },
  { name: "Baros", atoll_administrative_code: "K" },
  { name: "Lankanfushi", atoll_administrative_code: "K" },
];

const DURATION_BANDS = new Set([3, 4, 5, 7, 10, 14]);

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

/** Same deterministic-uuid trick as scripts/generate-transfer-seed.mjs —
 * see that file's header comment. */
function deterministicUuid(key) {
  const hex = createHash("sha1").update(key).digest("hex").slice(0, 32);
  return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-${hex.slice(12, 16)}-${hex.slice(16, 20)}-${hex.slice(20, 32)}`;
}

function durationBandSlug(nights) {
  return DURATION_BANDS.has(nights) ? `${nights}-nights` : "custom";
}

function loadJson(dir, file) {
  const full = path.join(dir, file);
  if (!existsSync(full)) throw new Error(`Missing required data file: ${full}`);
  return JSON.parse(readFileSync(full, "utf8"));
}

function main() {
  const seededIslands = loadJson(LOCATIONS_DATA_DIR, "islands.json");
  const packageEntries = loadJson(PACKAGES_DATA_DIR, "packages.json");

  const locationSlugByKey = new Map();
  for (const island of seededIslands) {
    locationSlugByKey.set(`${island.name}::${island.atoll_administrative_code}`, slugify(island.name));
  }
  for (const island of TASK5_RESORT_ISLANDS) {
    locationSlugByKey.set(`${island.name}::${island.atoll_administrative_code}`, slugify(island.name));
  }

  const warnings = [];
  const lines = [];

  lines.push("-- MTG: packages seed (Task 11).");
  lines.push("-- GENERATED FILE — do not hand-edit. Source of truth:");
  lines.push("--   data/maldives/packages/packages.json");
  lines.push("--   data/maldives/packages/SOURCES.md");
  lines.push("-- Regenerate with: node scripts/generate-package-seed.mjs");
  lines.push("--");
  lines.push("-- Idempotent. Package nodes use ON CONFLICT (node_type, slug) DO NOTHING as");
  lines.push("-- usual. Stages use the schema's own (package_id, stage_number) unique");
  lines.push("-- constraint. package_itinerary_items has no natural unique key, so each");
  lines.push("-- item's id is a deterministic hash of (package, stage, sort_order, role) —");
  lines.push("-- see this script's own header comment for why, mirroring Task 10's identical");
  lines.push("-- transfer_services trick. Every referenced accommodation/activity/transfer");
  lines.push("-- service must already exist (from Tasks 5-10) — nothing here creates new");
  lines.push("-- entity data, only references it.");
  lines.push("");

  let packageCount = 0;
  let stageCount = 0;
  let itemCount = 0;
  let skippedItems = 0;
  let categoryTagCount = 0;
  let locationTagCount = 0;

  for (const pkg of packageEntries) {
    if (!pkg.name || !pkg.duration_nights || !Array.isArray(pkg.stages) || pkg.stages.length === 0) {
      warnings.push(`Skipping malformed package entry: ${JSON.stringify(pkg).slice(0, 200)}`);
      continue;
    }

    const slug = slugify(pkg.name);
    const summary = pkg.summary ?? null;
    const metaTitle = `${pkg.name} | Maldives Packages | MTG`;

    lines.push(`-- Package: ${pkg.name}`);
    lines.push(`insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)`);
    lines.push(
      `values ('package', ${sqlString(slug)}, ${sqlString(pkg.name)}, ${sqlString(summary)}, 'published', ${sqlString(metaTitle)}, ${sqlString(summary)}, now())`,
    );
    lines.push(`on conflict (node_type, slug) do nothing;`);
    lines.push("");

    // price_from/currency/operated_by_provider_id are always null — see
    // this script's header comment and SOURCES.md.
    lines.push(`insert into packages (id, duration_nights, price_from, currency, operated_by_provider_id)`);
    lines.push(`select id, ${sqlLiteral(pkg.duration_nights)}, null, null, null`);
    lines.push(`from nodes where node_type = 'package' and slug = ${sqlString(slug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");

    lines.push(`insert into bookable_products (id, booking_mode)`);
    lines.push(`select id, 'inquiry' from nodes where node_type = 'package' and slug = ${sqlString(slug)}`);
    lines.push(`on conflict (id) do nothing;`);
    lines.push("");
    packageCount += 1;

    // ── Taxonomy tags (traveler-type/style/theme/inclusion + derived
    //    duration-band) — reuses the existing category system as-is. ──
    const tagSlugs = [
      ...(pkg.traveler_types ?? []),
      ...(pkg.styles ?? []),
      ...(pkg.themes ?? []),
      ...(pkg.inclusions ?? []),
      durationBandSlug(pkg.duration_nights),
    ];
    for (const tagSlug of tagSlugs) {
      lines.push(`insert into node_categories (node_id, category_id)`);
      lines.push(`select n.id, c.id`);
      lines.push(`from nodes n, nodes c`);
      lines.push(`where n.node_type = 'package' and n.slug = ${sqlString(slug)}`);
      lines.push(`  and c.node_type = 'category' and c.slug = ${sqlString(tagSlug)}`);
      lines.push(`on conflict (node_id, category_id) do nothing;`);
      lines.push("");
      categoryTagCount += 1;
    }

    // ── Destination tags — first destination is 'primary', the rest
    //    'secondary', tagged directly at seed time (not derived from the
    //    itinerary on every read) for efficient reverse-discovery. ──
    const destinations = pkg.destinations ?? [];
    destinations.forEach((dest, i) => {
      const destSlug = locationSlugByKey.get(`${dest.name}::${dest.atoll_administrative_code}`);
      if (!destSlug) {
        warnings.push(`Package "${pkg.name}": could not resolve destination "${dest.name}" (${dest.atoll_administrative_code})`);
        return;
      }
      const relation = i === 0 ? "primary" : "secondary";
      lines.push(`insert into node_locations (node_id, location_id, relation)`);
      lines.push(`select n.id, l.id, ${sqlString(relation)}`);
      lines.push(`from nodes n, nodes l`);
      lines.push(`where n.node_type = 'package' and n.slug = ${sqlString(slug)}`);
      lines.push(`  and l.node_type = 'location' and l.slug = ${sqlString(destSlug)}`);
      lines.push(`on conflict (node_id, location_id) do nothing;`);
      lines.push("");
      locationTagCount += 1;
    });

    // ── Itinerary stages + items ──
    for (const stage of pkg.stages) {
      lines.push(
        `insert into package_itinerary_stages (package_id, stage_number, day_start, day_end, night_count, title, description, sort_order)`,
      );
      lines.push(
        `select id, ${sqlLiteral(stage.stage_number)}, ${sqlLiteral(stage.day_start)}, ${sqlLiteral(stage.day_end)}, ${sqlLiteral(stage.night_count)}, ${sqlString(stage.title ?? null)}, ${sqlString(stage.description ?? null)}, ${sqlLiteral(stage.stage_number)}`,
      );
      lines.push(`from nodes where node_type = 'package' and slug = ${sqlString(slug)}`);
      lines.push(`on conflict (package_id, stage_number) do nothing;`);
      lines.push("");
      stageCount += 1;

      for (const item of stage.items ?? []) {
        const sortOrder = item.sort_order ?? 0;
        const quantity = item.quantity ?? 1;
        const notes = item.notes ?? null;
        const itemKey = `package-item::${slug}::${stage.stage_number}::${sortOrder}::${item.component_role}`;
        const itemId = deterministicUuid(itemKey);

        if (item.component_role === "transfer") {
          if (!item.transfer_route_slug || !item.operator_name || !item.service_name) {
            warnings.push(`Package "${pkg.name}" stage ${stage.stage_number}: incomplete transfer item, skipping`);
            skippedItems += 1;
            continue;
          }
          const providerSlug = slugify(item.operator_name);
          const serviceKey = `transfer-service::${item.transfer_route_slug}::${providerSlug}::${slugify(item.service_name)}`;
          const serviceId = deterministicUuid(serviceKey);

          lines.push(
            `insert into package_itinerary_items (id, stage_id, component_type, transfer_service_id, component_role, quantity, notes, sort_order)`,
          );
          lines.push(
            `select ${sqlString(itemId)}::uuid, s.id, 'transfer_service', ${sqlString(serviceId)}::uuid, ${sqlString(item.component_role)}, ${sqlLiteral(quantity)}, ${sqlString(notes)}, ${sqlLiteral(sortOrder)}`,
          );
          lines.push(`from package_itinerary_stages s`);
          lines.push(`join nodes p on p.id = s.package_id`);
          lines.push(
            `where p.node_type = 'package' and p.slug = ${sqlString(slug)} and s.stage_number = ${sqlLiteral(stage.stage_number)}`,
          );
          lines.push(`on conflict (id) do nothing;`);
          lines.push("");
          itemCount += 1;
          continue;
        }

        const componentNodeType = item.accommodation_slug ? "accommodation" : item.activity_slug ? "activity" : null;
        const componentSlug = item.accommodation_slug ?? item.activity_slug ?? null;
        if (!componentNodeType || !componentSlug) {
          warnings.push(
            `Package "${pkg.name}" stage ${stage.stage_number}: item with role "${item.component_role}" has no resolvable reference, skipping (no fabricated entity)`,
          );
          skippedItems += 1;
          continue;
        }

        lines.push(
          `insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, quantity, notes, sort_order)`,
        );
        lines.push(
          `select ${sqlString(itemId)}::uuid, s.id, 'node', comp.id, ${sqlString(item.component_role)}, ${sqlLiteral(quantity)}, ${sqlString(notes)}, ${sqlLiteral(sortOrder)}`,
        );
        lines.push(`from package_itinerary_stages s`);
        lines.push(`join nodes p on p.id = s.package_id`);
        lines.push(`join nodes comp on comp.node_type = ${sqlString(componentNodeType)} and comp.slug = ${sqlString(componentSlug)}`);
        lines.push(
          `where p.node_type = 'package' and p.slug = ${sqlString(slug)} and s.stage_number = ${sqlLiteral(stage.stage_number)}`,
        );
        lines.push(`on conflict (id) do nothing;`);
        lines.push("");
        itemCount += 1;
      }
    }
  }

  writeFileSync(MIGRATION_PATH, lines.join("\n") + "\n");

  console.log(`Wrote ${MIGRATION_PATH}`);
  console.log(
    `Packages: ${packageCount}, Stages: ${stageCount}, Items: ${itemCount} (skipped ${skippedItems}), Category tags: ${categoryTagCount}, Location tags: ${locationTagCount}`,
  );
  if (warnings.length > 0) {
    console.log(`\nWarnings (${warnings.length}):`);
    for (const w of warnings) console.log(`  - ${w}`);
  }
}

main();
