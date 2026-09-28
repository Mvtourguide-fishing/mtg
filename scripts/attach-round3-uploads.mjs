#!/usr/bin/env node
// Matches the owner's third batch of uploaded photos
// (assets/uploads/{north,south}/, ~194 files) to real entities that were
// STILL missing a hero image after round 2 — see
// data/maldives/media/round2-still-missing-images.json, which is round 2's
// own "still missing" output and is therefore already accurate against the
// current database (round 2's migration has been applied), unlike the
// original hero-coverage-baseline.json snapshot which predates it.
//
// Same matching strategy as scripts/attach-round2-uploads.mjs (never
// fabricated — every match is a real token/name overlap): atoll-signal
// parsing for islands/atolls, token-overlap scoring for everything else,
// thumbnail filtering, and a gallery pass for already-covered entities.
// See that file's header comment for the full rationale; kept as a
// separate script (rather than parameterizing round 2's) so each batch's
// inputs/outputs stay independently reproducible and diffable.
//
// Usage:
//   node scripts/attach-round3-uploads.mjs --report     (default; prints matches, writes nothing)
//   node scripts/attach-round3-uploads.mjs --commit      (writes migration + manifest + missing-images report)

import { existsSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, deterministicUuid, distinctiveTokens, ROOT, toAsciiSafe, tokenOverlapScore } from "./lib/legacy-shared.mjs";

const COMMIT = process.argv.includes("--commit");
const UPLOADS_ROOT = path.join(ROOT, "assets", "uploads");
const IMAGE_EXT = new Set([".webp", ".jpg", ".jpeg", ".png", ".avif"]);
const POOL_DIRS = ["north", "south"];

const ISLAND_SCORE_THRESHOLD_SAME_ATOLL = 0.5;
const ISLAND_SCORE_THRESHOLD_GLOBAL = 0.75;
const GENERIC_SCORE_THRESHOLD = 0.6;

// See attach-round2-uploads.mjs for the concrete false-positive this
// guards against ("Go Surf Maldives" <- an unrelated "best surf spots"
// photo). Real single-token proper-noun entity names are unaffected.
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

