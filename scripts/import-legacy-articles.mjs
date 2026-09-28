#!/usr/bin/env node
// Task 14 §12-16: legacy article/Travel Guide extraction.
//
// Reads the "article" pages already classified in
// data/maldives/content/url-inventory.json (built by
// scripts/import-legacy-urls.mjs), cleans each one's real HTML into a
// safe, minimal content representation (stripping legacy nav/footer/
// scripts/comment widgets, keeping real headings/paragraphs/lists/
// images/YouTube embeds), matches its images against the media inventory
// and its mentioned locations/entities against the real MTG catalogue,
// and classifies it into a reusable category.
//
// Writes:
//   data/maldives/content/article-migration-report.json  — per-article report
//   data/maldives/content/articles/<slug>.html            — cleaned body HTML
//
// Read-only by default. Usage:
//   node scripts/import-legacy-articles.mjs            # report only
//   node scripts/import-legacy-articles.mjs --commit   # also emit a SQL migration

import { load as loadHtml } from "cheerio";
import { existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import path from "node:path";

import {
  DATA_DIR,
  RELEASE_DIR,
  ROOT,
  assignUniqueSlug,
  buildEntityIndex,
  deterministicUuid,
  distinctiveTokens,
  slugify,
  storagePathForRelativePath,
  toAsciiSafe,
  tokenOverlapScore,
} from "./lib/legacy-shared.mjs";

const CONTENT_DATA_DIR = path.join(DATA_DIR, "content");
const ARTICLES_OUT_DIR = path.join(CONTENT_DATA_DIR, "articles");
const COMMIT = process.argv.includes("--commit");

// Elements/sections that are legacy chrome, ads, or community features
// (no reviews/comments system in this migration) rather than article
// content — removed before extraction.
const NOISE_SELECTORS = [
  "script", "style", "nav", "form", "iframe:not([src*='youtube']):not([src*='youtu.be'])",
  // The site's shared header/footer are non-standard custom tags
  // (<header2 class="header2 fixed-top">, <footer2>), not <header>/<footer>,
  // so they must be listed explicitly — they aren't scoped out of every
  // page by the .container-based root selection below, and otherwise leak
  // the nav menu ("Home / Articles / Maps / Ferry Schedules / ...") into
  // the extracted article body as if it were real content.
  "header", "header2", "footer", "footer2",
  "[id*='placeholder' i]", "[id*='review' i]", "[class*='review' i]",
  "[id*='comment' i]", "[class*='comment' i]", ".tab.fixed-top",
  "[class*='advert' i]", "[class*='banner-ad' i]", ".breadcrumb",
  // Auto-generated "explore more articles" widget appended to the end of
  // every legacy article page: an image-card grid (each .card with a
  // "card-body aqua-gradient" caption) plus a plain-text fallback link
  // list (ul.pt-3.text-center.text-primary) repeating the same titles.
  // Confirmed present in ~10/48 article pages, always in the trailing
  // ~15% of the document — it is site chrome, not this article's content,
  // and left unstripped it appends a nonsensical stray image/list block
  // to every extracted body.
  ".card:has(.card-body.aqua-gradient)",
  "ul.pt-3.text-center.text-primary",
];

const CATEGORY_RULES = [
  { category: "Airports", test: /airport|international-airport/i },
  { category: "Transportation", test: /transfer|ferry|speedboat|seaplane|transport/i },
  { category: "Diving", test: /diving|scuba|dive site/i },
  { category: "Fishing", test: /fishing/i },
  { category: "Surfing", test: /surfing|surf break/i },
  { category: "Islands", test: /island(?!s? travel)/i },
  { category: "Atolls", test: /atoll/i },
  { category: "Accommodation", test: /resort|hotel|guesthouse|villa|honeymoon|accommodation/i },
  { category: "Culture", test: /culture|religion|people|tradition/i },
  { category: "Food", test: /food|cuisine|restaurant|dining/i },
  { category: "Shopping", test: /shopping|souvenir/i },
  { category: "Travel Tips", test: /budget|tips|best time|season|when to (go|visit)|weather|climate/i },
];

function categorize(title, text) {
  const haystack = `${title ?? ""} ${text.slice(0, 2000)}`;
  for (const rule of CATEGORY_RULES) {
    if (rule.test.test(haystack)) return rule.category;
  }
  return "Maldives Travel";
}

function extractYouTubeId(src) {
  const m = src.match(/youtube\.com\/embed\/([a-zA-Z0-9_-]{6,20})/) || src.match(/youtu\.be\/([a-zA-Z0-9_-]{6,20})/);
  return m ? m[1] : null;
}

// The legacy site's own domain — most images are lazy-loaded via
// data-src="https://maldivestour.guide/images/..." (absolute, self-hosted)
// rather than a relative path. These are ours to migrate, unlike genuinely
// external hosts (Google, placeholder.com, Facebook) that also appear in
// data-src attributes for unrelated widgets.
const SELF_HOSTED_ORIGIN = /^https?:\/\/(?:www\.)?maldivestour\.guide\//i;

/** Site chrome that legitimately exists as a real, matchable file (so it
 * isn't caught by the "confidence" gate below) but is never real article
 * content — the site logo/favicon, reused as a lazy-load placeholder
 * graphic, turns up dozens of times across article bodies (Task 15 §1
 * audit: 37 of 676 newly-includable images were exactly this). */
const NON_CONTENT_FILENAMES = new Set(["icon.png", "icon-og.png", "favicon.ico", "logo.png"]);

/** Normalizes a legacy img src/data-src ("/images/x.webp", "images/x.webp",
 * "https://maldivestour.guide/images/x.webp", "../images/x.webp",
 * "/images/x.webp?v=2", a URL-encoded filename) to the same relativePath
 * shape the media inventory uses. `fromRelPath` (the source HTML file's own
 * path, relative to RELEASE_DIR) resolves "../"-relative references against
 * the page's own directory rather than the release root (Task 15 §3) — a
 * no-op for this batch of articles specifically (none use "../"), but
 * correct for any future page that does.
 */
function normalizeImageSrc(src, fromRelPath) {
  if (!src) return null;
  let value = src.trim();
  if (!value) return null;

  // Strip a query string / hash fragment before anything else — neither
  // is part of the actual file path (Task 15 §3).
  value = value.split("#")[0].split("?")[0];
  if (!value) return null;

  let pathPart;
  if (SELF_HOSTED_ORIGIN.test(value)) {
    pathPart = value.replace(SELF_HOSTED_ORIGIN, "");
  } else if (/^https?:\/\//i.test(value)) {
    return null; // genuinely external image, not ours to migrate
  } else if (value.startsWith("/")) {
    pathPart = value.slice(1);
  } else if (value.startsWith("../") || value.startsWith("./")) {
    // Relative to the linking page's own directory, same resolution used
    // for the Task 14 broken-internal-link check.
    const baseDir = path.posix.dirname(fromRelPath.split(path.sep).join("/"));
    pathPart = path.posix.normalize(path.posix.join(baseDir, value));
  } else {
    pathPart = value;
  }

  // URL-decode a percent-encoded filename (e.g. "Mal%C3%A9") so it can
  // match the inventory's on-disk (decoded) relativePath. Malformed
  // sequences (a stray "%" that isn't real encoding) throw — keep the
  // pre-decode value in that case rather than dropping the reference.
  try {
    pathPart = decodeURIComponent(pathPart);
  } catch {
    // leave as-is
  }

  return pathPart;
}

function main() {
  const urlInventoryPath = path.join(CONTENT_DATA_DIR, "url-inventory.json");
  if (!existsSync(urlInventoryPath)) {
    console.error("Run scripts/import-legacy-urls.mjs first (needs data/maldives/content/url-inventory.json).");
    process.exit(1);
  }
  const urlInventory = JSON.parse(readFileSync(urlInventoryPath, "utf8"));

  const mediaInventoryPath = path.join(DATA_DIR, "media", "media-inventory.json");
  const mediaByPath = new Map();
  if (existsSync(mediaInventoryPath)) {
    const mediaInventory = JSON.parse(readFileSync(mediaInventoryPath, "utf8"));
    for (const f of mediaInventory.files) mediaByPath.set(f.relativePath.toLowerCase(), f);
  } else {
    console.warn("data/maldives/media/media-inventory.json not found — run scripts/import-legacy-media.mjs first for image matching. Continuing without it.");
  }

  // Clear stale output from a previous run — otherwise a slug that no
  // longer gets produced (e.g. a disambiguated "-slug-2" whose duplicate
  // source was later excluded) leaves an orphaned .html file behind that
  // nothing in the current report references.
  rmSync(ARTICLES_OUT_DIR, { recursive: true, force: true });
  mkdirSync(ARTICLES_OUT_DIR, { recursive: true });

  const entities = buildEntityIndex();
  const candidates = urlInventory.pages.filter((p) => p.pageType === "article" && !p.isEmptyOrThin);

  const usedSlugs = new Set();
  const reports = [];

  for (const candidate of candidates) {
    const fullPath = path.join(RELEASE_DIR, candidate.sourceFile);
    const html = readFileSync(fullPath, "utf8");
    const $ = loadHtml(html);

    for (const sel of NOISE_SELECTORS) $(sel).remove();
    $("[class*='readers comment' i]").remove();

    // Find the content root: the container holding the first h1, else body.
    let root = $("body");
    const h1 = $("h1").first();
    if (h1.length) {
      const container = h1.closest(".container");
      if (container.length) root = container;
    }

    // Cut off everything from "Readers Comments" (or similar) onward —
    // it's a community feature we explicitly aren't migrating.
    root.find("h2, h3").each((_, el) => {
      const t = $(el).text().trim().toLowerCase();
      if (/reader|comment|leave a reply|related posts?$/i.test(t)) {
        $(el).nextAll().remove();
        $(el).remove();
      }
    });

    const title = h1.length ? h1.text().replace(/\s+/g, " ").trim() : candidate.title;
    const images = [];
    const videos = [];
    const blocks = [];

    root.find("h1,h2,h3,h4,p,ul,ol,img,iframe,table,blockquote").each((_, el) => {
      const $el = $(el);
      const tag = el.tagName?.toLowerCase();
      if (!tag) return;
      // Skip nodes nested inside an already-processed list/table (avoid
      // double-collecting <li>/<td> text as their own top-level blocks).
      if ($el.parents("ul,ol,table").length > 0 && tag !== "ul" && tag !== "ol" && tag !== "table") return;

      if (tag === "img") {
        const src = normalizeImageSrc($el.attr("data-src") || $el.attr("src"), candidate.sourceFile);
        if (!src) return;
        const match = mediaByPath.get(src.toLowerCase()) ?? null;
        // Task 15 §1 audit finding: Task 14 required "high/medium
        // CONFIDENCE" here, a bar meant for attaching a photo to a
        // specific resort/island/atoll it might not actually depict. That
        // bar makes no sense for embedding an image in the very article
        // that references it — we already know which article it belongs
        // to, because we're reading it out of that article's own HTML. The
        // only real requirement is that the file genuinely exists (so we
        // never render a dead src), which this file — being found by the
        // Task 14 media inventory's filesystem walk — already guarantees.
        // This single change recovered 676 of 833 legacy article images
        // that Task 14 was silently dropping (119 -> 795 embeddable).
        const usable = Boolean(match) && !NON_CONTENT_FILENAMES.has(match.filename.toLowerCase());
        images.push({ src, alt: $el.attr("alt") ?? null, match: match ? { confidence: match.confidence, entityMatch: match.match } : null });
        // Only reference images with a real uploaded file behind them
        // (Task 14: "never claim media was migrated if it wasn't"). An
        // <img> for a file that doesn't exist in the inventory would be a
        // permanently broken image on the live site, so it's dropped here
        // rather than rendered with a dead src. The stored src is the
        // final canonical storage_path (not the raw legacy relativePath)
        // so the article repository never needs to re-derive it later.
        if (usable) {
          blocks.push({
            type: "image",
            storagePath: storagePathForRelativePath(match.relativePath),
            relativePath: match.relativePath,
            width: match.width,
            height: match.height,
            alt: $el.attr("alt") ?? null,
          });
        }
      } else if (tag === "iframe") {
        const videoId = extractYouTubeId($el.attr("src") ?? "");
        if (!videoId) return;
        videos.push({ youtubeId: videoId, title: $el.attr("title") ?? null });
        blocks.push({ type: "video", youtubeId: videoId, title: $el.attr("title") ?? null });
      } else if (tag === "h1") {
        // handled separately as the article title
      } else if (["h2", "h3", "h4"].includes(tag)) {
        const text = $el.text().replace(/\s+/g, " ").trim();
        if (text) blocks.push({ type: "heading", level: Number(tag[1]), text });
      } else if (tag === "p") {
        const text = $el.text().replace(/\s+/g, " ").trim();
        if (text.length > 0) blocks.push({ type: "paragraph", text });
      } else if (tag === "ul" || tag === "ol") {
        const items = $el
          .children("li")
          .map((__, li) => $(li).text().replace(/\s+/g, " ").trim())
          .get()
          .filter(Boolean);
        if (items.length > 0) blocks.push({ type: "list", ordered: tag === "ol", items });
      } else if (tag === "table") {
        // Note: cheerio's .map() flattens array-returning callbacks (like
        // jQuery's), so the per-row cell arrays must be built with .each()
        // into a plain array rather than nested inside an outer .map().
        const rows = [];
        $el.find("tr").each((__, tr) => {
          const cells = $(tr)
            .find("th,td")
            .map((___, cell) => $(cell).text().replace(/\s+/g, " ").trim())
            .get();
          if (cells.length > 0) rows.push(cells);
        });
        if (rows.length > 0) blocks.push({ type: "table", rows });
      } else if (tag === "blockquote") {
        const text = $el.text().replace(/\s+/g, " ").trim();
        if (text) blocks.push({ type: "quote", text });
      }
    });

    // Trailing heading(s) with nothing under them (e.g. a "Questions?" /
    // FAQ heading whose actual content was a comment-form widget already
    // stripped as noise above) — drop them so the article doesn't end on
    // an unanswered question.
    while (blocks.length > 0 && blocks[blocks.length - 1].type === "heading") blocks.pop();

    const plainText = blocks
      .filter((b) => b.type === "paragraph" || b.type === "heading")
      .map((b) => b.text)
      .join(" ");
    const wordCount = plainText.split(/\s+/).filter(Boolean).length;

    // Related entities: title + all text, matched against the real
    // catalogue — never fabricated, only entities that actually exist.
    const textTokens = new Set([...distinctiveTokens(title ?? ""), ...distinctiveTokens(plainText.slice(0, 4000))]);
    const relatedEntities = [];
    const seenEntityKeys = new Set();
    for (const entity of entities) {
      if (entity.type === "country") continue;
      const score = tokenOverlapScore(textTokens, entity.tokens);
      if (score >= 0.5) {
        const key = `${entity.type}:${entity.slug}`;
        if (seenEntityKeys.has(key)) continue;
        seenEntityKeys.add(key);
        relatedEntities.push({ type: entity.type, slug: entity.slug, title: entity.title, href: entity.href, score: Number(score.toFixed(2)) });
      }
    }
    relatedEntities.sort((a, b) => b.score - a.score);

    // Natural in-body contextual links (Task 15 §5-11/§43): link the FIRST
    // mention of each of this article's strongest real related entities,
    // using the same real href buildEntityIndex() already assigned it.
    // Capped at the top 8 entities and one link per entity in the whole
    // article, so this can never become keyword-stuffed - it just makes
    // real, already-existing mentions of real places/entities clickable.
    const topLinkEntities = relatedEntities.filter((e) => e.score >= 0.6).slice(0, 8);
    if (topLinkEntities.length > 0) {
      const linkedEntityKeys = new Set();
      for (const block of blocks) {
        if (block.type !== "paragraph") continue;
        let html = escapeHtml(block.text);
        for (const entity of topLinkEntities) {
          const key = `${entity.type}:${entity.slug}`;
          if (linkedEntityKeys.has(key)) continue;
          const linked = injectFirstEntityLink(html, entity.title, entity.href);
          if (linked !== html) {
            html = linked;
            linkedEntityKeys.add(key);
          }
        }
        if (html !== escapeHtml(block.text)) block.html = html;
      }
    }

    const category = categorize(title, plainText);
    // A title in a non-Latin script (Arabic/Japanese/Korean/Russian/
    // Chinese translations of the same English page) slugifies to nothing
    // usable ("", "-"). Fall back to the (ASCII) source filename for the
    // slug, and force needs-review: this is a single-language (English)
    // site, so a translated duplicate isn't a real standalone article to
    // auto-migrate — it's flagged for a human to decide, not silently
    // published under a garbled slug.
    const hasAsciiTitle = /[a-z0-9]/i.test(slugify(title ?? ""));
    const slugBasis = hasAsciiTitle ? title : path.basename(candidate.sourceFile, ".html");
    const slug = assignUniqueSlug(slugBasis || path.basename(candidate.sourceFile, ".html"), usedSlugs);

    // Exactly the images actually embedded into the body below — see the
    // img handler's `usable` comment for why this is no longer gated by
    // entity-match confidence (Task 15 §1).
    const matchedImages = blocks.filter((b) => b.type === "image");
    let confidence;
    if (!hasAsciiTitle) confidence = "needs-review";
    else if (title && blocks.filter((b) => b.type === "paragraph").length >= 3 && wordCount >= 150) confidence = "high";
    else if (title && wordCount >= 60) confidence = "medium";
    else confidence = "needs-review";

    const cleanHtml = renderHtml(blocks);
    const outFile = path.join(ARTICLES_OUT_DIR, `${slug}.html`);
    writeFileSync(outFile, cleanHtml);

    // Every image actually embedded in cleanHtml above (i.e. already
    // filtered to real uploaded-file matches) — writeCommitMigration uses
    // this directly rather than re-parsing the written HTML file, so the
    // node_media rows it creates can never drift from what the body
    // actually references.
    const embeddedImages = blocks
      .filter((b) => b.type === "image")
      .map((b) => ({ relativePath: b.relativePath, storagePath: b.storagePath, width: b.width, height: b.height }));

    reports.push({
      oldUrl: candidate.oldUrl,
      sourceFile: candidate.sourceFile,
      oldTitle: candidate.title,
      candidateTitle: title,
      candidateSlug: slug,
      candidateNewUrl: `/maldives/travel-guide/${slug}/`,
      category,
      metaDescription: candidate.metaDescription,
      wordCount,
      paragraphCount: blocks.filter((b) => b.type === "paragraph").length,
      headingCount: blocks.filter((b) => b.type === "heading").length,
      imageCount: images.length,
      matchedImageCount: matchedImages.length,
      videoCount: videos.length,
      videos,
      relatedEntities: relatedEntities.slice(0, 8),
      bodyFile: path.relative(ROOT, outFile).split(path.sep).join("/"),
      migrationStatus: confidence === "needs-review" ? "needs-review" : "ready",
      confidence,
      nonEnglishTitle: !hasAsciiTitle,
      embeddedImages,
      relatedArticles: [],
    });
  }

  // Duplicate-content guard: the legacy site has a handful of distinct URLs
  // sharing the exact same article title and near-identical body (e.g.
  // things-to-do-in-maldives-for-couples.html and things-to-do-on-honeymoon.html,
  // both "Romantic Things to Do in the Maldives for Couples"). Migrating
  // every one of those as its own live Travel Guide page would publish
  // duplicate content under separate new URLs — a real SEO regression, not
  // an improvement. Keep only the longest (most complete) one per
  // normalized title as "ready"; downgrade the rest to needs-review so a
  // human decides (merge, keep as a distinct page, or drop) rather than
  // auto-publishing duplicates.
  const byNormalizedTitle = new Map();
  for (const r of reports) {
    if (r.migrationStatus !== "ready" || !r.candidateTitle) continue;
    const key = r.candidateTitle.trim().toLowerCase();
    const group = byNormalizedTitle.get(key) ?? [];
    group.push(r);
    byNormalizedTitle.set(key, group);
  }
  for (const group of byNormalizedTitle.values()) {
    if (group.length < 2) continue;
    group.sort((a, b) => b.wordCount - a.wordCount);
    for (const dup of group.slice(1)) {
      dup.migrationStatus = "needs-review";
      dup.confidence = "needs-review";
      dup.duplicateOfSlug = group[0].candidateSlug;
    }
  }

  // Article-to-article relatedness (Task 15 §5-11 "other-article"): two
  // READY articles that reference several of the SAME real entities (same
  // resort/island/dive site/...) are genuinely related content. Reusing the
  // relatedEntities already matched above (real catalogue matches only)
  // instead of a second freeform text-similarity heuristic keeps this
  // natural/editorial rather than keyword-stuffed, and never fabricates a
  // relationship between two articles that merely happen to share common
  // words.
  const readyReports = reports.filter((r) => r.migrationStatus === "ready");
  for (const a of readyReports) {
    const aKeys = new Set(a.relatedEntities.map((e) => `${e.type}:${e.slug}`));
    if (aKeys.size === 0) continue;
    const scored = [];
    for (const b of readyReports) {
      if (b === a) continue;
      let sharedEntityCount = 0;
      for (const e of b.relatedEntities) if (aKeys.has(`${e.type}:${e.slug}`)) sharedEntityCount += 1;
      if (sharedEntityCount > 0) {
        scored.push({ slug: b.candidateSlug, title: b.candidateTitle, href: b.candidateNewUrl, sharedEntityCount });
      }
    }
    scored.sort((x, y) => y.sharedEntityCount - x.sharedEntityCount);
    a.relatedArticles = scored.slice(0, 4);
  }

  const byConfidence = { high: 0, medium: 0, "needs-review": 0 };
  for (const r of reports) byConfidence[r.confidence] += 1;
  const byCategory = {};
  for (const r of reports) byCategory[r.category] = (byCategory[r.category] ?? 0) + 1;

  writeFileSync(
    path.join(CONTENT_DATA_DIR, "article-migration-report.json"),
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        totalCandidates: candidates.length,
        totalExtracted: reports.length,
        byConfidence,
        byCategory,
        articles: reports,
      },
      null,
      2,
    ),
  );

  console.log(`Extracted ${reports.length} candidate articles from ${candidates.length} classified article pages`);
  console.log("By confidence:", byConfidence);
  console.log("By category:", byCategory);
  console.log("Wrote data/maldives/content/article-migration-report.json and data/maldives/content/articles/*.html");

  if (COMMIT) {
    writeCommitMigration(reports.filter((r) => r.migrationStatus === "ready"));
  } else {
    console.log("\n(dry run — pass --commit to also emit a SQL migration for ready articles)");
  }
}

