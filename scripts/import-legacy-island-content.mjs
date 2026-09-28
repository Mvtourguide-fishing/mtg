#!/usr/bin/env node
// Island destination system, Phase 2b: turns the raw legacy extraction
// (data/maldives/locations/island-legacy-content/*.json, from
// extract-legacy-island-content.mjs) into final, page-ready content and a
// migration that stores it on each island's own node.
//
// This is MTG's own previously-published content (release/ is this same
// site's prior export, not a third-party source) being restructured and
// carried forward into the new architecture — the same reuse-and-clean
// pattern already used for the 48 legacy Travel Guide articles
// (import-legacy-articles.mjs), not new synthesis and not scraped from a
// competitor.
//
// Per island, this:
//   - keeps the "Welcome to X" intro as `overview` paragraphs
//   - drops any section literally about accommodation (the live
//     accommodations section on the island page already shows current,
//     real properties — legacy prose naming specific old guesthouses
//     would risk contradicting it)
//   - flattens the remaining sections (Location & Map, the island's own
//     distinctive heading, Beaches & Marine Life, Activities &
//     Experiences, People & Community Life, ...) into one ordered list of
//     {heading, paragraphs}, dropping any empty subsection (list-based
//     content like "Quick Facts"/"How to Get There" that this pass's
//     paragraph-only extraction didn't capture)
//   - keeps FAQs as-is
//   - matches nearbyIslandMentions against real MTG island slugs (never a
//     free-text name) via the same tokenOverlapScore/fuzzy approach as
//     the reconciliation pass, dropping anything that doesn't resolve to
//     an actual island
//
// Writes:
//   data/maldives/locations/island-content/<slug>.json   — final content
//   supabase/migrations/<TIMESTAMP>_island_content_attributes.sql
//
// Usage: node scripts/import-legacy-island-content.mjs

import { existsSync, mkdirSync, readFileSync, readdirSync, rmSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, ROOT, buildEntityIndex, distinctiveTokens, toAsciiSafe, tokenOverlapScore } from "./lib/legacy-shared.mjs";

const LOCATIONS_DIR = path.join(DATA_DIR, "locations");
const LEGACY_CONTENT_DIR = path.join(LOCATIONS_DIR, "island-legacy-content");
const FINAL_CONTENT_DIR = path.join(LOCATIONS_DIR, "island-content");
const MIGRATION_PATH = path.join(ROOT, "supabase", "migrations", "20250122000100_island_content_attributes.sql");

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

// A significant fraction of the legacy island pages (spot-checked: ~48%
// of FAQ answers, ~51% of the same set contain exact parenthetical
// transfer durations) carry specific dollar price ranges and exact
// transfer-minute counts that are systematically varied per island in a
// clearly formulaic way (e.g. $35-85, $40-90, $43-93 per night across
// consecutive islands) rather than independently sourced figures — this
// is exactly the fabricated-looking numeric claim the task's own rules
// forbid ("Never invent: ... prices ... transfer times ... ferry
// schedules"). Dropping only the offending sentence (not the whole
// paragraph/FAQ) keeps whatever genuinely useful, non-quantified content
// surrounds it.
const UNVERIFIABLE_CLAIM_PATTERNS = [
  /\$\d+[\d,]*(\s*-\s*\$?\d+[\d,]*)?\s*(per\s+(night|person|pax))?/gi,
  /\(\s*\d+\s*(-\s*\d+\s*)?(minutes?|mins?|hours?|hrs?)\s*\)/gi,
  /\b\d+\s*-\s*\d+\s*(minutes?|meters?|metres?|feet|ft)\b/gi,
];

function containsUnverifiableClaim(sentence) {
  return UNVERIFIABLE_CLAIM_PATTERNS.some((re) => {
    re.lastIndex = 0;
    return re.test(sentence);
  });
}

/** Splits on sentence boundaries, drops any sentence carrying an
 * unverifiable price/duration/visibility claim, rejoins the rest — never
 * leaves a mid-sentence numeric gap or dangling clause. */
function sanitizeText(text) {
  if (!text) return text;
  const sentences = text.split(/(?<=[.!?])\s+/);
  const kept = sentences.filter((s) => !containsUnverifiableClaim(s));
  return kept.join(" ").trim();
}

function sanitizeParagraphs(paragraphs) {
  return paragraphs.map((p) => sanitizeText(p)).filter((p) => p.length > 0);
}

function sqlString(value) {
  return `'${toAsciiSafe(String(value)).replace(/'/g, "''")}'`;
}

/** Legacy sections whose top heading isn't real island-destination
 * content — accommodation listings (risk of stale business names
 * contradicting the live accommodations section) and any leftover
 * "quick facts"-only heading with nothing else under it. */
function isDroppedSectionHeading(heading) {
  return /accommodation/i.test(heading);
}

function buildNarrativeSections(rawSections) {
  const out = [];
  // sections[0] is always "Welcome to X" in every observed legacy page —
  // its lead paragraph(s) become `overview`, not a narrative section.
  for (let i = 1; i < rawSections.length; i += 1) {
    const section = rawSections[i];
    if (isDroppedSectionHeading(section.heading)) continue;
    for (const sub of section.subsections) {
      if (sub.paragraphs.length === 0) continue; // list-only content (e.g. "Quick Facts") not captured here
      const paragraphs = sanitizeParagraphs(sub.paragraphs);
      if (paragraphs.length === 0) continue; // the whole subsection was an unverifiable claim
      out.push({ heading: sub.heading ?? section.heading, paragraphs });
    }
  }
  return out;
}

