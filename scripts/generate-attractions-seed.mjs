#!/usr/bin/env node
// Generates the Maldives Attractions seed migration from
// data/maldives/attractions/attractions.json — real, sourced landmarks
// (location_type = 'poi'), the same architecture already used for dive
// sites and surf breaks. No new media_assets rows — every image id
// already exists from 20250115000100_full_legacy_image_library.sql.
//
// Usage: node scripts/generate-attractions-seed.mjs > supabase/migrations/20250121000100_seed_attractions.sql

import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import path from "node:path";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const attractions = JSON.parse(readFileSync(path.join(__dirname, "../data/maldives/attractions/attractions.json"), "utf-8"));

function sqlString(value) {
  return `'${String(value).replace(/'/g, "''")}'`;
}

function ltreeLabel(slug) {
  return slug.replace(/-/g, "_");
}

const lines = [];
lines.push("-- Maldives Attractions: real, sourced points of interest (location_type = 'poi'),");
lines.push("-- the same architecture already used for dive sites and surf breaks — no new");
lines.push("-- table, no duplicate entity model. Source:");
lines.push("--   data/maldives/attractions/attractions.json");
lines.push("--   data/maldives/attractions/SOURCES.md");
lines.push("-- GENERATED FILE, regenerate with:");
lines.push("--   node scripts/generate-attractions-seed.mjs");
lines.push("");

for (const a of attractions) {
  const attrs = {
    attraction_type: a.attraction_type,
    best_for: a.best_for,
    source_article_slug: a.source_article_slug,
    body: a.body,
  };
  const attrsJson = JSON.stringify(attrs).replace(/'/g, "''");

  lines.push(
    `insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at) values ('location', ${sqlString(a.slug)}, ${sqlString(a.title)}, ${sqlString(a.summary)}, 'published', ${sqlString(`${a.title} | Maldives Attractions | MTG`)}, ${sqlString(a.summary)}, '${attrsJson}'::jsonb, now()) on conflict (node_type, slug) do nothing;`,
  );
  lines.push(
    `insert into locations (id, location_type, parent_id, path) select n.id, 'poi', p.id, (p_loc.path || '${ltreeLabel(a.slug)}'::ltree) from nodes n, nodes p join locations p_loc on p_loc.id = p.id where n.node_type = 'location' and n.slug = ${sqlString(a.slug)} and p.node_type = 'location' and p.slug = ${sqlString(a.parent_location_slug)} on conflict (id) do nothing;`,
  );

  if (a.image) {
    lines.push(
      `delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = ${sqlString(a.slug)});`,
    );
    lines.push(
      `insert into node_media (node_id, media_id, role, sort_order) select id, ${sqlString(a.image.mediaId)}, 'hero', 0 from nodes where node_type = 'location' and slug = ${sqlString(a.slug)} on conflict (node_id, media_id, role) do nothing;`,
    );
  }

  lines.push("");
}

process.stdout.write(lines.join("\n") + "\n");