function escapeHtml(value) {
  return String(value).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}

/** Wraps the first case-insensitive, word-bounded match of `entityTitle`
 * inside an already-HTML-escaped paragraph string with a real link to
 * `href`. Never matches inside a previously injected <a>...</a> (so two
 * entities whose names overlap can't nest), and never partial-word matches
 * ("Male" inside "Female"). Returns `escapedText` unchanged if no safe
 * match is found. */
function injectFirstEntityLink(escapedText, entityTitle, href) {
  const escapedTitle = escapeHtml(entityTitle);
  if (escapedTitle.length < 4) return escapedText;
  const idx = escapedText.toLowerCase().indexOf(escapedTitle.toLowerCase());
  if (idx === -1) return escapedText;

  const before = escapedText[idx - 1];
  const after = escapedText[idx + escapedTitle.length];
  if (before && /[a-zA-Z0-9]/.test(before)) return escapedText;
  if (after && /[a-zA-Z0-9]/.test(after)) return escapedText;

  const priorOpenAnchor = escapedText.lastIndexOf("<a ", idx);
  const priorCloseAnchor = escapedText.lastIndexOf("</a>", idx);
  if (priorOpenAnchor > priorCloseAnchor) return escapedText; // already inside a link

  return (
    escapedText.slice(0, idx) +
    `<a href="${escapeHtml(href)}">` +
    escapedText.slice(idx, idx + escapedTitle.length) +
    "</a>" +
    escapedText.slice(idx + escapedTitle.length)
  );
}

