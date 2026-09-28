#!/usr/bin/env node
// Task 16 §2-3: master legacy URL inventory.
//
// The real, authoritative discovery pass already happened in Task 14
// (scripts/import-legacy-urls.mjs, a full filesystem walk of release/
// that classifies every real page — 1037 pages). This script does not
// re-walk the filesystem; it builds on that inventory (still the source
// of truth for "every meaningful legacy URL") and adds what Task 16
// specifically asks for beyond it:
//
//   - `internalLinkCount` / `linkedFromSample`: how many OTHER legacy
//     pages link to this one, and a sample of which ones — a real,
//     honest signal of relative importance within the legacy site. This
//     project has no Search Console export in the repository (checked;
//     none exists), so this is used INSTEAD, clearly labeled as what it
//     actually is (internal link popularity), never presented as
//     Search Console data.
//   - `linkedUrlVariants`: the distinct raw href strings actually used
//     across the legacy site to link to this page (trailing slash,
//     query string, encoding differences) — real evidence of what a
//     redirect's source-path normalization needs to handle, not a
//     guess.
//
// Writes: data/maldives/migration/legacy-url-inventory.json
// Usage: node scripts/build-legacy-url-inventory.mjs

import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, RELEASE_DIR, ROOT } from "./lib/legacy-shared.mjs";

const CONTENT_DATA_DIR = path.join(DATA_DIR, "content");
const MIGRATION_DATA_DIR = path.join(DATA_DIR, "migration");
const SELF_HOSTED_ORIGIN = /^https?:\/\/(?:www\.)?maldivestour\.guide\//i;

/** Resolves an <a href="..."> value found on `fromRelPath` to a
 * RELEASE_DIR-relative path (same resolution as
 * scripts/generate-data-quality-report.mjs's identical helper), keeping
 * the ORIGINAL raw href string too so real variant forms are visible. */
function resolveInternalHref(rawHref, fromRelPath) {
  if (!rawHref) return null;
  const trimmed = rawHref.trim();
  if (!trimmed || trimmed.startsWith("#") || trimmed.startsWith("mailto:") || trimmed.startsWith("tel:") || trimmed.startsWith("javascript:")) {
    return null;
  }

  let pathPart;
  if (SELF_HOSTED_ORIGIN.test(trimmed)) {
    pathPart = trimmed.replace(SELF_HOSTED_ORIGIN, "");
  } else if (/^https?:\/\//i.test(trimmed)) {
    return null; // genuinely external
  } else if (trimmed.startsWith("/")) {
    pathPart = trimmed.slice(1);
  } else {
    pathPart = path.posix.join(path.posix.dirname(fromRelPath.split(path.sep).join("/")), trimmed);
  }

  const normalized = pathPart.split("#")[0].split("?")[0];
  if (!normalized || normalized.endsWith("/")) return null;

  return { target: normalized, raw: trimmed };
}

function main() {
  const urlInventoryPath = path.join(CONTENT_DATA_DIR, "url-inventory.json");
  if (!existsSync(urlInventoryPath)) {
    console.error("Run scripts/import-legacy-urls.mjs first (needs data/maldives/content/url-inventory.json).");
    process.exit(1);
  }
  const urlInventory = JSON.parse(readFileSync(urlInventoryPath, "utf8"));
  const pages = urlInventory.pages;
  const pageBySourceFile = new Map(pages.map((p) => [p.sourceFile.toLowerCase(), p]));

  const linkCountByTarget = new Map();
  const linkedFromByTarget = new Map();
  const variantsByTarget = new Map();

  for (const page of pages) {
    const fullPath = path.join(RELEASE_DIR, page.sourceFile);
    let html;
    try {
      html = readFileSync(fullPath, "utf8");
    } catch {
      continue;
    }

    const hrefRe = /<a\s[^>]*href="([^"]*)"/gi;
    let m;
    while ((m = hrefRe.exec(html))) {
      const resolved = resolveInternalHref(m[1], page.sourceFile);
      if (!resolved || !resolved.target.toLowerCase().endsWith(".html")) continue;
      const key = resolved.target.toLowerCase();
      if (!pageBySourceFile.has(key)) continue; // not a real page (broken link — already covered by data-quality-report.json)
      if (key === page.sourceFile.toLowerCase()) continue; // self-link, not evidence of external importance

      linkCountByTarget.set(key, (linkCountByTarget.get(key) ?? 0) + 1);
      const from = linkedFromByTarget.get(key) ?? [];
      if (from.length < 5 && !from.includes(page.sourceFile)) from.push(page.sourceFile);
      linkedFromByTarget.set(key, from);

      const variants = variantsByTarget.get(key) ?? new Set();
      variants.add(resolved.raw);
      variantsByTarget.set(key, variants);
    }
  }

  const enriched = pages.map((p) => {
    const key = p.sourceFile.toLowerCase();
    return {
      ...p,
      internalLinkCount: linkCountByTarget.get(key) ?? 0,
      linkedFromSample: linkedFromByTarget.get(key) ?? [],
      linkedUrlVariants: variantsByTarget.has(key) ? Array.from(variantsByTarget.get(key)).slice(0, 8) : [],
    };
  });

  enriched.sort((a, b) => b.internalLinkCount - a.internalLinkCount);

  mkdirSync(MIGRATION_DATA_DIR, { recursive: true });
  const outPath = path.join(MIGRATION_DATA_DIR, "legacy-url-inventory.json");
  writeFileSync(
    outPath,
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        note:
          "Task 16 §2-3. Built on top of data/maldives/content/url-inventory.json (Task 14's full filesystem walk of " +
          "release/ — still the authoritative discovery of every real legacy page). Adds internalLinkCount/" +
          "linkedFromSample (a real, honest importance signal — this repository has no Search Console export, " +
          "confirmed absent, so this is used instead and never presented as Search Console data) and " +
          "linkedUrlVariants (the actual raw href strings used across the site to reach each page).",
        totalPages: enriched.length,
        pagesWithNoInternalLinks: enriched.filter((p) => p.internalLinkCount === 0).length,
        topLinkedPages: enriched.slice(0, 20).map((p) => ({ sourceFile: p.sourceFile, internalLinkCount: p.internalLinkCount })),
        pages: enriched,
      },
      null,
      2,
    ),
  );

  console.log(`Enriched ${enriched.length} legacy pages with internal-link evidence`);
  console.log(`Pages with zero internal links (from other legacy pages): ${enriched.filter((p) => p.internalLinkCount === 0).length}`);
  console.log(`Wrote ${path.relative(ROOT, outPath)}`);
}

main();
