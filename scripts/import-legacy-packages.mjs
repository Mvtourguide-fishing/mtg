#!/usr/bin/env node
// Task 15 §17-20: legacy package/tour page inventory + migration.
//
// Reads the "package" pages already classified in
// data/maldives/content/url-inventory.json (Task 14 explicitly deferred
// these — same as transfers, see scripts/import-legacy-transfers.mjs).
//
// The `packages/` and `tours/` legacy directories both classify as
// pageType "package" by the coarse directory-based rule in
// import-legacy-urls.mjs, but on inspection they are NOT one uniform
// content type:
//   - Most of tours/*.html are literal checkout widgets (<title>Booking
//     Form</title>, a handful of form fields, no descriptive content) —
//     not a package/tour page at all.
//   - Several packages/*.html are B2B partner-recruitment pages
//     ("Join Our Network", "Tour Operators & Package Providers") — aimed
//     at operators, not travelers; not a customer-facing package either.
//   - The remaining packages/*-package.html pages ARE genuine marketing
//     copy for a multi-night package, but every one inspected names only a
//     generic atoll ("South Male Atoll", "Multiple Atolls") rather than a
//     specific real resort, and carries an obviously templated rating
//     ("5.0 (128 reviews)") that doesn't correspond to any real, checkable
//     review data — there is no real, identifiable MTG entity behind them.
//
// This script classifies every page into one of these real sub-types and
// only ever treats a page as a genuine migratable package when it names a
// SPECIFIC accommodation that confidently matches the real MTG catalogue
// (scripts/lib/legacy-shared.mjs's buildEntityIndex(), score >= 0.6) —
// never fabricating a package around a generic "South Male Atoll" resort
// stand-in. As of this pass, zero pages clear that bar (see the generated
// report) — an honest result of the current small accommodation catalogue
// (14 entries), not a bug in this script. Re-running this script after the
// catalogue grows will pick up any newly-matchable package automatically.
//
// Writes:
//   data/maldives/content/package-migration-report.json
//
// Read-only by default. Usage:
//   node scripts/import-legacy-packages.mjs            # report only
//   node scripts/import-legacy-packages.mjs --commit   # also emit a SQL migration

import { existsSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import {
  DATA_DIR,
  RELEASE_DIR,
  ROOT,
  buildEntityIndex,
  deterministicUuid,
  distinctiveTokens,
  toAsciiSafe,
  tokenOverlapScore,
} from "./lib/legacy-shared.mjs";

const CONTENT_DATA_DIR = path.join(DATA_DIR, "content");
const COMMIT = process.argv.includes("--commit");

function extractTag(html, regex) {
  const m = html.match(regex);
  return m ? m[1].replace(/\s+/g, " ").trim() : null;
}

function isBookingFormWidget(title, html) {
  const t = (title ?? "").trim().toLowerCase();
  if (t === "booking form" || t === "") return true;
  // A page with a real <form> and no descriptive body copy beyond ~400
  // chars is a checkout widget, not content, regardless of its title.
  const text = html.replace(/<[^>]+>/g, " ").replace(/\s+/g, " ").trim();
  return /<form[\s>]/i.test(html) && text.length < 400;
}

function isPartnerRecruitmentPage(title, text) {
  const hay = `${title ?? ""} ${text}`.toLowerCase();
  return /join our network|become a partner|partner with us|tour operators & package providers|list your (resort|hotel|guesthouse|business)/i.test(hay);
}

const FABRICATED_RATING_PATTERN = /\b\d(?:\.\d)?\s*\(\d{1,4}\s*reviews?\)/i;

function extractPrice(text) {
  const m = text.match(/\$\s?([\d,]{2,6})(?:\.\d{2})?\b/);
  if (!m) return null;
  const value = Number(m[1].replace(/,/g, ""));
  return Number.isFinite(value) && value > 0 ? value : null;
}

function extractNights(text) {
  const m = text.match(/(\d{1,2})[\s-]?night/i);
  return m ? Number(m[1]) : null;
}

function main() {
  const urlInventoryPath = path.join(CONTENT_DATA_DIR, "url-inventory.json");
  if (!existsSync(urlInventoryPath)) {
    console.error("Run scripts/import-legacy-urls.mjs first (needs data/maldives/content/url-inventory.json).");
    process.exit(1);
  }
  const urlInventory = JSON.parse(readFileSync(urlInventoryPath, "utf8"));
  const packagePages = urlInventory.pages.filter((p) => p.pageType === "package");

  const entities = buildEntityIndex();
  const accommodationEntities = entities.filter((e) => ["hotel", "resort", "guesthouse", "villa", "other"].includes(e.type));

  const records = [];

  for (const page of packagePages) {
    const fullPath = path.join(RELEASE_DIR, page.sourceFile);
    let html;
    try {
      html = readFileSync(fullPath, "utf8");
    } catch {
      records.push({ oldUrl: page.oldUrl, sourceFile: page.sourceFile, migrationStatus: "malformed", reason: "source file unreadable" });
      continue;
    }

    const title = extractTag(html, /<title[^>]*>([^<]*)<\/title>/i) ?? page.title;
    const text = html.replace(/<[^>]+>/g, " ").replace(/\s+/g, " ").trim();

    if (isBookingFormWidget(title, html)) {
      records.push({
        oldUrl: page.oldUrl,
        sourceFile: page.sourceFile,
        title,
        pageSubType: "booking-form-widget",
        migrationStatus: "skipped",
        reason: "checkout/booking-form widget, not a package content page",
      });
      continue;
    }

    if (isPartnerRecruitmentPage(title, text)) {
      records.push({
        oldUrl: page.oldUrl,
        sourceFile: page.sourceFile,
        title,
        pageSubType: "partner-recruitment",
        migrationStatus: "skipped",
        reason: "B2B partner-recruitment page aimed at operators, not a customer-facing package",
      });
      continue;
    }

    if (text.length < 300) {
      records.push({
        oldUrl: page.oldUrl,
        sourceFile: page.sourceFile,
        title,
        pageSubType: "empty-or-thin",
        migrationStatus: "skipped",
        reason: "too little content to be a real package page",
      });
      continue;
    }

    const searchText = `${title ?? ""} ${text.slice(0, 1000)}`;
    const searchTokens = new Set(distinctiveTokens(searchText));
    let best = null;
    for (const acc of accommodationEntities) {
      const score = tokenOverlapScore(searchTokens, acc.tokens);
      if (score > 0 && (!best || score > best.score)) best = { acc, score };
    }

    const hasFabricatedRating = FABRICATED_RATING_PATTERN.test(text);
    const price = extractPrice(text);
    const nights = extractNights(text);

    if (!best || best.score < 0.6) {
      records.push({
        oldUrl: page.oldUrl,
        sourceFile: page.sourceFile,
        title,
        pageSubType: "generic-template-marketing",
        priceFound: price,
        nightsFound: nights,
        hasFabricatedRating,
        migrationStatus: "needs-review",
        reason:
          "genuine-looking package copy, but does not name a specific accommodation that matches the real MTG catalogue " +
          "(data/maldives/accommodations/accommodations.json) — never migrated against a generic/unidentified resort" +
          (hasFabricatedRating ? "; also carries an unverifiable templated star rating/review count" : ""),
      });
      continue;
    }

    records.push({
      oldUrl: page.oldUrl,
      sourceFile: page.sourceFile,
      title,
      pageSubType: "package-candidate",
      matchedAccommodation: { slug: best.acc.slug, title: best.acc.title, score: Number(best.score.toFixed(2)) },
      priceFound: price,
      nightsFound: nights,
      hasFabricatedRating,
      migrationStatus: price && nights ? "ready" : "needs-review",
      reason:
        price && nights
          ? "matched a real accommodation with a real price and night count"
          : `matched accommodation "${best.acc.title}" but could not confidently extract both a real price and a night count`,
    });
  }

  const byStatus = {};
  const bySubType = {};
  for (const r of records) {
    byStatus[r.migrationStatus] = (byStatus[r.migrationStatus] ?? 0) + 1;
    if (r.pageSubType) bySubType[r.pageSubType] = (bySubType[r.pageSubType] ?? 0) + 1;
  }

  writeFileSync(
    path.join(CONTENT_DATA_DIR, "package-migration-report.json"),
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        note:
          "Task 15 §17-20. A page only reaches migrationStatus='ready' when it names a specific accommodation that " +
          "confidently matches the real MTG catalogue AND carries a real extractable price and night count — never a " +
          "package built around a generic/unidentified resort. See scripts/import-legacy-packages.mjs for the full " +
          "classification rules.",
        totalPackagePages: packagePages.length,
        byMigrationStatus: byStatus,
        byPageSubType: bySubType,
        pages: records,
      },
      null,
      2,
    ),
  );

  console.log(`Classified ${records.length} legacy package/tour pages`);
  console.log("By migration status:", byStatus);
  console.log("By page sub-type:", bySubType);
  console.log("Wrote data/maldives/content/package-migration-report.json");

  if (COMMIT) {
    writeCommitMigration(records.filter((r) => r.migrationStatus === "ready"));
  } else {
    console.log("\n(dry run — pass --commit to also emit a SQL migration for ready packages)");
  }
}

