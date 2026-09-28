#!/usr/bin/env node
// Matches the owner's second big batch of uploaded photos
// (assets/uploads/{activities,article,articles,atoll,atolls,attractions,
// central,destinations,diving,resorts,resorts2}/, ~798 files) to real
// entities that currently have NO hero image at all — see
// data/maldives/media/hero-coverage-baseline.json, a snapshot of real
// node_media hero coverage taken directly from a full local-Postgres
// migration replay (355/379 islands, 19/21 atolls, 9/155 accommodations,
// 5/13 surf breaks, 4/41 articles, 1/17 attractions had zero hero image
// before this script — a real, large, pre-existing gap, not something
// this batch of uploads created).
//
// Matching strategy (never fabricated — every match is a real token/name
// overlap, nothing is force-assigned):
//   - Filenames often carry a real signal: either an atoll-code-ish
//     lowercase prefix before a Capitalized island name
//     ("meemu-Dhiggaru-maldives.jpg"), or a proper-noun-heavy resort/place
//     name ("Adaaran-Club-Rannalhi.jpg"), or an atoll's own name directly
//     ("noonu-atoll-maldives.jpg").
//   - Islands: parse a leading lowercase atoll-signal (mapped through
//     ATOLL_ALIAS_TOKENS, which also covers real colloquial names —
//     "Ari Atoll" for Alif Alif/Alif Dhaalu, "Male Atoll" for Kaafu) to
//     narrow the candidate list to that one atoll's islands, then score
//     the remaining filename tokens against each candidate island's title
//     via the existing distinctiveTokens()/tokenOverlapScore() (same
//     functions every other Task 14+ matching script in this repo uses).
//     Falls back to a stricter global (cross-atoll) match only when no
//     atoll signal parses.
//   - Atolls: matched only when the filename explicitly names that atoll
//     (directly or via a real colloquial alias) — never inferred from an
//     unrelated island/resort photo.
//   - Accommodations/surf breaks/articles/attractions: token-overlap
//     against title, same threshold discipline as every other script.
//   - "-300x300" WordPress thumbnail crops are skipped whenever a
//     full-size sibling exists anywhere in the pool (never used as a hero
//     when a better version is available).
//   - One file becomes at most one entity's hero; leftover confidently-
//     matched files for an already-covered entity are added as gallery
//     (capped) instead of being discarded, so "use all of these images"
//     doesn't mean guessing on weak matches — it means every confident
//     match gets used somewhere, and everything else is reported, never
//     force-placed.
//
// Usage:
//   node scripts/attach-round2-uploads.mjs --report     (default; prints matches, writes nothing)
//   node scripts/attach-round2-uploads.mjs --commit      (writes migration + manifest + missing-images report)

import { existsSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, deterministicUuid, distinctiveTokens, ROOT, toAsciiSafe, tokenOverlapScore } from "./lib/legacy-shared.mjs";

const COMMIT = process.argv.includes("--commit");
const UPLOADS_ROOT = path.join(ROOT, "assets", "uploads");
const IMAGE_EXT = new Set([".webp", ".jpg", ".jpeg", ".png", ".avif"]);
const POOL_DIRS = ["activities", "article", "articles", "atoll", "atolls", "attractions", "central", "destinations", "diving", "resorts", "resorts2"];

const ISLAND_SCORE_THRESHOLD_SAME_ATOLL = 0.5;
const ISLAND_SCORE_THRESHOLD_GLOBAL = 0.75;
const GENERIC_SCORE_THRESHOLD = 0.6;

