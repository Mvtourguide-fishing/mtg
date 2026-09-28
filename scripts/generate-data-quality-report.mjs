#!/usr/bin/env node
// Task 14 §31: consolidated data-quality report for the legacy migration.
// Read-only — combines/derives from the reports the other migration
// scripts already wrote (url-inventory.json, media-match-report.json,
// media-duplicates.json, article-migration-report.json) plus two checks
// that don't belong in any single one of those scripts: duplicate page
// titles across the WHOLE legacy site (not just articles), and broken
// internal links within the legacy site itself. Deletes nothing, changes
// nothing — output only, for human review.
//
// Usage: node scripts/generate-data-quality-report.mjs

import { existsSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, RELEASE_DIR, ROOT } from "./lib/legacy-shared.mjs";

const CONTENT_DATA_DIR = path.join(DATA_DIR, "content");
const SELF_HOSTED_ORIGIN = /^https?:\/\/(?:www\.)?maldivestour\.guide\//i;

function loadJsonIfExists(fullPath) {
  if (!existsSync(fullPath)) return null;
  return JSON.parse(readFileSync(fullPath, "utf8"));
}

/** Resolves an <a href="..."> value found on `fromRelPath` to a
 * RELEASE_DIR-relative path, or null if it isn't a same-site link worth
 * checking (external host, mailto:, tel:, a bare hash/query, etc). */
function resolveInternalHref(href, fromRelPath) {
  if (!href) return null;
  const trimmed = href.trim();
  if (!trimmed || trimmed.startsWith("#") || trimmed.startsWith("mailto:") || trimmed.startsWith("tel:") || trimmed.startsWith("javascript:")) return null;

  let pathPart;
  if (SELF_HOSTED_ORIGIN.test(trimmed)) {
    pathPart = trimmed.replace(SELF_HOSTED_ORIGIN, "");
  } else if (/^https?:\/\//i.test(trimmed)) {
    return null; // genuinely external
  } else if (trimmed.startsWith("/")) {
    pathPart = trimmed.slice(1);
  } else {
    // Relative to the linking page's own directory.
    pathPart = path.posix.join(path.posix.dirname(fromRelPath.split(path.sep).join("/")), trimmed);
  }

  // Strip query string / hash fragment.
  pathPart = pathPart.split("#")[0].split("?")[0];
  if (!pathPart) return null;
  // A directory-style link ("/atolls/") implicitly means its index.html —
  // out of scope for this check (the legacy site has no per-directory
  // index files we've observed); only flag links that clearly name a file.
  if (pathPart.endsWith("/")) return null;
  return pathPart;
}

function findBrokenLinks(pages) {
  const brokenByTarget = new Map(); // missing target -> [{from, href}]
  let totalInternalLinksChecked = 0;

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
      const target = resolveInternalHref(m[1], page.sourceFile);
      if (!target) continue;
      // Only check links that look like they point at this same release
      // tree's HTML pages — images/css/js broken links are a separate
      // (media) concern already covered by the media-match report.
      if (!target.toLowerCase().endsWith(".html")) continue;
      totalInternalLinksChecked += 1;

      const targetFull = path.join(RELEASE_DIR, target);
      if (existsSync(targetFull)) continue;

      const list = brokenByTarget.get(target) ?? [];
      list.push(page.sourceFile);
      brokenByTarget.set(target, list);
    }
  }

  const broken = Array.from(brokenByTarget.entries())
    .map(([target, linkedFrom]) => ({ target, linkedFromCount: linkedFrom.length, linkedFromSample: linkedFrom.slice(0, 5) }))
    .sort((a, b) => b.linkedFromCount - a.linkedFromCount);

  return { totalInternalLinksChecked, brokenTargetCount: broken.length, broken };
}

function findDuplicateTitles(pages) {
  const byTitle = new Map();
  for (const page of pages) {
    if (!page.title) continue;
    const key = page.title.trim().toLowerCase();
    if (!key) continue;
    const list = byTitle.get(key) ?? [];
    list.push(page.sourceFile);
    byTitle.set(key, list);
  }

  return Array.from(byTitle.entries())
    .filter(([, files]) => files.length > 1)
    .map(([title, files]) => ({ title, count: files.length, sourceFiles: files }))
    .sort((a, b) => b.count - a.count);
}

