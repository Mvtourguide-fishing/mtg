#!/usr/bin/env node
// Attaches the owner's own newly-uploaded fishing photos to the real MFH
// fishing content:
//   - assets/uploads/fishing/images/{charters,gallery,packages}/ (NOT the
//     atolls/ or articles/ subfolders, out of scope here)
//   - assets/uploads/hotels/maldives-fishing/ — real photos of the actual
//     lodge building (added in a follow-up upload), unlike the charters/
//     folder's per-atoll-named decorative photos.
//
// The owner explicitly confirmed (AskUserQuestion, this task) that despite
// most charter filenames suggesting 15+ separate named businesses (e.g.
// "addu-adventurer.webp", "reef-baa.webp"), every one of those files is
// just an extra real photo for the ONE real charter operator on record
// (Maldives Fishing and Holiday Pvt Ltd, boat "Emperor", Maamendhoo, Gaafu
// Alifu Atoll — see data/maldives/fishing/mfh-charters.json) and its
// lodge/package variants. Never treated as separate listings here. The
// follow-up charter uploads (emperor.webp, emperor-fishing-charter.webp,
// maldives-fishing-boat-emperor.webp, etc.) are actual photos of that real
// boat, not decorative — preferred as the hero over the earlier decorative
// batch. Likewise every file under hotels/maldives-fishing/ is a genuine
// photo of the real lodge, preferred as ITS hero over the earlier
// decorative gallery/ pool.
//
// Registers one media_assets row per file (same
// deterministicUuid("uploaded-media::" + relativePath) /
// storagePathForUpload() scheme as scripts/attach-uploaded-media.mjs, so a
// physical file always gets the same id regardless of which script last
// touched it), then attaches node_media hero+gallery to:
//   - charters/ -> the 2 real charter activities
//     (private-full-day-fishing-charter, private-half-day-fishing-charter),
//     real "Emperor" boat photos first (hero), decorative photos after
//   - hotels/maldives-fishing/ + gallery/ -> the accommodation lodge
//     (maldives-fishing-and-holidays-lodge), real lodge photos first
//     (hero), decorative gallery/ photos after
// packages/ only get a media_assets row here — this codebase has no
// node_media convention for packages (see
// src/lib/packages/package-images.ts's PACKAGE_HERO_OVERRIDES, a hand-kept
// literal map); those ids are hand-copied into that file separately using
// this script's printed report, so the two never drift on id/path.
//
// Usage: node scripts/attach-fishing-uploads.mjs [--commit]

import { existsSync, readdirSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, deterministicUuid, ROOT, toAsciiSafe } from "./lib/legacy-shared.mjs";

const COMMIT = process.argv.includes("--commit");
const FISHING_UPLOADS_DIR = path.join(ROOT, "assets", "uploads", "fishing", "images");
const HOTEL_UPLOADS_DIR = path.join(ROOT, "assets", "uploads", "hotels", "maldives-fishing");
const IMAGE_EXT = new Set([".webp", ".jpg", ".jpeg", ".png", ".avif"]);

const CHARTER_ACTIVITY_SLUGS = ["private-full-day-fishing-charter", "private-half-day-fishing-charter"];
const ACCOMMODATION_SLUG = "maldives-fishing-and-holidays-lodge";
// Real photos of the actual "Emperor" boat, by filename — sorted first
// within the charters/ pool so they win the hero slot over the earlier,
// purely decorative per-atoll-named batch.
const REAL_BOAT_PATTERN = /emperor|maldives-fishing-boat|maldives-fishing-charter/i;

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

// Identical convention to attach-uploaded-media.mjs's storagePathForUpload —
// same "uploads/" + slugified-relativePath scheme, reused verbatim so a
// physical file's storage_path never depends on which script generated it.
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

function listImages(dir) {
  if (!existsSync(dir)) return [];
  return readdirSync(dir)
    .filter((f) => IMAGE_EXT.has(path.extname(f).toLowerCase()))
    .sort();
}

function registerFile(manifest, relativePath, altText) {
  const mediaId = deterministicUuid(`uploaded-media::${relativePath}`);
  const storagePath = storagePathForUpload(relativePath);
  const entry = { mediaId, relativePath, storagePath, altText };
  manifest.push(entry);
  return entry;
}

function attachMedia(lines, nodeType, slug, entries) {
  lines.push(`delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = ${sqlString(nodeType)} and slug = ${sqlString(slug)});`);
  entries.forEach((entry, i) => {
    const role = i === 0 ? "hero" : "gallery";
    lines.push(
      `insert into node_media (node_id, media_id, role, sort_order) select id, ${sqlString(entry.mediaId)}, ${sqlString(role)}, ${i} from nodes where node_type = ${sqlString(nodeType)} and slug = ${sqlString(slug)} on conflict (node_id, media_id, role) do nothing;`,
    );
  });
}

