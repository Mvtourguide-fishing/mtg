#!/usr/bin/env node
// Task 16 §10/§14/§16-22: generates a SQL migration that populates the
// EXISTING url_redirects table (supabase/migrations/20250101001200_redirects.sql,
// with its own DB-level chain-prevention trigger already built in Task 3)
// from data/maldives/migration/redirect-map.json.
//
// Every row uses target_type='path' with a real, already-verified new app
// URL (never target_type='node' — this repo's redirect targets are a mix
// of real entity pages AND fixed category/hub routes that aren't nodes at
// all, e.g. /maldives/transfers/, so one uniform, simple target_path
// column covers every case without a second lookup path). status_code is
// always 301 (permanent) per Task 16 §11 — this migration never creates
// a 302/308 row.
//
// Idempotent: re-running this generator (e.g. after the redirect map is
// refined) UPDATEs an existing row's target/notes on conflict rather than
// doing nothing — same reasoning as the articles.body fix in Task 15:
// this file keeps iterating, so a re-run must actually refresh live data,
// not silently no-op.
//
// Usage: node scripts/generate-redirect-seed.mjs

import { existsSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, ROOT, toAsciiSafe } from "./lib/legacy-shared.mjs";

const MIGRATION_DATA_DIR = path.join(DATA_DIR, "migration");

function sqlString(value) {
  if (value === null || value === undefined) return "null";
  return `'${toAsciiSafe(value).replace(/'/g, "''")}'`;
}

function main() {
  const mapPath = path.join(MIGRATION_DATA_DIR, "redirect-map.json");
  if (!existsSync(mapPath)) {
    console.error("Run scripts/build-redirect-map.mjs first.");
    process.exit(1);
  }
  const { records } = JSON.parse(readFileSync(mapPath, "utf8"));

  // "keep" (the homepage) needs no redirect row — old URL and new URL are
  // the same path.
  const toInsert = records.filter((r) => r.migrationStatus === "redirect" || r.migrationStatus === "consolidate");

  const seenSourcePaths = new Set();
  const lines = [];
  lines.push("-- Task 16: legacy URL -> new URL permanent redirects, populated into the");
  lines.push("-- existing url_redirects table (Task 3 schema - unchanged, including its own");
  lines.push("-- DB-level chain-prevention trigger).");
  lines.push("-- GENERATED FILE - do not hand-edit. Regenerate with:");
  lines.push("--   node scripts/generate-redirect-seed.mjs");
  lines.push("-- Source: data/maldives/migration/redirect-map.json (status=redirect/consolidate).");
  lines.push("--");
  lines.push("-- Every target_path is a real, currently-live app route, verified against the");
  lines.push("-- real MTG entity catalogue / migration reports (never invented) - see");
  lines.push("-- scripts/build-redirect-map.mjs for exactly how each mapping was decided.");
  lines.push("-- On conflict this UPDATEs (not \"do nothing\") so re-running after refining");
  lines.push("-- the redirect map keeps live rows in sync, same as the Task 15 articles fix.");
  lines.push("");

  let count = 0;
  let skippedDuplicateSource = 0;
  for (const r of toInsert) {
    if (seenSourcePaths.has(r.oldUrl)) {
      skippedDuplicateSource += 1;
      continue;
    }
    seenSourcePaths.add(r.oldUrl);

    const notes = `[${r.migrationStatus}, confidence=${r.confidence}] ${r.reason}`;
    lines.push(
      `insert into url_redirects (source_path, target_type, target_path, status_code, notes) values (${sqlString(r.oldUrl)}, 'path', ${sqlString(r.newUrl)}, 301, ${sqlString(notes)}) on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();`,
    );
    lines.push("");
    count += 1;
  }

  const migrationPath = path.join(ROOT, "supabase", "migrations", "20250111000100_legacy_redirects.sql");
  writeFileSync(migrationPath, lines.join("\n") + "\n");

  console.log(`Wrote ${migrationPath}`);
  console.log(`  redirects: ${count}${skippedDuplicateSource > 0 ? `, skipped ${skippedDuplicateSource} duplicate source paths` : ""}`);
}

main();