function main() {
  const urlInventory = loadJsonIfExists(path.join(CONTENT_DATA_DIR, "url-inventory.json"));
  if (!urlInventory) {
    console.error("Run scripts/import-legacy-urls.mjs first (needs data/maldives/content/url-inventory.json).");
    process.exit(1);
  }
  const mediaMatchReport = loadJsonIfExists(path.join(DATA_DIR, "media", "media-match-report.json"));
  const mediaDuplicates = loadJsonIfExists(path.join(DATA_DIR, "media", "media-duplicates.json"));
  const articleReport = loadJsonIfExists(path.join(CONTENT_DATA_DIR, "article-migration-report.json"));
  const transferReport = loadJsonIfExists(path.join(CONTENT_DATA_DIR, "transfer-migration-report.json"));
  const packageReport = loadJsonIfExists(path.join(CONTENT_DATA_DIR, "package-migration-report.json"));

  const pages = urlInventory.pages;
  const duplicateTitles = findDuplicateTitles(pages);
  const linkCheck = findBrokenLinks(pages);

  const report = {
    generatedAt: new Date().toISOString(),
    note:
      "Read-only Task 14 data-quality summary. Nothing here was deleted or modified — it's an input to human review, " +
      "same as media-match-report.json and article-migration-report.json.",
    pages: {
      totalClassified: pages.length,
      emptyOrThinCount: urlInventory.emptyOrThinPages?.length ?? 0,
      emptyOrThinPages: urlInventory.emptyOrThinPages ?? [],
      // Task 15 §50: real content sub-type within the coarse "package"/
      // "transfer" pageType buckets (booking-form widgets, B2B
      // partner-recruitment pages, generic templated marketing, real
      // structured content) — see classifyContentSubType() in
      // scripts/import-legacy-urls.mjs.
      byContentSubType: urlInventory.byContentSubType ?? null,
    },
    duplicateTitles: {
      groupCount: duplicateTitles.length,
      totalDuplicatePages: duplicateTitles.reduce((sum, g) => sum + g.count, 0),
      groups: duplicateTitles,
    },
    brokenInternalLinks: linkCheck,
    media: mediaMatchReport
      ? {
          totalFiles: mediaMatchReport.totalFiles,
          confidenceCounts: mediaMatchReport.counts,
          unmatchedCount: mediaMatchReport.unmatchedCount,
        }
      : null,
    mediaDuplicates: mediaDuplicates
      ? {
          exactDuplicateGroups: mediaDuplicates.exactDuplicateGroups,
          exactDuplicateFiles: mediaDuplicates.exactDuplicateFiles,
          duplicateFilenameGroups: mediaDuplicates.duplicateFilenameGroups,
          suspiciousFileCount: mediaDuplicates.suspiciousFileCount,
        }
      : null,
    articles: articleReport
      ? {
          totalCandidates: articleReport.totalCandidates,
          byConfidence: articleReport.byConfidence,
          nonEnglishExcluded: articleReport.articles.filter((a) => a.nonEnglishTitle).length,
          duplicateContentExcluded: articleReport.articles.filter((a) => a.duplicateOfSlug).length,
        }
      : null,
    // Task 15 §22-23/§51.
    transfers: transferReport
      ? {
          totalPages: transferReport.totalTransferPages,
          byMigrationStatus: transferReport.byMigrationStatus,
          alreadyCoveredNotDuplicated: transferReport.pages.filter((p) => p.migrationStatus === "already-covered").length,
        }
      : null,
    packages: packageReport
      ? {
          totalPages: packageReport.totalPackagePages,
          byMigrationStatus: packageReport.byMigrationStatus,
          byPageSubType: packageReport.byPageSubType,
          // Legacy pages that published a star rating / review count with
          // no real, checkable review data behind it (e.g. "5.0 (128
          // reviews)" on a page naming no specific resort) — a genuine
          // "outdated/untrustworthy content" flag worth a human's
          // attention, never migrated as if it were real (Task 15 §22-23).
          fabricatedTrustSignalPages: packageReport.pages.filter((p) => p.hasFabricatedRating).map((p) => p.sourceFile),
        }
      : null,
  };

  const outPath = path.join(CONTENT_DATA_DIR, "data-quality-report.json");
  writeFileSync(outPath, JSON.stringify(report, null, 2));

  console.log(`Pages classified: ${report.pages.totalClassified} (${report.pages.emptyOrThinCount} empty/thin)`);
  console.log(`Duplicate title groups: ${report.duplicateTitles.groupCount} (${report.duplicateTitles.totalDuplicatePages} pages total)`);
  console.log(`Internal links checked: ${linkCheck.totalInternalLinksChecked}, broken targets: ${linkCheck.brokenTargetCount}`);
  if (report.media) console.log(`Media confidence counts:`, report.media.confidenceCounts, `unmatched: ${report.media.unmatchedCount}`);
  if (report.mediaDuplicates)
    console.log(
      `Media exact-duplicate groups: ${report.mediaDuplicates.exactDuplicateGroups} (${report.mediaDuplicates.exactDuplicateFiles} redundant files)`,
    );
  if (report.articles) console.log(`Article candidates: ${report.articles.totalCandidates}`, report.articles.byConfidence);
  if (report.transfers) console.log(`Transfer pages: ${report.transfers.totalPages}`, report.transfers.byMigrationStatus);
  if (report.packages) {
    console.log(`Package pages: ${report.packages.totalPages}`, report.packages.byMigrationStatus);
    console.log(`Package pages with a fabricated trust signal: ${report.packages.fabricatedTrustSignalPages.length}`);
  }
  console.log(`Wrote ${path.relative(ROOT, outPath)}`);
}

main();