// No HTML tag allow-list check is needed here: unlike a sanitizer that
// filters arbitrary input HTML, this regenerates output from scratch out
// of a small fixed set of block types (heading/paragraph/list/image/video/
// table/quote), each with a hardcoded tag and every text value passed
// through escapeHtml() — there is no code path that could ever emit a tag
// or raw fragment taken directly from the source page. The one exception,
// a paragraph's optional `b.html`, is never source-page HTML either — it's
// built exclusively by injectFirstEntityLink() above from an already
// escapeHtml()'d string plus a real, internally-generated href.
function renderHtml(blocks) {
  const parts = [];
  for (const b of blocks) {
    if (b.type === "heading") parts.push(`<h${b.level}>${escapeHtml(b.text)}</h${b.level}>`);
    else if (b.type === "paragraph") parts.push(`<p>${b.html ?? escapeHtml(b.text)}</p>`);
    else if (b.type === "list") {
      const tag = b.ordered ? "ol" : "ul";
      parts.push(`<${tag}>${b.items.map((i) => `<li>${escapeHtml(i)}</li>`).join("")}</${tag}>`);
    } else if (b.type === "image") {
      // b.storagePath is the final canonical Storage path (see the img
      // handler above) — the article repository resolves it to a public
      // URL at render time via the same helper the hero/gallery images use,
      // never a raw legacy-site path.
      parts.push(`<figure><img src="${escapeHtml(b.storagePath)}" alt="${escapeHtml(b.alt ?? "")}" loading="lazy" /></figure>`);
    } else if (b.type === "video") {
      parts.push(`<div data-youtube-id="${escapeHtml(b.youtubeId)}" data-video-title="${escapeHtml(b.title ?? "")}"></div>`);
    } else if (b.type === "table") {
      const rows = b.rows.map((r) => `<tr>${r.map((c) => `<td>${escapeHtml(c)}</td>`).join("")}</tr>`).join("");
      parts.push(`<table><tbody>${rows}</tbody></table>`);
    } else if (b.type === "quote") {
      parts.push(`<blockquote>${escapeHtml(b.text)}</blockquote>`);
    }
  }
  return parts.join("\n");
}

