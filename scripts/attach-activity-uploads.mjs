#!/usr/bin/env node
// Attaches the site owner's own newly-uploaded activity photos to the
// real Male Atoll excursion content recovered from the legacy site
// (release/public_html/tours/*-male-atoll-activities.html):
//   assets/uploads/activities/{dolphin,full-day,nurse-shark,sand-bank,stingray}/
// plus assets/uploads/activities/island-hopping/ (registered as
// media_assets here for the future Island Tour activity; not yet attached
// to a node since that entity is still pending owner confirmation).
//
// Same deterministicUuid("uploaded-media::" + relativePath) /
// storagePathForUpload() scheme as scripts/attach-fishing-uploads.mjs, so a
// physical file always gets the same id regardless of which script last
// touched it. Only image files are registered — media_assets.media_type
// has no 'video' option, so the two .mp4 files in sand-bank/ and stingray/
// are skipped (not silently dropped from a page — they were never
// referenced by any node here).
//
// Usage: node scripts/attach-activity-uploads.mjs [--commit]

import { existsSync, readdirSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, deterministicUuid, ROOT, toAsciiSafe } from "./lib/legacy-shared.mjs";

const COMMIT = process.argv.includes("--commit");
const UPLOADS_DIR = path.join(ROOT, "assets", "uploads", "activities");
const IMAGE_EXT = new Set([".webp", ".jpg", ".jpeg", ".png", ".avif"]);

// folder -> [nodeType, slug] this folder's images attach to (in order,
// first file becomes hero). island-hopping has no target yet.
const FOLDER_TARGETS = {
  "full-day": ["activity", "full-day-excursion-male-atoll"],
  "nurse-shark": ["activity", "nurse-shark-snorkeling"],
  "sand-bank": ["activity", "sandbank-and-snorkeling-excursion"],
  stingray: ["activity", "stingray-snorkeling"],
  dolphin: ["activity", "dolphin-excursion"],
};

// Within each folder, prefer these filenames first (case-insensitive) so
// the hero is the most on-topic photo rather than an alphabetically-first
// unrelated one — several folders hold photos shared across the combined
// Full Day Excursion itinerary (stingray + nurse shark + sandbank +
// dolphin + local island).
const HERO_PREFERENCE = {
  "full-day": [/stingray-point-snorkeling/i, /nurse-shark-point-snorkeling/i, /maldives-sandbank/i, /lucky-dolphin-trip/i],
  "nurse-shark": [/^nurs-shark-snorkeling/i, /nurse-shark-point-snorkeling/i],
  "sand-bank": [/^maldives-sandbank/i],
  stingray: [/^stingray-point-snorkeling/i],
  dolphin: [/^maldives-lucky-dolphin-trip/i],
  // Vaavu Atoll Excursion draws from nurse-shark/ (the only folder with
  // real vaavu-shipwreck/vaavu-nurse-shark photos) via a second pass below.
};

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

// Identical convention to attach-fishing-uploads.mjs's storagePathForUpload.
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
  return cleaned ? `${cleaned} — Maldives activities` : "Maldives activities";
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

function orderWithHeroFirst(files, patterns) {
  if (!patterns || patterns.length === 0) return files;
  const ranked = files.map((f) => {
    const idx = patterns.findIndex((p) => p.test(f));
    return { f, rank: idx === -1 ? patterns.length : idx };
  });
  ranked.sort((a, b) => (a.rank !== b.rank ? a.rank - b.rank : a.f.localeCompare(b.f)));
  return ranked.map((r) => r.f);
}

function attachMedia(lines, nodeType, slug, entries, maxCount) {
  const picked = entries.slice(0, maxCount);
  lines.push(`delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = ${sqlString(nodeType)} and slug = ${sqlString(slug)});`);
  picked.forEach((entry, i) => {
    const role = i === 0 ? "hero" : "gallery";
    lines.push(
      `insert into node_media (node_id, media_id, role, sort_order) select id, ${sqlString(entry.mediaId)}, ${sqlString(role)}, ${i} from nodes where node_type = ${sqlString(nodeType)} and slug = ${sqlString(slug)} on conflict (node_id, media_id, role) do nothing;`,
    );
  });
}

