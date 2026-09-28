#!/usr/bin/env node
// Task 21 follow-on: only 4 of this project's 14 real accommodations had a
// hero image (Baros, Gili Lankanfushi, Kaani Beach Hotel, Six Senses
// Laamu) — the rest were never matched by Task 14's original
// high-confidence-only media import. Now that the FULL resorts/ and
// hotels/ image libraries are migrated (every real photo, not just a
// capped high-confidence subset — see build-full-legacy-image-library.mjs),
// this re-attempts the match for every accommodation using the same
// resort-folder-name matching approach that worked well for transfer
// routes (recover-transfer-route-images.mjs).
//
// Source of accommodation names: data/maldives/accommodations/
// accommodations.json (the same file the original seed used) — never
// invented. A real match requires token-overlap score >= 0.6 against a
// resorts/ or hotels/ folder name, same threshold as the transfer-route
// script. No match, no image — never a stock substitute.
//
// Writes: supabase/migrations/20250116000200_accommodation_images.sql
//
// Usage: node scripts/attach-accommodation-images.mjs [--commit]

import { existsSync, readdirSync, writeFileSync } from "node:fs";
import path from "node:path";

import { deterministicUuid, distinctiveTokens, loadJson, RELEASE_DIR, ROOT, toAsciiSafe, tokenOverlapScore } from "./lib/legacy-shared.mjs";

const COMMIT = process.argv.includes("--commit");
const IMAGE_EXT = new Set([".webp", ".jpg", ".jpeg", ".png"]);
const THRESHOLD = 0.6;
const FOLDER_ROOTS = ["resorts", "hotels"];

function sqlString(value) {
  return `'${toAsciiSafe(String(value)).replace(/'/g, "''")}'`;
}

function buildFolderIndex() {
  const index = [];
  for (const root of FOLDER_ROOTS) {
    const rootDir = path.join(RELEASE_DIR, root);
    if (!existsSync(rootDir)) continue;
    for (const entry of readdirSync(rootDir, { withFileTypes: true })) {
      if (!entry.isDirectory()) continue;
      const imagesDir = path.join(rootDir, entry.name, "images");
      if (!existsSync(imagesDir)) continue;
      const files = readdirSync(imagesDir)
        .filter((f) => IMAGE_EXT.has(path.extname(f).toLowerCase()))
        .sort();
      if (files.length === 0) continue;
      index.push({ root, folder: entry.name, relativePath: `${root}/${entry.name}/images/${files[0]}` });
    }
  }
  return index;
}

// Two folders the automatic scorer can't reach: their names fuse the
// brand and island into one compound word with no separator
// ("kaanibeach-maafushi", "arena-maafushi" has no brand/island split at
// all) so plain token overlap sees near-zero shared tokens even though
// these ARE the same real properties — manually verified by inspecting
// the folder's own images, not guessed.
const MANUAL_FOLDER_OVERRIDES = {
  "Arena Beach Hotel": { root: "hotels", folder: "arena-maafushi" },
  "Kaani Beach Hotel": { root: "hotels", folder: "kaanibeach-maafushi" },
};

function matchFolder(name, islandName, index) {
  const override = MANUAL_FOLDER_OVERRIDES[name];
  if (override) {
    const entry = index.find((e) => e.root === override.root && e.folder === override.folder);
    if (entry) return { entry, score: 1 };
  }

  const nameTokens = new Set(distinctiveTokens(name));
  let best = null;
  let bestScore = 0;
  for (const entry of index) {
    const folderTokens = new Set(distinctiveTokens(entry.folder.replace(/-/g, " ")));
    const score = tokenOverlapScore(folderTokens, nameTokens);
    if (score > bestScore) {
      bestScore = score;
      best = entry;
    }
  }
  return best && bestScore >= THRESHOLD ? { entry: best, score: bestScore } : null;
}

function main() {
  const accommodations = loadJson("accommodations", "accommodations.json");
  const index = buildFolderIndex();

  const lines = [];
  const matches = [];
  const unmatched = [];

  for (const acc of accommodations) {
    const match = matchFolder(acc.name, acc.island_name, index);
    if (!match) {
      unmatched.push(acc.name);
      continue;
    }
    matches.push({ name: acc.name, folder: match.entry.folder, score: Number(match.score.toFixed(2)) });

    // relativePath -> mediaId must match build-full-legacy-image-library.mjs's
    // own deterministicUuid("legacy-media::" + relativePath) exactly — the
    // media_assets row already exists from that migration, so this only
    // ever needs a node_media insert, never a new media_assets row.
    const relativePath = match.entry.relativePath;
    const mediaId = deterministicUuid(`legacy-media::${relativePath}`);

    lines.push(
      `delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'accommodation' and title = ${sqlString(acc.name)});`,
    );
    lines.push(
      `insert into node_media (node_id, media_id, role, sort_order) select id, ${sqlString(mediaId)}, 'hero', 0 from nodes where node_type = 'accommodation' and title = ${sqlString(acc.name)} on conflict (node_id, media_id, role) do nothing;`,
    );
  }

  console.log(`Accommodations: ${accommodations.length}`);
  console.log(`Matched: ${matches.length}`);
  for (const m of matches) console.log(`  "${m.name}" -> ${m.folder}/ (score ${m.score})`);
  console.log(`Unmatched: ${unmatched.length}`, unmatched);

  if (COMMIT) {
    const sql = [
      "-- Task 21 follow-on: backfill hero images for real accommodations",
      "-- that Task 14's original high-confidence-only import missed, now",
      "-- matched against the FULL resorts/ and hotels/ image libraries.",
      "-- GENERATED FILE, regenerate with:",
      "--   node scripts/attach-accommodation-images.mjs --commit",
      "",
      ...lines,
      "",
    ].join("\n");
    const outPath = path.join(ROOT, "supabase", "migrations", "20250116000200_accommodation_images.sql");
    writeFileSync(outPath, sql);
    console.log(`\nWrote ${path.relative(ROOT, outPath)}`);
  }
}

main();
