#!/usr/bin/env node
// Task 14: legacy media inventory + entity matching.
//
// Walks release/public_html (the extracted "webmigration" GitHub Release
// asset — the legacy MTG website, NOT part of the git tree, see
// .gitignore), catalogs every image/video, and matches each one against
// the real MTG entity catalogue reconstructed by
// scripts/lib/legacy-shared.mjs — never a fabricated/guessed entity.
//
// Writes:
//   data/maldives/media/media-inventory.json      — every file, full record
//   data/maldives/media/media-match-report.json   — confidence summary + review lists
//   data/maldives/media/media-duplicates.json     — hash/filename duplicate groups
//
// Read-only by default. Nothing in release/ is renamed or modified, and
// no database/Storage write happens here — see scripts/upload-legacy-media.mjs
// for that (separate, and also dry-run by default).
//
// Usage:
//   node scripts/import-legacy-media.mjs            # inventory + match report
//   node scripts/import-legacy-media.mjs --commit    # also emit a SQL migration
//                                                       for HIGH-confidence matches
//                                                       against EXISTING entities

import { createHash } from "node:crypto";
import { existsSync, mkdirSync, readdirSync, readFileSync, statSync, writeFileSync } from "node:fs";
import path from "node:path";
import { imageSize } from "image-size";

import {
  ATOLL_FOLDER_TO_CODE,
  RELEASE_DIR,
  ROOT,
  buildEntityIndex,
  deterministicUuid,
  distinctiveTokens,
  storagePathForRelativePath,
  toAsciiSafe,
  tokenOverlapScore,
} from "./lib/legacy-shared.mjs";

const MEDIA_DATA_DIR = path.join(ROOT, "data", "maldives", "media");
const COMMIT = process.argv.includes("--commit");

const IMAGE_EXT = new Set([".jpg", ".jpeg", ".png", ".webp", ".gif", ".svg"]);
const VIDEO_EXT = new Set([".mp4", ".mov", ".webm"]);
const MIME_BY_EXT = {
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".png": "image/png",
  ".webp": "image/webp",
  ".gif": "image/gif",
  ".svg": "image/svg+xml",
  ".mp4": "video/mp4",
  ".mov": "video/quicktime",
  ".webm": "video/webm",
};

// Directories that are legacy site plumbing, not content media, even
// though they may contain image-extension files (e.g. vendor icon sets).
const SKIP_DIR_NAMES = new Set(["vendor", "node_modules", ".git", "css", "js", "font", "fonts", "bml", "gpay"]);

function shouldSkipDir(name) {
  return SKIP_DIR_NAMES.has(name);
}

function walk(dir, relBase, out) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (entry.isDirectory()) {
      if (shouldSkipDir(entry.name)) continue;
      walk(path.join(dir, entry.name), path.join(relBase, entry.name), out);
      continue;
    }
    const ext = path.extname(entry.name).toLowerCase();
    if (!IMAGE_EXT.has(ext) && !VIDEO_EXT.has(ext)) continue;
    if (entry.name === "Thumbs.db") continue;
    out.push(path.join(relBase, entry.name));
  }
}

function readDimensions(fullPath, ext) {
  if (!IMAGE_EXT.has(ext) || ext === ".svg") return { width: null, height: null };
  try {
    const buffer = readFileSync(fullPath);
    const { width, height } = imageSize(buffer);
    return { width: width ?? null, height: height ?? null };
  } catch {
    return { width: null, height: null };
  }
}

function sha1Of(fullPath) {
  try {
    return createHash("sha1").update(readFileSync(fullPath)).digest("hex");
  } catch {
    return null;
  }
}

function parts0(relativePath) {
  const parts = relativePath.split(path.sep);
  return parts.length > 1 ? parts[1] : null;
}

/** Directory-path role/context hints: a file under resorts/<Name>/images/
 * or hotels/<Name>/images/ is very likely media FOR that accommodation,
 * regardless of what the filename itself says. */