function sqlString(value) {
  if (value === null || value === undefined) return "null";
  return `'${toAsciiSafe(value).replace(/'/g, "''")}'`;
}

function sqlLiteral(value) {
  if (value === null || value === undefined) return "null";
  return String(value);
}

/** A genuine legacy package resolves to exactly one matched accommodation
 * (no legacy page in this dataset described a real multi-stop itinerary
 * across several named, matchable resorts), so the itinerary this
 * generates is intentionally simple: one stage spanning the full stay, one
 * itinerary item for the matched accommodation. If a future page names
 * several real, matched accommodations across distinct date ranges, this
 * function's single-stage assumption would need revisiting — flagged here
 * rather than speculatively built for a shape no current source page has. */
function writeCommitMigration(readyPackages) {
  const lines = [];
  lines.push("-- Task 15: legacy package pages migrated into the existing packages/");
  lines.push("-- package_itinerary_stages/package_itinerary_items architecture (Task 11 -");
  lines.push("-- no new schema).");
  lines.push("-- GENERATED FILE - do not hand-edit. Regenerate with:");
  lines.push("--   node scripts/import-legacy-packages.mjs --commit");
  lines.push("-- Source: data/maldives/content/package-migration-report.json (status=ready).");
  lines.push("--");
  lines.push("-- Every package here named a specific accommodation that confidently");
  lines.push("-- matched the real MTG catalogue AND carried a real, extractable price and");
  lines.push("-- night count - legacy pricing is preserved as historical context, not");
  lines.push("-- presented as a current live rate (see each package's summary text).");
  lines.push("");

  let packageCount = 0;

  for (const pkg of readyPackages) {
    const slugBasis = pkg.title.replace(/\s*-\s*package details/i, "").trim();
    const slug = toAsciiSafe(slugBasis)
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-+|-+$/g, "");
    const title = slugBasis;
    const summary = `${title}, featuring ${pkg.matchedAccommodation.title}. Legacy pricing from the previous site: approximately $${pkg.priceFound} for ${pkg.nightsFound} nights (historical reference only, not a current live rate).`;

    lines.push(`-- Package: ${toAsciiSafe(title)}`);
    lines.push(
      `insert into nodes (node_type, slug, title, summary, status, legacy_slugs, published_at) values ('package', ${sqlString(slug)}, ${sqlString(title)}, ${sqlString(summary)}, 'published', ARRAY[${sqlString(pkg.oldUrl)}]::text[], now()) on conflict (node_type, slug) do nothing;`,
    );
    lines.push("");
    lines.push(
      `insert into packages (id, duration_nights, price_from, currency) select id, ${sqlLiteral(pkg.nightsFound)}, ${sqlLiteral(pkg.priceFound)}, 'USD' from nodes where node_type = 'package' and slug = ${sqlString(slug)} on conflict (id) do nothing;`,
    );
    lines.push("");

    const stageId = deterministicUuid(`legacy-package-stage::${slug}`);
    lines.push(
      `insert into package_itinerary_stages (id, package_id, stage_number, day_start, day_end, night_count, title) select ${sqlString(stageId)}::uuid, id, 1, 1, ${pkg.nightsFound}, ${pkg.nightsFound}, ${sqlString(pkg.matchedAccommodation.title)} from nodes where node_type = 'package' and slug = ${sqlString(slug)} on conflict (id) do nothing;`,
    );
    lines.push("");
    const itemId = deterministicUuid(`legacy-package-item::${slug}::${pkg.matchedAccommodation.slug}`);
    lines.push(
      `insert into package_itinerary_items (id, stage_id, component_type, component_node_id, component_role, sort_order) select ${sqlString(itemId)}::uuid, ${sqlString(stageId)}::uuid, 'node', a.id, 'accommodation', 0 from nodes a where a.node_type = 'accommodation' and a.slug = ${sqlString(pkg.matchedAccommodation.slug)} on conflict (id) do nothing;`,
    );
    lines.push("");
    packageCount += 1;
  }

  const migrationPath = path.join(ROOT, "supabase", "migrations", "20250110000800_legacy_packages.sql");
  writeFileSync(migrationPath, lines.join("\n") + "\n");
  console.log(`\nWrote ${migrationPath}`);
  console.log(`  packages: ${packageCount}`);
}

main();
