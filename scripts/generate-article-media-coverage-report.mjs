#!/usr/bin/env node
// Task 15 §24: article-media-coverage report.
//
// Read-only — derived entirely from data/maldives/content/
// article-migration-report.json (scripts/import-legacy-articles.mjs).
// Answers, per article and in aggregate, the exact question Task 15's §1
// audit was built to answer: of the <img> tags actually present in this
// article's own legacy HTML, how many made it into the migrated body?
// (imageCount = every <img>/data-src found; matchedImageCount = how many
// were actually embedded, already filtered to real uploaded-file matches —
// see the img handler in import-legacy-articles.mjs's main()). Nothing
// here is re-derived or re-matched; it only summarizes numbers those
// scripts already computed, so it can never disagree with what actually
// got embedded in each article's body.
//
// Writes: data/maldives/content/article-media-coverage.json
// Usage: node scripts/generate-article-media-coverage-report.mjs

import { existsSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, ROOT } from "./lib/legacy-shared.mjs";

const CONTENT_DATA_DIR = path.join(DATA_DIR, "content");

function main() {
  const reportPath = path.join(CONTENT_DATA_DIR, "article-migration-report.json");
  if (!existsSync(reportPath)) {
    console.error("Run scripts/import-legacy-articles.mjs first (needs data/maldives/content/article-migration-report.json).");
    process.exit(1);
  }
  const articleReport = JSON.parse(readFileSync(reportPath, "utf8"));

  const perArticle = articleReport.articles.map((a) => {
    const coverage = a.imageCount > 0 ? Number((a.matchedImageCount / a.imageCount).toFixed(3)) : null;
    return {
      candidateSlug: a.candidateSlug,
      candidateTitle: a.candidateTitle,
      migrationStatus: a.migrationStatus,
      oldSourceImageCount: a.imageCount,
      embeddedImageCount: a.matchedImageCount,
      coverage,
      hasHeroImage: a.matchedImageCount > 0,
      hasZeroImages: a.imageCount > 0 && a.matchedImageCount === 0,
      hasNoSourceImages: a.imageCount === 0,
    };
  });

  const readyArticles = perArticle.filter((a) => a.migrationStatus === "ready");
  const totalSourceImages = perArticle.reduce((sum, a) => sum + a.oldSourceImageCount, 0);
  const totalEmbeddedImages = perArticle.reduce((sum, a) => sum + a.embeddedImageCount, 0);

  const summary = {
    totalArticles: perArticle.length,
    readyArticles: readyArticles.length,
    totalSourceImagesAcrossAllArticles: totalSourceImages,
    totalEmbeddedImagesAcrossAllArticles: totalEmbeddedImages,
    overallCoverage: totalSourceImages > 0 ? Number((totalEmbeddedImages / totalSourceImages).toFixed(3)) : null,
    readyArticlesWithZeroImages: readyArticles.filter((a) => a.hasZeroImages).length,
    readyArticlesWithNoSourceImages: readyArticles.filter((a) => a.hasNoSourceImages).length,
    readyArticlesWithFullCoverage: readyArticles.filter((a) => a.coverage === 1).length,
    readyArticlesWithPartialCoverage: readyArticles.filter((a) => a.coverage !== null && a.coverage > 0 && a.coverage < 1).length,
  };

  const report = {
    generatedAt: new Date().toISOString(),
    note:
      "Task 15 §24. imageCount/matchedImageCount come directly from " +
      "data/maldives/content/article-migration-report.json (scripts/import-legacy-articles.mjs) — " +
      "matchedImageCount is exactly how many images are actually embedded in each article's migrated " +
      "body (see that script's img-tag handler), never a separate estimate.",
    summary,
    articlesWithZeroImagesDespiteSource: perArticle.filter((a) => a.hasZeroImages).map((a) => a.candidateSlug),
    articles: perArticle,
  };

  const outPath = path.join(CONTENT_DATA_DIR, "article-media-coverage.json");
  writeFileSync(outPath, JSON.stringify(report, null, 2));

  console.log(`Articles: ${summary.totalArticles} (${summary.readyArticles} ready)`);
  console.log(`Source images: ${summary.totalSourceImagesAcrossAllArticles}, embedded: ${summary.totalEmbeddedImagesAcrossAllArticles} (overall coverage ${summary.overallCoverage})`);
  console.log(`Ready articles with zero images despite having source images: ${summary.readyArticlesWithZeroImages}`);
  console.log(`Ready articles with full coverage: ${summary.readyArticlesWithFullCoverage}, partial: ${summary.readyArticlesWithPartialCoverage}`);
  console.log(`Wrote ${path.relative(ROOT, outPath)}`);
}

main();
