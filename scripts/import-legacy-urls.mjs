#!/usr/bin/env node
// Task 14 §23: legacy URL inventory. Read-only — classifies every real
// legacy HTML page (skipping template fragments, admin/backend files,
// and non-content directories) and records old URL, title, page type,
// and a candidate new MTG URL where the content clearly maps to an
// existing entity. Does NOT implement redirects (a later task) — this
// report is the input that task will need.
//
// Usage: node scripts/import-legacy-urls.mjs

import { existsSync, mkdirSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import { RELEASE_DIR, ROOT, buildEntityIndex, distinctiveTokens, tokenOverlapScore } from "./lib/legacy-shared.mjs";

const CONTENT_DATA_DIR = path.join(ROOT, "data", "maldives", "content");

// Directories that hold no real, migratable page content (template
// fragments, legacy admin/backend, vendor libraries, a non-English
// mirror with unrelated-looking page names, sample/demo content).
const SKIP_DIRS = new Set(["vendor", "css", "js", "font", "fonts", "bml", "gpay", "ru", "sample", "app", "comments", "comment-reply-system", "mdb-addons"]);

// Root-level files that are template includes/admin utilities, not pages.
const SKIP_ROOT_FILES = new Set([
  "DomainActivation.html", "nav2.html", "footer.html", "footer2.html",
  "footer-transfer.html", "form.html", "email.html", "community.html",
]);

// Filenames that are dev/test scratch files regardless of which directory
// they turn up in — e.g. articles/sample.html, a copy-pasted draft of the
// real maldives-religion.html article, not a distinct indexed page.
const SKIP_FILENAMES_ANY_DIR = new Set(["sample.html", "test.html", "demo.html", "template.html"]);

function walk(dir, relBase, out) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (entry.isDirectory()) {
      if (relBase === "" && SKIP_DIRS.has(entry.name)) continue;
      walk(path.join(dir, entry.name), path.join(relBase, entry.name), out);
      continue;
    }
    if (!entry.name.toLowerCase().endsWith(".html")) continue;
    if (relBase === "" && SKIP_ROOT_FILES.has(entry.name)) continue;
    if (SKIP_FILENAMES_ANY_DIR.has(entry.name.toLowerCase())) continue;
    out.push(path.join(relBase, entry.name));
  }
}

function extractTag(html, regex) {
  const m = html.match(regex);
  return m ? m[1].replace(/\s+/g, " ").trim() : null;
}

// Task 15 §50: the directory-based `classify()` rule below is deliberately
// coarse (one pageType per top-level legacy folder) and, for "package" and
// "transfer", that coarseness hides real, very different content types —
// discovered while building the dedicated transfer/package migrations
// (scripts/import-legacy-transfers.mjs, scripts/import-legacy-packages.mjs):
// most of tours/*.html turned out to be bare checkout widgets, several
// packages/*.html are B2B partner-recruitment pages, and several more are
// generic templated marketing copy with a fabricated star rating. This
// second, cheap pass adds that real sub-type as its own field WITHOUT
// touching pageType (nothing downstream that filters on pageType breaks),
// using only lightweight structural/keyword signals — the heavier
// real-entity matching that decides an actual migration outcome stays in
// the two dedicated scripts above, which remain the source of truth for
// migrationStatus.
const FABRICATED_RATING_PATTERN = /\b\d(?:\.\d)?\s*\(\d{1,4}\s*reviews?\)/i;

function classifyContentSubType(pageType, title, html) {
  if (pageType !== "package" && pageType !== "transfer") return null;

  const text = html.replace(/<[^>]+>/g, " ").replace(/\s+/g, " ").trim();
  const t = (title ?? "").trim().toLowerCase();

  if (t === "booking form" || t === "") return "booking-form-widget";
  if (/<form[\s>]/i.test(html) && text.length < 400) return "booking-form-widget";
  if (/join our network|become a partner|partner with us|tour operators & package providers|list your (resort|hotel|guesthouse|business)/i.test(`${title ?? ""} ${text}`)) {
    return "partner-recruitment";
  }
  if (/<script type="application\/ld\+json">/i.test(html)) return "structured-listing";
  if (pageType === "package" && FABRICATED_RATING_PATTERN.test(text)) return "generic-template-marketing";
  return "content-page";
}