function main() {
  const folders = ["dolphin", "full-day", "nurse-shark", "sand-bank", "stingray", "island-hopping"];
  const manifest = [];
  const lines = [];
  lines.push("-- Owner-uploaded activity photos (assets/uploads/activities/*/) for the");
  lines.push("-- real Male Atoll excursions recovered from the legacy site: Full Day");
  lines.push("-- Excursion, Vaavu Atoll Excursion, Stingray Snorkeling, Nurse Shark");
  lines.push("-- Snorkeling, Sandbank and Snorkeling Excursion, Dolphin Excursion.");
  lines.push("-- island-hopping/ photos are registered here but not yet attached to a");
  lines.push("-- node — the Island Tour activity is pending owner confirmation.");
  lines.push("-- GENERATED FILE, regenerate with:");
  lines.push("--   node scripts/attach-activity-uploads.mjs --commit");
  lines.push("");

  const byFolder = {};
  for (const folder of folders) {
    const files = listImages(path.join(UPLOADS_DIR, folder));
    byFolder[folder] = files;
    for (const filename of files) {
      const relativePath = `assets/uploads/activities/${folder}/${filename}`;
      const entry = registerFile(manifest, relativePath, altTextFor(filename));
      lines.push(
        `insert into media_assets (id, media_type, storage_path, alt_text) values (${sqlString(entry.mediaId)}, 'image', ${sqlString(entry.storagePath)}, ${sqlString(entry.altText)}) on conflict (id) do nothing;`,
      );
    }
  }
  lines.push("");

  const entriesByRelativePath = new Map(manifest.map((e) => [e.relativePath, e]));
  function entriesFor(folder) {
    return byFolder[folder].map((f) => entriesByRelativePath.get(`assets/uploads/activities/${folder}/${f}`));
  }

  for (const [folder, [nodeType, slug]] of Object.entries(FOLDER_TARGETS)) {
    const ordered = orderWithHeroFirst(byFolder[folder], HERO_PREFERENCE[folder]);
    const entries = ordered.map((f) => entriesByRelativePath.get(`assets/uploads/activities/${folder}/${f}`));
    lines.push(`-- Activity: ${slug}`);
    attachMedia(lines, nodeType, slug, entries, 6);
    lines.push("");
  }

  // Vaavu Atoll Excursion draws from nurse-shark/'s real vaavu-* photos
  // (shipwreck + nurse shark are its two named stops) — a second,
  // non-overlapping pick from the same folder, not the generic nurse-shark
  // photos already used above for the Nurse Shark Snorkeling activity.
  const vaavuFiles = byFolder["nurse-shark"].filter((f) => /^vaavu-/i.test(f));
  const vaavuOrdered = orderWithHeroFirst(vaavuFiles, [/vaavu-shipwreck-excursion\.webp$/i, /vaavu-nurse-shark-excursion/i, /vaavu-shipwreck-snorkeling/i]);
  const vaavuEntries = vaavuOrdered.map((f) => entriesByRelativePath.get(`assets/uploads/activities/nurse-shark/${f}`));
  lines.push("-- Activity: vaavu-atoll-excursion");
  attachMedia(lines, "activity", "vaavu-atoll-excursion", vaavuEntries, 6);
  lines.push("");

  console.log(`Found: ${folders.map((f) => `${f}=${byFolder[f].length}`).join(" ")}`);
  console.log(`\nIsland-hopping photos available for the future Island Tour node (id, storagePath, filename):`);
  for (const e of entriesFor("island-hopping")) console.log(`  ${e.mediaId}  ${e.storagePath}  (${e.relativePath.split("/").pop()})`);

  if (COMMIT) {
    const outPath = path.join(ROOT, "supabase", "migrations", "20250202000200_activity_uploads_media.sql");
    writeFileSync(outPath, [...lines, ""].join("\n"));
    console.log(`\nWrote ${path.relative(ROOT, outPath)}`);

    const manifestPath = path.join(DATA_DIR, "migration", "activity-uploads-manifest.json");
    writeFileSync(manifestPath, JSON.stringify({ generatedAt: new Date().toISOString(), files: manifest }, null, 2));
    console.log(`Wrote ${path.relative(ROOT, manifestPath)} (${manifest.length} files)`);
  }
}

main();
