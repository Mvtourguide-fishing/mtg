#!/usr/bin/env node
// Stays ecosystem, Phase 2: redirects the 147 legacy resort/hotel/
// guesthouse pages just migrated (scripts/generate-stays-seed.mjs) to
// their new canonical URL. These properties were previously flagged
// "not yet represented in the MTG accommodation catalogue" in the
// existing redirect-review.json (from the earlier, broader Task 16
// redirect-mapping pass) — that's no longer true, so this closes that
// specific gap without re-running the full redirect-map builder (which
// covers every other vertical and is out of scope for this change).
//
// Only each property's PRIMARY overview page is redirected — the
// per-room `*-booking.html` sub-pages were already confirmed non-content
// (booking-form widgets) by the existing retired-urls.json and are left
// alone here.
//
// Matches the target accommodation by title (not a locally-recomputed
// slug) via a SELECT join, same robustness reasoning as
// scripts/attach-stays-images.mjs — the seed generator's own
// assignUniqueSlug disambiguation isn't reproduced here, so this can
// never point a redirect at the wrong property.
//
// Usage: node scripts/generate-stays-redirects.mjs

import { readFileSync, writeFileSync } from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const V2_DATA_DIR = path.join(ROOT, "data", "maldives", "accommodations-v2");

function sqlString(value) {
  return `'${String(value).replace(/'/g, "''")}'`;
}

const TYPE_SEGMENT = { resort: "resorts", hotel: "hotels", guesthouse: "guesthouses" };

function main() {
  const properties = JSON.parse(readFileSync(path.join(V2_DATA_DIR, "resolved-properties.json"), "utf8"));

  const lines = [];
  lines.push("-- Redirects the 147 migrated legacy resort/hotel/guesthouse pages to");
  lines.push("-- their new canonical URL (Stays ecosystem, Phase 2).");
  lines.push("-- GENERATED FILE — do not hand-edit. Regenerate with:");
  lines.push("--   node scripts/generate-stays-redirects.mjs");
  lines.push("-- Source: data/maldives/accommodations-v2/resolved-properties.json");
  lines.push("--");
  lines.push("-- Matches by node title via a join, not a locally-recomputed slug — see");
  lines.push("-- this script's header comment for why. On conflict this UPDATEs (not");
  lines.push("-- \"do nothing\"), same convention as 20250111000100_legacy_redirects.sql.");
  lines.push("");

  let count = 0;
  for (const p of properties) {
    const segment = TYPE_SEGMENT[p.accommodationType];
    if (!segment) continue;

    const sourcePath = `/${p.sourceFile}`;
    const notes = p.mergeIntoExistingSlug
      ? `[stays-migration] Same resort as the already-seeded "${p.mergeIntoExistingSlug}" — redirected there directly, not to a duplicate page.`
      : `[stays-migration] ${p.name} migrated to the real Stays ecosystem catalogue.`;
    // Merge-case properties share a node with a Task 5 accommodation
    // whose title differs from this property's own p.name (see
    // mergeIntoExistingSlug's comment) — match by the known real slug
    // instead of title for those.
    const nodeSelector = p.mergeIntoExistingSlug ? `n.slug = ${sqlString(p.mergeIntoExistingSlug)}` : `n.title = ${sqlString(p.name)}`;

    lines.push(
      `insert into url_redirects (source_path, target_type, target_path, status_code, notes)`,
    );
    lines.push(
      `select ${sqlString(sourcePath)}, 'path', '/maldives/${segment}/' || n.slug || '/', 301, ${sqlString(notes)}`,
    );
    lines.push(`from nodes n where n.node_type = 'accommodation' and ${nodeSelector}`);
    lines.push(
      `on conflict (source_path) do update set target_type = excluded.target_type, target_path = excluded.target_path, status_code = excluded.status_code, notes = excluded.notes, updated_at = now();`,
    );
    lines.push("");
    count += 1;
  }

  const migrationPath = path.join(ROOT, "supabase", "migrations", "20250123000400_stays_redirects.sql");
  writeFileSync(migrationPath, lines.join("\n") + "\n");
  console.log(`Redirect rows: ${count}`);
  console.log(`Wrote ${migrationPath}`);
}

main();