function sqlString(value) {
  if (value === null || value === undefined) return "null";
  return `'${toAsciiSafe(value).replace(/'/g, "''")}'`;
}

// Task 15 §5-11: entity types whose node_type is 'location' (atoll/island/
// dive_site/surf_break all share that node_type in the schema — see
// supabase/migrations/20250101000300_nodes.sql) reuse the EXISTING
// node_locations table (Task 14 already wired island/atoll through it).
// Everything else gets the new generic node_relationships table below —
// never a second location-relationship system for the same node_type.
const LOCATION_ENTITY_TYPES = new Set(["atoll", "island", "dive_site", "surf_break"]);

// Maps a buildEntityIndex() entity `type` to the `nodes.node_type` it's
// actually stored under (accommodation subtypes and diving/fishing/surfing
// activities all collapse to one shared node_type in the schema).
const ENTITY_TYPE_TO_NODE_TYPE = {
  hotel: "accommodation",
  resort: "accommodation",
  guesthouse: "accommodation",
  villa: "accommodation",
  other: "accommodation",
  activity: "activity",
  diving: "activity",
  fishing: "activity",
  surfing: "activity",
  package: "package",
  transfer_route: "transfer_route",
};

const CATEGORY_SLUGS = {
  "Maldives Travel": "maldives-travel",
  Transportation: "transportation",
  Airports: "airports",
  Islands: "islands",
  Atolls: "atolls",
  Accommodation: "accommodation",
  Diving: "diving",
  Fishing: "fishing",
  Surfing: "surfing",
  Culture: "culture",
  Food: "food",
  Shopping: "shopping",
  Maps: "maps",
  "Travel Tips": "travel-tips",
};