// Generic tourism/activity words that are common enough across this
// upload batch's filenames that a lone-token "full containment" match
// (tokenOverlapScore's 0.7 floor when an entity's ENTIRE distinctive-token
// set is a single word) would be false confidence, not a real match —
// caught concretely: "Go Surf Maldives" (-> just "surf" once "maldives"
// and the length<=2 "go" are stripped) matched an unrelated generic
// "best surf spots" article photo. Genuine single-token entity names that
// are actual distinctive proper nouns (e.g. "Rihiveli", "Honky's",
// "Castaways" — all real place/surf-break names, not common words) are
// NOT on this list and still match normally.
const GENERIC_SINGLE_TOKEN_DENYLIST = new Set([
  "surf", "surfing", "beach", "diving", "dive", "fishing", "resort", "hotel",
  "spa", "island", "atoll", "view", "pool", "villa", "water", "sunset",
  "tour", "boat", "reef", "snorkel", "snorkeling",
]);

function isTrustworthyEntityTokenSet(tokens) {
  if (tokens.size === 0) return false;
  if (tokens.size >= 2) return true;
  const [only] = tokens;
  return !GENERIC_SINGLE_TOKEN_DENYLIST.has(only);
}
const MAX_GALLERY_EXTRA = 3;

// Real colloquial/administrative atoll names, including the marketing
// names ("Ari Atoll", "Male Atoll", "North/South Ari/Male") that show up
// constantly in resort/dive-site filenames but aren't this project's own
// atoll node titles — every one of these genuinely refers to the atoll
// code it's mapped to (verified against Maldives administrative geography,
// same convention as legacy-shared.mjs's ATOLL_FOLDER_TO_CODE).
const ATOLL_ALIAS_TOKENS = {
  "alif-alif": "AA", "north-ari": "AA", "ari": "AA",
  "alif-dhaalu": "ADh", "south-ari": "ADh",
  baa: "B",
  dhaalu: "Dh",
  faafu: "F",
  "gaafu-alifu": "GA", "gaafu-alif": "GA",
  "gaafu-dhaalu": "GDh",
  gnaviyani: "Gn", fuvahmulah: "Gn",
  "haa-alifu": "HA", "haa-alif": "HA",
  "haa-dhaalu": "HDh",
  kaafu: "K", "north-male": "K", "south-male": "K", male: "K",
  laamu: "L",
  lhaviyani: "Lh",
  meemu: "M",
  noonu: "N",
  raa: "R",
  seenu: "S", addu: "S",
  shaviyani: "Sh",
  thaa: "Th",
  vaavu: "V",
};

function tokenSet(input) {
  return new Set(distinctiveTokens(input));
}

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

function altTextFor(filename) {
  const base = filename.replace(/\.[^.]+$/, "").replace(/[​-‍﻿]/g, "");
  const cleaned = base.replace(/-\d+x\d+$/, "").replace(/[-_()]+/g, " ").replace(/\s+/g, " ").trim();
  return cleaned || "Maldives";
}

/** Parses a leading run of lowercase, hyphen-joined tokens as an atoll
 * signal (e.g. "gaafu-dhaalu" from "gaafu-dhaalu-Thinadhoo-maldives.jpg"),
 * checked longest-alias-first so "gaafu-dhaalu" wins over a bare "gaafu"
 * partial. Returns null when no alias matches — never guesses. */
function parseAtollSignal(baseName) {
  // Case-insensitive on purpose: this project's filenames mix
  // lowercase-prefixed ("meemu-Dhiggaru-maldives.jpg") and Title-Case
  // ("South-Male-Atoll.webp", "Baa-Atoll-Maldives.webp") conventions for
  // the exact same kind of atoll-code signal — checking only strictly-
  // lowercase tokens would silently miss every Title-Case one. Scans
  // every starting position (not just the very first token), since some
  // real files put a brand name first ("LUX-South-Ari-Atoll-...webp").
  const tokens = baseName
    .split(/[-_\s]+/)
    .filter(Boolean)
    .filter((t) => /^[a-zA-Z]+$/.test(t))
    .map((t) => t.toLowerCase());
  for (let start = 0; start < tokens.length; start += 1) {
    for (let len = Math.min(3, tokens.length - start); len >= 1; len -= 1) {
      const candidate = tokens.slice(start, start + len).join("-");
      if (ATOLL_ALIAS_TOKENS[candidate]) return ATOLL_ALIAS_TOKENS[candidate];
    }
  }
  return null;
}

