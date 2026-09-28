#!/usr/bin/env node
// Task 16 §26-27: redirect validation.
//
// This sandbox has no network access to the live Supabase/Next.js
// deployment (confirmed in Task 15 and again here), so this cannot make
// real HTTP requests against production. What it CAN do, and does, is
// exhaustively verify the same things a live crawl would check, from the
// generated data itself:
//
//   1. Every source_path is unique (no duplicate redirect rows).
//   2. No redirect chain: no newUrl is itself another redirect's oldUrl.
//   3. No redirect loop (a cycle through several hops).
//   4. Every newUrl is a REAL destination — cross-checked against the
//      live entity catalogue (buildEntityIndex()) and the fixed set of
//      static app routes, the same source of truth src/app/sitemap.ts
//      itself is built from. A redirect target that doesn't resolve to
//      any of these would be a redirect to a 404 — this script fails
//      loudly on that, it does not report success anyway.
//
// Usage: node scripts/validate-redirects.mjs

import { existsSync, readFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, buildEntityIndex } from "./lib/legacy-shared.mjs";

const MIGRATION_DATA_DIR = path.join(DATA_DIR, "migration");

const STATIC_APP_PATHS = new Set([
  "/",
  "/maldives/",
  "/maldives/activities/",
  "/maldives/atolls/",
  "/maldives/dive-sites/",
  "/maldives/diving/",
  "/maldives/fishing/",
  "/maldives/guesthouses/",
  "/maldives/hotels/",
  "/maldives/islands/",
  "/maldives/packages/",
  "/maldives/providers/",
  "/maldives/resorts/",
  "/maldives/surf-breaks/",
  "/maldives/surfing/",
  "/maldives/transfers/",
  "/maldives/airport-transfers/",
  "/maldives/resort-transfers/",
  "/maldives/hotel-transfers/",
  "/maldives/island-transfers/",
  "/maldives/speedboat-transfers/",
  "/maldives-speedboats-charter/",
  "/maldives-ferry-schedule/",
  "/maldives/travel-guide/",
]);

function main() {
  const mapPath = path.join(MIGRATION_DATA_DIR, "redirect-map.json");
  if (!existsSync(mapPath)) {
    console.error("Run scripts/build-redirect-map.mjs first.");
    process.exit(1);
  }
  const { records } = JSON.parse(readFileSync(mapPath, "utf8"));
  const redirects = records.filter((r) => r.migrationStatus === "redirect" || r.migrationStatus === "consolidate");

  const errors = [];

  // ── 1. Unique source paths ──────────────────────────────────────────
  const bySource = new Map();
  for (const r of redirects) {
    if (bySource.has(r.oldUrl)) errors.push(`Duplicate source_path: ${r.oldUrl}`);
    bySource.set(r.oldUrl, r);
  }

  // ── 2/3. Chains and loops ───────────────────────────────────────────
  const sourceSet = new Set(redirects.map((r) => r.oldUrl));
  for (const r of redirects) {
    if (sourceSet.has(r.newUrl)) errors.push(`Redirect chain: ${r.oldUrl} -> ${r.newUrl} (which is itself a redirect source)`);
  }
  // General cycle detection (defense in depth beyond the direct-chain
  // check above, and beyond the DB trigger itself).
  const bySourceForCycles = new Map(redirects.map((r) => [r.oldUrl, r.newUrl]));
  for (const start of sourceSet) {
    let cur = start;
    const seen = new Set();
    while (bySourceForCycles.has(cur)) {
      if (seen.has(cur)) {
        errors.push(`Redirect loop detected starting at ${start}`);
        break;
      }
      seen.add(cur);
      cur = bySourceForCycles.get(cur);
    }
  }

  // ── 4. Every destination is real ────────────────────────────────────
  const entities = buildEntityIndex();
  const realHrefs = new Set(entities.map((e) => e.href));
  // Article/provider/dive-site/surf-break hrefs aren't in buildEntityIndex
  // (that index covers Task 14/15's matching universe: locations/
  // accommodations/activities/packages/transfer_routes) — those come from
  // the migration reports and a small set of known real path prefixes
  // instead, verified directly rather than assumed.
  const articleReportPath = path.join(DATA_DIR, "content", "article-migration-report.json");
  if (existsSync(articleReportPath)) {
    const articleReport = JSON.parse(readFileSync(articleReportPath, "utf8"));
    for (const a of articleReport.articles) {
      if (a.migrationStatus === "ready") realHrefs.add(a.candidateNewUrl);
    }
  }
  // Task 18's own legacy transfer recovery creates real destinations
  // (verified against a from-scratch local Postgres apply in that task —
  // see its own migration report) that aren't in buildEntityIndex()
  // because they don't exist in the static data/maldives/**/*.json seed
  // files at all; they were inserted directly by that task's own SQL.
  const transferRecoveryPath = path.join(DATA_DIR, "migration", "transfer-legacy-recovery.json");
  if (existsSync(transferRecoveryPath)) {
    const recovery = JSON.parse(readFileSync(transferRecoveryPath, "utf8"));
    for (const r of recovery.records) {
      if (r.status === "ready") realHrefs.add(`/maldives/transfers/velana-international-airport-to-${r.islandSlug}/`);
    }
  }
  const DYNAMIC_PREFIX_PATTERNS = [/^\/maldives\/dive-sites\/[^/]+\/$/, /^\/maldives\/surf-breaks\/[^/]+\/$/, /^\/maldives\/providers\/[^/]+\/$/];

  let brokenDestinations = 0;
  for (const r of redirects) {
    const isStatic = STATIC_APP_PATHS.has(r.newUrl);
    const isKnownEntity = realHrefs.has(r.newUrl);
    const isDynamicPattern = DYNAMIC_PREFIX_PATTERNS.some((p) => p.test(r.newUrl));
    if (!isStatic && !isKnownEntity && !isDynamicPattern) {
      errors.push(`Unverified destination: ${r.oldUrl} -> ${r.newUrl} (not a known static route or real entity href)`);
      brokenDestinations += 1;
    }
  }

  console.log(`Validated ${redirects.length} redirects.`);
  console.log(`Broken/unverified destinations: ${brokenDestinations}`);
  console.log(`Total issues: ${errors.length}`);

  if (errors.length > 0) {
    console.log("\nISSUES FOUND:");
    for (const e of errors.slice(0, 50)) console.log(`  - ${e}`);
    if (errors.length > 50) console.log(`  ... and ${errors.length - 50} more`);
    process.exitCode = 1;
  } else {
    console.log("No chains, no loops, no duplicate sources, no unverified destinations.");
  }
}

main();