function main() {
  // Real "Emperor" boat photos sorted first (win the hero slot), then the
  // earlier decorative per-atoll-named batch, alphabetical within each group.
  const charterFiles = listImages(path.join(FISHING_UPLOADS_DIR, "charters")).sort((a, b) => {
    const aReal = REAL_BOAT_PATTERN.test(a) ? 0 : 1;
    const bReal = REAL_BOAT_PATTERN.test(b) ? 0 : 1;
    return aReal !== bReal ? aReal - bReal : a.localeCompare(b);
  });
  // Alphabetical puts a close-up fish shot (Blue-marlin.avif) first, which
  // makes an odd lead/hero photo for an accommodation — prefer a
  // boat/place shot as the hero instead, alphabetical for the rest.
  const galleryFiles = listImages(path.join(FISHING_UPLOADS_DIR, "gallery")).sort((a, b) => {
    const heroLike = /aerial-view|charter-boat/i;
    const aHero = heroLike.test(a) ? 0 : 1;
    const bHero = heroLike.test(b) ? 0 : 1;
    return aHero !== bHero ? aHero - bHero : a.localeCompare(b);
  });
  const packageFiles = listImages(path.join(FISHING_UPLOADS_DIR, "packages"));
  const hotelFiles = listImages(HOTEL_UPLOADS_DIR);

  console.log(`Found: charters=${charterFiles.length} gallery=${galleryFiles.length} packages=${packageFiles.length} hotel=${hotelFiles.length}`);

  const manifest = [];
  const lines = [];
  lines.push("-- Owner-uploaded fishing charter/gallery/package/lodge photos");
  lines.push("-- (assets/uploads/fishing/images/ + assets/uploads/hotels/maldives-fishing/)");
  lines.push("-- — real photos the owner pushed directly for the one real MFH");
  lines.push("-- charter/lodge/package listing (confirmed via AskUserQuestion, not");
  lines.push("-- separate businesses despite most charter filenames).");
  lines.push("-- GENERATED FILE, regenerate with:");
  lines.push("--   node scripts/attach-fishing-uploads.mjs --commit");
  lines.push("");

  // media_assets rows for every file (charters + gallery + packages + hotel)
  // — packages/ never gets a node_media row below (see header), but still
  // gets a real DB row here so nothing is an orphaned Storage-only file.
  for (const [folder, files] of [["charters", charterFiles], ["gallery", galleryFiles], ["packages", packageFiles]]) {
    for (const filename of files) {
      const relativePath = `assets/uploads/fishing/images/${folder}/${filename}`;
      const entry = registerFile(manifest, relativePath, altTextFor(filename));
      lines.push(
        `insert into media_assets (id, media_type, storage_path, alt_text) values (${sqlString(entry.mediaId)}, 'image', ${sqlString(entry.storagePath)}, ${sqlString(entry.altText)}) on conflict (id) do nothing;`,
      );
    }
  }
  for (const filename of hotelFiles) {
    const relativePath = `assets/uploads/hotels/maldives-fishing/${filename}`;
    const entry = registerFile(manifest, relativePath, altTextFor(filename));
    lines.push(
      `insert into media_assets (id, media_type, storage_path, alt_text) values (${sqlString(entry.mediaId)}, 'image', ${sqlString(entry.storagePath)}, ${sqlString(entry.altText)}) on conflict (id) do nothing;`,
    );
  }
  lines.push("");

  // Charters: split the photos across the 2 real charter activities — first
  // half to the full-day charter, second half to the half-day one (both are
  // the same boat/operator, so this is an even split, not a claim that any
  // specific photo is unique to one charter). The real "Emperor" photos sort
  // first within the pool, so each charter's hero is a real boat photo.
  const charterEntries = manifest.filter((e) => e.relativePath.includes("/charters/"));
  const mid = Math.ceil(charterEntries.length / 2);
  const perCharter = [charterEntries.slice(0, mid), charterEntries.slice(mid)];
  CHARTER_ACTIVITY_SLUGS.forEach((slug, i) => {
    lines.push(`-- Charter activity: ${slug}`);
    attachMedia(lines, "activity", slug, perCharter[i]);
    lines.push("");
  });

  // Accommodation lodge: real lodge photos first (hero + early gallery),
  // then the decorative gallery/ pool as additional gallery images.
  const hotelEntries = manifest.filter((e) => e.relativePath.startsWith("assets/uploads/hotels/"));
  const galleryEntries = manifest.filter((e) => e.relativePath.includes("/gallery/"));
  const lodgeEntries = [...hotelEntries, ...galleryEntries];
  lines.push(`-- Accommodation: ${ACCOMMODATION_SLUG}`);
  attachMedia(lines, "accommodation", ACCOMMODATION_SLUG, lodgeEntries);
  lines.push("");

  console.log(`\nCharter activity image assignments:`);
  CHARTER_ACTIVITY_SLUGS.forEach((slug, i) => {
    console.log(`  ${slug}: ${perCharter[i].map((e) => e.relativePath.split("/").pop()).join(", ")}`);
  });
  console.log(`\n${ACCOMMODATION_SLUG}: ${lodgeEntries.map((e) => e.relativePath.split("/").pop()).join(", ")}`);

  const packageEntries = manifest.filter((e) => e.relativePath.includes("/packages/"));
  console.log(`\nPackage photos available for PACKAGE_HERO_OVERRIDES (id, storagePath, filename):`);
  for (const e of packageEntries) console.log(`  ${e.mediaId}  ${e.storagePath}  (${e.relativePath.split("/").pop()})`);

  if (COMMIT) {
    const outPath = path.join(ROOT, "supabase", "migrations", "20250124000100_fishing_uploads_media.sql");
    writeFileSync(outPath, [...lines, ""].join("\n"));
    console.log(`\nWrote ${path.relative(ROOT, outPath)}`);

    const manifestPath = path.join(DATA_DIR, "migration", "fishing-uploads-manifest.json");
    writeFileSync(manifestPath, JSON.stringify({ generatedAt: new Date().toISOString(), files: manifest }, null, 2));
    console.log(`Wrote ${path.relative(ROOT, manifestPath)} (${manifest.length} files)`);
  }
}

main();
