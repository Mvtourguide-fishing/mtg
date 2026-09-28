#!/usr/bin/env node
// Repoints src/lib/transfers/category-images.ts's hardcoded hero images
// (the transfer hub, 5 category landing pages, ferry schedule page, and
// speedboat charter hub) from the old "legacy/images/transfers/*.webp"
// paths to the owner's freshly re-uploaded copies of those same photos
// under assets/uploads/transfers/.
//
// Those old legacy paths were never actually uploaded to Storage (the
// same still-unrun full-legacy-image-library gap documented earlier this
// project), so these hero images were broken/missing in production —
// same root cause as the fish-species.ts fix for the red snapper image.
// The owner's new upload includes several files whose names match the old
// legacy filenames almost exactly, confirming they're re-uploads of the
// same intended photos, not new/different content.
//
// domesticFlightComingSoon has no real replacement in the new upload (no
// domestic-flight photo was provided) and is left untouched rather than
// guessed.
//
// Registers one media_assets row per file (same
// deterministicUuid("uploaded-media::" + relativePath) scheme as every
// other attach-*.mjs script in this project — re-running this after
// scripts/attach-transfer-homepage-images.mjs already registered
// maldives-speed-boat-transfers.webp produces the identical id, so it
// never double-registers), then PRINTS the new category-images.ts source
// (this file has no DB rows to update — the ids/paths are hardcoded
// TypeScript literals, so the code file itself must be hand-edited to
// match what this script prints/writes).
//
// Usage: node scripts/attach-transfer-category-images.mjs [--commit]

import { existsSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, deterministicUuid, ROOT, toAsciiSafe } from "./lib/legacy-shared.mjs";

const COMMIT = process.argv.includes("--commit");
const TRANSFERS_DIR = path.join(ROOT, "assets", "uploads", "transfers");

function sqlString(value) {
  return `'${toAsciiSafe(String(value)).replace(/'/g, "''")}'`;
}

function slugifySegment(input) {
  return String(input)
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

function storagePathForUpload(relativePath) {
  const segments = relativePath.split("/");
  const filename = segments.pop();
  const extMatch = filename.match(/\.[a-zA-Z0-9]+$/);
  const ext = extMatch ? extMatch[0].toLowerCase() : "";
  const base = slugifySegment(filename.slice(0, filename.length - ext.length));
  const dir = segments.map(slugifySegment).join("/");
  return `uploads/${dir ? `${dir}/` : ""}${base}${ext}`;
}

// key -> [filename in assets/uploads/transfers/, alt text]
const ASSIGNMENTS = {
  mainHub: ["maldives-transfers.webp", "Maldives transfers"],
  airportTransfers: ["maldives-taxi-transfer.webp", "Maldives airport transfers"],
  resortTransfers: ["maldives-resort-transfer-300x300.webp", "Maldives resort transfers"],
  islandTransfers: ["maldives-island-transfers.webp", "Maldives island transfers"],
  hotelTransfers: ["maldives-bus-transfer.webp", "Maldives hotel transfers"],
  speedboatTransfers: ["maldives-speed-boat-transfers.webp", "Maldives speedboat transfers"],
  speedboatCharterHub: ["maldives-speed-boat-transfers-870x500.webp", "Private speedboat charter in the Maldives"],
  ferryScheduleHub: ["maldives-transportation.webp", "Maldives public transportation"],
  seaplaneComingSoon: ["maldives-seaplane-transfers.webp", "Maldives seaplane transfers"],
};

function main() {
  if (!existsSync(TRANSFERS_DIR)) {
    console.error(`Not found: ${TRANSFERS_DIR}`);
    process.exit(1);
  }

  const lines = [];
  lines.push(
    "-- media_assets rows for the transfer category hero images repointed",
    "-- in src/lib/transfers/category-images.ts (not node-backed, so no",
    "-- node_media rows here -- the code file itself carries the id/path).",
    "-- GENERATED FILE, regenerate with:",
    "--   node scripts/attach-transfer-category-images.mjs --commit",
    "",
  );

  const manifest = [];
  const entries = {};
  for (const [key, [filename, altText]] of Object.entries(ASSIGNMENTS)) {
    const relativePath = `assets/uploads/transfers/${filename}`;
    if (!existsSync(path.join(ROOT, relativePath))) {
      console.error(`Missing file: ${relativePath}`);
      process.exit(1);
    }
    const mediaId = deterministicUuid(`uploaded-media::${relativePath}`);
    const storagePath = storagePathForUpload(relativePath);
    manifest.push({ mediaId, relativePath, storagePath, altText, filename });
    entries[key] = { mediaId, storagePath, altText };

    lines.push(
      `insert into media_assets (id, media_type, storage_path, alt_text) values (${sqlString(mediaId)}, 'image', ${sqlString(storagePath)}, ${sqlString(altText)}) on conflict (id) do nothing;`,
    );
  }

  console.log("New TRANSFER_CATEGORY_IMAGES entries (key -> file):");
  for (const [key, [filename]] of Object.entries(ASSIGNMENTS)) console.log(`  ${key}  ->  ${filename}`);
  console.log("\ndomesticFlightComingSoon left unchanged (no real replacement uploaded).");

  if (COMMIT) {
    const outPath = path.join(ROOT, "supabase", "migrations", "20250129000200_transfer_category_images.sql");
    writeFileSync(outPath, lines.join("\n") + "\n");
    console.log(`\nWrote ${path.relative(ROOT, outPath)}`);

    const manifestPath = path.join(DATA_DIR, "migration", "transfer-category-images-manifest.json");
    writeFileSync(manifestPath, JSON.stringify({ generatedAt: new Date().toISOString(), files: manifest }, null, 2));
    console.log(`Wrote ${path.relative(ROOT, manifestPath)} (${manifest.length} files)`);

    const entriesPath = path.join(ROOT, "scripts", ".transfer-category-images-entries.json");
    writeFileSync(entriesPath, JSON.stringify(entries, null, 2));
    console.log(`Wrote ${path.relative(ROOT, entriesPath)} (for hand-editing category-images.ts)`);
  }
}

main();
