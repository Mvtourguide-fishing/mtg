#!/usr/bin/env node
// Attaches real legacy images to surf break location nodes via node_media
// (role = 'hero'). No new media_assets rows — every image below already
// exists from 20250115000100_full_legacy_image_library.sql (confirmed by
// grep). Same pattern as attach-dive-site-images.mjs / attach-island-images.mjs.
//
// Provenance: every entry here is a real photo whose filename directly names
// the specific wave/break it depicts (verified by listing
// release/public_html/images/surfing/*.webp during the photo-bug audit) —
// this is the complete real per-surf-break photo coverage found in the
// legacy export (8 of the 13 seeded surf breaks; the rest — Honky's, Ninjas,
// Guraidhoo Corner, Isdoo Corner, Castaways — have no genuine break-specific
// photo available and get none rather than a stock/generic substitute, same
// no-fallback-for-a-named-entity policy applied to islands).
//
// Slugs verified against scripts/generate-surfing-seed.mjs's
// assignUniqueSlug(brk.name, usedBreakSlugs, atollSlug): all 13 surf break
// names in data/maldives/surfing/surf_breaks.json are distinct, so every
// slug below is simply slugify(name) with no disambiguator suffix applied.
//
// Usage: node scripts/attach-surf-break-images.mjs > supabase/migrations/20250122000800_surf_break_images.sql

import { deterministicUuid, storagePathForRelativePath } from "./lib/legacy-shared.mjs";

const SURF_BREAKS = [
  { slug: "cokes", relativePath: "images/surfing/maldives-surfing-Wave-Cokes.webp" },
  { slug: "chickens", relativePath: "images/surfing/maldives-surfing-Wave-chicken.webp" },
  { slug: "sultans", relativePath: "images/surfing/maldives-surfing-Wave-Sultans.webp" },
  { slug: "jailbreak", relativePath: "images/surfing/maldives-surfing-Wave-Jailbreaks.webp" },
  { slug: "pasta-point", relativePath: "images/surfing/Cinnamon-Dhonveli-Pasta-Point.webp" },
  { slug: "yin-yang", relativePath: "images/surfing/maldives-surfing-Wave-Yin-Yang.webp" },
  { slug: "tiger-stripes", relativePath: "images/surfing/maldives-surfing-Tiger-Stripes.webp" },
  { slug: "beacons", relativePath: "images/surfing/maldives-surfing-Wave-Beacons.webp" },
];

const lines = [];
lines.push("-- Attaches real legacy images to surf break location nodes (node_media");
lines.push("-- role = 'hero'). No new media_assets rows — every id below already");
lines.push("-- exists from 20250115000100_full_legacy_image_library.sql.");
lines.push("-- GENERATED FILE, regenerate with:");
lines.push("--   node scripts/attach-surf-break-images.mjs");
lines.push("");

for (const brk of SURF_BREAKS) {
  const mediaId = deterministicUuid(`legacy-media::${brk.relativePath}`);
  const storagePath = storagePathForRelativePath(brk.relativePath);
  lines.push(`-- ${brk.slug}: ${storagePath}`);
  lines.push(
    `delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = '${brk.slug}');`,
  );
  lines.push(
    `insert into node_media (node_id, media_id, role, sort_order) select id, '${mediaId}', 'hero', 0 from nodes where node_type = 'location' and slug = '${brk.slug}' on conflict (node_id, media_id, role) do nothing;`,
  );
  lines.push("");
}

process.stdout.write(lines.join("\n") + "\n");
