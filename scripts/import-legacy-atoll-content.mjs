#!/usr/bin/env node
// Island destination system, Phase 2c: the same legacy-content-reuse
// pattern as import-legacy-island-content.mjs, for the 20 real legacy
// atoll-overview pages (release/public_html/atolls/<atoll>-atoll-maldives.html
// / vaavu-atoll.html) — one atoll page each, matched via the same verified
// ATOLL_FOLDER_TO_CODE table used everywhere else in this migration.
//
// Same rules as the island pass: drop resort/hotel/guesthouse-heading
// sections (the live accommodations section already shows current real
// properties), and strip any sentence carrying an unverifiable price or
// exact-duration claim before anything is written.
//
// Writes:
//   data/maldives/locations/atoll-content/<slug>.json
//   supabase/migrations/<TIMESTAMP>_atoll_content_attributes.sql
//
// Usage: node scripts/import-legacy-atoll-content.mjs

import { load as loadHtml } from "cheerio";
import { existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import path from "node:path";

import { ATOLL_FOLDER_TO_CODE, DATA_DIR, RELEASE_DIR, ROOT, buildEntityIndex, toAsciiSafe } from "./lib/legacy-shared.mjs";

const ATOLLS_DIR = path.join(RELEASE_DIR, "atolls");
const OUT_DIR = path.join(DATA_DIR, "locations", "atoll-content");
const MIGRATION_PATH = path.join(ROOT, "supabase", "migrations", "20250122000200_atoll_content_attributes.sql");

const NOISE_SELECTORS = ["script", "style", "nav", "header", "header2", "footer", "footer2", ".top-header", "#top-nav", ".menu-toggle"];
const DROPPED_HEADING = /resort|hotel|guesthouse|accommodation|discover other maldives atolls|comments/i;

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
function sanitizeText(text) {
  if (!text) return text;
  const sentences = text.split(/(?<=[.!?])\s+/);
  return sentences.filter((s) => !containsUnverifiableClaim(s)).join(" ").trim();
}
function sanitizeParagraphs(paragraphs) {
  return paragraphs.map(sanitizeText).filter((p) => p.length > 0);
}

function sqlString(value) {
  return `'${toAsciiSafe(String(value)).replace(/'/g, "''")}'`;
}

function extractAtollProfile(filePath) {
  const html = readFileSync(filePath, "utf8");
  const $ = loadHtml(html);
  $(NOISE_SELECTORS.join(", ")).remove();

  const sections = [];
  $("main h2, .container h2").each((_, el) => {
    const heading = $(el).text().trim();
    if (!heading || DROPPED_HEADING.test(heading)) return;

    const paragraphs = [];
    let node = $(el).next();
    // Walk forward collecting <p> text (including within nested cards)
    // until the next <h2> — legacy pages vary between a plain <p> flow
    // and h2 -> div.row > .card > h3/p structures (see Best Dive Sites).
    let steps = 0;
    while (node.length > 0 && node.prop("tagName")?.toLowerCase() !== "h2" && steps < 40) {
      node.find("p").addBack("p").each((_, p) => {
        const text = $(p).text().trim();
        if (text) paragraphs.push(text);
      });
      node = node.next();
      steps += 1;
    }
    const cleaned = sanitizeParagraphs(paragraphs);
    if (cleaned.length > 0) sections.push({ heading, paragraphs: cleaned });
  });

  return { sourceFile: path.relative(RELEASE_DIR, filePath).split(path.sep).join("/"), sections };
}

function main() {
  const entities = buildEntityIndex();
  const atolls = entities.filter((e) => e.type === "atoll");

  if (existsSync(OUT_DIR)) rmSync(OUT_DIR, { recursive: true, force: true });
  mkdirSync(OUT_DIR, { recursive: true });

  const sqlLines = [
    "-- MTG: atoll destination content (Phase 2c).",
    "-- GENERATED FILE — do not hand-edit. Source: data/maldives/locations/atoll-content/*.json,",
    "-- built from MTG's own legacy site content by scripts/import-legacy-atoll-content.mjs.",
    "-- Regenerate with: node scripts/import-legacy-atoll-content.mjs",
    "--",
    "-- Idempotent: merges (jsonb ||) these keys into each atoll node's existing `attributes`.",
    "",
  ];

  let matched = 0;
  let processed = 0;
  const unmatched = [];

  for (const atoll of atolls) {
    if (!atoll.administrativeCode) continue;
    // Reverse of ATOLL_FOLDER_TO_CODE, preferring the "-atoll-maldives.html"
    // naming (every folder entry has a same-named top-level overview file
    // except Vaavu, whose overview file is "vaavu-atoll.html").
    const folder = Object.entries(ATOLL_FOLDER_TO_CODE).find(([, code]) => code === atoll.administrativeCode)?.[0];
    if (!folder) {
      unmatched.push(atoll.title);
      continue;
    }
    const candidates = [`${folder}-maldives.html`, `${folder.replace(/-atoll$/, "")}-atoll-maldives.html`, `${folder}.html`];
    const filePath = candidates.map((c) => path.join(ATOLLS_DIR, c)).find((p) => existsSync(p));
    if (!filePath) {
      unmatched.push(atoll.title);
      continue;
    }

    matched += 1;
    const raw = extractAtollProfile(filePath);
    if (raw.sections.length === 0) continue;

    const content = { slug: atoll.slug, contentSource: "legacy_mtg_guide", sourceFile: raw.sourceFile, sections: raw.sections };
    writeFileSync(path.join(OUT_DIR, `${atoll.slug}.json`), JSON.stringify(content, null, 2) + "\n");
    processed += 1;

    const attributesPatch = { atoll_content_source: content.contentSource, atoll_sections: content.sections };
    sqlLines.push(`-- ${atoll.slug}`);
    sqlLines.push(`update nodes set attributes = coalesce(attributes, '{}'::jsonb) || ${sqlString(JSON.stringify(attributesPatch))}::jsonb`);
    sqlLines.push(`where node_type = 'location' and slug = ${sqlString(atoll.slug)};`);
    sqlLines.push("");
  }

  writeFileSync(MIGRATION_PATH, sqlLines.join("\n") + "\n");

  console.log(`Atolls: ${atolls.length}`);
  console.log(`Matched to a legacy overview file: ${matched}`);
  console.log(`Content profiles written: ${processed}`);
  console.log(`Unmatched: ${unmatched.length}${unmatched.length ? " (" + unmatched.join(", ") + ")" : ""}`);
  console.log(`Wrote migration: ${MIGRATION_PATH}`);
}

main();
