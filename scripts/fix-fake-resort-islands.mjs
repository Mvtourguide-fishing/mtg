#!/usr/bin/env node
// Entity-cleanup: the Task 18 legacy transfer rebuild
// (supabase/migrations/20250112000100_legacy_transfers_rebuild.sql) fell
// back to auto-creating a brand-new "island" location node for every
// legacy transfer destination name it couldn't match to an existing
// entity at the time. Because the real island system (379 real islands,
// built much later) didn't exist yet, EVERY resort-named transfer
// destination from that batch became a fake "island" — e.g. a location
// node titled "Adaaran Prestige Vadoo" sitting right alongside the real
// "Vadoo" island, both published, both generating a /maldives/islands/
// page for the same real place.
//
// This script is read-only/report-only against the input files below —
// it does NOT touch the live database. It reads three JSON exports taken
// directly from a full local-Postgres migration replay
// (/tmp/entity_audit/*.json — see the audit commands run earlier in this
// session) and, for each of the fake island nodes, tries to resolve the
// REAL geographical island it should have pointed at all along:
//
//   1. Prefer accommodation-mediated resolution: find the real
//      accommodation node whose title token-overlaps this fake island's
//      title, then use THAT accommodation's own real primary-island
//      relationship (node_locations, relation='primary') — this is
//      exactly the resort -> island link and is already correct in the
//      accommodations seed data (verified: Adaaran Prestige Vadoo's own
//      node_locations row already points at the real "vadoo" island, not
//      at this fake node — nothing references the fake node at all).
//   2. Falls back to direct title-vs-real-island-title token overlap
//      (same-atoll-first, like every other matching script this
//      session), for the ~2/3 of these 55 that don't have an
//      accommodation record in this DB at all yet (e.g. "Bandos
//      Maldives Resort" the fake island vs the real "bandos" island).
//   3. Falls back to the fake island's own parent atoll (still a real,
//      correct destination, just less specific) when no island match is
//      confident enough — never guessed, always reported.
//
// Usage:
//   node scripts/fix-fake-resort-islands.mjs --report     (default; prints the resolution table)
//   node scripts/fix-fake-resort-islands.mjs --commit      (writes the migration SQL)

import { readFileSync, writeFileSync } from "node:fs";
import path from "node:path";

import { distinctiveTokens, ROOT, toAsciiSafe, tokenOverlapScore } from "./lib/legacy-shared.mjs";

const COMMIT = process.argv.includes("--commit");
const AUDIT_DIR = "/tmp/entity_audit";

const ACCOMMODATION_THRESHOLD = 0.6;
const ISLAND_SAME_ATOLL_THRESHOLD = 0.5;
const ISLAND_GLOBAL_THRESHOLD = 0.8;

// The Task 18 legacy transfer rebuild recorded a real per-resort lat/lng
// for every one of these 55 nodes (recovered from each legacy page's own
// JSON-LD — verified these vary meaningfully, not a shared default), but
// hardcoded EVERY one's parent atoll to "kaafu" regardless of where that
// coordinate actually falls. Kaafu Atoll's real longitude range is
// roughly 73.2-73.7 (verified against the ones that resolved to a real
// Kaafu island via their own accommodation's real node_locations link,
// e.g. Vadoo 73.5081, Bandos 73.5169, Reethi Rah's neighborhood, etc.) —
// a fallback whose own recorded longitude falls well outside that band
// contradicts the "kaafu" it was defaulted to, so it's flagged for
// manual confirmation instead of silently trusting the stale default.
const KAAFU_LNG_RANGE = [73.15, 73.75];

function tokenSet(input) {
  return new Set(distinctiveTokens(input));
}

function sqlString(value) {
  return `'${toAsciiSafe(String(value)).replace(/'/g, "''")}'`;
}

