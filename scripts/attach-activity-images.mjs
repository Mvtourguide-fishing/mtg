#!/usr/bin/env node
// Attaches real legacy images to every existing Activity node (fishing,
// diving, surfing, and general/other categories) — see this task's report:
// ActivitySummary/ActivityDetail never had an image field, no node_media
// row has ever existed for node_type='activity', so every activity listing
// card has always rendered without an image, by construction, since
// Task 6. This script is the fix's data half (see the paired code changes
// in src/lib/activities/types.ts, src/lib/activities/repository.ts, and
// src/components/activity/activity-card.tsx).
//
// Every image assigned here already exists as a real media_assets row
// (from supabase/migrations/20250115000100_full_legacy_image_library.sql,
// already uploaded to Storage in a prior task) — this script only adds the
// node_media LINK, never invents a filename or path.
//
// Deterministic allocation strategy (per the task brief's explicit ask):
//   - Activities are grouped by activity_category into an image pool of
//     genuinely on-topic legacy photos for that category (fishing/diving/
//     surfing each pull from their own dedicated legacy folder; every
//     other category pulls from images/activities/, keyword-matched to
//     the activity's own title where possible — dolphin cruise -> a
//     dolphin photo, sandbank picnic -> a sandbank photo, etc).
//   - Within a category, activities are sorted by slug (a stable order)
//     and each is block-allocated 1 hero + up to 3 gallery images by
//     walking the pool in a fixed (path-sorted) order, advancing past any
//     image already claimed by an earlier activity in the same run. Every
//     pool here is larger than its category's activity count, so no two
//     activities in the same category ever share a hero image, and no
//     activity's gallery repeats its own hero.
//   - Missing-image handling: if a category pool is ever exhausted for a
//     given activity, that activity is simply left without a hero rather
//     than reusing another activity's image or fabricating one — see the
//     coverage report's "missing" list, expected to be empty given the
//     pool sizes actually available.
//   - Stable between builds: pool order is sorted by relativePath (a
//     property of the on-disk manifest, not run order), so this script
//     produces byte-identical output on every re-run.
//
// Usage: node scripts/attach-activity-images.mjs [--commit]

import { existsSync, readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, ROOT, toAsciiSafe } from "./lib/legacy-shared.mjs";

const COMMIT = process.argv.includes("--commit");

// slug -> activity_category, extracted directly from the seed migrations
// (supabase/migrations/2025010{4,5,6,7}*_seed_*.sql) — see this task's
// audit for the extraction method. Kept as a literal list here (not
// re-derived from JSON source data) because activity_category is a
// database column set at seed time, and slugs are the only stable key
// node_media can join against.
const ACTIVITY_CATEGORY = {
  "snorkeling-dolphin-watching-sandbank-package": "excursion",
  "sunset-dolphin-cruise": "excursion",
  "sandbank-picnic": "general",
  "male-guided-tour": "culture",
  "private-surf-lesson-cokes": "surfing",
  "discover-scuba-diving-dsd": "diving",
  "padi-open-water-diver-course": "diving",
  "private-snorkeling-trip": "watersports",
  "private-dolphin-cruise": "excursion",
  "full-day-snorkeling-island-hopping-tour": "island_hopping",
  "sandbank-snorkeling-dolphin-watching-excursions": "excursion",
  "guided-reef-dive": "diving",
  "sunset-dolphin-cruise-kunfunadhoo": "excursion",
  "soneva-soul-60-minute-spa-treatment": "spa",
  "traditional-handline-fishing-trip": "fishing",
  "night-fishing-excursion": "fishing",
  "sunset-fishing-trip": "fishing",
  "private-sport-fishing-trip": "fishing",
  "sunset-fishing-trip-maafushi": "fishing",
  "night-fishing-trip": "fishing",
  "marlin-big-game-fishing-charter": "fishing",
  "sunset-reef-fishing": "fishing",
  "big-game-fishing-trip": "fishing",
  "big-game-fishing-trip-lankanfushi": "fishing",
  "fishing-is-a-family-matter": "fishing",
  "golden-reel-adventure": "fishing",
  "fun-dive-single-tank": "diving",
  "advanced-open-water-diver-course": "diving",
  "night-diver-specialty-course": "diving",
  "discover-scuba-diving": "diving",
  "fluo-night-diving": "diving",
  "fun-dive": "diving",
  "padi-open-water-diver-course-kunfunadhoo": "diving",
  "padi-bubble-maker": "diving",
  "discover-scuba-diving-velassaru": "diving",
  "padi-open-water-diver-course-thulusdhoo": "diving",
  "discover-scuba-diving-thulusdhoo": "diving",
  "fun-dive-single-tank-thulusdhoo": "diving",
  "padi-open-water-diver-course-vihamanaafushi": "diving",
  "discover-scuba-diving-lankanfushi": "diving",
  "group-surf-lesson": "surfing",
  "guided-surf-boat-trip": "surfing",
  "surf-lesson": "surfing",
  "surfboard-rental": "surfing",
  "wave-surfing": "surfing",
  "wave-surfing-maafushi": "surfing",
  "multi-day-surf-camp-package": "surfing",
  "beginner-lagoon-surf-lesson": "surfing",
  "first-green-wave-private-surf-lesson": "surfing",
};

