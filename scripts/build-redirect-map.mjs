#!/usr/bin/env node
// Task 16: the SEO URL migration decision engine.
//
// For every legacy page in data/maldives/migration/legacy-url-inventory.json,
// decides one of: keep / redirect / consolidate / retire / review (Task 16
// §5), using ONLY verified real destinations — the same real MTG entity
// catalogue (buildEntityIndex(), scripts/lib/legacy-shared.mjs) and the
// same already-verified Task 14/15 migration reports (articles/transfers/
// packages) every other migration script in this repo uses. Never invents
// a mapping; every "redirect"/"consolidate" carries a real, verified new
// URL and a documented reason.
//
// Writes:
//   data/maldives/migration/redirect-map.json      (redirect/consolidate)
//   data/maldives/migration/redirect-review.json    (review)
//   data/maldives/migration/redirect-coverage.json  (summary, by type)
//
// Usage: node scripts/build-redirect-map.mjs

import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import {
  ATOLL_FOLDER_TO_CODE,
  DATA_DIR,
  buildEntityIndex,
  distinctiveTokens,
  tokenOverlapScore,
} from "./lib/legacy-shared.mjs";

const CONTENT_DATA_DIR = path.join(DATA_DIR, "content");
const MIGRATION_DATA_DIR = path.join(DATA_DIR, "migration");
const CONFIDENT = 0.6;

function loadJsonIfExists(fullPath) {
  if (!existsSync(fullPath)) return null;
  return JSON.parse(readFileSync(fullPath, "utf8"));
}

function toOldUrl(sourceFile) {
  return `/${sourceFile}`;
}

/** buildEntityIndex() adds each atoll's own administrative_code as a
 * token (e.g. "b" for Baa Atoll, "k" for Kaafu Atoll — 8 of the 20
 * atolls have single-letter codes). A bare single-character token is
 * never going to appear in real legacy filenames/titles, but it still
 * counts toward tokenOverlapScore's union denominator AND toward the
 * function's "full containment" floor's entityTokens.size check — for a
 * short atoll name like "Baa Atoll" (one real token after "atoll" is
 * stripped as a stopword: "baa"), that extra single-letter token alone
 * drags a genuine match (baa-atoll-map.html → Baa Atoll) below the
 * confidence threshold. Filtered out here, locally, rather than in
 * scripts/lib/legacy-shared.mjs — that module is shared by the already-
 * shipped Task 14/15 scripts and changing its scoring there is a wider
 * blast radius than this task needs. */
function stripShortTokens(tokens) {
  return new Set([...tokens].filter((t) => t.length > 1));
}

/** Best token-overlap match of `searchText` against a pool of
 * buildEntityIndex() entities — identical method/threshold used
 * throughout Tasks 14-15 (never a new heuristic), with stripShortTokens()
 * applied to both sides (see its comment). */
function bestMatch(searchText, pool) {
  const tokens = stripShortTokens(new Set(distinctiveTokens(searchText)));
  let best = null;
  for (const e of pool) {
    const score = tokenOverlapScore(tokens, stripShortTokens(e.tokens));
    if (score > 0 && (!best || score > best.score)) best = { entity: e, score };
  }
  return best && best.score >= CONFIDENT ? best : null;
}

function record(page, fields) {
  return {
    oldUrl: toOldUrl(page.sourceFile),
    sourceFile: page.sourceFile,
    oldTitle: page.title,
    pageType: page.pageType,
    internalLinkCount: page.internalLinkCount ?? 0,
    ...fields,
  };
}

