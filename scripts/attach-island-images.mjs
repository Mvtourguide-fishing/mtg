#!/usr/bin/env node
// Attaches real legacy images to island location nodes via node_media
// (role = 'hero'). No new media_assets rows — every image below already
// exists from 20250115000100_full_legacy_image_library.sql (confirmed by
// grep). Same pattern as attach-dive-site-images.mjs.
//
// Provenance: every entry here is a real photo whose filename directly
// names the specific island it depicts (verified by listing
// release/public_html/atolls/*/images/ and release/public_html/images/islands/
// during the Phase 4 audit) — this is the complete real per-island photo
// coverage found in the legacy export (13 of 193 islands; the rest have
// no genuine island-specific photo available, and get none rather than a
// stock/generic substitute, since — unlike dive sites, where a labeled
// "generic diving photo" is an honest fallback — a wrong island's photo
// under a different island's name would be actively misleading).
//
// Usage: node scripts/attach-island-images.mjs > supabase/migrations/20250122000700_island_images.sql

import { deterministicUuid, storagePathForRelativePath } from "./lib/legacy-shared.mjs";

const ISLANDS = [
  { slug: "fulidhoo", relativePath: "atolls/vaavu-atoll/images/vaavu-fulidhoo-island-maldives.webp" },
  { slug: "felidhoo", relativePath: "atolls/vaavu-atoll/images/vaavu-felidhoo-island-maldives.webp" },
  { slug: "keyodhoo", relativePath: "atolls/vaavu-atoll/images/vaavu-keyodhoo-island-maldives.webp" },
  { slug: "rakeedhoo", relativePath: "atolls/vaavu-atoll/images/vaavu-rakeedhoo-island-maldives.webp" },
  { slug: "thinadhoo", relativePath: "atolls/vaavu-atoll/images/vaavu-thinadhoo-island-maldives.webp" },
  { slug: "hinnavaru", relativePath: "atolls/lhaviyani-atoll/images/lhaviyani-hinnavaru-island-maldives.webp" },
  { slug: "kurendhoo", relativePath: "atolls/lhaviyani-atoll/images/lhaviyani-kurendhoo-island-maldives.webp" },
  { slug: "naifaru", relativePath: "atolls/lhaviyani-atoll/images/lhaviyani-naifaru-island-maldives.webp" },
  { slug: "olhuvelifushi", relativePath: "atolls/lhaviyani-atoll/images/lhaviyani-olhuvelifushi-island-maldives.webp" },
  // Curated /images/islands/ set preferred over the duplicate copies also
  // sitting in various atoll folders (same photo, same relativePath would
  // produce the same media_assets id either way — this just picks one).
  { slug: "fuvahmulah", relativePath: "images/islands/fuvahmulah-island-maldives.webp" },
  { slug: "maafushi", relativePath: "images/islands/kaafu-maafushi-island.webp" },
  { slug: "thulusdhoo", relativePath: "images/islands/thullusdhoo-island-maldives.webp" },
  { slug: "hulhumale", relativePath: "images/islands/hulhumale-city-maldives.webp" },
];

const lines = [];
lines.push("-- Attaches real legacy images to island location nodes (node_media");
lines.push("-- role = 'hero'). No new media_assets rows — every id below already");
lines.push("-- exists from 20250115000100_full_legacy_image_library.sql.");
lines.push("-- GENERATED FILE, regenerate with:");
lines.push("--   node scripts/attach-island-images.mjs");
lines.push("");

for (const island of ISLANDS) {
  const mediaId = deterministicUuid(`legacy-media::${island.relativePath}`);
  const storagePath = storagePathForRelativePath(island.relativePath);
  lines.push(`-- ${island.slug}: ${storagePath}`);
  lines.push(
    `delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = '${island.slug}');`,
  );
  lines.push(
    `insert into node_media (node_id, media_id, role, sort_order) select id, '${mediaId}', 'hero', 0 from nodes where node_type = 'location' and slug = '${island.slug}' on conflict (node_id, media_id, role) do nothing;`,
  );
  lines.push("");
}

process.stdout.write(lines.join("\n") + "\n");