function main() {
  const fakeIslands = JSON.parse(readFileSync(path.join(AUDIT_DIR, "fake_islands.json"), "utf8"));
  const realIslands = JSON.parse(readFileSync(path.join(AUDIT_DIR, "real_islands.json"), "utf8"));
  const realAtolls = JSON.parse(readFileSync(path.join(AUDIT_DIR, "real_atolls.json"), "utf8"));
  const realAccommodations = JSON.parse(readFileSync(path.join(AUDIT_DIR, "real_accommodations.json"), "utf8"));
  const accommodationPrimaryIsland = JSON.parse(
    readFileSync(path.join(AUDIT_DIR, "accommodation_primary_island.json"), "utf8"),
  );

  const primaryIslandByAccId = new Map(accommodationPrimaryIsland.map((r) => [r.accommodation_id, r]));
  const realIslandsBySlug = new Map(realIslands.map((i) => [i.slug, i]));
  const realAtollsBySlug = new Map(realAtolls.map((a) => [a.slug, a]));

  const results = [];

  for (const fake of fakeIslands) {
    const fakeTokens = tokenSet(fake.title);
    let resolution = null;

    // 1. Accommodation-mediated resolution.
    let bestAcc = null;
    for (const acc of realAccommodations) {
      const score = tokenOverlapScore(fakeTokens, tokenSet(acc.title));
      if (score >= ACCOMMODATION_THRESHOLD && (!bestAcc || score > bestAcc.score)) bestAcc = { acc, score };
    }
    if (bestAcc) {
      const primary = primaryIslandByAccId.get(bestAcc.acc.id);
      if (primary && realIslandsBySlug.has(primary.island_slug)) {
        resolution = { method: "accommodation", targetType: "island", slug: primary.island_slug, via: bestAcc.acc.title, score: bestAcc.score };
      }
    }

    // 2. Direct title-vs-real-island-title token overlap.
    if (!resolution) {
      const pool = fake.parent_atoll_slug ? realIslands.filter((i) => i.atoll_slug === fake.parent_atoll_slug) : realIslands;
      const threshold = fake.parent_atoll_slug ? ISLAND_SAME_ATOLL_THRESHOLD : ISLAND_GLOBAL_THRESHOLD;
      let best = null;
      const searchPool = pool.length > 0 ? pool : realIslands;
      const searchThreshold = pool.length > 0 ? threshold : ISLAND_GLOBAL_THRESHOLD;
      for (const isl of searchPool) {
        if (isl.slug === fake.slug) continue;
        const score = tokenOverlapScore(fakeTokens, tokenSet(isl.title));
        if (score >= searchThreshold && (!best || score > best.score)) best = { isl, score };
      }
      if (best) resolution = { method: "title", targetType: "island", slug: best.isl.slug, score: best.score };
    }

    // 3. Atoll fallback — but only trust the recorded "kaafu" default
    // when this node's own recorded longitude is actually consistent
    // with Kaafu Atoll. Every one of the ~18 that never resolved to a
    // specific island still has a real per-resort lat/lng recovered from
    // its legacy page; a few fall well outside Kaafu's real range,
    // meaning the hardcoded "kaafu" parent was wrong for them
    // specifically — those get flagged for manual confirmation instead
    // of silently redirected to the wrong atoll.
    if (!resolution) {
      const lngOk = typeof fake.lng === "number" && fake.lng >= KAAFU_LNG_RANGE[0] && fake.lng <= KAAFU_LNG_RANGE[1];
      if (fake.parent_atoll_slug && realAtollsBySlug.has(fake.parent_atoll_slug) && lngOk) {
        resolution = { method: "atoll-fallback", targetType: "atoll", slug: fake.parent_atoll_slug, score: null };
      } else {
        resolution = { method: "needs-manual-review", targetType: null, slug: null, score: null };
      }
    }

    results.push({ fake, resolution });
  }

  // ---- Report ----
  const byMethod = { accommodation: 0, title: 0, "atoll-fallback": 0, "needs-manual-review": 0 };
  for (const r of results) byMethod[r.resolution.method] += 1;
  console.log(`Total fake island nodes: ${results.length}`);
  console.log(`Resolved via accommodation's real primary-island relationship: ${byMethod.accommodation}`);
  console.log(`Resolved via direct island-title match: ${byMethod.title}`);
  console.log(`Fell back to parent atoll (no island match found): ${byMethod["atoll-fallback"]}`);
  console.log(`NEEDS MANUAL REVIEW (recorded coordinates contradict the recorded atoll): ${byMethod["needs-manual-review"]}`);
  console.log("");

  if (process.argv.includes("--verbose") || !COMMIT) {
    for (const { fake, resolution } of results) {
      const target = resolution.slug ? `${resolution.targetType}:${resolution.slug}` : "NONE";
      const scoreStr = resolution.score != null ? ` (score ${resolution.score.toFixed(2)})` : "";
      const viaStr = resolution.via ? ` via accommodation "${resolution.via}"` : "";
      console.log(`  ${fake.slug} (tr_refs=${fake.tr_refs}) -> ${target} [${resolution.method}]${scoreStr}${viaStr}`);
    }
  }

  if (!COMMIT) {
    console.log(`\n(report mode — pass --commit to write the migration SQL; --verbose to see every resolution)`);
    return;
  }

  const needsReview = results.filter((r) => r.resolution.method === "needs-manual-review");
  const resolved = results.filter((r) => r.resolution.method !== "needs-manual-review");
  if (needsReview.length > 0) {
    console.log(`\nSkipping ${needsReview.length} node(s) pending manual confirmation (not included in the generated SQL):`);
    for (const r of needsReview) console.log(`  ${r.fake.slug} — recorded at lat ${r.fake.lat}, lng ${r.fake.lng} (outside Kaafu's real range) but its parent atoll defaults to "kaafu"`);
  }

  const lines = [];
  lines.push("-- Entity cleanup: archive the fake resort-named 'island' location");
  lines.push("-- nodes the Task 18 legacy transfer rebuild auto-created (see");
  lines.push("-- scripts/fix-fake-resort-islands.mjs), repoint the transfer routes that");
  lines.push("-- referenced them at the real island/atoll instead, and 301 the old");
  lines.push("-- /maldives/islands/{slug}/ URL to the correct canonical destination.");
  lines.push("-- GENERATED FILE, regenerate with:");
  lines.push("--   node scripts/fix-fake-resort-islands.mjs --commit");
  lines.push("");

  for (const { fake, resolution } of resolved) {
    const targetPath = resolution.targetType === "island" ? `/maldives/islands/${resolution.slug}/` : `/maldives/atolls/${resolution.slug}/`;
    const oldPath = `/maldives/islands/${fake.slug}/`;

    const fakeIdExpr = `(select id from nodes where node_type = 'location' and slug = ${sqlString(fake.slug)})`;
    const targetIdExpr = `(select id from nodes where node_type = 'location' and slug = ${sqlString(resolution.slug)})`;

    lines.push(`-- ${fake.title} (${fake.slug}) -> ${resolution.targetType}:${resolution.slug} [${resolution.method}]`);
    // Repointing destination_location_id can collide with an existing
    // transfer_routes row sharing the same (origin, destination) pair —
    // e.g. several different fake resort destinations all falling back
    // to the same real atoll from the same airport. A plain UPDATE would
    // hit transfer_routes_origin_location_id_destination_location_id_key
    // (caught by applying this exact file against a full local-Postgres
    // replay before shipping it). The NOT EXISTS guard below skips the
    // repoint for exactly the colliding routes; the three statements
    // after it are the cleanup for those (redirect this route's own page
    // to the surviving route — collapsing any existing chain onto it
    // first — then drop the now-redundant row). No DO block: this file
    // is meant to be pasted into a plain SQL runner (including the
    // Supabase dashboard's SQL editor, which doesn't handle multi-
    // statement dollar-quoted PL/pgSQL blocks) — every other migration
    // in this project is plain SQL for the same reason.
    lines.push(
      `update transfer_routes as tr1 set destination_location_id = ${targetIdExpr} where tr1.destination_location_id = ${fakeIdExpr} and not exists (select 1 from transfer_routes tr2 where tr2.origin_location_id = tr1.origin_location_id and tr2.destination_location_id = ${targetIdExpr} and tr2.id <> tr1.id);`,
    );
    lines.push(
      `update url_redirects set target_path = '/maldives/transfers/' || survivor.slug || '/', updated_at = now() from transfer_routes tr join nodes n on n.id = tr.id join transfer_routes tr2 on tr2.origin_location_id = tr.origin_location_id and tr2.destination_location_id = ${targetIdExpr} and tr2.id <> tr.id join nodes survivor on survivor.id = tr2.id where tr.destination_location_id = ${fakeIdExpr} and url_redirects.target_path = '/maldives/transfers/' || n.slug || '/' and url_redirects.status_code = 301;`,
    );
    lines.push(
      `insert into url_redirects (source_path, target_type, target_path, status_code, notes) select '/maldives/transfers/' || n.slug || '/', 'path', '/maldives/transfers/' || survivor.slug || '/', 301, 'Entity cleanup: this route duplicated an existing one once its fake destination was repointed to the real island/atoll.' from transfer_routes tr join nodes n on n.id = tr.id join transfer_routes tr2 on tr2.origin_location_id = tr.origin_location_id and tr2.destination_location_id = ${targetIdExpr} and tr2.id <> tr.id join nodes survivor on survivor.id = tr2.id where tr.destination_location_id = ${fakeIdExpr} on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();`,
    );
    lines.push(`delete from nodes where id in (select tr.id from transfer_routes tr where tr.destination_location_id = ${fakeIdExpr});`);
    if (resolution.targetType === "island") {
      // The fake node's own hero photo is a real photo of this real
      // island (it was the resort's own legacy image, taken on that
      // island) — move it across rather than losing it, but only when
      // the real island doesn't already have one of its own.
      lines.push(
        `update node_media as nm set node_id = ${targetIdExpr} where nm.node_id = ${fakeIdExpr} and nm.role = 'hero' and not exists (select 1 from node_media nm2 where nm2.node_id = ${targetIdExpr} and nm2.role = 'hero');`,
      );
    }
    lines.push(`update nodes set status = 'archived' where node_type = 'location' and slug = ${sqlString(fake.slug)};`);
    // Archive (never delete — keeps the row and its media/history intact,
    // and status='archived' fails every repository query's
    // .eq("status","published") filter and the locations_public_read RLS
    // policy, so it stops appearing in listings, search, and the sitemap
    // without any code change). Handled inside the DO block above, ahead
    // of this comment only for readability of the generated file.
    // 301 the old URL to the real canonical destination — never to the
    // resort page, per the task spec (a destination URL must resolve to
    // a destination, not an accommodation).
    lines.push(
      `insert into url_redirects (source_path, target_type, target_path, status_code, notes) values (${sqlString(oldPath)}, 'path', ${sqlString(targetPath)}, 301, 'Entity cleanup: this was a fake island node auto-created from a legacy transfer destination name (the real resort is a separate accommodation entity) — resolved via ${resolution.method}.') on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();`,
    );
    lines.push("");
  }

  const outPath = path.join(ROOT, "supabase", "migrations", "20250126000100_fix_fake_resort_islands.sql");
  writeFileSync(outPath, lines.join("\n") + "\n");
  console.log(`Wrote ${path.relative(ROOT, outPath)}`);

  const reportPath = path.join(ROOT, "data", "maldives", "locations", "fake-resort-island-cleanup-report.json");
  writeFileSync(
    reportPath,
    JSON.stringify(
      {
        generatedAt: new Date().toISOString(),
        total: results.length,
        byMethod,
        entries: results.map((r) => ({
          fakeSlug: r.fake.slug,
          fakeTitle: r.fake.title,
          transferRoutesRepointed: r.fake.tr_refs,
          resolutionMethod: r.resolution.method,
          resolvedTo: r.resolution.slug ? `${r.resolution.targetType}:${r.resolution.slug}` : null,
          score: r.resolution.score,
        })),
      },
      null,
      2,
    ),
  );
  console.log(`Wrote ${path.relative(ROOT, reportPath)}`);
}

main();
