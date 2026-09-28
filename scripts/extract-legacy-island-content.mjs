#!/usr/bin/env node
// Island destination system, Phase 1-2: legacy island-page reconciliation
// + content extraction.
//
// The legacy site (release/public_html/atolls/<atoll-folder>/) has one
// HTML page per local island, at a consistent template — <div
// class="fact-box"> for quick facts, <section class="section"> blocks
// with <h2 class="section-title">/<h3> headings and <p> body copy, <div
// class="faq-item"> for FAQs, <div class="nearby-section"> for
// nearby-island links. This script:
//
//   1. Matches every real MTG island (buildEntityIndex(), the same slug
//      derivation generate-location-seed.mjs uses) against its legacy
//      page, using the verified ATOLL_FOLDER_TO_CODE table plus
//      tokenOverlapScore — never guessing an island's atoll from its
//      name.
//   2. For every match, extracts the page's real structured content
//      (facts, section text, FAQs, nearby-island mentions, image refs)
//      into one JSON profile per island — extraction only, no rewriting
//      and no invented facts. This is raw material for a later
//      content-generation pass, not page copy itself.
//
// Read-only against the live site — writes only to data/maldives/locations/.
//
// Usage: node scripts/extract-legacy-island-content.mjs

import { load as loadHtml } from "cheerio";
import { existsSync, mkdirSync, readdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import path from "node:path";

import {
  ATOLL_FOLDER_TO_CODE,
  DATA_DIR,
  RELEASE_DIR,
  buildEntityIndex,
  distinctiveTokens,
  tokenOverlapScore,
} from "./lib/legacy-shared.mjs";

const ATOLLS_DIR = path.join(RELEASE_DIR, "atolls");
const LOCATIONS_DIR = path.join(DATA_DIR, "locations");
const CONTENT_OUT_DIR = path.join(LOCATIONS_DIR, "island-legacy-content");
const RECONCILIATION_PATH = path.join(LOCATIONS_DIR, "island-legacy-reconciliation.json");

// Reverse of ATOLL_FOLDER_TO_CODE — one atoll code can have more than one
// legacy folder name (e.g. "HA" -> both "haa-alifu" and "haa-alifu-atoll"
// exist in the export), so every candidate folder is checked.
const FOLDERS_BY_CODE = new Map();
for (const [folder, code] of Object.entries(ATOLL_FOLDER_TO_CODE)) {
  if (!FOLDERS_BY_CODE.has(code)) FOLDERS_BY_CODE.set(code, []);
  FOLDERS_BY_CODE.get(code).push(folder);
}

const NOISE_SELECTORS = [
  "script", "style", "nav", "header", "header2", "footer", "footer2",
  ".top-header", "#top-nav", ".menu-toggle",
];

// Human-verified matches the automated scorer can't reach: either a
// colloquial/alternate name (the legacy page titles itself "Mulah
// Island" — a short form of "Boli Mulah" — and Meemu Atoll's actual atoll
// capital "Muli" already has its own separate, already-matched legacy
// page, so this is confirmed a different island, not a duplicate), or a
// compound name the legacy site wrote as one unhyphenated word
// ("Faresmaathodaa" vs MTG's "Fares-Maathodaa" — an exact name match once
// the hyphen is accounted for, not a guess).
const MANUAL_MATCH_OVERRIDES = {
  "boli-mulah": "atolls/meemu-atoll/meemu-mulah-island-maldives.html",
  "fares-maathodaa": "atolls/gaafu-dhaalu-atoll/gaafu-dhaalu-faresmaathodaa-island-maldives.html",
  // These three MTG islands are administratively grouped under "Malé
  // City" (a distinct atoll-level division from Kaafu Atoll in MTG's own
  // data), but the legacy site filed all three under its Kaafu Atoll
  // folder by *geography* instead — real content for the right islands,
  // just outside where the atoll-code folder lookup would ever look. Two
  // also use a "-city-maldives.html"/differently-worded filename, outside
  // the "-island-maldives.html" pattern this script otherwise scans for.
  male: "atolls/kaafu-atoll/kaafu-male-city-maldives.html",
  hulhumale: "atolls/kaafu-atoll/kaafu-hulhumale-island-maldives.html",
  villingili: "atolls/kaafu-atoll/kaafu-vilimale-island-maldives.html",
};

// Human-reviewed and confirmed as genuinely different islands from their
// flagged candidate (not a naming variant) — real, distinct Maldivian
// islands that happen to score moderately on token similarity to a
// nearby island's legacy filename:
//  - Kunburudhoo (Haa Dhaalu) vs "Kumundhoo": a different island in the
//    same atoll that already has its own separately-matched legacy page.
//  - Rinbudhoo (Dhaalu) vs "Bandidhoo": different island names, no
//    genuine transliteration relationship.
//  - Gaadhoo (Laamu) vs "Fonadhoo": different island names.
//  - Kalhaidhoo (Laamu) vs "Maabaidhoo": different island names.
//  - Dhiyadhoo (Gaafu Alifu) vs "Dhevvadhoo": different island names.
//  - Maradhoo-Feydhoo (Seenu/Addu) vs "Hulhudhoo-Meedhoo": both are real,
//    separate merged-island communities within Addu Atoll's linked-island
//    chain (Hithadhoo, Maradhoo, Feydhoo, Maradhoo-Feydhoo, Hulhudhoo-
//    Meedhoo, Gan), not the same place.
const CONFIRMED_NO_MATCH = new Set([
  "kunburudhoo",
  "rinbudhoo",
  "gaadhoo",
  "kalhaidhoo",
  "dhiyadhoo",
  "maradhoo-feydhoo",
]);

const MIN_MATCH_SCORE = 0.5;
// Legacy filenames and MTG's islands.json transliterate Dhivehi island
// names slightly differently in many cases (single/double vowel or
// consonant: "maduvvari" vs "maduvvaree", "gadhdhoo" vs "gaddhoo",
// "vilingili" vs "villingili") — exact-token overlap scores these 0
// despite being the same island. A Levenshtein-based fallback catches
// these without guessing: FUZZY_ACCEPT is high-confidence enough to
// extract automatically (flagged matchMethod: "fuzzy" for spot-checking),
// FUZZY_REVIEW is too uncertain to extract but too close to ignore —
// flagged "needs_review" with its best candidate for a human to confirm.
const FUZZY_ACCEPT_SCORE = 0.75;
const FUZZY_REVIEW_SCORE = 0.55;

function levenshtein(a, b) {
  const m = a.length;
  const n = b.length;
  if (m === 0) return n;
  if (n === 0) return m;
  const prev = new Array(n + 1);
  const curr = new Array(n + 1);
  for (let j = 0; j <= n; j += 1) prev[j] = j;
  for (let i = 1; i <= m; i += 1) {
    curr[0] = i;
    for (let j = 1; j <= n; j += 1) {
      const cost = a[i - 1] === b[j - 1] ? 0 : 1;
      curr[j] = Math.min(curr[j - 1] + 1, prev[j] + 1, prev[j - 1] + cost);
    }
    for (let j = 0; j <= n; j += 1) prev[j] = curr[j];
  }
  return prev[n];
}

/** For every entity token, finds the file token with the closest edit
 * distance and returns the WORST (minimum) of those best-match
 * similarities — requiring every distinctive word in the island's name
 * to have a close counterpart in the filename, not just one out of a
 * multi-word name (e.g. "Boli Mulah" matching a file only because it
 * contains "mulah" is a real ambiguity, not a confident fuzzy match). */
function fuzzyTokenScore(fileTokens, entityTokens) {
  const fileArr = [...fileTokens];
  if (fileArr.length === 0 || entityTokens.size === 0) return 0;
  let worst = 1;
  for (const et of entityTokens) {
    let best = 0;
    for (const ft of fileArr) {
      const dist = levenshtein(et, ft);
      const sim = 1 - dist / Math.max(et.length, ft.length);
      if (sim > best) best = sim;
    }
    if (best < worst) worst = best;
  }
  return worst;
}

function main() {
  const entities = buildEntityIndex();
  // Only real, seeded local/inhabited islands (islands.json's 193 rows) —
  // buildEntityIndex() also reconstructs uninhabited resort-island
  // entities from accommodations.json for its own matching purposes;
  // those are a different vertical (already covered by accommodation
  // pages), not this local-island destination system.
  const islands = entities.filter((e) => e.type === "island" && e.isInhabited === true);
  const atollByslug = new Map(entities.filter((e) => e.type === "atoll").map((a) => [a.slug, a]));

  if (!existsSync(ATOLLS_DIR)) {
    console.error(`Legacy atolls directory not found: ${ATOLLS_DIR}`);
    process.exit(1);
  }

  // Every "*-island-maldives.html" file across every atoll folder, so we
  // can also report legacy pages that don't match any current MTG island
  // (renamed/merged/removed islands) rather than silently dropping them.
  const allLegacyFiles = [];
  for (const folder of readdirSync(ATOLLS_DIR)) {
    const folderPath = path.join(ATOLLS_DIR, folder);
    let files;
    try {
      files = readdirSync(folderPath);
    } catch {
      continue;
    }
    for (const file of files) {
      if (file.endsWith("-island-maldives.html")) {
        allLegacyFiles.push({ folder, file, relativePath: `atolls/${folder}/${file}` });
      }
    }
  }
  const usedLegacyFiles = new Set();

  const reconciliation = [];
  let matchedCount = 0;
  let extractedCount = 0;
  const extractionFailures = [];

  if (existsSync(CONTENT_OUT_DIR)) rmSync(CONTENT_OUT_DIR, { recursive: true, force: true });
  mkdirSync(CONTENT_OUT_DIR, { recursive: true });

  for (const island of islands) {
    const atoll = atollByslug.get(island.atollSlug);
    const atollCode = atoll?.administrativeCode ?? null;
    const candidateFolders = atollCode ? (FOLDERS_BY_CODE.get(atollCode) ?? []) : [];

    let best = null;
    let bestFuzzy = null;
    if (MANUAL_MATCH_OVERRIDES[island.slug]) {
      best = { score: 1, relativePath: MANUAL_MATCH_OVERRIDES[island.slug] };
    } else {
      for (const folder of candidateFolders) {
        const folderPath = path.join(ATOLLS_DIR, folder);
        if (!existsSync(folderPath)) continue;
        for (const file of readdirSync(folderPath)) {
          if (!file.endsWith("-island-maldives.html")) continue;
          const fileTokens = new Set(distinctiveTokens(file));
          const score = tokenOverlapScore(fileTokens, island.tokens);
          if (!best || score > best.score) best = { folder, file, score, relativePath: `atolls/${folder}/${file}` };

          const fuzzyScore = fuzzyTokenScore(fileTokens, island.tokens);
          if (!bestFuzzy || fuzzyScore > bestFuzzy.score) bestFuzzy = { folder, file, score: fuzzyScore, relativePath: `atolls/${folder}/${file}` };
        }
      }
    }

    const manualMatch = Boolean(MANUAL_MATCH_OVERRIDES[island.slug]);
    const exactMatch = !manualMatch && best && best.score >= MIN_MATCH_SCORE;
    const fuzzyMatch = !manualMatch && !exactMatch && bestFuzzy && bestFuzzy.score >= FUZZY_ACCEPT_SCORE;
    const needsReview =
      !manualMatch && !exactMatch && !fuzzyMatch && !CONFIRMED_NO_MATCH.has(island.slug) && bestFuzzy && bestFuzzy.score >= FUZZY_REVIEW_SCORE;
    const winner = manualMatch ? best : exactMatch ? best : fuzzyMatch ? bestFuzzy : null;
    const matched = Boolean(winner);

    const record = {
      slug: island.slug,
      title: island.title,
      atollSlug: island.atollSlug,
      atollTitle: atoll?.title ?? null,
      legacyFile: matched ? winner.relativePath : null,
      matchScore: winner ? Number(winner.score.toFixed(3)) : best ? Number(best.score.toFixed(3)) : 0,
      matchMethod: manualMatch ? "manual" : exactMatch ? "exact" : fuzzyMatch ? "fuzzy" : null,
      status: matched ? "matched" : needsReview ? "needs_review" : "no_legacy_page",
      reviewCandidate: needsReview ? { file: bestFuzzy.relativePath, score: Number(bestFuzzy.score.toFixed(3)) } : null,
    };
    reconciliation.push(record);

    if (matched) {
      matchedCount += 1;
      usedLegacyFiles.add(winner.relativePath);
      try {
        const profile = extractIslandProfile(path.join(RELEASE_DIR, best.relativePath), island, atoll);
        writeFileSync(path.join(CONTENT_OUT_DIR, `${island.slug}.json`), JSON.stringify(profile, null, 2) + "\n");
        extractedCount += 1;
      } catch (err) {
        extractionFailures.push({ slug: island.slug, file: best.relativePath, error: String(err?.message ?? err) });
      }
    }
  }

  // Legacy pages that never matched any current MTG island at all — for
  // manual review, not evidence of anything on their own (could be a
  // renamed/merged island, or a genuinely extra legacy page).
  const orphanLegacyFiles = allLegacyFiles
    .filter((f) => !usedLegacyFiles.has(f.relativePath))
    .map((f) => f.relativePath);

  const needsReviewCount = reconciliation.filter((r) => r.status === "needs_review").length;
  const trueNoLegacyCount = reconciliation.filter((r) => r.status === "no_legacy_page").length;
  const fuzzyMatchedCount = reconciliation.filter((r) => r.matchMethod === "fuzzy").length;

  const report = {
    generatedAt: new Date().toISOString(),
    summary: {
      expectedMtgIslands: islands.length,
      legacyIslandPagesFound: allLegacyFiles.length,
      matched: matchedCount,
      matchedExact: matchedCount - fuzzyMatchedCount,
      matchedFuzzy: fuzzyMatchedCount,
      needsReview: needsReviewCount,
      noLegacyPage: trueNoLegacyCount,
      extracted: extractedCount,
      extractionFailures: extractionFailures.length,
      orphanLegacyFiles: orphanLegacyFiles.length,
    },
    islands: reconciliation,
    orphanLegacyFiles,
    extractionFailures,
  };

  writeFileSync(RECONCILIATION_PATH, JSON.stringify(report, null, 2) + "\n");

  console.log(`Expected MTG islands: ${islands.length}`);
  console.log(`Legacy island pages found: ${allLegacyFiles.length}`);
  console.log(`Matched: ${matchedCount} (exact: ${matchedCount - fuzzyMatchedCount}, fuzzy: ${fuzzyMatchedCount})`);
  console.log(`Needs manual review: ${needsReviewCount}`);
  console.log(`No legacy page: ${trueNoLegacyCount}`);
  console.log(`Profiles extracted: ${extractedCount}`);
  console.log(`Extraction failures: ${extractionFailures.length}`);
  console.log(`Orphan legacy files (matched no MTG island): ${orphanLegacyFiles.length}`);
  console.log(`\nWrote ${RECONCILIATION_PATH}`);
  console.log(`Wrote ${extractedCount} profiles to ${CONTENT_OUT_DIR}/`);
}

/** Extracts one island's real structured content from its legacy page.
 * Every field is either the literal text found on the page or omitted —
 * nothing here is inferred or generated. */
function extractIslandProfile(filePath, island, atoll) {
  const html = readFileSync(filePath, "utf8");
  const $ = loadHtml(html);
  $(NOISE_SELECTORS.join(", ")).remove();

  const title = $("title").first().text().trim() || null;
  const h1 = $("main h1").first().text().trim() || $("h1").first().text().trim() || null;
  const heroSummary = $(".hero-content p").first().text().trim() || null;

  // Quick facts: <div class="fact-box"><ul><li><strong>Label:</strong> value</li>...
  const quickFacts = [];
  $(".fact-box li").each((_, el) => {
    const $el = $(el);
    const label = $el.find("strong").first().text().replace(/:\s*$/, "").trim();
    const full = $el.text().trim();
    const value = label ? full.slice(full.indexOf(label) + label.length).replace(/^:\s*/, "").trim() : full;
    if (label && value) quickFacts.push({ label, value });
  });

  // Section content, in document order: <section class="section"> with an
  // <h2 class="section-title">, then any h3/h4 subheadings and <p> text.
  const sections = [];
  $("main section.section, main section.faq-section, main section.nearby-section").each((_, el) => {
    const $section = $(el);
    const heading = $section.find("h2").first().text().trim();
    if (!heading) return;
    if (/frequently asked questions/i.test(heading) || /nearby islands/i.test(heading)) return; // extracted separately below

    const subsections = [];
    let current = { heading: null, paragraphs: [] };
    $section.find("h3, h4, p").each((_, node) => {
      const tag = node.tagName?.toLowerCase();
      const text = $(node).text().trim();
      if (!text) return;
      if (tag === "h3" || tag === "h4") {
        if (current.heading || current.paragraphs.length > 0) subsections.push(current);
        current = { heading: text, paragraphs: [] };
      } else if (tag === "p") {
        current.paragraphs.push(text);
      }
    });
    if (current.heading || current.paragraphs.length > 0) subsections.push(current);
    sections.push({ heading, subsections });
  });

  // FAQs: <div class="faq-item"><div class="faq-question">...</div><div class="faq-answer">...</div></div>
  const faqs = [];
  $(".faq-item").each((_, el) => {
    const question = $(el).find(".faq-question").first().text().trim();
    const answer = $(el).find(".faq-answer").first().text().trim();
    if (question && answer) faqs.push({ question, answer });
  });

  // Nearby-island mentions: raw legacy links/names only — matching these
  // to real MTG island slugs is a separate, later step, not done here.
  const nearbyIslandMentions = [];
  $(".nearby-section .island-card a, .nearby-section a").each((_, el) => {
    const href = $(el).attr("href") ?? null;
    const name = $(el).find(".island-caption").first().text().trim() || $(el).text().trim();
    if (name) nearbyIslandMentions.push({ name, legacyHref: href });
  });

  // Every <img> in the main content — recorded for a later, separate
  // review of which (if any) are genuinely island-specific vs.
  // generic/shared/third-party (per the audit, most are not unique).
  const images = [];
  $("main img").each((_, el) => {
    const src = $(el).attr("src") ?? null;
    const alt = $(el).attr("alt") ?? null;
    if (!src) return;
    const isExternal = /^https?:\/\//i.test(src) && !src.includes("maldivestour.guide");
    images.push({ src, alt, source: isExternal ? "external" : "legacy-local" });
  });

  return {
    slug: island.slug,
    mtgTitle: island.title,
    atollSlug: island.atollSlug,
    atollTitle: atoll?.title ?? null,
    sourceFile: path.relative(RELEASE_DIR, filePath).split(path.sep).join("/"),
    legacyTitle: title,
    legacyH1: h1,
    heroSummary,
    quickFacts,
    sections,
    faqs,
    nearbyIslandMentions,
    images,
  };
}

main();