function listPoolFiles() {
  const files = [];
  for (const dir of POOL_DIRS) {
    const full = path.join(UPLOADS_ROOT, dir);
    if (!existsSync(full)) continue;
    for (const filename of readdirSync(full)) {
      if (!IMAGE_EXT.has(path.extname(filename).toLowerCase())) continue;
      files.push({ dir, filename, relativePath: `assets/uploads/${dir}/${filename}`, absPath: path.join(full, filename) });
    }
  }
  return files;
}

/** Drops a "-300x300"-style thumbnail whenever a full-size sibling (same
 * base name, no size suffix) exists anywhere in the whole pool. */
function filterThumbnails(files) {
  const fullSizeBases = new Set();
  for (const f of files) {
    const base = f.filename.replace(/\.[^.]+$/, "");
    if (!/-\d+x\d+$/.test(base)) fullSizeBases.add(base.toLowerCase());
  }
  return files.filter((f) => {
    const base = f.filename.replace(/\.[^.]+$/, "");
    const m = base.match(/^(.*)-\d+x\d+$/);
    if (!m) return true;
    return !fullSizeBases.has(m[1].toLowerCase());
  });
}

function main() {
  const baseline = JSON.parse(readFileSync(path.join(DATA_DIR, "media", "hero-coverage-baseline.json"), "utf8"));

  let files = listPoolFiles();
  const totalBeforeDedup = files.length;
  files = filterThumbnails(files);
  console.log(`Pool: ${totalBeforeDedup} files across ${POOL_DIRS.length} folders, ${files.length} after dropping thumbnails with a full-size sibling.`);

  const candidates = files.map((f) => {
    const base = f.filename.replace(/\.[^.]+$/, "").replace(/[​-‍﻿]/g, "");
    return { ...f, base, tokens: tokenSet(base), atollSignal: parseAtollSignal(base) };
  });
  const usedRelativePaths = new Set();

  // ---- Islands ----
  const missingIslands = baseline.islands.filter((i) => !i.hasHero);
  const islandMatches = new Map(); // slug -> {file, score}
  for (const cand of candidates) {
    if (usedRelativePaths.has(cand.relativePath)) continue;
    let pool = missingIslands;
    let threshold = ISLAND_SCORE_THRESHOLD_GLOBAL;
    if (cand.atollSignal) {
      pool = missingIslands.filter((i) => i.atollCode === cand.atollSignal);
      threshold = ISLAND_SCORE_THRESHOLD_SAME_ATOLL;
    }
    let best = null;
    for (const island of pool) {
      const score = tokenOverlapScore(cand.tokens, tokenSet(island.title));
      if (score >= threshold && (!best || score > best.score)) best = { island, score };
    }
    if (best && (!islandMatches.has(best.island.slug) || islandMatches.get(best.island.slug).score < best.score)) {
      islandMatches.set(best.island.slug, { file: cand, score: best.score });
    }
  }
  for (const { file } of islandMatches.values()) usedRelativePaths.add(file.relativePath);

  // ---- Atolls ----
  const missingAtolls = baseline.atolls.filter((a) => !a.hasHero);
  const atollMatches = new Map();
  for (const cand of candidates) {
    if (usedRelativePaths.has(cand.relativePath)) continue;
    if (!cand.atollSignal) continue;
    const atoll = missingAtolls.find((a) => a.atollCode === cand.atollSignal);
    if (!atoll) continue;
    // Prefer a file that explicitly names the atoll itself (contains
    // "atoll" before thumbnail-stripping) over an arbitrary island/resort
    // photo that merely carries the right atoll-code prefix; among
    // multiple explicit matches, prefer the fewest extra tokens (a clean
    // "South-Male-Atoll.webp" over a specific dive-site-named
    // "Male-Atoll-Nassimo-Thila-Maldives.webp" — both real, but the
    // shorter one reads as a genuine atoll-level photo, not one specific
    // place within it).
    const explicit = /atoll/i.test(cand.base);
    const existing = atollMatches.get(atoll.slug);
    const better =
      !existing ||
      (explicit && !existing.explicit) ||
      (explicit === existing.explicit && cand.tokens.size < existing.file.tokens.size);
    if (better) {
      atollMatches.set(atoll.slug, { file: cand, explicit });
    }
  }
  for (const { file } of atollMatches.values()) usedRelativePaths.add(file.relativePath);

  // ---- Generic (accommodations, surf breaks, articles, attractions) ----
  function matchGeneric(entities) {
    // See isTrustworthyEntityTokenSet()'s comment — excludes only the
    // dangerous case (a generic single-word residual token), not every
    // single-token entity.
    const missing = entities.filter((e) => !e.hasHero && isTrustworthyEntityTokenSet(tokenSet(e.title)));
    const matches = new Map();
    for (const cand of candidates) {
      if (usedRelativePaths.has(cand.relativePath)) continue;
      let best = null;
      for (const entity of missing) {
        const score = tokenOverlapScore(cand.tokens, tokenSet(entity.title));
        if (score >= GENERIC_SCORE_THRESHOLD && (!best || score > best.score)) best = { entity, score };
      }
      if (best && (!matches.has(best.entity.slug) || matches.get(best.entity.slug).score < best.score)) {
        matches.set(best.entity.slug, { file: cand, score: best.score });
      }
    }
    for (const { file } of matches.values()) usedRelativePaths.add(file.relativePath);
    return matches;
  }
  const accommodationMatches = matchGeneric(baseline.accommodations);
  const surfBreakMatches = matchGeneric(baseline.surfBreaks);
  const articleMatches = matchGeneric(baseline.articles);
  const attractionMatches = matchGeneric(baseline.attractions);

  // ---- Gallery pass: confidently-matched leftovers for ALREADY-covered
  // accommodations/islands (so "use all of these images" doesn't just
  // mean "fill gaps" — real extra photos of a place we already show
  // still get used, capped, as gallery, never overwriting the hero). ----
  const galleryAdds = []; // {nodeType, slug, file}
  const galleryCountBySlug = new Map();
  const coveredAccommodations = baseline.accommodations.filter((a) => a.hasHero && isTrustworthyEntityTokenSet(tokenSet(a.title)));
  const coveredIslands = baseline.islands.filter((i) => i.hasHero);
  for (const cand of candidates) {
    if (usedRelativePaths.has(cand.relativePath)) continue;
    let best = null;
    for (const acc of coveredAccommodations) {
      const score = tokenOverlapScore(cand.tokens, tokenSet(acc.title));
      if (score >= GENERIC_SCORE_THRESHOLD && (!best || score > best.score)) best = { type: "accommodation", entity: acc, score };
    }
    let pool = cand.atollSignal ? coveredIslands.filter((i) => i.atollCode === cand.atollSignal) : [];
    for (const isl of pool) {
      const score = tokenOverlapScore(cand.tokens, tokenSet(isl.title));
      const thr = ISLAND_SCORE_THRESHOLD_SAME_ATOLL;
      if (score >= thr && (!best || score > best.score)) best = { type: "island", entity: isl, score };
    }
    if (!best) continue;
    const key = `${best.type}:${best.entity.slug}`;
    const count = galleryCountBySlug.get(key) ?? 0;
    if (count >= MAX_GALLERY_EXTRA) continue;
    galleryCountBySlug.set(key, count + 1);
    galleryAdds.push({ nodeType: best.type, slug: best.entity.slug, file: cand });
    usedRelativePaths.add(cand.relativePath);
  }

  // ---- Report ----
  console.log(`\nIslands matched: ${islandMatches.size} / ${missingIslands.length} missing`);
  console.log(`Atolls matched: ${atollMatches.size} / ${missingAtolls.length} missing`);
  console.log(`Accommodations matched: ${accommodationMatches.size} / ${baseline.accommodations.filter((a) => !a.hasHero).length} missing`);
  console.log(`Surf breaks matched: ${surfBreakMatches.size} / ${baseline.surfBreaks.filter((s) => !s.hasHero).length} missing`);
  console.log(`Articles matched: ${articleMatches.size} / ${baseline.articles.filter((a) => !a.hasHero).length} missing`);
  console.log(`Attractions matched: ${attractionMatches.size} / ${baseline.attractions.filter((a) => !a.hasHero).length} missing`);
  console.log(`Gallery-only extra matches (already-covered entities): ${galleryAdds.length}`);
  console.log(`Total files used: ${usedRelativePaths.size} / ${candidates.length}`);
  console.log(`Unmatched leftover files: ${candidates.length - usedRelativePaths.size}`);

  if (process.argv.includes("--verbose")) {
    console.log("\n--- Atoll matches ---");
    for (const [slug, { file, explicit }] of atollMatches) console.log(`  ${slug} <- ${file.relativePath}${explicit ? "" : " (island/resort photo, no explicit atoll match)"}`);
    console.log("\n--- Island matches (first 40) ---");
    let i = 0;
    for (const [slug, { file, score }] of islandMatches) {
      if (i++ >= 40) break;
      console.log(`  ${slug} <- ${file.relativePath} (score ${score.toFixed(2)})`);
    }
    console.log("\n--- Accommodation matches ---");
    for (const [slug, { file, score }] of accommodationMatches) console.log(`  ${slug} <- ${file.relativePath} (score ${score.toFixed(2)})`);
    console.log("\n--- Surf break matches ---");
    for (const [slug, { file, score }] of surfBreakMatches) console.log(`  ${slug} <- ${file.relativePath} (score ${score.toFixed(2)})`);
    console.log("\n--- Article matches ---");
    for (const [slug, { file, score }] of articleMatches) console.log(`  ${slug} <- ${file.relativePath} (score ${score.toFixed(2)})`);
    console.log("\n--- Attraction matches ---");
    for (const [slug, { file, score }] of attractionMatches) console.log(`  ${slug} <- ${file.relativePath} (score ${score.toFixed(2)})`);
  }

  if (!COMMIT) {
    console.log(`\n(report mode — pass --commit to write the migration/manifest/report; --verbose to see every match)`);
    return;
  }

  // ---- Generate SQL + manifest ----
  const manifest = [];
  const lines = [];
  lines.push("-- Round 2 owner-uploaded photos (activities/article(s)/atoll(s)/");
  lines.push("-- attractions/central/destinations/diving/resorts(2)/) matched to real");
  lines.push("-- entities that had zero hero image before this file, per a full local-");
  lines.push("-- Postgres coverage snapshot (data/maldives/media/hero-coverage-baseline.json).");
  lines.push("-- GENERATED FILE, regenerate with:");
  lines.push("--   node scripts/attach-round2-uploads.mjs --commit");
  lines.push("");

  function registerFile(cand) {
    const mediaId = deterministicUuid(`uploaded-media::${cand.relativePath}`);
    const storagePath = storagePathForUpload(cand.relativePath);
    const altText = altTextFor(cand.filename);
    manifest.push({ mediaId, relativePath: cand.relativePath, storagePath, altText });
    lines.push(
      `insert into media_assets (id, media_type, storage_path, alt_text) values (${sqlString(mediaId)}, 'image', ${sqlString(storagePath)}, ${sqlString(altText)}) on conflict (id) do nothing;`,
    );
    return mediaId;
  }

  function attachHero(nodeType, slug, cand) {
    const mediaId = registerFile(cand);
    lines.push(`insert into node_media (node_id, media_id, role, sort_order) select id, ${sqlString(mediaId)}, 'hero', 0 from nodes where node_type = ${sqlString(nodeType)} and slug = ${sqlString(slug)} on conflict (node_id, media_id, role) do nothing;`);
  }

  lines.push("-- Islands");
  for (const [slug, { file }] of islandMatches) attachHero("location", slug, file);
  lines.push("");
  lines.push("-- Atolls");
  for (const [slug, { file }] of atollMatches) attachHero("location", slug, file);
  lines.push("");
  lines.push("-- Accommodations");
  for (const [slug, { file }] of accommodationMatches) attachHero("accommodation", slug, file);
  lines.push("");
  lines.push("-- Surf breaks");
  for (const [slug, { file }] of surfBreakMatches) attachHero("location", slug, file);
  lines.push("");
  lines.push("-- Articles");
  for (const [slug, { file }] of articleMatches) attachHero("article", slug, file);
  lines.push("");
  lines.push("-- Attractions");
  for (const [slug, { file }] of attractionMatches) attachHero("location", slug, file);
  lines.push("");

  lines.push("-- Gallery-only extras for already-covered entities");
  const gallerySortCounters = new Map();
  for (const add of galleryAdds) {
    const mediaId = registerFile(add.file);
    const nodeType = add.nodeType === "island" ? "location" : add.nodeType;
    const counterKey = `${nodeType}:${add.slug}`;
    const sortOrder = (gallerySortCounters.get(counterKey) ?? 0) + 1;
    gallerySortCounters.set(counterKey, sortOrder);
    lines.push(
      `insert into node_media (node_id, media_id, role, sort_order) select id, ${sqlString(mediaId)}, 'gallery', ${sortOrder} from nodes where node_type = ${sqlString(nodeType)} and slug = ${sqlString(add.slug)} on conflict (node_id, media_id, role) do nothing;`,
    );
  }
  lines.push("");

  const outPath = path.join(ROOT, "supabase", "migrations", "20250125000100_round2_uploads_media.sql");
  writeFileSync(outPath, lines.join("\n") + "\n");
  console.log(`\nWrote ${path.relative(ROOT, outPath)}`);

  const manifestPath = path.join(DATA_DIR, "migration", "round2-uploads-manifest.json");
  writeFileSync(manifestPath, JSON.stringify({ generatedAt: new Date().toISOString(), files: manifest }, null, 2));
  console.log(`Wrote ${path.relative(ROOT, manifestPath)} (${manifest.length} files)`);

  // ---- Still-missing report ----
  const stillMissing = { islands: [], atolls: [], accommodations: [], surfBreaks: [], articles: [], attractions: [] };
  for (const i of missingIslands) if (!islandMatches.has(i.slug)) stillMissing.islands.push(i);
  for (const a of missingAtolls) if (!atollMatches.has(a.slug)) stillMissing.atolls.push(a);
  for (const a of baseline.accommodations) if (!a.hasHero && !accommodationMatches.has(a.slug)) stillMissing.accommodations.push(a);
  for (const s of baseline.surfBreaks) if (!s.hasHero && !surfBreakMatches.has(s.slug)) stillMissing.surfBreaks.push(s);
  for (const a of baseline.articles) if (!a.hasHero && !articleMatches.has(a.slug)) stillMissing.articles.push(a);
  for (const a of baseline.attractions) if (!a.hasHero && !attractionMatches.has(a.slug)) stillMissing.attractions.push(a);

  const unmatchedFiles = candidates.filter((c) => !usedRelativePaths.has(c.relativePath)).map((c) => c.relativePath);

  const reportPath = path.join(DATA_DIR, "media", "round2-still-missing-images.json");
  writeFileSync(
    reportPath,
    JSON.stringify({ generatedAt: new Date().toISOString(), stillMissing, unmatchedUploadedFiles: unmatchedFiles }, null, 2),
  );
  console.log(`Wrote ${path.relative(ROOT, reportPath)}`);
  console.log(
    `\nStill missing after this pass: ${stillMissing.islands.length} islands, ${stillMissing.atolls.length} atolls, ${stillMissing.accommodations.length} accommodations, ${stillMissing.surfBreaks.length} surf breaks, ${stillMissing.articles.length} articles, ${stillMissing.attractions.length} attractions.`,
  );
  console.log(`${unmatchedFiles.length} uploaded files were not confidently matched to anything.`);
}

main();