function main() {
  const inventoryPath = path.join(MIGRATION_DATA_DIR, "legacy-url-inventory.json");
  if (!existsSync(inventoryPath)) {
    console.error("Run scripts/build-legacy-url-inventory.mjs first.");
    process.exit(1);
  }
  const inventory = JSON.parse(readFileSync(inventoryPath, "utf8"));
  const pages = inventory.pages;

  const articleReport = loadJsonIfExists(path.join(CONTENT_DATA_DIR, "article-migration-report.json"));
  const transferReport = loadJsonIfExists(path.join(CONTENT_DATA_DIR, "transfer-migration-report.json"));
  const packageReport = loadJsonIfExists(path.join(CONTENT_DATA_DIR, "package-migration-report.json"));
  // Task 18 superseded Task 15's conservative transfer matching (2 of 88
  // legacy pages) with a much richer recovery pass (63 of 88, including 55
  // brand-new destination islands) — checked FIRST for any transfer page.
  const transferRecoveryReport = loadJsonIfExists(path.join(MIGRATION_DATA_DIR, "transfer-legacy-recovery.json"));

  const articleBySourceFile = new Map((articleReport?.articles ?? []).map((a) => [a.sourceFile, a]));
  const transferBySourceFile = new Map((transferReport?.pages ?? []).map((t) => [t.sourceFile, t]));
  const transferRecoveryBySourceFile = new Map((transferRecoveryReport?.records ?? []).map((t) => [t.sourceFile, t]));
  const packageBySourceFile = new Map((packageReport?.pages ?? []).map((p) => [p.sourceFile, p]));

  const entities = buildEntityIndex();
  const atollEntities = entities.filter((e) => e.type === "atoll");
  const islandEntities = entities.filter((e) => e.type === "island");
  const locationEntities = entities.filter((e) => e.type === "atoll" || e.type === "island");
  const accommodationEntities = entities.filter((e) => ["hotel", "resort", "guesthouse", "villa", "other"].includes(e.type));
  const divingEntities = entities.filter((e) => e.type === "dive_site" || e.type === "diving");
  const fishingEntities = entities.filter((e) => e.type === "fishing");
  const surfingEntities = entities.filter((e) => e.type === "surf_break" || e.type === "surfing");
  const activityEntities = entities.filter((e) => e.type === "activity");
  const atollEntityByCode = new Map(atollEntities.map((e) => [e.administrativeCode, e]));

  const results = [];

  // ── Accommodation grouping: one decision per "resort identity" folder,
  // applied to every page under it (main page + room/booking sub-pages) —
  // never a separate match per sub-page, since sub-pages have no
  // independent destination in the new site (Task 16 §18).
  const accommodationGroupKey = (sourceFile) => {
    const parts = sourceFile.split("/");
    if (parts.length >= 3 && (parts[0] === "resorts" || parts[0] === "hotels")) return parts.slice(0, 2).join("/");
    return sourceFile; // standalone page — its own group of one
  };
  const accommodationGroupDecision = new Map(); // key -> {match, resultReason}

  function decideAccommodationGroup(key, sampleTitle) {
    if (accommodationGroupDecision.has(key)) return accommodationGroupDecision.get(key);
    const basis = key.split("/").pop().replace(/[-_]/g, " ");
    const match = bestMatch(`${basis} ${sampleTitle ?? ""}`, accommodationEntities);
    const decision = match
      ? { newUrl: match.entity.href, confidence: match.score >= 0.8 ? "high" : "medium", reason: `Same accommodation entity ("${match.entity.title}", matched via legacy property folder name)` }
      : null;
    accommodationGroupDecision.set(key, decision);
    return decision;
  }

  for (const page of pages) {
    const sf = page.sourceFile;
    const titleLower = (page.title ?? "").trim().toLowerCase();

    // ── Universal short-circuits (apply regardless of pageType) ────────
    if (sf === "index.html") {
      results.push(record(page, { newUrl: "/", status: 301, migrationStatus: "keep", confidence: "high", reason: "Legacy homepage — same as the new site's homepage." }));
      continue;
    }
    if (titleLower === "" || titleLower === "booking form" || titleLower === "acitvities booking") {
      results.push(record(page, { newUrl: null, status: null, migrationStatus: "retire", confidence: "high", reason: "Checkout/booking-form widget, not a real content page — no meaningful replacement in a site with no booking system yet." }));
      continue;
    }
    if (page.isEmptyOrThin) {
      results.push(record(page, { newUrl: null, status: null, migrationStatus: "retire", confidence: "high", reason: "Page has no meaningful content (empty/thin)." }));
      continue;
    }

    // ── Per pageType handling ───────────────────────────────────────────
    if (page.pageType === "location") {
      const parts = sf.split("/");
      if (parts[0] === "atolls" && parts.length === 2) {
        const base = parts[1].replace(/\.html$/i, "").replace(/-maldives$/i, "");
        const code = ATOLL_FOLDER_TO_CODE[base];
        const entity = code ? atollEntityByCode.get(code) : null;
        if (entity) {
          results.push(record(page, { newUrl: entity.href, status: 301, migrationStatus: "redirect", confidence: "high", reason: `Same atoll entity ("${entity.title}"), verified via the legacy atoll-folder → administrative-code mapping.` }));
        } else {
          results.push(record(page, { newUrl: null, status: null, migrationStatus: "review", confidence: "unmatched", reason: "Atoll page whose folder name did not resolve to a known administrative code." }));
        }
        continue;
      }
      if (parts[0] === "atolls" && parts.length === 3) {
        const atollBase = parts[1];
        const code = ATOLL_FOLDER_TO_CODE[atollBase];
        const atollEntity = code ? atollEntityByCode.get(code) : null;
        const islandBasis = parts[2].replace(/\.html$/i, "").replace(/^.*?-/, "").replace(/-island-maldives$/i, "").replace(/-maldives$/i, "");
        const pool = atollEntity ? islandEntities.filter((e) => e.atollSlug === atollEntity.slug) : islandEntities;
        const match = bestMatch(`${islandBasis} ${page.title ?? ""}`, pool);
        if (match) {
          results.push(record(page, { newUrl: match.entity.href, status: 301, migrationStatus: "redirect", confidence: match.score >= 0.8 ? "high" : "medium", reason: `Same island entity ("${match.entity.title}"${atollEntity ? `, scoped to ${atollEntity.title}` : ""}).` }));
        } else {
          results.push(record(page, { newUrl: null, status: null, migrationStatus: "review", confidence: "unmatched", reason: "Island page did not confidently match a real, seeded island — never guessed from name similarity alone." }));
        }
        continue;
      }
      // The handful of non-atolls/ "location" pages (root-level city/atoll
      // guides) — generic token match against every real location.
      const match = bestMatch(`${page.title ?? ""} ${path.basename(sf, ".html")}`, locationEntities);
      if (match) {
        results.push(record(page, { newUrl: match.entity.href, status: 301, migrationStatus: "redirect", confidence: match.score >= 0.8 ? "high" : "medium", reason: `Same ${match.entity.type} entity ("${match.entity.title}").` }));
      } else {
        results.push(record(page, { newUrl: null, status: null, migrationStatus: "review", confidence: "unmatched", reason: "Generic location-themed content with no confidently matching real entity." }));
      }
      continue;
    }

    if (page.pageType === "accommodation") {
      // Root-level directory/listing pages (not a specific property).
      if (/^maldives-(resorts|hotels)\.html$/i.test(sf) || /^maldives-luxury-(resort|resorts)\.html$/i.test(sf)) {
        const seg = /hotel/i.test(sf) ? "hotels" : "resorts";
        results.push(record(page, { newUrl: `/maldives/${seg}/`, status: 301, migrationStatus: "redirect", confidence: "medium", reason: `Legacy directory/listing page → the new ${seg} directory page (same intent, no specific property named).` }));
        continue;
      }
      const key = accommodationGroupKey(sf);
      const decision = decideAccommodationGroup(key, page.title);
      if (decision) {
        results.push(record(page, { newUrl: decision.newUrl, status: 301, migrationStatus: key === sf ? "redirect" : "consolidate", confidence: decision.confidence, reason: decision.reason }));
      } else {
        results.push(record(page, { newUrl: null, status: null, migrationStatus: "review", confidence: "unmatched", reason: "Legacy property not yet represented in the current MTG accommodation catalogue (14 entries) — never duplicated to make a match." }));
      }
      continue;
    }

    if (page.pageType === "diving" || page.pageType === "fishing" || page.pageType === "surfing") {
      const pool = page.pageType === "diving" ? divingEntities : page.pageType === "fishing" ? fishingEntities : surfingEntities;
      const match = bestMatch(`${page.title ?? ""} ${path.basename(sf, ".html")}`, pool) ?? bestMatch(page.title ?? "", activityEntities);
      if (match) {
        results.push(record(page, { newUrl: match.entity.href, status: 301, migrationStatus: "redirect", confidence: match.score >= 0.8 ? "high" : "medium", reason: `Same ${match.entity.type} entity ("${match.entity.title}").` }));
      } else {
        results.push(record(page, { newUrl: null, status: null, migrationStatus: "review", confidence: "unmatched", reason: `Legacy ${page.pageType} content with no confidently matching real dive site/activity/surf break — never sent to a generic category page without a confirmed specific match.` }));
      }
      continue;
    }

    if (page.pageType === "article") {
      const a = articleBySourceFile.get(sf);
      if (a?.migrationStatus === "ready") {
        results.push(record(page, { newUrl: a.candidateNewUrl, status: 301, migrationStatus: "redirect", confidence: "high", reason: "Article migrated to the new Travel Guide (verified: page exists in article-migration-report.json with status=ready)." }));
      } else if (a?.duplicateOfSlug) {
        results.push(record(page, { newUrl: `/maldives/travel-guide/${a.duplicateOfSlug}/`, status: 301, migrationStatus: "consolidate", confidence: "high", reason: "Duplicate-content legacy article — consolidated into the one migrated article covering the same content." }));
      } else if (a) {
        results.push(record(page, { newUrl: null, status: null, migrationStatus: "review", confidence: "unmatched", reason: `Article not migrated (${a.migrationStatus}) — ${a.nonEnglishTitle ? "non-English title, needs a human decision" : "did not meet migration confidence bar"}.` }));
      } else {
        results.push(record(page, { newUrl: null, status: null, migrationStatus: "review", confidence: "unmatched", reason: "Article page not found in the article migration report — needs manual inspection." }));
      }
      continue;
    }

    if (page.pageType === "transfer") {
      const recovered = transferRecoveryBySourceFile.get(sf);
      if (recovered?.status === "ready") {
        const newUrl = `/maldives/transfers/velana-international-airport-to-${recovered.islandSlug}/`;
        results.push(
          record(page, {
            newUrl,
            status: 301,
            migrationStatus: "redirect",
            confidence: "high",
            reason: `Same transfer route, recovered from this page's own JSON-LD (Task 18) — ${recovered.isNewLocation ? `a new destination (${recovered.islandTitle}) created from this page's real name/atoll/coordinates` : `matches the already-seeded island ${recovered.islandTitle}`}.`,
          }),
        );
        continue;
      }
      const t = transferBySourceFile.get(sf);
      // These specific source files were individually inspected (their
      // titles read as genuinely generic transfer-booking utilities or
      // hub/listing pages — "Speedboat Booking", "Maldives Customize
      // Transfer Booking" — never naming one specific property) and are
      // the ONLY "no structured data" transfer pages this script sends to
      // the transfers directory. Everything else in that bucket names a
      // specific resort (e.g. "Banyan Tree Maldives Transfer", "Naladhu
      // Island Maldives Transfer") that just lacks JSON-LD — those are
      // real, specific content this script must NOT blur into a category
      // redirect (Task 16 §20), so they fall through to review instead.
      const GENERIC_TRANSFER_HUB_FILES = new Set([
        "transfer/alifalif-transfer-booking.html",
        "transfer/baaatoll-transfer-booking.html",
        "transfer/ga-transfer-booking.html",
        "transfer/customize-transfer-booking.html",
        "transfer/speedboat-booking.html",
        "transfer/transfer-booking.html",
      ]);
      if (t?.migrationStatus === "already-covered") {
        results.push(record(page, { newUrl: `/maldives/transfers/velana-international-airport-to-${t.destinationIslandSlug}/`, status: 301, migrationStatus: "redirect", confidence: "high", reason: `Same transfer route (verified: Velana International Airport → ${t.matchedAccommodation.title}'s island, already live from Task 10).` }));
      } else if (sf === "maafushi-island-transfer.html") {
        // Names the island directly (not a specific resort) — Maafushi
        // already has a real, live transfer route from Task 10.
        results.push(record(page, { newUrl: "/maldives/transfers/velana-international-airport-to-maafushi/", status: 301, migrationStatus: "redirect", confidence: "high", reason: "Names the island Maafushi directly (not a specific resort) — a real transfer route to Maafushi already exists (Task 10)." }));
      } else if (sf === "transfer/snorkeling-and-diving-activities-in-maldives.html") {
        // Misfiled under transfer/ by the directory-based classifier —
        // its own title/content is a general activities hub, not a
        // transfer page.
        results.push(record(page, { newUrl: "/maldives/activities/", status: 301, migrationStatus: "redirect", confidence: "medium", reason: "Content is a general snorkeling/diving/water-sports activities hub (misfiled under transfer/ by directory), not transfer content — mapped to the activities directory." }));
      } else if (sf === "transfer/transfer-thank-you.html") {
        results.push(record(page, { newUrl: null, status: null, migrationStatus: "retire", confidence: "high", reason: "Post-checkout confirmation page, not real content." }));
      } else if (sf === "maldives-transportation-ferry-speedboat-transfers.html") {
        // Task 20: this page's own real province ferry schedule content
        // (9 routes, transcribed) now has a dedicated page — a more
        // specific, accurate target than the generic transfers hub.
        results.push(record(page, { newUrl: "/maldives-ferry-schedule/", status: 301, migrationStatus: "redirect", confidence: "high", reason: "This page's real province ferry schedule content was migrated to a dedicated Ferry Schedule page (Task 20)." }));
      } else if (t?.reason?.startsWith("no structured") && GENERIC_TRANSFER_HUB_FILES.has(sf)) {
        results.push(record(page, { newUrl: "/maldives/transfers/", status: 301, migrationStatus: "redirect", confidence: "medium", reason: "Generic transfer-booking utility/hub page naming no specific property — mapped to the transfers directory as the closest genuine equivalent." }));
      } else {
        results.push(record(page, { newUrl: null, status: null, migrationStatus: "review", confidence: "unmatched", reason: t?.reason?.startsWith("no structured") ? "Names a specific resort/property not yet in the current MTG accommodation catalogue — never blurred into a generic category redirect." : (t?.reason ?? "Transfer page needs manual review.") }));
      }
      continue;
    }

    if (page.pageType === "package") {
      const p = packageBySourceFile.get(sf);
      if (p?.pageSubType === "booking-form-widget" || p?.pageSubType === "partner-recruitment" || p?.pageSubType === "empty-or-thin") {
        results.push(record(page, { newUrl: null, status: null, migrationStatus: "retire", confidence: "high", reason: p.reason }));
      } else {
        results.push(record(page, { newUrl: null, status: null, migrationStatus: "review", confidence: "unmatched", reason: p?.reason ?? "Package/tour page needs manual review — no real, matched package migrated yet." }));
      }
      continue;
    }

    if (page.pageType === "map") {
      const match = bestMatch(`${page.title ?? ""} ${path.basename(sf, ".html")}`, locationEntities);
      if (match) {
        results.push(record(page, { newUrl: match.entity.href, status: 301, migrationStatus: "redirect", confidence: match.score >= 0.8 ? "high" : "medium", reason: `Map of a specific real location ("${match.entity.title}") — redirected to that entity's page (no dedicated map feature exists yet).` }));
      } else {
        // Generic "Maldives on a map" pages (including translated
        // duplicates) name no specific entity — consolidated to the
        // country hub, never to an unrelated page (Task 16 §15).
        results.push(record(page, { newUrl: "/maldives/", status: 301, migrationStatus: "consolidate", confidence: "medium", reason: "Generic whole-country map page (no specific atoll/island named, including translated duplicates of the same content) — consolidated to the Maldives hub page." }));
      }
      continue;
    }

    if (page.pageType === "shopping") {
      results.push(record(page, { newUrl: null, status: null, migrationStatus: "retire", confidence: "high", reason: "Legacy e-commerce cart/checkout page — the new site has no shopping/payments functionality (explicitly out of scope)." }));
      continue;
    }

    // pageType === "other"
    if (/^partners\//.test(sf) || sf === "partners.html") {
      results.push(record(page, { newUrl: null, status: null, migrationStatus: "retire", confidence: "high", reason: "B2B partner-recruitment page aimed at operators, not customer-facing content." }));
    } else if (/^(contact|contact\/contact|faqs|privacy-policy)\.html$/i.test(sf)) {
      results.push(record(page, { newUrl: null, status: null, migrationStatus: "review", confidence: "unmatched", reason: "Legitimately useful page (contact/legal/FAQ) with no current equivalent on the new site — needs a human decision on whether to recreate it, not a redirect." }));
    } else if (/booking|menu\.html|promotional\.html|verify\.html/i.test(sf)) {
      results.push(record(page, { newUrl: null, status: null, migrationStatus: "retire", confidence: "high", reason: "Checkout/internal-utility page, not real content." }));
    } else {
      results.push(record(page, { newUrl: null, status: null, migrationStatus: "review", confidence: "unmatched", reason: "Miscellaneous legacy content with no confidently matching real page — needs manual review rather than a guessed redirect." }));
    }
  }

  // ── Chain safety: no redirect's newUrl may itself be an old (.html)
  // source path in this same map (Task 16 §9). All newUrls above come
  // from real live entity hrefs or fixed app routes, so this is a
  // defensive check, not an expected finding.
  const oldUrlSet = new Set(results.map((r) => r.oldUrl));
  const chainIssues = results.filter((r) => r.newUrl && oldUrlSet.has(r.newUrl));

  const redirectMap = results.filter((r) => r.migrationStatus === "redirect" || r.migrationStatus === "consolidate" || r.migrationStatus === "keep");
  const reviewMap = results.filter((r) => r.migrationStatus === "review");
  const retireMap = results.filter((r) => r.migrationStatus === "retire");

  mkdirSync(MIGRATION_DATA_DIR, { recursive: true });

  writeFileSync(
    path.join(MIGRATION_DATA_DIR, "redirect-map.json"),
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        note: "Task 16 §23. Every entry's newUrl is a verified, currently-real destination — never an invented mapping.",
        total: redirectMap.length,
        chainIssuesFound: chainIssues.length,
        records: redirectMap,
      },
      null,
      2,
    ),
  );

  writeFileSync(
    path.join(MIGRATION_DATA_DIR, "redirect-review.json"),
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        note: "Task 16 §24. Pages needing a human decision — never silently discarded, never guessed into a redirect.",
        total: reviewMap.length,
        records: reviewMap.sort((a, b) => b.internalLinkCount - a.internalLinkCount),
      },
      null,
      2,
    ),
  );

  writeFileSync(
    path.join(MIGRATION_DATA_DIR, "retired-urls.json"),
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        note: "Task 16 §32. Legacy pages with no meaningful replacement — recorded, never redirected to an unrelated page, never deleted from release/.",
        total: retireMap.length,
        records: retireMap,
      },
      null,
      2,
    ),
  );

  const byType = {};
  for (const r of results) {
    const t = r.pageType;
    byType[t] ??= { total: 0, keep: 0, redirect: 0, consolidate: 0, retire: 0, review: 0 };
    byType[t].total += 1;
    byType[t][r.migrationStatus] += 1;
  }

  const highValueThreshold = 50; // internalLinkCount — see legacy-url-inventory.json's topLinkedPages
  const highValue = results.filter((r) => r.internalLinkCount >= highValueThreshold);

  const coverage = {
    generatedAt: new Date().toISOString(),
    note:
      "Task 16 §25. 'High-value' here means high internal-link count within the legacy site itself (no Search Console " +
      "export exists in this repository — confirmed absent, see legacy-url-inventory.json's own note).",
    totalLegacyUrls: results.length,
    keep: results.filter((r) => r.migrationStatus === "keep").length,
    redirect: results.filter((r) => r.migrationStatus === "redirect").length,
    consolidate: results.filter((r) => r.migrationStatus === "consolidate").length,
    retire: results.filter((r) => r.migrationStatus === "retire").length,
    review: results.filter((r) => r.migrationStatus === "review").length,
    chainIssuesFound: chainIssues.length,
    highValueThreshold,
    highValueTotal: highValue.length,
    highValueMapped: highValue.filter((r) => r.migrationStatus === "keep" || r.migrationStatus === "redirect" || r.migrationStatus === "consolidate").length,
    highValueUnmapped: highValue.filter((r) => r.migrationStatus === "review" || r.migrationStatus === "retire").length,
    byType,
  };
  writeFileSync(path.join(MIGRATION_DATA_DIR, "redirect-coverage.json"), JSON.stringify(coverage, null, 2));

  console.log(`Total legacy URLs: ${results.length}`);
  console.log(`keep=${coverage.keep} redirect=${coverage.redirect} consolidate=${coverage.consolidate} retire=${coverage.retire} review=${coverage.review}`);
  console.log(`Chain issues found: ${chainIssues.length}`);
  console.log(`High-value (internalLinkCount >= ${highValueThreshold}): ${coverage.highValueTotal} total, ${coverage.highValueMapped} mapped, ${coverage.highValueUnmapped} unmapped`);
  console.log("By type:", JSON.stringify(byType, null, 2));
  console.log("\nWrote redirect-map.json, redirect-review.json, retired-urls.json, redirect-coverage.json");
}

main();