function classify(relPath) {
  const parts = relPath.split(path.sep);
  const top = parts[0];
  const filename = parts[parts.length - 1].toLowerCase();

  const DIR_TYPE = {
    atolls: "location",
    "maldives-islands": "location",
    resorts: "accommodation",
    hotels: "accommodation",
    diving: "diving",
    fishing: "fishing",
    transfer: "transfer",
    tours: "package",
    packages: "package",
    articles: "article",
    maps: "map",
    shopping: "shopping",
    partners: "other",
    terms: "other",
    contact: "other",
  };
  if (top !== relPath && DIR_TYPE[top]) return DIR_TYPE[top];

  // Root-level pages: classify by filename keyword.
  if (/travel-guide|islands-travel/.test(filename)) return "article";
  if (/fishing/.test(filename)) return "fishing";
  if (/(scuba|diving)/.test(filename)) return "diving";
  if (/surfing/.test(filename)) return "surfing";
  if (/(transfer|ferry|transportation)/.test(filename)) return "transfer";
  if (/(resorts|hotels)\.html$/.test(filename)) return "accommodation";
  if (/(package|holiday-tour)/.test(filename)) return "package";
  if (/(male-city|atoll|island)/.test(filename)) return "location";
  if (/(privacy-policy|faqs)/.test(filename)) return "other";
  if (filename === "index.html") return "location";
  return "other";
}

function main() {
  if (!existsSync(RELEASE_DIR)) {
    console.error(`Legacy source not found at ${RELEASE_DIR}.`);
    process.exit(1);
  }
  mkdirSync(CONTENT_DATA_DIR, { recursive: true });

  const relativePaths = [];
  walk(RELEASE_DIR, "", relativePaths);
  relativePaths.sort();

  const entities = buildEntityIndex();
  const records = [];

  for (const rel of relativePaths) {
    const fullPath = path.join(RELEASE_DIR, rel);
    let html;
    try {
      html = readFileSync(fullPath, "utf8");
    } catch {
      continue;
    }

    const title = extractTag(html, /<title[^>]*>([^<]*)<\/title>/i);
    const metaDescription = extractTag(html, /<meta\s+name=["']description["']\s+content=["']([^"']*)["']/i);
    const pageType = classify(rel);
    const contentSubType = classifyContentSubType(pageType, title, html);
    const isEmpty = html.replace(/<[^>]+>/g, "").trim().length < 80;

    const urlPath = "/" + rel.split(path.sep).join("/");

    // Candidate entity match: title first (most reliable signal for a
    // real page), falling back to the filename.
    const searchText = title || path.basename(rel, ".html");
    const fileTokens = new Set(distinctiveTokens(searchText));
    let best = null;
    for (const entity of entities) {
      const score = tokenOverlapScore(fileTokens, entity.tokens);
      if (score > 0 && (!best || score > best.score)) best = { entity, score };
    }

    // Task 14 §24: transfer/package/tour pages are classified here but
    // deliberately NOT resolved to a migration target — that's the
    // dedicated legacy-commercial-migration task's job.
    const deferred = pageType === "transfer" || pageType === "package";

    let migrationStatus;
    let confidence;
    if (deferred) {
      migrationStatus = "deferred-to-transfer-package-migration";
      confidence = "n/a";
    } else if (best && best.score >= 0.6) {
      migrationStatus = "candidate-match";
      confidence = best.score >= 0.8 ? "high" : "medium";
    } else if (best && best.score >= 0.3) {
      migrationStatus = "needs-review";
      confidence = "low";
    } else {
      migrationStatus = pageType === "article" ? "candidate-article" : "unmatched";
      confidence = "unmatched";
    }

    records.push({
      oldUrl: urlPath,
      sourceFile: rel.split(path.sep).join("/"),
      pageType,
      contentSubType,
      title,
      metaDescription,
      isEmptyOrThin: isEmpty,
      candidateEntityType: best?.entity.type ?? null,
      candidateEntitySlug: best?.entity.slug ?? null,
      candidateNewUrl: best?.entity.href ?? null,
      matchScore: best ? Number(best.score.toFixed(2)) : null,
      migrationStatus,
      confidence,
    });
  }

  const byType = {};
  const byStatus = {};
  const byContentSubType = {};
  for (const r of records) {
    byType[r.pageType] = (byType[r.pageType] ?? 0) + 1;
    byStatus[r.migrationStatus] = (byStatus[r.migrationStatus] ?? 0) + 1;
    if (r.contentSubType) byContentSubType[r.contentSubType] = (byContentSubType[r.contentSubType] ?? 0) + 1;
  }

  writeFileSync(
    path.join(CONTENT_DATA_DIR, "url-inventory.json"),
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        note: "Read-only inventory (Task 14 §23). No redirects implemented here — this feeds the later SEO redirect/migration task.",
        totalPages: records.length,
        byPageType: byType,
        byMigrationStatus: byStatus,
        byContentSubType: byContentSubType,
        emptyOrThinPages: records.filter((r) => r.isEmptyOrThin).map((r) => r.sourceFile),
        pages: records,
      },
      null,
      2,
    ),
  );

  console.log(`Classified ${records.length} legacy HTML pages`);
  console.log("By type:", byType);
  console.log("By migration status:", byStatus);
  console.log("By content sub-type (package/transfer only):", byContentSubType);
  console.log(`Wrote data/maldives/content/url-inventory.json`);
}

main();