// Same real colloquial/administrative atoll alias table as round 2, plus
// entries this batch's own filenames need: the official Dhivehi-style
// spelling "Alifu Alifu" / "Alifu Dhaalu" (trailing "u" on the first word
// too, unlike round 2's "Alif Alif" / "Alif Dhaalu" files), and the bare
// short codes "ba" and "hdh" this batch uses as a standalone token
// (e.g. "ba-Dhonfanu-island.jpg", "hdh-naavaidhoo-island.jpg") alongside
// the full "baa"/"haa-dhaalu" words round 2's files used instead.
const ATOLL_ALIAS_TOKENS = {
  "alif-alif": "AA", "alifu-alifu": "AA", "north-ari": "AA", "ari": "AA",
  "alif-dhaalu": "ADh", "alifu-dhaalu": "ADh", "south-ari": "ADh",
  baa: "B", ba: "B",
  dhaalu: "Dh",
  faafu: "F",
  "gaafu-alifu": "GA", "gaafu-alif": "GA",
  "gaafu-dhaalu": "GDh",
  gnaviyani: "Gn", fuvahmulah: "Gn",
  "haa-alifu": "HA", "haa-alif": "HA",
  "haa-dhaalu": "HDh", hdh: "HDh",
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

function parseAtollSignal(baseName) {
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

/** round2-still-missing-images.json's stillMissing lists are already
 * pre-filtered to "no hero as of round 2" — every entry in them is, by
 * construction, missing. Normalize to the {hasHero:false, ...} shape the
 * shared matching logic below expects, so it reads identically to round
 * 2's hero-coverage-baseline.json filter (`!hasHero`). */
function loadStillMissingAsBaseline() {
  const raw = JSON.parse(readFileSync(path.join(DATA_DIR, "media", "round2-still-missing-images.json"), "utf8"));
  const sm = raw.stillMissing;
  const withHasHeroFalse = (arr) => arr.map((e) => ({ ...e, hasHero: false }));
  return {
    islands: withHasHeroFalse(sm.islands),
    atolls: withHasHeroFalse(sm.atolls),
    accommodations: withHasHeroFalse(sm.accommodations),
    surfBreaks: withHasHeroFalse(sm.surfBreaks),
    articles: withHasHeroFalse(sm.articles),
    attractions: withHasHeroFalse(sm.attractions),
  };
}

function main() {
  const baseline = loadStillMissingAsBaseline();

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
  const missingIslands = baseline.islands;
  const islandMatches = new Map();
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
  const missingAtolls = baseline.atolls;
  const atollMatches = new Map();
  for (const cand of candidates) {
    if (usedRelativePaths.has(cand.relativePath)) continue;
    if (!cand.atollSignal) continue;
    const atoll = missingAtolls.find((a) => a.atollCode === cand.atollSignal);
    if (!atoll) continue;
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
    const missing = entities.filter((e) => isTrustworthyEntityTokenSet(tokenSet(e.title)));
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

  // ---- Gallery pass for already-covered entities. "Already-covered" now
  // means "not in round 2's still-missing list" — we don't have a full
  // hasHero snapshot post-round-2, so this pass is intentionally narrower
  // than round 2's: only islands/accommodations round 2 itself just
  // matched are treated as covered (real, current information), rather
  // than re-reading the stale pre-round-2 baseline. ----
  const galleryAdds = [];
  const galleryCountBySlug = new Map();
  let coveredAccommodations = [];
  let coveredIslands = [];
  let coveredAtolls = [];
  try {
    const round2Manifest = JSON.parse(readFileSync(path.join(DATA_DIR, "media", "hero-coverage-baseline.json"), "utf8"));
    const stillMissingSlugs = {
      islands: new Set(baseline.islands.map((i) => i.slug)),
      accommodations: new Set(baseline.accommodations.map((a) => a.slug)),
      atolls: new Set(baseline.atolls.map((a) => a.slug)),
    };
    coveredAccommodations = round2Manifest.accommodations.filter(
      (a) => !stillMissingSlugs.accommodations.has(a.slug) && isTrustworthyEntityTokenSet(tokenSet(a.title)),
    );
    coveredIslands = round2Manifest.islands.filter((i) => !stillMissingSlugs.islands.has(i.slug));
    coveredAtolls = round2Manifest.atolls.filter((a) => !stillMissingSlugs.atolls.has(a.slug));
  } catch {
    // hero-coverage-baseline.json missing — skip the gallery pass rather
    // than guess at coverage.
  }
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
    // Only an explicit atoll-named photo ("...-atoll-maldives.jpg") is
    // trusted here — an arbitrary island/resort photo that merely carries
    // the right atoll-code prefix isn't a genuine atoll-level gallery
    // photo (same "explicit" discipline as the hero-atoll pass above).
    if (cand.atollSignal && /atoll/i.test(cand.base)) {
      const atoll = coveredAtolls.find((a) => a.atollCode === cand.atollSignal);
      if (atoll && (!best || 1 > best.score)) best = { type: "atoll", entity: atoll, score: 1 };
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
  console.log(`Accommodations matched: ${accommodationMatches.size} / ${baseline.accommodations.length} missing`);
  console.log(`Surf breaks matched: ${surfBreakMatches.size} / ${baseline.surfBreaks.length} missing`);
  console.log(`Articles matched: ${articleMatches.size} / ${baseline.articles.length} missing`);
  console.log(`Attractions matched: ${attractionMatches.size} / ${baseline.attractions.length} missing`);
  console.log(`Gallery-only extra matches (already-covered entities): ${galleryAdds.length}`);
  console.log(`Total files used: ${usedRelativePaths.size} / ${candidates.length}`);
  console.log(`Unmatched leftover files: ${candidates.length - usedRelativePaths.size}`);

  if (process.argv.includes("--verbose")) {
    console.log("\n--- Atoll matches ---");
    for (const [slug, { file, explicit }] of atollMatches) console.log(`  ${slug} <- ${file.relativePath}${explicit ? "" : " (island/resort photo, no explicit atoll match)"}`);
    console.log("\n--- Island matches ---");
    for (const [slug, { file, score }] of islandMatches) console.log(`  ${slug} <- ${file.relativePath} (score ${score.toFixed(2)})`);
    console.log("\n--- Accommodation matches ---");
    for (const [slug, { file, score }] of accommodationMatches) console.log(`  ${slug} <- ${file.relativePath} (score ${score.toFixed(2)})`);
    console.log("\n--- Surf break matches ---");
    for (const [slug, { file, score }] of surfBreakMatches) console.log(`  ${slug} <- ${file.relativePath} (score ${score.toFixed(2)})`);
    console.log("\n--- Article matches ---");
    for (const [slug, { file, score }] of articleMatches) console.log(`  ${slug} <- ${file.relativePath} (score ${score.toFixed(2)})`);
    console.log("\n--- Attraction matches ---");
    for (const [slug, { file, score }] of attractionMatches) console.log(`  ${slug} <- ${file.relativePath} (score ${score.toFixed(2)})`);
    console.log("\n--- Unmatched files ---");
    for (const c of candidates) if (!usedRelativePaths.has(c.relativePath)) console.log(`  ${c.relativePath}`);
  }

  if (!COMMIT) {
    console.log(`\n(report mode — pass --commit to write the migration/manifest/report; --verbose to see every match)`);
    return;
  }

  // ---- Generate SQL + manifest ----
  const manifest = [];
  const lines = [];
  lines.push("-- Round 3 owner-uploaded photos (assets/uploads/{north,south}/) matched");
  lines.push("-- to real entities that were still missing a hero image after round 2");
  lines.push("-- (data/maldives/media/round2-still-missing-images.json).");
  lines.push("-- GENERATED FILE, regenerate with:");
  lines.push("--   node scripts/attach-round3-uploads.mjs --commit");
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
    const nodeType = add.nodeType === "island" || add.nodeType === "atoll" ? "location" : add.nodeType;
    const counterKey = `${nodeType}:${add.slug}`;
    const sortOrder = (gallerySortCounters.get(counterKey) ?? 0) + 1;
    gallerySortCounters.set(counterKey, sortOrder);
    lines.push(
      `insert into node_media (node_id, media_id, role, sort_order) select id, ${sqlString(mediaId)}, 'gallery', ${sortOrder} from nodes where node_type = ${sqlString(nodeType)} and slug = ${sqlString(add.slug)} on conflict (node_id, media_id, role) do nothing;`,
    );
  }
  lines.push("");

  const outPath = path.join(ROOT, "supabase", "migrations", "20250125000200_round3_uploads_media.sql");
  writeFileSync(outPath, lines.join("\n") + "\n");
  console.log(`\nWrote ${path.relative(ROOT, outPath)}`);

  const manifestPath = path.join(DATA_DIR, "migration", "round3-uploads-manifest.json");
  writeFileSync(manifestPath, JSON.stringify({ generatedAt: new Date().toISOString(), files: manifest }, null, 2));
  console.log(`Wrote ${path.relative(ROOT, manifestPath)} (${manifest.length} files)`);

  // ---- Still-missing report ----
  const stillMissing = { islands: [], atolls: [], accommodations: [], surfBreaks: [], articles: [], attractions: [] };
  for (const i of missingIslands) if (!islandMatches.has(i.slug)) stillMissing.islands.push(i);
  for (const a of missingAtolls) if (!atollMatches.has(a.slug)) stillMissing.atolls.push(a);
  for (const a of baseline.accommodations) if (!accommodationMatches.has(a.slug)) stillMissing.accommodations.push(a);
  for (const s of baseline.surfBreaks) if (!surfBreakMatches.has(s.slug)) stillMissing.surfBreaks.push(s);
  for (const a of baseline.articles) if (!articleMatches.has(a.slug)) stillMissing.articles.push(a);
  for (const a of baseline.attractions) if (!attractionMatches.has(a.slug)) stillMissing.attractions.push(a);

  const unmatchedFiles = candidates.filter((c) => !usedRelativePaths.has(c.relativePath)).map((c) => c.relativePath);

  const reportPath = path.join(DATA_DIR, "media", "round3-still-missing-images.json");
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