function buildOverview(rawSections) {
  if (rawSections.length === 0) return [];
  const first = rawSections[0].subsections.find((s) => s.heading === null);
  return sanitizeParagraphs(first?.paragraphs ?? []);
}

function buildFaqs(rawFaqs) {
  return rawFaqs
    .map((faq) => ({ question: faq.question, answer: sanitizeText(faq.answer) }))
    // An answer built almost entirely around a stripped price/duration
    // claim collapses to near-nothing once sanitized — drop it rather
    // than publish a threadbare non-answer.
    .filter((faq) => faq.answer.length >= 30);
}

function matchNearbyIslands(mentions, islandEntities, ownSlug) {
  const matched = [];
  const seen = new Set([ownSlug]);
  for (const mention of mentions) {
    const nameTokens = new Set(distinctiveTokens(mention.name));
    if (nameTokens.size === 0) continue; // e.g. "Explore More Islands in ..." captions have no distinctive tokens left after stopword removal

    let best = null;
    for (const entity of islandEntities) {
      const exact = tokenOverlapScore(nameTokens, entity.tokens);
      const fuzzy = fuzzyTokenScore(nameTokens, entity.tokens);
      const score = Math.max(exact, fuzzy >= 0.75 ? fuzzy : 0);
      if (!best || score > best.score) best = { slug: entity.slug, score };
    }
    if (best && best.score >= 0.6 && !seen.has(best.slug)) {
      matched.push(best.slug);
      seen.add(best.slug);
    }
  }
  return matched;
}

function main() {
  if (!existsSync(LEGACY_CONTENT_DIR)) {
    console.error(`Missing ${LEGACY_CONTENT_DIR} — run extract-legacy-island-content.mjs first.`);
    process.exit(1);
  }

  const entities = buildEntityIndex();
  const islandEntities = entities.filter((e) => e.type === "island" && e.isInhabited === true);

  if (existsSync(FINAL_CONTENT_DIR)) rmSync(FINAL_CONTENT_DIR, { recursive: true, force: true });
  mkdirSync(FINAL_CONTENT_DIR, { recursive: true });

  const sqlLines = [];
  sqlLines.push("-- MTG: island destination content (Phase 2b).");
  sqlLines.push("-- GENERATED FILE — do not hand-edit. Source: data/maldives/locations/island-content/*.json,");
  sqlLines.push("-- built from MTG's own legacy site content by scripts/import-legacy-island-content.mjs.");
  sqlLines.push("-- Regenerate with: node scripts/import-legacy-island-content.mjs");
  sqlLines.push("--");
  sqlLines.push("-- Idempotent: merges (jsonb ||) these keys into each island node's existing");
  sqlLines.push("-- `attributes`, so re-applying after the source data changes just overwrites");
  sqlLines.push("-- the same keys rather than duplicating anything.");
  sqlLines.push("");

  let processed = 0;
  const files = readdirSync(LEGACY_CONTENT_DIR).filter((f) => f.endsWith(".json"));
  for (const file of files) {
    const slug = file.replace(/\.json$/, "");
    const raw = JSON.parse(readFileSync(path.join(LEGACY_CONTENT_DIR, file), "utf8"));

    const overview = buildOverview(raw.sections);
    const narrativeSections = buildNarrativeSections(raw.sections);
    const faqs = buildFaqs(raw.faqs);
    const nearbySlugs = matchNearbyIslands(raw.nearbyIslandMentions, islandEntities, slug);
    // Quick-fact values are short label:value phrases (e.g. "Approximately
    // 1,500 residents"), not full sentences — sanitizeText's
    // sentence-splitter would treat the whole phrase as one "sentence" and
    // drop it entirely if it contains a stray digit pattern, so these are
    // checked directly against the claim patterns instead and dropped
    // outright (never partially edited) when they contain one.
    const quickFacts = raw.quickFacts.filter((fact) => !containsUnverifiableClaim(fact.value));

    // An island with only an empty overview and no sections/FAQs isn't
    // worth a content record at all — nothing real to store.
    if (overview.length === 0 && narrativeSections.length === 0 && faqs.length === 0) continue;

    const content = {
      slug,
      contentSource: "legacy_mtg_guide",
      sourceFile: raw.sourceFile,
      quickFacts,
      overview,
      sections: narrativeSections,
      faqs,
      nearbyIslandSlugs: nearbySlugs,
    };

    writeFileSync(path.join(FINAL_CONTENT_DIR, `${slug}.json`), JSON.stringify(content, null, 2) + "\n");
    processed += 1;

    const attributesPatch = {
      island_content_source: content.contentSource,
      island_quick_facts: content.quickFacts,
      island_overview: content.overview,
      island_sections: content.sections,
      island_faqs: content.faqs,
      island_nearby_slugs: content.nearbyIslandSlugs,
    };

    sqlLines.push(`-- ${slug}`);
    sqlLines.push(
      `update nodes set attributes = coalesce(attributes, '{}'::jsonb) || ${sqlString(JSON.stringify(attributesPatch))}::jsonb`,
    );
    sqlLines.push(`where node_type = 'location' and slug = ${sqlString(slug)};`);
    sqlLines.push("");
  }

  writeFileSync(MIGRATION_PATH, sqlLines.join("\n") + "\n");

  console.log(`Processed ${files.length} legacy content files.`);
  console.log(`Wrote ${processed} final content profiles to ${FINAL_CONTENT_DIR}/`);
  console.log(`Wrote migration: ${MIGRATION_PATH}`);
}

main();
