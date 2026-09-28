#!/usr/bin/env node
// Stays ecosystem, Phase 2: attaches real legacy images to the 148
// migrated resort/hotel/guesthouse properties and their room/villa
// records. No new media_assets rows — every image referenced here
// already exists from 20250115000100_full_legacy_image_library.sql
// (which already covers the entire release/public_html/{resorts,hotels}/
// tree, confirmed by the Phase 1 audit's own image-count cross-check), and
// every computed id is independently verified present in that file before
// being used, same discipline as every prior attach-*-images.mjs script.
//
// Hero/gallery selection: a property's images/ folder mixes true
// property-level photos (beach, pool, dining, aerial) with the same
// per-room carousel photos already attached to accommodation_rooms —
// re-checked here, since spot-checking found the very FIRST <img> tag on
// a page is often already a specific room photo, not a property-level
// shot (e.g. Kurumba's first body image is "...Superior-Room.webp"). So
// hero/gallery candidates are the property's images MINUS whatever's
// already used by a room, alphabetically ordered (deterministic, not a
// curation claim) — a "-map.webp" file is skipped for hero specifically
// (a floor plan/location graphic, not a photo) but can still appear in
// the gallery.
//
// Usage: node scripts/attach-stays-images.mjs
// (writes directly to supabase/migrations/20250123000300_stays_images.sql)

import { readFileSync, writeFileSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

import { deterministicUuid } from "./lib/legacy-shared.mjs";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const V2_DATA_DIR = path.join(ROOT, "data", "maldives", "accommodations-v2");
const LIBRARY_MIGRATION = path.join(ROOT, "supabase", "migrations", "20250115000100_full_legacy_image_library.sql");
const MAX_GALLERY_IMAGES = 10;

function loadJson(file) {
  return JSON.parse(readFileSync(path.join(V2_DATA_DIR, file), "utf8"));
}

/** Every media_assets id already present in the full legacy image
 * library migration, for verifying computed ids before referencing them —
 * never trust the hash alone without confirming the row actually exists. */
function loadLibraryIds() {
  const sql = readFileSync(LIBRARY_MIGRATION, "utf8");
  const ids = new Set();
  const re = /values \('([0-9a-f-]{36})',/g;
  let m;
  while ((m = re.exec(sql))) ids.add(m[1]);
  return ids;
}

function stripLeadingSlash(p) {
  return p.startsWith("/") ? p.slice(1) : p;
}

function main() {
  const properties = loadJson("resolved-properties.json");
  const libraryIds = loadLibraryIds();

  const lines = [];
  lines.push("-- Attaches real legacy images to the 148 migrated Stays properties");
  lines.push("-- (node_media role='hero'/'gallery') and their real room/villa photos");
  lines.push("-- (accommodation_room_media). No new media_assets rows — every id below");
  lines.push("-- already exists from 20250115000100_full_legacy_image_library.sql.");
  lines.push("-- GENERATED FILE, regenerate with:");
  lines.push("--   node scripts/attach-stays-images.mjs");
  lines.push("");

  let heroCount = 0;
  let galleryCount = 0;
  let roomImageCount = 0;
  let missingIds = 0;

  for (const p of properties) {
    const roomImageBasenames = new Set();
    for (const room of p.rooms ?? []) {
      for (const img of room.images ?? []) {
        roomImageBasenames.add(path.basename(img));
      }
    }

    const candidateFiles = (p.imageFiles ?? [])
      .filter((f) => !roomImageBasenames.has(f))
      .sort((a, b) => a.localeCompare(b));

    const heroFile = candidateFiles.find((f) => !/map/i.test(f)) ?? candidateFiles[0] ?? p.imageFiles?.[0] ?? null;
    const galleryFiles = candidateFiles.filter((f) => f !== heroFile).slice(0, MAX_GALLERY_IMAGES);

    if (heroFile || galleryFiles.length > 0) {
      lines.push(`-- ${p.folder} (${p.name})`);
    }

    function mediaInsertForImage(relativeFile, role, sortOrder) {
      const relativePath = `${p.imageDirRelative}/${relativeFile}`;
      const mediaId = deterministicUuid(`legacy-media::${relativePath}`);
      if (!libraryIds.has(mediaId)) {
        missingIds += 1;
        return null;
      }
      return { mediaId, relativePath, role, sortOrder };
    }

    const mediaOps = [];
    if (heroFile) {
      const op = mediaInsertForImage(heroFile, "hero", 0);
      if (op) {
        mediaOps.push(op);
        heroCount += 1;
      }
    }
    galleryFiles.forEach((f, i) => {
      const op = mediaInsertForImage(f, "gallery", i);
      if (op) {
        mediaOps.push(op);
        galleryCount += 1;
      }
    });

    // Properties merged into an already-seeded Task 5 accommodation (see
    // mergeIntoExistingSlug's comment in merge-accommodation-research.mjs)
    // have a node whose title is the Task 5 one, not this property's own
    // p.name — match by the known real slug instead for those; title
    // match for everyone else (no locally-recomputed slug to rely on).
    const nodeSelector = p.mergeIntoExistingSlug
      ? `slug = '${p.mergeIntoExistingSlug}'`
      : `title = '${p.name.replace(/'/g, "''")}'`;
    for (const op of mediaOps) {
      lines.push(
        `insert into node_media (node_id, media_id, role, sort_order) select id, '${op.mediaId}', '${op.role}', ${op.sortOrder} from nodes where node_type = 'accommodation' and ${nodeSelector} on conflict (node_id, media_id, role) do nothing;`,
      );
    }
    if (mediaOps.length > 0) lines.push("");

    // Room images (1-2 real photos each, already found by the extraction
    // script's carousel scan).
    for (const room of p.rooms ?? []) {
      const roomImages = (room.images ?? []).map(stripLeadingSlash);
      if (roomImages.length === 0) continue;

      roomImages.forEach((relativePath, i) => {
        const mediaId = deterministicUuid(`legacy-media::${relativePath}`);
        if (!libraryIds.has(mediaId)) {
          missingIds += 1;
          return;
        }
        lines.push(
          `insert into accommodation_room_media (room_id, media_id, sort_order) select r.id, '${mediaId}', ${i} from accommodation_rooms r join nodes n on n.id = r.accommodation_id where n.node_type = 'accommodation' and ${nodeSelector} and r.name = '${room.name.replace(/'/g, "''")}' on conflict (room_id, media_id) do nothing;`,
        );
        roomImageCount += 1;
      });
    }
  }

  writeFileSync(path.join(ROOT, "supabase", "migrations", "20250123000300_stays_images.sql"), lines.join("\n") + "\n");

  console.log(`Hero images: ${heroCount}, Gallery images: ${galleryCount}, Room images: ${roomImageCount}`);
  console.log(`Missing/unverified ids skipped: ${missingIds}`);
}

main();
