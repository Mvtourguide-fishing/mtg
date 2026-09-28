#!/usr/bin/env node
// Registers the second batch of the owner's fishing gallery uploads
// (assets/uploads/fishing/images/gallery/ — 20 new files added after
// scripts/attach-fishing-uploads.mjs first ran) and attaches them as
// additional 'gallery' node_media rows on the real MFH lodge
// (maldives-fishing-and-holidays-lodge), continuing the sort_order
// sequence the first batch left off at (1-10 already used).
//
// Deliberately a SEPARATE migration rather than re-running
// attach-fishing-uploads.mjs and overwriting 20250124000100_fishing_uploads_media.sql
// in place — that file may already be applied in production, and this way
// the new inserts are purely additive (all ON CONFLICT DO NOTHING, same
// deterministicUuid("uploaded-media::" + relativePath) scheme, so if
// attach-fishing-uploads.mjs is ever re-run later the ids still match and
// nothing double-registers).
//
// Skips exact re-uploads of already-registered filenames (case-sensitive
// filesystem, so "Blue-marlin.avif" from round 1 and any differently-cased
// duplicate would both be kept — none exist here) and the one true
// duplicate file in this batch (yellowfin-tuna - Copy.webp, byte-identical
// to yellowfin-tuna.webp).
//
// Usage: node scripts/attach-fishing-gallery-round2.mjs [--commit]

import { existsSync, readdirSync, statSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, deterministicUuid, ROOT, toAsciiSafe } from "./lib/legacy-shared.mjs";

const COMMIT = process.argv.includes("--commit");
const GALLERY_DIR = path.join(ROOT, "assets", "uploads", "fishing", "images", "gallery");
const IMAGE_EXT = new Set([".webp", ".jpg", ".jpeg", ".png", ".avif"]);
const ACCOMMODATION_SLUG = "maldives-fishing-and-holidays-lodge";

// Filenames already registered by attach-fishing-uploads.mjs's first run
// (round 1) — never re-registered here.
const ROUND1_FILES = new Set([
  "Blue-marlin.avif",
  "Fishing-charter-boat.webp",
  "Maldives-atoll-aerial-view.webp",
  "Reef-fishing-grouper.webp",
  "Sailfish-maldives.webp",
  "Yellowfin-tuna-fishing-Maldives.webp",
  "fishing-liveaboard-Maldives.webp",
  "giant-trevally.webp",
]);

// Byte-identical duplicate of yellowfin-tuna.webp in this same batch.
const SKIP_FILES = new Set(["yellowfin-tuna - Copy.webp"]);

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

function altTextFor(filename) {
  const base = filename.replace(/\.[^.]+$/, "");
  const cleaned = base.replace(/[-_()]+/g, " ").replace(/\s+/g, " ").trim();
  return cleaned ? `${cleaned} — Maldives fishing` : "Maldives fishing";
}

function main() {
  if (!existsSync(GALLERY_DIR)) {
    console.error(`Not found: ${GALLERY_DIR}`);
    process.exit(1);
  }

  const allFiles = readdirSync(GALLERY_DIR)
    .filter((f) => IMAGE_EXT.has(path.extname(f).toLowerCase()) && statSync(path.join(GALLERY_DIR, f)).isFile())
    .sort();

  const newFiles = allFiles.filter((f) => !ROUND1_FILES.has(f) && !SKIP_FILES.has(f));
  const skipped = allFiles.filter((f) => SKIP_FILES.has(f));

  console.log(`gallery/ total=${allFiles.length} round1=${ROUND1_FILES.size} new=${newFiles.length} skipped-duplicate=${skipped.length}`);

  const manifest = [];
  const lines = [];
  lines.push("-- Round 2 of the owner's fishing gallery uploads (20 new files added to");
  lines.push("-- assets/uploads/fishing/images/gallery/ after the first batch — see");
  lines.push("-- scripts/attach-fishing-uploads.mjs for that original batch). Registers");
  lines.push("-- one media_assets row per new file and appends them as additional");
  lines.push("-- 'gallery' node_media rows on the real MFH lodge, continuing sort_order");
  lines.push("-- from where the first batch left off. 4 of these files replace a");
  lines.push("-- broken legacy fish-species photo reference (see fish-species.ts) —");
  lines.push("-- those 4 are registered here for their media_assets row only; the");
  lines.push("-- fish-species.ts code change itself is a separate, non-SQL edit.");
  lines.push("-- GENERATED FILE, regenerate with:");
  lines.push("--   node scripts/attach-fishing-gallery-round2.mjs --commit");
  lines.push("");

  for (const filename of newFiles) {
    const relativePath = `assets/uploads/fishing/images/gallery/${filename}`;
    const mediaId = deterministicUuid(`uploaded-media::${relativePath}`);
    const storagePath = storagePathForUpload(relativePath);
    const altText = altTextFor(filename);
    manifest.push({ mediaId, relativePath, storagePath, altText, filename });
    lines.push(
      `insert into media_assets (id, media_type, storage_path, alt_text) values (${sqlString(mediaId)}, 'image', ${sqlString(storagePath)}, ${sqlString(altText)}) on conflict (id) do nothing;`,
    );
  }
  lines.push("");

  // Append to the lodge's existing gallery (sort_order 1-10 already used by
  // round 1 — see 20250124000100_fishing_uploads_media.sql), continuing at 11.
  lines.push(`-- Accommodation: ${ACCOMMODATION_SLUG} (append to existing gallery)`);
  manifest.forEach((entry, i) => {
    const sortOrder = 11 + i;
    lines.push(
      `insert into node_media (node_id, media_id, role, sort_order) select id, ${sqlString(entry.mediaId)}, 'gallery', ${sortOrder} from nodes where node_type = 'accommodation' and slug = ${sqlString(ACCOMMODATION_SLUG)} on conflict (node_id, media_id, role) do nothing;`,
    );
  });
  lines.push("");

  console.log(`\nRegistered media (id, storagePath, filename):`);
  for (const e of manifest) console.log(`  ${e.mediaId}  ${e.storagePath}  (${e.filename})`);

  if (COMMIT) {
    const outPath = path.join(ROOT, "supabase", "migrations", "20250128000100_fishing_gallery_round2_media.sql");
    writeFileSync(outPath, [...lines, ""].join("\n"));
    console.log(`\nWrote ${path.relative(ROOT, outPath)}`);

    const manifestPath = path.join(DATA_DIR, "migration", "fishing-gallery-round2-manifest.json");
    writeFileSync(manifestPath, JSON.stringify({ generatedAt: new Date().toISOString(), files: manifest }, null, 2));
    console.log(`Wrote ${path.relative(ROOT, manifestPath)} (${manifest.length} files)`);
  }
}

main();
