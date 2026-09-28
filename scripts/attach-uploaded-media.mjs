#!/usr/bin/env node
// Attaches the owner's own newly-uploaded speedboat/vehicle photos
// (assets/uploads/speedboats/<slug>/*, assets/uploads/vehicles/<slug>/*
// — pushed directly by the owner, not scraped from the legacy site) to
// the matching real node_media rows. Folder names ARE the real node
// slugs (7 speedboats + 4 vehicles, all already in the DB), so no
// fuzzy matching is needed here — only which file within a folder
// becomes the hero.
//
// Hero selection per folder: prefer a file whose name contains
// "exterior" (the owner's own consistent naming for the main shot:
// chill-speed_exterior.jpg, arriva-exterior.jpeg, etc.), else a file
// whose name token-matches the folder slug itself (e.g. seaguard.png
// for slug "seaguard"), else the alphabetically-first file. This avoids
// picking one of the few generic legacy-site filenames mixed into some
// folders (e.g. "Male-airport-to-...webp" in chill-speed-2) as the hero
// — those are flagged in the printed report, never silently used as the
// main photo, but ARE still migrated as gallery images since the owner
// chose to include them.
//
// Writes: supabase/migrations/20250117000100_uploaded_boat_vehicle_media.sql
// and data/maldives/migration/uploaded-media-manifest.json (read by
// scripts/upload-legacy-media.mjs, same as every other manifest).
//
// Usage: node scripts/attach-uploaded-media.mjs [--commit]

import { existsSync, readdirSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, deterministicUuid, distinctiveTokens, ROOT, toAsciiSafe } from "./lib/legacy-shared.mjs";

const COMMIT = process.argv.includes("--commit");
const UPLOADS_ROOT = path.join(ROOT, "assets", "uploads");
const IMAGE_EXT = new Set([".webp", ".jpg", ".jpeg", ".png"]);

const GROUPS = [
  { dir: "speedboats", nodeType: "speedboat" },
  { dir: "vehicles", nodeType: "vehicle" },
];

function sqlString(value) {
  return `'${toAsciiSafe(String(value)).replace(/'/g, "''")}'`;
}

function altTextFor(filename) {
  const base = filename.replace(/\.[^.]+$/, "");
  const cleaned = base.replace(/[-_()]+/g, " ").replace(/\s+/g, " ").trim();
  return cleaned || "Maldives Tour Guide";
}

/** Storage path for an uploaded (non-legacy) file — mirrors
 * storagePathForRelativePath's slugify-every-segment approach but with
 * an "uploads/" prefix instead of "legacy/", since these files didn't
 * come from the old site. */
function storagePathForUpload(relativePath) {
  const segments = relativePath.split("/");
  const filename = segments.pop();
  const extMatch = filename.match(/\.[a-zA-Z0-9]+$/);
  const ext = extMatch ? extMatch[0].toLowerCase() : "";
  const base = distinctiveTokensToSlug(filename.slice(0, filename.length - ext.length));
  const dir = segments.map(distinctiveTokensToSlug).join("/");
  return `uploads/${dir ? `${dir}/` : ""}${base}${ext}`;
}

// Same slugify rule used throughout this project (lowercase, non-alnum -> hyphen).
function distinctiveTokensToSlug(input) {
  return String(input)
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

function pickHero(files, slug) {
  const withExterior = files.find((f) => /exterior/i.test(f));
  if (withExterior) return withExterior;

  const slugTokens = new Set(distinctiveTokens(slug));
  const slugMatch = files.find((f) => {
    const fileTokens = new Set(distinctiveTokens(f));
    return [...slugTokens].every((t) => fileTokens.has(t));
  });
  if (slugMatch) return slugMatch;

  return [...files].sort()[0];
}

function main() {
  if (!existsSync(UPLOADS_ROOT)) {
    console.error(`Not found: ${UPLOADS_ROOT}`);
    process.exit(1);
  }

  const lines = [];
  const uploadManifest = [];
  const report = [];
  const flaggedGeneric = [];

  for (const group of GROUPS) {
    const groupDir = path.join(UPLOADS_ROOT, group.dir);
    if (!existsSync(groupDir)) continue;

    for (const entry of readdirSync(groupDir, { withFileTypes: true })) {
      if (!entry.isDirectory()) continue;
      const slug = entry.name;
      const folderDir = path.join(groupDir, slug);
      const files = readdirSync(folderDir).filter((f) => IMAGE_EXT.has(path.extname(f).toLowerCase()));
      if (files.length === 0) continue;

      const hero = pickHero(files, slug);
      const routeSlugPredicate = `node_type = ${sqlString(group.nodeType)} and slug = ${sqlString(slug)}`;

      lines.push(`delete from node_media where role = 'hero' and node_id = (select id from nodes where ${routeSlugPredicate});`);

      files.sort();
      let sortOrder = 0;
      for (const filename of files) {
        const relativePath = `assets/uploads/${group.dir}/${slug}/${filename}`;
        const mediaId = deterministicUuid(`uploaded-media::${relativePath}`);
        const storagePath = storagePathForUpload(relativePath);
        const role = filename === hero ? "hero" : "gallery";
        uploadManifest.push({ mediaId, relativePath, storagePath });

        lines.push(
          `insert into media_assets (id, media_type, storage_path, alt_text) values (${sqlString(mediaId)}, 'image', ${sqlString(storagePath)}, ${sqlString(altTextFor(filename))}) on conflict (id) do nothing;`,
        );
        lines.push(
          `insert into node_media (node_id, media_id, role, sort_order) select id, ${sqlString(mediaId)}, ${sqlString(role)}, ${sortOrder} from nodes where ${routeSlugPredicate} on conflict (node_id, media_id, role) do nothing;`,
        );
        sortOrder += 1;

        if (!/exterior|interior|seating|bow/i.test(filename) && !new RegExp(distinctiveTokens(slug).join("|"), "i").test(filename)) {
          flaggedGeneric.push({ slug, filename, isHero: filename === hero });
        }
      }
      report.push({ nodeType: group.nodeType, slug, files, hero });
    }
  }

  console.log(`Folders processed: ${report.length}`);
  for (const r of report) console.log(`  ${r.nodeType}/${r.slug}: ${r.files.length} files, hero = ${r.hero}`);

  console.log(`\nFiles that don't look boat/vehicle-specific by name (still migrated, just flagged):`);
  for (const f of flaggedGeneric) console.log(`  ${f.slug}/${f.filename}${f.isHero ? "  <-- WOULD BE HERO, check this" : " (gallery)"}`);
  if (flaggedGeneric.length === 0) console.log("  (none)");

  if (COMMIT) {
    const sql = [
      "-- Owner-uploaded speedboat and vehicle photos (assets/uploads/) --",
      "-- real photos the owner pushed directly, not from the legacy site.",
      "-- GENERATED FILE, regenerate with:",
      "--   node scripts/attach-uploaded-media.mjs --commit",
      "",
      ...lines,
      "",
    ].join("\n");
    const outPath = path.join(ROOT, "supabase", "migrations", "20250117000100_uploaded_boat_vehicle_media.sql");
    writeFileSync(outPath, sql);
    console.log(`\nWrote ${path.relative(ROOT, outPath)}`);

    const manifestPath = path.join(DATA_DIR, "migration", "uploaded-media-manifest.json");
    writeFileSync(manifestPath, JSON.stringify({ generatedAt: new Date().toISOString(), files: uploadManifest }, null, 2));
    console.log(`Wrote ${path.relative(ROOT, manifestPath)} (${uploadManifest.length} files)`);
  }
}

main();
