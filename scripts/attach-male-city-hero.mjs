#!/usr/bin/env node
// One-off, manually-confirmed fix: assets/uploads/articles/visit-male-city.webp
// is a real, correct photo for the "Malé City" location node (slug
// male-city, atollCode MLE) — never auto-matched by round 2/3 because the
// atoll-alias parser resolves the token "male" to Kaafu atoll's code (K),
// which is correct for "North/South Male Atoll" references but not for
// this separate MLE-coded city entity, so the generic matcher never
// considered it a candidate. Not folded into the alias table itself
// because that would make every future "male"-containing filename
// ambiguous between Kaafu atoll and Malé City.

import { writeFileSync } from "node:fs";
import path from "node:path";

import { DATA_DIR, deterministicUuid, ROOT, toAsciiSafe } from "./lib/legacy-shared.mjs";

const relativePath = "assets/uploads/articles/visit-male-city.webp";
const mediaId = deterministicUuid(`uploaded-media::${relativePath}`);
const storagePath = "uploads/assets/uploads/articles/visit-male-city.webp";
const altText = "visit male city";

function sqlString(value) {
  return `'${toAsciiSafe(String(value)).replace(/'/g, "''")}'`;
}

const lines = [
  "-- Manual fix: visit-male-city.webp <- Malé City location (see",
  "-- scripts/attach-male-city-hero.mjs for why this needed a manual match",
  "-- instead of the round 2/3 automated matcher).",
  `insert into media_assets (id, media_type, storage_path, alt_text) values (${sqlString(mediaId)}, 'image', ${sqlString(storagePath)}, ${sqlString(altText)}) on conflict (id) do nothing;`,
  `insert into node_media (node_id, media_id, role, sort_order) select id, ${sqlString(mediaId)}, 'hero', 0 from nodes where node_type = 'location' and slug = 'male-city' on conflict (node_id, media_id, role) do nothing;`,
  "",
];

const outPath = path.join(ROOT, "supabase", "migrations", "20250125000300_male_city_hero.sql");
writeFileSync(outPath, lines.join("\n"));
console.log(`Wrote ${path.relative(ROOT, outPath)}`);

const manifestPath = path.join(DATA_DIR, "migration", "male-city-hero-manifest.json");
writeFileSync(
  manifestPath,
  JSON.stringify({ generatedAt: new Date().toISOString(), files: [{ mediaId, relativePath, storagePath, altText }] }, null, 2),
);
console.log(`Wrote ${path.relative(ROOT, manifestPath)}`);
