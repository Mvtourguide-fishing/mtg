#!/usr/bin/env node
// Attaches real legacy images to the 12 seeded dive_site nodes (node_type =
// 'location', location_type = 'dive_site') via node_media (role = 'hero').
// No new media_assets rows — every id below already exists from
// 20250115000100_full_legacy_image_library.sql.
//
// Provenance: 7 of the 12 sites have a legacy image whose filename directly
// names that exact site (e.g. HP-reef-Male-Atoll.webp for hp-reef) and which
// is genuinely used on the legacy site to depict that site (confirmed via
// grep against release/public_html — see each entry's `note`). The other 5
// sites have no site-specific legacy photo, so they get an honest, clearly
// generic real diving photo from the same library instead (never presented
// as if it were a specific, unverified photo of that site) — the same
// fallback approach already used for PACKAGE_CATEGORY_FALLBACK_IMAGES.
//
// Usage: node scripts/attach-dive-site-images.mjs > supabase/migrations/20250120000100_dive_site_images.sql

const SITES = [
  {
    slug: "banana-reef",
    mediaId: "f35a4c70-06da-6f90-bed0-03380c678089",
    storagePath: "legacy/images/diving/north-male-atoll-banana-reef-maldives.webp",
    note: "exact match: images/diving/North-Male-Atoll-Banana-Reef-Maldives.webp, referenced 4x in release/public_html/diving/banana-reef-maldives.html",
  },
  {
    slug: "hp-reef",
    mediaId: "e5e75530-eb83-0dd5-c871-bc41f28010a0",
    storagePath: "legacy/images/diving/hp-reef-male-atoll.webp",
    note: "exact match: images/diving/HP-reef-Male-Atoll.webp, used on release/public_html/articles/maldives-diving-spots.html and diving/maldives-diving.html to depict this site",
  },
  {
    slug: "lankan-manta-point",
    mediaId: "bf39851a-0019-c28f-6f3c-8be91ec35ee0",
    storagePath: "legacy/images/diving/manta-point-lankanfinolhu-island.webp",
    note: "exact match: images/diving/Manta-Point-Lankanfinolhu-Island.webp, referenced 2x in release/public_html/diving/manta-point-maldives.html",
  },
  {
    slug: "fish-head-mushimasmingili-thila",
    mediaId: "b7a13e6a-5efe-f05a-331f-4ddeaba017c9",
    storagePath: "legacy/images/diving/maldives-dive-environment.webp",
    note: "GENERIC fallback — no legacy photo names Fish Head specifically; real diving-environment photo from the same library",
  },
  {
    slug: "kuda-rah-thila",
    mediaId: "1b632642-8108-ecbf-5b74-aa4a3b6e5fe0",
    storagePath: "legacy/images/diving/maldives-dive-site-madigaa.webp",
    note: "GENERIC fallback — no legacy page/photo exists for Kuda Rah Thila specifically",
  },
  {
    slug: "guraidhoo-kandu",
    mediaId: "fc4f382c-eb59-731f-ded0-a046bfb13c38",
    storagePath: "legacy/images/diving/fushi-kandu-maldives.webp",
    note: "exact match by real-world name: our seed data's own sourcing note ties Guraidhoo Kandu to Wikipedia's 'Fushi Kandu' name for the same site; images/diving/Fushi-Kandu-maldives.webp is used on release/public_html/diving/maldives-diving.html and scuba-diving-in-maldives.html",
  },
  {
    slug: "kandooma-thila",
    mediaId: "35ba29b0-e64b-dc11-a3ed-7ba968344ba0",
    storagePath: "legacy/images/diving/south-male-atoll-kandooma-thila-maldives.webp",
    note: "exact match: images/diving/South-Male-Atoll-Kandooma-Thila-Maldives.webp, referenced in release/public_html/diving/kandooma-thila-maldives.html",
  },
  {
    slug: "maaya-thila",
    mediaId: "21f35349-02c7-0ad2-d2f3-19f084ddaa86",
    storagePath: "legacy/images/diving/ari-atoll-maaya-thila-maldives.webp",
    note: "exact match: images/diving/Ari-Atoll-Maaya-Thila-Maldives.webp, referenced 3x in release/public_html/diving/maya-thila-maldives.html",
  },
  {
    slug: "rasdhoo-madivaru",
    mediaId: "9b9a29e5-73ff-8a6a-30cf-5aaffcb1147c",
    storagePath: "legacy/images/diving/madivaru-corner-maldives.webp",
    note: "exact match: images/diving/Madivaru-Corner-maldives.webp, the actual header image on release/public_html/diving/rasdhoo-madivaru-maldives.html (2x)",
  },
  {
    slug: "kuda-giri-wreck",
    mediaId: "6de043c9-baab-3903-e3dc-76a981383ddf",
    storagePath: "legacy/images/activities/alif-alif-fesdhoo-wreck-maldives.webp",
    note: "GENERIC fallback — real Maldives wreck-diving photo (a different named wreck), no legacy page exists for Kuda Giri Wreck specifically",
  },
  {
    slug: "okobe-thila",
    mediaId: "7e6594bf-7b16-1a1a-47e0-79ca5ca1c1fe",
    storagePath: "legacy/images/diving/maldives-dive-site-veligandu-east.webp",
    note: "GENERIC fallback — no legacy page/photo exists for Okobe Thila specifically",
  },
  {
    slug: "vaadhoo-caves",
    mediaId: "b168136b-5954-7363-1938-3ebc25d6ef97",
    storagePath: "legacy/images/diving/meedhoo-coral-garden.webp",
    note: "GENERIC fallback — real Maldives coral-garden photo (a different named site), no legacy page exists for Vaadhoo Caves specifically",
  },
];

const lines = [];
lines.push("-- Attaches real legacy images to the 12 seeded dive_site location nodes");
lines.push("-- (node_media role = 'hero'). No new media_assets rows — every id below");
lines.push("-- already exists from 20250115000100_full_legacy_image_library.sql.");
lines.push("-- GENERATED FILE, regenerate with:");
lines.push("--   node scripts/attach-dive-site-images.mjs");
lines.push("");

for (const site of SITES) {
  lines.push(`-- ${site.slug}: ${site.note}`);
  lines.push(
    `delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = '${site.slug}');`,
  );
  lines.push(
    `insert into node_media (node_id, media_id, role, sort_order) select id, '${site.mediaId}', 'hero', 0 from nodes where node_type = 'location' and slug = '${site.slug}' on conflict (node_id, media_id, role) do nothing;`,
  );
  lines.push("");
}

process.stdout.write(lines.join("\n") + "\n");