function writeCommitMigration(readyArticles) {
  const lines = [];
  lines.push("-- Task 14: legacy Travel Guide articles migrated into the existing");
  lines.push("-- `articles` table (Task 2/3 foundation - no new content system).");
  lines.push("-- GENERATED FILE - do not hand-edit. Regenerate with:");
  lines.push("--   node scripts/import-legacy-articles.mjs --commit");
  lines.push("-- Source: data/maldives/content/article-migration-report.json (status=ready).");
  lines.push("--");
  lines.push("-- Article category nodes are created on first use only (Task 14 section 16 -");
  lines.push("-- no empty categories). Content/hero image node_media rows reuse the");
  lines.push("-- SAME deterministic media_assets ids scripts/import-legacy-media.mjs");
  lines.push("-- generates for the same source file, so running both migrations never");
  lines.push("-- creates duplicate media_assets rows for one physical image.");
  lines.push("");

  const usedCategories = new Set(readyArticles.map((a) => a.category));
  if (usedCategories.size > 0) {
    lines.push("-- Article categories actually used by migrated content.");
    for (const cat of usedCategories) {
      const catSlug = CATEGORY_SLUGS[cat] ?? slugify(cat);
      // Every statement below is emitted as ONE line (never split across
      // several lines.push calls) — a multi-line statement pasted into the
      // Supabase SQL Editor has been observed arriving at Postgres split
      // apart (e.g. "on conflict ..." submitted as its own query, which
      // isn't valid standalone SQL even though the full statement is).
      // One line per statement is immune to that regardless of cause.
      lines.push(
        `insert into nodes (node_type, slug, title, status, published_at) values ('category', ${sqlString(catSlug)}, ${sqlString(cat)}, 'published', now()) on conflict (node_type, slug) do nothing;`,
      );
      lines.push("");
      lines.push(
        `insert into categories (id, category_group, path) select id, 'article-category', text2ltree(${sqlString(catSlug.replace(/-/g, "_"))}) from nodes where node_type = 'category' and slug = ${sqlString(catSlug)} on conflict (id) do nothing;`,
      );
      lines.push("");
    }
  }

  let articleCount = 0;
  let mediaCount = 0;
  let attachCount = 0;
  let locationTagCount = 0;
  let relationshipCount = 0;
  const uploadManifest = [];

  for (const article of readyArticles) {
    const catSlug = CATEGORY_SLUGS[article.category] ?? slugify(article.category);
    const bodyHtml = readFileSync(path.join(ROOT, article.bodyFile), "utf8");
    const metaTitle = `${article.candidateTitle} | Maldives Travel Guide | MTG`;
    const metaDescription = article.metaDescription ?? article.candidateTitle;
    const summary = (article.metaDescription ?? article.candidateTitle ?? "").slice(0, 300);
    const readingMinutes = Math.max(1, Math.round(article.wordCount / 200));

    lines.push(`-- Article: ${toAsciiSafe(article.candidateTitle)}`);
    lines.push(
      `insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, legacy_slugs, published_at) values ('article', ${sqlString(article.candidateSlug)}, ${sqlString(article.candidateTitle)}, ${sqlString(summary)}, 'published', ${sqlString(metaTitle)}, ${sqlString(metaDescription)}, ARRAY[${sqlString(article.oldUrl)}]::text[], now()) on conflict (node_type, slug) do nothing;`,
    );
    lines.push("");

    // The on-disk body HTML has one real newline per paragraph/block (see
    // renderHtml in main()) for human readability. Embedding those raw
    // newlines inside this statement's string literal was assumed safe —
    // a SQL client has to track quote state to paste large content like
    // this at all — but that assumption was wrong: pasted into the
    // Supabase SQL Editor, a large multi-line string literal has been
    // observed getting split mid-string, desynchronizing quote parsing for
    // everything after it (observed: a word from the article prose,
    // "crystal", showing up as an undefined relation). Stripping the
    // newlines here (only for the SQL value — the .html file on disk is
    // untouched) makes every statement a genuinely single physical line,
    // immune to any client that isn't fully SQL-string-aware.
    const bodyHtmlForSql = bodyHtml.replace(/\r?\n/g, "");
    // Unlike every other statement in this file, this one intentionally
    // UPDATEs on conflict rather than doing nothing: `body` is exactly the
    // content this generator keeps iterating on (Task 15 recovered 676
    // previously-dropped images, then added in-body entity links, both
    // AFTER many users' databases already had the Task 14 version of this
    // row) — "do nothing" would silently leave their live body stale on
    // every re-run, defeating the entire point of re-running the file.
    lines.push(
      `insert into articles (id, body, reading_time_minutes) select id, ${sqlString(bodyHtmlForSql)}, ${readingMinutes} from nodes where node_type = 'article' and slug = ${sqlString(article.candidateSlug)} on conflict (id) do update set body = excluded.body, reading_time_minutes = excluded.reading_time_minutes;`,
    );
    lines.push("");
    articleCount += 1;

    lines.push(
      `insert into node_categories (node_id, category_id) select n.id, c.id from nodes n, nodes c where n.node_type = 'article' and n.slug = ${sqlString(article.candidateSlug)} and c.node_type = 'category' and c.slug = ${sqlString(catSlug)} on conflict (node_id, category_id) do nothing;`,
    );
    lines.push("");

    // Related location entities (atoll/island/dive_site/surf_break all
    // share node_type='location' - Task 15 §5-11) -> node_locations
    // (secondary — an article isn't primarily "about" one place the way an
    // accommodation is). Reuses the same table Task 14 already wired up for
    // island/atoll rather than adding a second location-relationship system.
    for (const rel of article.relatedEntities.filter((e) => LOCATION_ENTITY_TYPES.has(e.type))) {
      lines.push(
        `insert into node_locations (node_id, location_id, relation) select n.id, l.id, 'secondary' from nodes n, nodes l where n.node_type = 'article' and n.slug = ${sqlString(article.candidateSlug)} and l.node_type = 'location' and l.slug = ${sqlString(rel.slug)} on conflict (node_id, location_id) do nothing;`,
      );
      lines.push("");
      locationTagCount += 1;
    }

    // Every other related entity type (accommodation/activity/diving/
    // fishing/surfing/package/transfer_route) -> the generic
    // node_relationships table (Task 15 §5-11), keyed by real matches only
    // (article.relatedEntities never contains a fabricated entity).
    for (const rel of article.relatedEntities) {
      if (LOCATION_ENTITY_TYPES.has(rel.type) || rel.type === "country") continue;
      const relatedNodeType = ENTITY_TYPE_TO_NODE_TYPE[rel.type];
      if (!relatedNodeType) continue;
      lines.push(
        `insert into node_relationships (node_id, related_node_id, relation_type, confidence) select n.id, r.id, 'related', ${rel.score} from nodes n, nodes r where n.node_type = 'article' and n.slug = ${sqlString(article.candidateSlug)} and r.node_type = ${sqlString(relatedNodeType)} and r.slug = ${sqlString(rel.slug)} on conflict (node_id, related_node_id, relation_type) do nothing;`,
      );
      lines.push("");
      relationshipCount += 1;
    }

    // Content images actually embedded in this article's body (already
    // filtered to real uploaded-file matches when the body was rendered —
    // see the img handler in main()). Using article.embeddedImages
    // directly, rather than re-parsing bodyHtml, guarantees these
    // node_media rows can never drift from what the stored body actually
    // references.
    article.embeddedImages.forEach((m, index) => {
      const mediaKey = `legacy-media::${m.relativePath}`;
      const mediaId = deterministicUuid(mediaKey);
      const storagePath = m.storagePath;

      lines.push(
        `insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values (${sqlString(mediaId)}::uuid, 'image', ${sqlString(storagePath)}, ${sqlString(article.candidateTitle)}, ${sqlString("Legacy MTG site archive")}, ${m.width ?? "null"}, ${m.height ?? "null"}) on conflict (id) do nothing;`,
      );
      lines.push("");
      mediaCount += 1;
      uploadManifest.push({ mediaId, relativePath: m.relativePath, storagePath });

      const role = index === 0 ? "hero" : "content";
      lines.push(
        `insert into node_media (node_id, media_id, role, sort_order) select n.id, ${sqlString(mediaId)}::uuid, ${sqlString(role)}, ${index} from nodes n where n.node_type = 'article' and n.slug = ${sqlString(article.candidateSlug)} on conflict (node_id, media_id, role) do nothing;`,
      );
      lines.push("");
      attachCount += 1;
    });
  }

  // Article-to-article relatedness (computed above, from shared real
  // entities) is inserted only AFTER every article node above has been
  // created — not interleaved into the per-article loop. An article's
  // relatedArticles can point at an article that hasn't been inserted YET
  // in file order (they aren't alphabetical), so an interleaved insert's
  // `nodes n, nodes r where r.node_type = 'article' and r.slug = ...` join
  // would silently match zero rows for a forward reference and only
  // self-heal on a second re-run — caught by a from-scratch local Postgres
  // apply (Task 15 §31/§54), fixed by this separate second pass instead.
  lines.push("-- Article-to-article relationships (all articles above must exist first).");
  for (const article of readyArticles) {
    article.relatedArticles.forEach((rel, idx) => {
      lines.push(
        `insert into node_relationships (node_id, related_node_id, relation_type, sort_order) select n.id, r.id, 'related', ${idx} from nodes n, nodes r where n.node_type = 'article' and n.slug = ${sqlString(article.candidateSlug)} and r.node_type = 'article' and r.slug = ${sqlString(rel.slug)} on conflict (node_id, related_node_id, relation_type) do nothing;`,
      );
      lines.push("");
      relationshipCount += 1;
    });
  }

  const migrationPath = path.join(ROOT, "supabase", "migrations", "20250110000300_legacy_articles.sql");
  writeFileSync(migrationPath, lines.join("\n") + "\n");
  console.log(`\nWrote ${migrationPath}`);
  console.log(`  articles: ${articleCount}, categories used: ${usedCategories.size}, media_assets: ${mediaCount}, node_media: ${attachCount}, location tags: ${locationTagCount}, entity/article relationships: ${relationshipCount}`);

  const manifestPath = path.join(CONTENT_DATA_DIR, "article-storage-manifest.json");
  writeFileSync(manifestPath, JSON.stringify({ generatedAt: new Date().toISOString(), files: uploadManifest }, null, 2));
  console.log(`  Wrote ${path.relative(ROOT, manifestPath)} (${uploadManifest.length} files)`);
}

main();