function pathHint(relativePath) {
  const parts = relativePath.split(path.sep);
  const hint = { likelySection: parts[0] ?? null, folderName: null };
  if ((parts[0] === "resorts" || parts[0] === "hotels") && parts.length > 2) {
    hint.folderName = parts[1];
  }
  return hint;
}

function guessRole(relativePath, filename) {
  const lower = (relativePath + "/" + filename).toLowerCase();
  if (lower.includes("/maps/") || lower.includes("map")) return "map";
  if (lower.includes("thumb")) return "thumbnail";
  if (lower.includes("hero") || lower.includes("banner") || lower.includes("cover")) return "hero";
  return "gallery";
}

function main() {
  if (!existsSync(RELEASE_DIR)) {
    console.error(`Legacy source not found at ${RELEASE_DIR}.`);
    console.error("Expected the extracted 'webmigration' GitHub Release asset (public_html.rar) at release/public_html.");
    process.exit(1);
  }
  mkdirSync(MEDIA_DATA_DIR, { recursive: true });

  const relativePaths = [];
  walk(RELEASE_DIR, "", relativePaths);
  relativePaths.sort();

  const entities = buildEntityIndex();

  const inventory = [];
  const hashGroups = new Map();
  const filenameGroups = new Map();

  for (const rel of relativePaths) {
    const fullPath = path.join(RELEASE_DIR, rel);
    const ext = path.extname(rel).toLowerCase();
    const filename = path.basename(rel);
    const stat = statSync(fullPath);
    const { width, height } = readDimensions(fullPath, ext);
    const sha1 = sha1Of(fullPath);
    const hint = pathHint(rel);

    const fileTokens = new Set([
      ...distinctiveTokens(filename.replace(ext, "")),
      ...distinctiveTokens(hint.folderName ?? ""),
    ]);

    // Explicit override: atolls/<folder>/... reliably identifies its
    // atoll by folder name alone (see ATOLL_FOLDER_TO_CODE) — this is
    // more trustworthy than any token-overlap score, since a few legacy
    // folder names use different transliteration than our seeded titles
    // (e.g. "alifu-alifu" vs "Alif Alif Atoll") and would otherwise
    // mis-score against an unrelated atoll whose name shares a token.
    const atollFolderMatch =
      rel.startsWith(`atolls${path.sep}`) && parts0(rel) && ATOLL_FOLDER_TO_CODE[parts0(rel)]
        ? entities.find((e) => e.type === "atoll" && e.administrativeCode === ATOLL_FOLDER_TO_CODE[parts0(rel)])
        : null;

    // Score every entity; keep the best few candidates.
    const scored = [];
    for (const entity of entities) {
      let score = tokenOverlapScore(fileTokens, entity.tokens);
      // A strong boost when the resort/hotel FOLDER name itself
      // (not just the filename) closely matches the entity — this is
      // the single strongest signal in the whole dataset (Task 14 §4/§6).
      if (hint.folderName && (entity.type === "resort" || entity.type === "hotel" || entity.type === "guesthouse")) {
        const folderTokens = new Set(distinctiveTokens(hint.folderName));
        const folderScore = tokenOverlapScore(folderTokens, entity.tokens);
        if (folderScore > score) score = Math.min(1, folderScore + 0.2);
      }
      if (score > 0) scored.push({ entity, score });
    }
    // The atoll-folder signal is only a FALLBACK, applied after the fact
    // — if the filename already names a more specific island/resort/etc.
    // within that atoll well enough to stand on its own (>= 0.6), that
    // more precise match should win rather than being out-competed by an
    // artificially boosted atoll score.
    if (atollFolderMatch) {
      const bestSpecific = scored.find((s) => s.entity.type !== "atoll" && s.entity.type !== "country");
      if (!bestSpecific || bestSpecific.score < 0.6) {
        const existing = scored.find((s) => s.entity === atollFolderMatch);
        if (existing) existing.score = Math.max(existing.score, 0.85);
        else scored.push({ entity: atollFolderMatch, score: 0.85 });
      }
    }
    scored.sort((a, b) => b.score - a.score);
    const best = scored[0] ?? null;
    const runnerUp = scored[1] ?? null;

    let confidence = "unmatched";
    if (best) {
      const clearlyBest = !runnerUp || best.score - runnerUp.score >= 0.2;
      if (best.score >= 0.75 && clearlyBest) confidence = "high";
      else if (best.score >= 0.4) confidence = "medium";
      else if (best.score >= 0.15) confidence = "low";
    }

    const record = {
      relativePath: rel.split(path.sep).join("/"),
      filename,
      extension: ext.replace(".", ""),
      sizeBytes: stat.size,
      width,
      height,
      mimeType: MIME_BY_EXT[ext] ?? null,
      sha1,
      tokens: Array.from(fileTokens),
      likelySection: hint.likelySection,
      likelyFolderEntity: hint.folderName,
      probableRole: guessRole(rel, filename),
      match: best
        ? { entityType: best.entity.type, slug: best.entity.slug, title: best.entity.title, href: best.entity.href, score: Number(best.score.toFixed(2)) }
        : null,
      alternateMatch: runnerUp
        ? { entityType: runnerUp.entity.type, slug: runnerUp.entity.slug, title: runnerUp.entity.title, score: Number(runnerUp.score.toFixed(2)) }
        : null,
      confidence,
    };
    inventory.push(record);

    if (sha1) {
      const list = hashGroups.get(sha1) ?? [];
      list.push(record.relativePath);
      hashGroups.set(sha1, list);
    }
    const fnList = filenameGroups.get(filename) ?? [];
    fnList.push(record.relativePath);
    filenameGroups.set(filename, fnList);
  }

  // ── Duplicate report ──
  const exactDuplicates = Array.from(hashGroups.entries())
    .filter(([, paths]) => paths.length > 1)
    .map(([sha1, paths]) => ({ sha1, count: paths.length, paths }));
  const duplicateFilenames = Array.from(filenameGroups.entries())
    .filter(([, paths]) => paths.length > 1)
    .map(([filename, paths]) => ({
      filename,
      count: paths.length,
      paths,
      sameFile: new Set(paths.map((p) => inventory.find((r) => r.relativePath === p)?.sha1)).size === 1,
    }));
  const suspicious = inventory.filter((r) => r.sizeBytes < 1024 || (r.width !== null && r.width < 32));

  writeFileSync(
    path.join(MEDIA_DATA_DIR, "media-duplicates.json"),
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        exactDuplicateGroups: exactDuplicates.length,
        exactDuplicateFiles: exactDuplicates.reduce((sum, g) => sum + g.count - 1, 0),
        duplicateFilenameGroups: duplicateFilenames.length,
        suspiciousFileCount: suspicious.length,
        exactDuplicates,
        duplicateFilenames,
        suspiciousFiles: suspicious.map((r) => ({ relativePath: r.relativePath, sizeBytes: r.sizeBytes, width: r.width, height: r.height })),
      },
      null,
      2,
    ),
  );

  // ── Inventory ──
  writeFileSync(
    path.join(MEDIA_DATA_DIR, "media-inventory.json"),
    JSON.stringify({ generatedAt: new Date().toISOString(), sourceRoot: "release/public_html", totalFiles: inventory.length, files: inventory }, null, 2),
  );

  // ── Match report (summary + review lists) ──
  const byConfidence = { high: [], medium: [], low: [], unmatched: [] };
  for (const r of inventory) byConfidence[r.confidence].push(r);
  const byType = {};
  for (const r of inventory) byType[r.extension] = (byType[r.extension] ?? 0) + 1;

  writeFileSync(
    path.join(MEDIA_DATA_DIR, "media-match-report.json"),
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        totalFiles: inventory.length,
        byExtension: byType,
        counts: {
          high: byConfidence.high.length,
          medium: byConfidence.medium.length,
          low: byConfidence.low.length,
          unmatched: byConfidence.unmatched.length,
        },
        // High-confidence matches are the only ones eligible for automatic
        // attachment (Task 14 §5) — full records so a human can audit them.
        highConfidenceMatches: byConfidence.high.map((r) => ({
          relativePath: r.relativePath,
          entityType: r.match.entityType,
          slug: r.match.slug,
          title: r.match.title,
          href: r.match.href,
          score: r.match.score,
          probableRole: r.probableRole,
        })),
        // Medium/low need human review before attaching (Task 14 §5) — kept
        // as slim rows rather than full records to keep this file readable.
        mediumConfidenceForReview: byConfidence.medium.map((r) => ({
          relativePath: r.relativePath,
          bestGuess: r.match ? `${r.match.entityType}:${r.match.slug} (${r.match.score})` : null,
          alternate: r.alternateMatch ? `${r.alternateMatch.entityType}:${r.alternateMatch.slug} (${r.alternateMatch.score})` : null,
        })),
        lowConfidenceForReview: byConfidence.low.map((r) => ({
          relativePath: r.relativePath,
          bestGuess: r.match ? `${r.match.entityType}:${r.match.slug} (${r.match.score})` : null,
        })),
        unmatchedCount: byConfidence.unmatched.length,
        unmatchedSample: byConfidence.unmatched.slice(0, 50).map((r) => r.relativePath),
      },
      null,
      2,
    ),
  );

  console.log(`Scanned ${inventory.length} media files under release/public_html`);
  console.log(`  high: ${byConfidence.high.length}, medium: ${byConfidence.medium.length}, low: ${byConfidence.low.length}, unmatched: ${byConfidence.unmatched.length}`);
  console.log(`  exact duplicate groups: ${exactDuplicates.length} (${exactDuplicates.reduce((s, g) => s + g.count - 1, 0)} redundant files)`);
  console.log(`Wrote data/maldives/media/{media-inventory,media-match-report,media-duplicates}.json`);

  if (COMMIT) {
    writeCommitMigration(byConfidence.high);
  } else {
    console.log("\n(dry run — pass --commit to also emit a SQL migration for high-confidence matches)");
  }
}