// A keyword hint per "other" category activity, used to pick a more
// specifically-relevant photo from images/activities/ than a purely
// positional walk would — never required (falls through to positional
// allocation if no keyword match exists in the pool).
const KEYWORD_HINT = {
  "snorkeling-dolphin-watching-sandbank-package": "dolphin",
  "sunset-dolphin-cruise": "dolphin",
  "sandbank-picnic": "sandbank",
  "male-guided-tour": "male",
  "private-snorkeling-trip": "snorkel",
  "private-dolphin-cruise": "dolphin",
  "full-day-snorkeling-island-hopping-tour": "island-hopping",
  "sandbank-snorkeling-dolphin-watching-excursions": "sandbank",
  "sunset-dolphin-cruise-kunfunadhoo": "dolphin",
  "soneva-soul-60-minute-spa-treatment": "spa",
};

function sqlString(value) {
  return `'${toAsciiSafe(String(value)).replace(/'/g, "''")}'`;
}

function main() {
  const manifestPath = path.join(DATA_DIR, "migration", "full-legacy-image-library-manifest.json");
  if (!existsSync(manifestPath)) {
    console.error(`Not found: ${manifestPath}`);
    process.exit(1);
  }
  const manifest = JSON.parse(readFileSync(manifestPath, "utf8"));
  const files = manifest.files;

  const fishingPool = files.filter((f) => f.relativePath.startsWith("images/fishing/")).sort((a, b) => a.relativePath.localeCompare(b.relativePath));
  const divingPool = files
    .filter((f) => f.relativePath.toLowerCase().includes("/diving/") && !f.relativePath.toLowerCase().includes("map"))
    .sort((a, b) => a.relativePath.localeCompare(b.relativePath));
  const surfingPool = files
    .filter((f) => f.relativePath.startsWith("images/surfing/") && !f.relativePath.toLowerCase().includes("map"))
    .sort((a, b) => a.relativePath.localeCompare(b.relativePath));
  const activitiesPool = files
    .filter((f) => f.relativePath.startsWith("images/activities/") && !f.relativePath.toLowerCase().includes("map"))
    .sort((a, b) => a.relativePath.localeCompare(b.relativePath));

  console.log(`Pools: fishing=${fishingPool.length} diving=${divingPool.length} surfing=${surfingPool.length} activities=${activitiesPool.length}`);

  const poolByCategory = {
    fishing: fishingPool,
    diving: divingPool,
    surfing: surfingPool,
  };

  const slugs = Object.keys(ACTIVITY_CATEGORY).sort();
  const byCategory = new Map();
  for (const slug of slugs) {
    const cat = ACTIVITY_CATEGORY[slug];
    const list = byCategory.get(cat) ?? [];
    list.push(slug);
    byCategory.set(cat, list);
  }

  const lines = [];
  const report = { totalListings: slugs.length, withImage: [], withoutImage: [], reuseNotes: [] };
  const IMAGES_PER_ACTIVITY = 4; // 1 hero + up to 3 gallery

  for (const [category, catSlugs] of byCategory) {
    let pool = poolByCategory[category];
    let cursor = 0;

    if (!pool) {
      // "other" categories (excursion, general, culture, watersports,
      // island_hopping, spa) share the general activities/ pool, with a
      // keyword-first pick per activity before falling back to a
      // positional walk.
      const used = new Set();
      for (const slug of catSlugs) {
        const hint = KEYWORD_HINT[slug];
        let picks = [];
        if (hint) {
          picks = activitiesPool.filter((f) => !used.has(f.mediaId) && f.relativePath.toLowerCase().includes(hint));
        }
        if (picks.length === 0) {
          picks = activitiesPool.filter((f) => !used.has(f.mediaId));
        }
        const chosen = picks.slice(0, IMAGES_PER_ACTIVITY);
        chosen.forEach((f) => used.add(f.mediaId));
        writeActivityMedia(lines, report, slug, chosen);
      }
      continue;
    }

    // Two-pass: guarantee every activity a hero first (pass 1), then
    // spend whatever pool remains on gallery extras (pass 2) — so a tight
    // pool (more activities * IMAGES_PER_ACTIVITY than available photos)
    // degrades to "smaller galleries," never to "some activities have no
    // hero at all" as long as pool.length >= catSlugs.length.
    const chosenBySlug = new Map(catSlugs.map((slug) => [slug, []]));
    for (const slug of catSlugs) {
      if (cursor >= pool.length) break;
      chosenBySlug.get(slug).push(pool[cursor]);
      cursor += 1;
    }
    outer: for (const slug of catSlugs) {
      const chosen = chosenBySlug.get(slug);
      while (chosen.length < IMAGES_PER_ACTIVITY) {
        if (cursor >= pool.length) break outer;
        chosen.push(pool[cursor]);
        cursor += 1;
      }
    }
    for (const slug of catSlugs) writeActivityMedia(lines, report, slug, chosenBySlug.get(slug));
  }

  console.log(`Activities with an image: ${report.withImage.length}/${report.totalListings}`);
  if (report.withoutImage.length > 0) console.log(`Activities WITHOUT an image: ${report.withoutImage.join(", ")}`);

  if (COMMIT) {
    const sql = [
      "-- Attaches real legacy fishing/diving/surfing/activities images to",
      "-- every existing Activity node (hero + gallery, node_media). No new",
      "-- media_assets rows — every id already exists from",
      "-- 20250115000100_full_legacy_image_library.sql.",
      "-- GENERATED FILE, regenerate with:",
      "--   node scripts/attach-activity-images.mjs --commit",
      "",
      ...lines,
      "",
    ].join("\n");
    const outPath = path.join(ROOT, "supabase", "migrations", "20250118000100_activity_images.sql");
    writeFileSync(outPath, sql);
    console.log(`Wrote ${path.relative(ROOT, outPath)}`);

    const reportPath = path.join(DATA_DIR, "media", "activity-image-coverage-report.json");
    writeFileSync(reportPath, JSON.stringify(report, null, 2));
    console.log(`Wrote ${path.relative(ROOT, reportPath)}`);
  }
}

function writeActivityMedia(lines, report, slug, chosen) {
  if (chosen.length === 0) {
    report.withoutImage.push(slug);
    return;
  }
  report.withImage.push({ slug, images: chosen.map((f) => f.relativePath) });

  lines.push(`delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'activity' and slug = ${sqlString(slug)});`);

  chosen.forEach((f, i) => {
    const role = i === 0 ? "hero" : "gallery";
    lines.push(
      `insert into node_media (node_id, media_id, role, sort_order) select id, ${sqlString(f.mediaId)}, ${sqlString(role)}, ${i} from nodes where node_type = 'activity' and slug = ${sqlString(slug)} on conflict (node_id, media_id, role) do nothing;`,
    );
  });
}

main();
