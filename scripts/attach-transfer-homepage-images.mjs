#!/usr/bin/env node
// Wires the owner's newly-uploaded assets/uploads/transfers/ photos to the
// 4 real transfer_route nodes that show on the homepage "Getting Around"
// section (getTransferRoutes({ pageSize: 4 }), ordered by title — see
// src/app/page.tsx). Those 4 routes (Guraidhoo<->Male, Maafushi->Male,
// Male->Himmafushi) had either no hero image or a stray one from an
// earlier broad image-matching pass, which the owner reported as showing
// wrong ("food picture") photos.
//
// Registers one media_assets row per file used (same
// deterministicUuid("uploaded-media::" + relativePath) / storagePathForUpload()
// scheme as scripts/attach-fishing-uploads.mjs, so a physical file always
// gets the same id regardless of which script last touched it), then
// deletes any existing 'hero' row for each route before inserting the new
// one — same idempotent delete-then-insert pattern as
// scripts/recover-transfer-route-images.mjs, so a re-run never leaves two
// hero rows or fails to replace a wrong one.
//
// Only 3 of the uploaded files genuinely depict a speedboat/ferry route
// between Male and a nearby local island (the rest are seaplane, Male
// street traffic, or duplicate crops of the same speedboat photo at a
// different size) — reusing a mismatched photo just to have 4 distinct
// images would recreate the exact bug being fixed, so the 4th route uses
// a real route map (maafushi-map2.webp) that explicitly depicts this exact
// Male Airport <-> Himmafushi/Maafushi/Guraidhoo speedboat network instead
// of a duplicate crop.
//
// Usage: node scripts/attach-transfer-homepage-images.mjs [--commit]

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

// Identical to attach-fishing-uploads.mjs / attach-uploaded-media.mjs.
function storagePathForUpload(relativePath) {
  const segments = relativePath.split("/");
  const filename = segments.pop();
  const extMatch = filename.match(/\.[a-zA-Z0-9]+$/);
  const ext = extMatch ? extMatch[0].toLowerCase() : "";
  const base = slugifySegment(filename.slice(0, filename.length - ext.length));
  const dir = segments.map(slugifySegment).join("/");
  return `uploads/${dir ? `${dir}/` : ""}${base}${ext}`;
}

// routeSlug -> [filename in assets/uploads/transfers/, real alt text]
const ASSIGNMENTS = {
  "guraidhoo-to-male": ["maldives-speedboat.webp", "Speedboat transfer between Guraidhoo and Male"],
  "maafushi-to-male": ["maldives-speed-boat-transfers.webp", "Speedboat transfer between Maafushi and Male"],
  "male-to-guraidhoo": ["maafushi-map2.webp", "Speedboat route map: Male Airport to Guraidhoo, Maafushi and Himmafushi"],
  "male-to-himmafushi": ["maldives-ferry-transfer.webp", "Ferry transfer between Male and Himmafushi"],
};

function main() {
  if (!existsSync(TRANSFERS_DIR)) {
    console.error(`Not found: ${TRANSFERS_DIR}`);
    process.exit(1);
  }

  const lines = [];
  lines.push(
    "-- Real photos for the 4 transfer routes shown on the homepage's",
    "-- 'Getting Around' section (getTransferRoutes({ pageSize: 4 }),",
    "-- ordered by title). Replaces whatever hero image (missing or wrong)",
    "-- those 4 routes had before with the owner's own",
    "-- assets/uploads/transfers/ photos.",
    "-- GENERATED FILE, regenerate with:",
    "--   node scripts/attach-transfer-homepage-images.mjs --commit",
    "",
  );

  const manifest = [];
  for (const [routeSlug, [filename, altText]] of Object.entries(ASSIGNMENTS)) {
    const relativePath = `assets/uploads/transfers/${filename}`;
    if (!existsSync(path.join(ROOT, relativePath))) {
      console.error(`Missing file: ${relativePath}`);
      process.exit(1);
    }
    const mediaId = deterministicUuid(`uploaded-media::${relativePath}`);
    const storagePath = storagePathForUpload(relativePath);
    manifest.push({ mediaId, relativePath, storagePath, altText, filename });

    lines.push(`-- Route: ${routeSlug}`);
    lines.push(
      `insert into media_assets (id, media_type, storage_path, alt_text) values (${sqlString(mediaId)}, 'image', ${sqlString(storagePath)}, ${sqlString(altText)}) on conflict (id) do nothing;`,
    );
    lines.push(
      `delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'transfer_route' and slug = ${sqlString(routeSlug)});`,
    );
    lines.push(
      `insert into node_media (node_id, media_id, role, sort_order) select id, ${sqlString(mediaId)}::uuid, 'hero', 0 from nodes where node_type = 'transfer_route' and slug = ${sqlString(routeSlug)} on conflict (node_id, media_id, role) do nothing;`,
    );
    lines.push("");
  }

  console.log("Assignments (route -> file):");
  for (const [routeSlug, [filename]] of Object.entries(ASSIGNMENTS)) console.log(`  ${routeSlug}  ->  ${filename}`);

  if (COMMIT) {
    const outPath = path.join(ROOT, "supabase", "migrations", "20250129000100_transfer_homepage_images.sql");
    writeFileSync(outPath, lines.join("\n") + "\n");
    console.log(`\nWrote ${path.relative(ROOT, outPath)}`);

    const manifestPath = path.join(DATA_DIR, "migration", "transfer-homepage-images-manifest.json");
    writeFileSync(manifestPath, JSON.stringify({ generatedAt: new Date().toISOString(), files: manifest }, null, 2));
    console.log(`Wrote ${path.relative(ROOT, manifestPath)} (${manifest.length} files)`);
  }
}

main();