function sqlString(value) {
  if (value === null || value === undefined) return "null";
  return `'${toAsciiSafe(value).replace(/'/g, "''")}'`;
}

/** Storage object path each high-confidence file will live at once
 * scripts/upload-legacy-media.mjs actually uploads it — the SQL migration
 * and the uploader must agree on this exact scheme. */
function storagePathFor(record) {
  return storagePathForRelativePath(record.relativePath);
}

function altTextFor(record) {
  const title = record.match.title;
  const labels = {
    resort: `${title}, Maldives resort`,
    hotel: `${title}, Maldives hotel`,
    guesthouse: `${title}, Maldives guesthouse`,
    island: `${title} Island, Maldives`,
    atoll: `${title}, Maldives`,
    activity: title,
    diving: `${title}, Maldives diving`,
    fishing: `${title}, Maldives fishing`,
    surfing: `${title}, Maldives surfing`,
    dive_site: `${title} dive site, Maldives`,
    surf_break: `${title} surf break, Maldives`,
    package: title,
    transfer_route: title,
  };
  return labels[record.match.entityType] ?? title;
}

function writeCommitMigration(highConfidenceRecords) {
  // One hero (first gallery-ranked candidate) + up to 5 gallery images per
  // entity — never every matched image blindly attached (Task 14 §6).
  const byEntity = new Map();
  for (const r of highConfidenceRecords) {
    const key = `${r.match.entityType}:${r.match.slug}`;
    const list = byEntity.get(key) ?? [];
    list.push(r);
    byEntity.set(key, list);
  }

  const NODE_TYPE_BY_ENTITY_TYPE = {
    resort: "accommodation",
    hotel: "accommodation",
    guesthouse: "accommodation",
    activity: "activity",
    diving: "activity",
    fishing: "activity",
    surfing: "activity",
    dive_site: "location",
    surf_break: "location",
    island: "location",
    atoll: "location",
    package: "package",
    transfer_route: "transfer_route",
  };

  const lines = [];
  lines.push("-- Task 14: high-confidence legacy media attached to existing MTG entities.");
  lines.push("-- GENERATED FILE - do not hand-edit. Regenerate with:");
  lines.push("--   node scripts/import-legacy-media.mjs --commit");
  lines.push("-- Source: data/maldives/media/media-match-report.json (highConfidenceMatches).");
  lines.push("--");
  lines.push("-- media_assets.storage_path values below are where");
  lines.push("-- scripts/upload-legacy-media.mjs uploads the matching local file - run");
  lines.push("-- that script (separately, needs live Supabase Storage access) so these");
  lines.push("-- paths resolve to a real object. Idempotent: media_assets uses a");
  lines.push("-- deterministic id (ON CONFLICT DO NOTHING), node_media uses its own");
  lines.push("-- primary key.");
  lines.push("");

  let entityCount = 0;
  let mediaCount = 0;
  let attachCount = 0;
  const uploadManifest = [];

  for (const [key, records] of byEntity) {
    const [entityType, slug] = key.split(":");
    const nodeType = NODE_TYPE_BY_ENTITY_TYPE[entityType];
    if (!nodeType) continue;

    // Rank: hero-guessed first, then gallery, cap at 6 total per entity.
    const ranked = [...records].sort((a, b) => (a.probableRole === "hero" ? -1 : 0) - (b.probableRole === "hero" ? -1 : 0));
    const selected = ranked.slice(0, 6);
    entityCount += 1;

    selected.forEach((r, index) => {
      const mediaKey = `legacy-media::${r.relativePath}`;
      const mediaId = deterministicUuid(mediaKey);
      const storagePath = storagePathFor(r);
      const role = index === 0 ? "hero" : "gallery";
      const alt = altTextFor(r);

      // Each statement is emitted as ONE line (never split across several
      // lines.push calls) — a multi-line statement pasted into the
      // Supabase SQL Editor can end up submitted to Postgres split apart
      // (observed: "on conflict ..." arriving as its own query), which is
      // invalid standalone SQL even though the full statement is valid.
      // One line per statement is immune to that regardless of cause.
      lines.push(
        `insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values (${sqlString(mediaId)}::uuid, 'image', ${sqlString(storagePath)}, ${sqlString(alt)}, ${sqlString("Legacy MTG site archive")}, ${r.width ?? "null"}, ${r.height ?? "null"}) on conflict (id) do nothing;`,
      );
      lines.push("");
      mediaCount += 1;
      uploadManifest.push({ mediaId, relativePath: r.relativePath, storagePath });

      lines.push(
        `insert into node_media (node_id, media_id, role, sort_order) select n.id, ${sqlString(mediaId)}::uuid, ${sqlString(role)}, ${index} from nodes n where n.node_type = ${sqlString(nodeType)} and n.slug = ${sqlString(slug)} on conflict (node_id, media_id, role) do nothing;`,
      );
      lines.push("");
      attachCount += 1;
    });
  }

  const migrationPath = path.join(ROOT, "supabase", "migrations", "20250110000200_legacy_media_attachments.sql");
  writeFileSync(migrationPath, lines.join("\n") + "\n");
  console.log(`\nWrote ${migrationPath}`);
  console.log(`  entities matched: ${entityCount}, media_assets rows: ${mediaCount}, node_media attachments: ${attachCount}`);

  // The exact list of physical files this migration's media_assets rows
  // reference — scripts/upload-legacy-media.mjs uploads precisely this set
  // (and the equivalent article-storage-manifest.json), never a broader
  // guess, so "files uploaded" and "DB rows referencing them" can't drift.
  const manifestPath = path.join(MEDIA_DATA_DIR, "media-storage-manifest.json");
  writeFileSync(manifestPath, JSON.stringify({ generatedAt: new Date().toISOString(), files: uploadManifest }, null, 2));
  console.log(`  Wrote ${path.relative(ROOT, manifestPath)} (${uploadManifest.length} files)`);
  console.log(`  Run scripts/upload-legacy-media.mjs to actually upload the matching files to Storage.`);
}

main();
