#!/usr/bin/env node
// Stays ecosystem, Phase 2: merges the mechanical legacy-page extraction
// (scripts/extract-legacy-accommodations.mjs's per-property JSON profiles)
// with the WebSearch-verified atoll/island research (4 parallel research
// passes, since the legacy pages' own text was independently found to
// contain real errors — e.g. Milaidhoo's own meta tag claims "Male Atoll"
// when it's a well-documented Baa Atoll resort; Adaaran Select Meedhupparu's
// meta tag claims Kaafu when it's Raa — neither extraction signal alone was
// trustworthy enough to seed from).
//
// Output: one clean, source-of-truth JSON array
// (data/maldives/accommodations-v2/resolved-properties.json) combining:
//   - verified atoll code + island name (from research)
//   - real description paragraphs, rooms, video id, image list (from
//     mechanical extraction)
// Properties whose research left the atoll genuinely unresolved (rare —
// only 1/150, a "Crystal Beach"-named guesthouse the researcher couldn't
// disambiguate among 3 same-named properties) are flagged and excluded
// from the seed-ready list rather than guessed.
//
// Usage: node scripts/merge-accommodation-research.mjs

import { existsSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const OUT_DIR = path.join(ROOT, "data", "maldives", "accommodations-v2");
const PROFILES_DIR = path.join(OUT_DIR, "legacy-profiles");
const RESEARCH_DIR = "/tmp/claude-0/-home-user-maldivestour/12a5f0c2-5b0b-5cd1-b7ad-31d18cdbaf3c/scratchpad";
const OUTPUT_PATH = path.join(OUT_DIR, "resolved-properties.json");
const REVIEW_PATH = path.join(OUT_DIR, "resolution-review.json");

function loadJson(filePath) {
  return JSON.parse(readFileSync(filePath, "utf8"));
}

/** Normalizes the two slightly different research-batch schemas (batch 1
 * used propertyName/verifiedAtollCode/verifiedIsland; batches 2-4 used
 * atollCode/islandName) into one shape. */
function normalizeResearchEntry(entry) {
  return {
    folder: entry.folder,
    atollCode: entry.verifiedAtollCode ?? entry.atollCode ?? null,
    islandName: entry.verifiedIsland ?? entry.islandName ?? null,
    accommodationTypeOverride: entry.accommodationType ?? null,
    note: entry.notes ?? entry.note ?? null,
    uncertain:
      entry.atollConfidence === "uncertain" ||
      entry.islandNameSource === "uncertain" ||
      !(entry.verifiedAtollCode ?? entry.atollCode) ||
      !(entry.verifiedIsland ?? entry.islandName),
  };
}

// Folders excluded post-research for reasons the research pass itself
// surfaced but couldn't resolve on its own: "Vakarufalhi" and "Nova" both
// independently verified to the same island/atoll (Vakarufalhi, South Ari
// Atoll) — Vakarufalhi Island Resort was rebranded to NOVA Maldives in
// 2019 (same physical resort, new ownership/branding), so the legacy
// "Vakarufalhi" page is the property's own former name, not a second
// current resort on the same island. Keeping both would show two
// "different" resorts occupying one island, which is actively misleading.
// These 6 folders are the SAME real resorts as 6 of the original Task 5
// accommodations (data/maldives/accommodations/accommodations.json),
// already seeded under a shorter name ("Gili Lankanfushi" vs this
// extraction's own "Gili Lankanfushi Maldives Island Resort") with the
// correct real island already attached — confirmed by cross-checking
// supabase/migrations/20250103000100_seed_accommodations.sql's own
// slugs and islands, which independently match this round's own
// WebSearch-verified island names exactly. Creating a second node for
// each would be a real duplicate-listing bug (and, since neither this
// script nor generate-stays-seed.mjs's new-island dedup checks against
// Task 5's own already-created resort islands, a duplicate island node
// too), so these are merged INTO the existing accommodation instead of
// seeded as new — see generate-stays-seed.mjs's mergeIntoExistingSlug
// handling.
const MERGE_INTO_EXISTING_SLUG = {
  Kurumba: "kurumba-maldives",
  "Baros-Island": "baros-maldives",
  "Gili-Lankanfushi": "gili-lankanfushi",
  "Six-Senses-Laamu": "six-senses-laamu",
  "Soneva-Fushi": "soneva-fushi",
  Velassaru: "velassaru-maldives",
  // Same check, same result, for the two Task 5 hotels on Maafushi.
  "arena-maafushi": "arena-beach-hotel",
  "kaanibeach-maafushi": "kaani-beach-hotel",
};

const EXCLUDED_FOLDERS = {
  Vakarufalhi: "Rebranded to NOVA Maldives (2019) — same physical resort/island as the 'Nova' folder, kept under its current name only.",
  // The legacy page itself is corrupted: Holiday-Island/Holiday-Island-
  // Resort-Maldives.html's own <title>, <h1> and <meta description> are
  // all "Four Seasons Maldives Private Island at Voavah Resort Maldives"
  // — a real copy-paste error in the SOURCE site (verified by reading the
  // raw HTML directly), not an extraction bug. Since the whole page's
  // content is Four Seasons Voavah's, not Holiday Island's own, there is
  // no reliable real data here to seed under either name — Four Seasons
  // Voavah is already correctly seeded from its own, uncorrupted folder.
  "Holiday-Island": "Source page's title/h1/meta are a verified copy-paste duplicate of Four Seasons Voavah's page — no reliable Holiday Island-specific content exists in the legacy export to seed.",
};

function main() {
  const research = new Map();
  for (let i = 1; i <= 4; i += 1) {
    const filePath = path.join(RESEARCH_DIR, `resort-verification-batch-${i}.json`);
    if (!existsSync(filePath)) throw new Error(`Missing research batch: ${filePath}`);
    for (const entry of loadJson(filePath)) {
      research.set(entry.folder, normalizeResearchEntry(entry));
    }
  }

  const extractionReport = loadJson(path.join(OUT_DIR, "legacy-extraction-report.json"));
  const resolved = [];
  const review = [];

  for (const summary of extractionReport.properties) {
    if (EXCLUDED_FOLDERS[summary.folder]) {
      review.push({ folder: summary.folder, reason: "excluded", note: EXCLUDED_FOLDERS[summary.folder] });
      continue;
    }

    const profilePath = path.join(PROFILES_DIR, `${summary.propertyKind}--${summary.folder}.json`);
    const profile = existsSync(profilePath) ? loadJson(profilePath) : null;
    const r = research.get(summary.folder);

    if (!r) {
      review.push({ folder: summary.folder, reason: "no_research_entry_found" });
      continue;
    }
    if (r.uncertain || !r.atollCode || !r.islandName) {
      review.push({ folder: summary.folder, reason: "research_uncertain_or_incomplete", research: r });
      continue;
    }
    if (!profile) {
      review.push({ folder: summary.folder, reason: "no_extraction_profile_found" });
      continue;
    }

    const accommodationType =
      r.accommodationTypeOverride ??
      (summary.propertyKind === "resort" ? "resort" : profile.isGuesthouseMention ? "guesthouse" : "hotel");

    const rooms = (profile.rooms ?? [])
      .filter((room) => room.name && room.price)
      .map((room) => ({
        name: room.name,
        priceFrom: room.price,
        currency: room.currency ?? "USD",
        bedType: room.bedType,
        maxOccupancy: room.maxOccupancy,
        images: room.images ?? [],
      }));

    const priceFrom = rooms.length > 0 ? Math.min(...rooms.map((rm) => rm.priceFrom)) : null;

    resolved.push({
      folder: summary.folder,
      propertyKind: summary.propertyKind,
      name: profile.legacyH1 ?? summary.folder,
      accommodationType,
      mergeIntoExistingSlug: MERGE_INTO_EXISTING_SLUG[summary.folder] ?? null,
      atollCode: r.atollCode,
      islandName: r.islandName,
      starRating: profile.starRating,
      descriptionParagraphs: profile.descriptionParagraphs ?? [],
      videoId: profile.videoId ?? null,
      priceFrom,
      priceCurrency: rooms.length > 0 ? "USD" : null,
      rooms,
      imageDirRelative: profile.imageDirRelative,
      imageFiles: profile.imageFiles ?? [],
      sourceFile: profile.sourceFile,
      researchNote: r.note,
    });
  }

  writeFileSync(OUTPUT_PATH, JSON.stringify(resolved, null, 2) + "\n");
  writeFileSync(REVIEW_PATH, JSON.stringify(review, null, 2) + "\n");

  console.log(`Resolved: ${resolved.length} / ${extractionReport.properties.length}`);
  console.log(`Needs review (excluded from seed): ${review.length}`);
  for (const r of review) console.log(`  - ${r.folder}: ${r.reason}`);
  console.log(`\nWrote ${OUTPUT_PATH}`);
  console.log(`Wrote ${REVIEW_PATH}`);
}

main();
