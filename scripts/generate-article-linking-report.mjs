#!/usr/bin/env node
// Task 15 §25: article-linking report.
//
// Read-only — derived entirely from data/maldives/content/
// article-migration-report.json and the cleaned article body files it
// references (data/maldives/content/articles/*.html), both written by
// scripts/import-legacy-articles.mjs. Summarizes, per article and in
// aggregate, how the Task 15 §5-11 entity-linking system actually landed:
// how many real related entities/articles were matched, how many of those
// became a natural in-body link (injectFirstEntityLink()), and how many
// articles have no related content at all (so the "Related" UI sections
// correctly render nothing rather than an empty shell — see
// src/components/articles/article-detail-page.tsx).
//
// Writes: data/maldives/content/article-linking-report.json
// Usage: node scripts/generate-article-linking-report.mjs

import { existsSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, ROOT } from "./lib/legacy-shared.mjs";

const CONTENT_DATA_DIR = path.join(DATA_DIR, "content");

const LOCATION_ENTITY_TYPES = new Set(["atoll", "island", "dive_site", "surf_break"]);

function countInBodyLinks(bodyFile) {
  const fullPath = path.join(ROOT, bodyFile);
  if (!existsSync(fullPath)) return 0;
  const html = readFileSync(fullPath, "utf8");
  const matches = html.match(/<a href="/g);
  return matches ? matches.length : 0;
}

function main() {
  const reportPath = path.join(CONTENT_DATA_DIR, "article-migration-report.json");
  if (!existsSync(reportPath)) {
    console.error("Run scripts/import-legacy-articles.mjs --commit first (needs article-migration-report.json with relatedArticles populated).");
    process.exit(1);
  }
  const articleReport = JSON.parse(readFileSync(reportPath, "utf8"));
  const readyArticles = articleReport.articles.filter((a) => a.migrationStatus === "ready");

  const byEntityType = {};
  let totalLocationTags = 0;
  let totalEntityRelationships = 0;
  let totalArticleRelationships = 0;
  let totalInBodyLinks = 0;
  let articlesWithNoRelatedContent = 0;

  const perArticle = readyArticles.map((a) => {
    const locationEntities = a.relatedEntities.filter((e) => LOCATION_ENTITY_TYPES.has(e.type));
    const otherEntities = a.relatedEntities.filter((e) => !LOCATION_ENTITY_TYPES.has(e.type) && e.type !== "country");
    const relatedArticles = a.relatedArticles ?? [];
    const inBodyLinks = countInBodyLinks(a.bodyFile);

    for (const e of a.relatedEntities) byEntityType[e.type] = (byEntityType[e.type] ?? 0) + 1;
    totalLocationTags += locationEntities.length;
    totalEntityRelationships += otherEntities.length;
    totalArticleRelationships += relatedArticles.length;
    totalInBodyLinks += inBodyLinks;

    const hasAnyRelatedContent = locationEntities.length > 0 || otherEntities.length > 0 || relatedArticles.length > 0;
    if (!hasAnyRelatedContent) articlesWithNoRelatedContent += 1;

    return {
      candidateSlug: a.candidateSlug,
      candidateTitle: a.candidateTitle,
      relatedLocationCount: locationEntities.length,
      relatedEntityCount: otherEntities.length,
      relatedEntityTypes: [...new Set(otherEntities.map((e) => e.type))],
      relatedArticleCount: relatedArticles.length,
      inBodyLinkCount: inBodyLinks,
      hasAnyRelatedContent,
    };
  });

  const summary = {
    totalReadyArticles: readyArticles.length,
    byRelatedEntityType: byEntityType,
    totalLocationTags,
    totalNonLocationEntityRelationships: totalEntityRelationships,
    totalArticleToArticleRelationships: totalArticleRelationships,
    totalNodeRelationshipRows: totalEntityRelationships + totalArticleRelationships,
    totalInBodyContextualLinks: totalInBodyLinks,
    articlesWithNoRelatedContent,
    articlesWithAtLeastOneRelatedArticle: perArticle.filter((a) => a.relatedArticleCount > 0).length,
    articlesWithAtLeastOneInBodyLink: perArticle.filter((a) => a.inBodyLinkCount > 0).length,
  };

  const report = {
    generatedAt: new Date().toISOString(),
    note:
      "Task 15 §25. Every number here reflects real, already-generated data: relatedEntities/relatedArticles from " +
      "data/maldives/content/article-migration-report.json (Task 14's token-overlap matching against the real MTG " +
      "catalogue, persisted to node_relationships by scripts/import-legacy-articles.mjs's writeCommitMigration), and " +
      "in-body link counts read directly from each article's cleaned body HTML. Nothing here is a separate estimate.",
    summary,
    articlesWithNoRelatedContent: perArticle.filter((a) => !a.hasAnyRelatedContent).map((a) => a.candidateSlug),
    articles: perArticle,
  };

  const outPath = path.join(CONTENT_DATA_DIR, "article-linking-report.json");
  writeFileSync(outPath, JSON.stringify(report, null, 2));

  console.log(`Ready articles: ${summary.totalReadyArticles}`);
  console.log(`Related entity types found:`, summary.byRelatedEntityType);
  console.log(`Location tags: ${summary.totalLocationTags}, other entity relationships: ${summary.totalNonLocationEntityRelationships}, article-to-article: ${summary.totalArticleToArticleRelationships}`);
  console.log(`In-body contextual links: ${summary.totalInBodyContextualLinks}`);
  console.log(`Articles with no related content at all: ${summary.articlesWithNoRelatedContent}`);
  console.log(`Wrote ${path.relative(ROOT, outPath)}`);
}

main();
