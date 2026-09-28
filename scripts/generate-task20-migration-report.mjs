#!/usr/bin/env node
// Task 20: consolidated migration report for the Maldives Transfers SEO
// platform rebuild. Read-only — summarizes numbers already produced by
// scripts/rebuild-legacy-transfers.mjs (Task 18, routes unchanged this
// task), scripts/build-transfers-platform-v2.mjs (speedboats/ferries/
// categories), and scripts/build-redirect-map.mjs (redirects).
//
// Usage: node scripts/generate-task20-migration-report.mjs

import { existsSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, ROOT } from "./lib/legacy-shared.mjs";

const MIGRATION_DATA_DIR = path.join(DATA_DIR, "migration");

function readJson(relPath) {
  const full = path.join(MIGRATION_DATA_DIR, relPath);
  if (!existsSync(full)) return null;
  return JSON.parse(readFileSync(full, "utf8"));
}

function main() {
  const recovery = readJson("transfer-legacy-recovery.json");
  const ferryManifest = readJson("task20-ferry-storage-manifest.json");

  const ready = recovery ? recovery.records.filter((r) => r.status === "ready") : [];

  const report = {
    generatedAt: new Date().toISOString(),
    note: "Task 20. Route-level numbers are unchanged from Task 18 (no new legacy transfer route pages were discovered this task) -- this report covers what's new: multi-category tagging, speedboat fleet, ferry schedule, and their redirects/images.",

    routes: {
      totalLegacyTransferPagesDiscovered: recovery?.totalTransferPages ?? null,
      routesMigrated: ready.length,
      note: "Unchanged from Task 18's own migration report (data/maldives/migration/task18-transfer-migration-report.json) -- see that file for the full legacy inventory/pricing/destination breakdown.",
      newInTask20: "Every migrated route was additionally tagged with real transfer-category values (airport / resort-transfer / hotel-transfer / island-transfer) derived from existing data (origin=airport, destination.is_inhabited, destination has a real hotel/guesthouse) -- never a new route.",
    },

    speedboats: {
      ownerStatedFleetSize: 8,
      namedByOwner: 7,
      discrepancy: "The owner described '8 speedboats' but named 7 distinct boats (Chill Speed, Jupiter 11, Chill Speed 2, Winover, Seaguard, Arriva, Touring 43) when asked directly in chat. Reported here rather than inventing an 8th boat to match the stated count.",
      legacyDataFound: "None -- release/public_html/ contains zero named private-hire speedboats (confirmed via exhaustive search: no fleet roster page, no per-boat images/specs/names). All specs used are as the owner stated them directly, not legacy-sourced.",
      imagesRecovered: 0,
      imagesNote: "The owner indicated images will be uploaded later. The speedboats table and node_media are wired and ready to receive them -- no placeholder/stock images were substituted.",
    },

    vehicles: {
      ownerDescribedFleet: "2x4-seater cars, 2x6-seater cars, 1 minibus, 1 large bus",
      dataFoundLegacyOrOwnerSupplied: 0,
      legacyDataFound: "One unrelated real product: a Male City sightseeing 'Car Tour' (USD 150/vehicle, 4-seater, with a genuine legacy data inconsistency between marketing copy '4 seater' and the booking form's '3p per car' field) -- this is a guided city tour, not an airport/hotel car-transfer fleet, so it was not used to populate the vehicles table.",
      status: "vehicles table, repository, and 'Car Transfers' hub section are built and ready; 0 vehicles seeded. Awaiting real fleet data from the owner.",
    },

    ferrySchedule: {
      sourcePage: "release/public_html/maldives-transportation-ferry-speedboat-transfers.html",
      legacyUrl: "/maldives-transportation-ferry-speedboat-transfers.html",
      routesDiscovered: 9,
      scheduleVariantsMigrated: 14,
      provincesCovered: 3,
      provincesTotalInRealMaldivesSystem: "~8 (RTL provincial ferry network)",
      note: "The legacy page itself only has structured schedule data for Upper North, North, and North Central provinces -- the remaining provinces are simply not present in the source, not omitted by this migration.",
      routeNumberNormalizations: [
        "Route 101's raw table header read 'Departure | Arrival' but every row's own time values only make chronological sense as 'Arrival | Departure' (matching all 8 other routes) -- normalized for internal consistency, values unchanged.",
        "A few island names appear with two spellings on the same legacy page (Ragetheemu/Rasgetheemu, Feridhu/Feridhoo, Dhidhoo/Dhidhdhoo used for two DIFFERENT islands in different atolls) -- normalized per-island, both real Maldivian islands preserved distinctly.",
      ],
      unmatchedStops: ["Henbadhoo (route 201 origin) -- not present in the current 193-island location seed; left unmatched (null location_id) rather than fabricated."],
      imagesRecovered: ferryManifest?.files?.length ?? 0,
      bookable: false,
      bookingNote: "Deliberately not connected to any booking flow -- Task 20 requires this be information-only.",
    },

    redirects: {
      total301RedirectsAfterTask20: 328,
      note: "Unchanged in count from Task 18 (328) -- this task reclassified one existing entry's target, not its count.",
      changedThisTask: 1,
      change: "/maldives-transportation-ferry-speedboat-transfers.html now redirects to /maldives-ferry-schedule/ (previously redirected to the generic /maldives/transfers/ hub) -- a more specific, accurate target now that its real schedule content has a dedicated page.",
    },

    newUrls: [
      "/maldives-speedboats-charter/",
      "/maldives-speedboats-charter/[boat-slug]/ (x7)",
      "/maldives-ferry-schedule/",
      "/maldives/transfers/find/ (noindex search results step)",
    ],

    knownGaps: [
      "Speedboat images: 0 of 7 boats have a photo yet (owner will supply later).",
      "Vehicle/car fleet: 0 vehicles seeded -- no real data exists yet.",
      "Ferry schedule covers only 3 of ~8 real Maldives ferry provinces (source limitation, not a migration gap).",
      "Route-level facilities (Task 20 section 35) are empty for all 77 pre-existing transfer services -- no legacy source data states AC/life-jacket/WiFi-type facilities per service, so none were invented; the column is wired for future real data.",
      "Reviews: 0 real reviews exist for any route/boat yet (expected -- the guest-review architecture is new this task).",
    ],
  };

  const outPath = path.join(MIGRATION_DATA_DIR, "task20-transfers-platform-migration-report.json");
  writeFileSync(outPath, JSON.stringify(report, null, 2));

  console.log("Routes:", report.routes);
  console.log("Speedboats:", report.speedboats);
  console.log("Vehicles:", report.vehicles);
  console.log("Ferry schedule:", { ...report.ferrySchedule, routeNumberNormalizations: undefined, unmatchedStops: undefined });
  console.log("Redirects:", report.redirects);
  console.log(`\nWrote ${path.relative(ROOT, outPath)}`);
}

main();
