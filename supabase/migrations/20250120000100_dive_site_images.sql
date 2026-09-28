-- Attaches real legacy images to the 12 seeded dive_site location nodes
-- (node_media role = 'hero'). No new media_assets rows — every id below
-- already exists from 20250115000100_full_legacy_image_library.sql.
-- GENERATED FILE, regenerate with:
--   node scripts/attach-dive-site-images.mjs

-- banana-reef: exact match: images/diving/North-Male-Atoll-Banana-Reef-Maldives.webp, referenced 4x in release/public_html/diving/banana-reef-maldives.html
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'banana-reef');
insert into node_media (node_id, media_id, role, sort_order) select id, 'f35a4c70-06da-6f90-bed0-03380c678089', 'hero', 0 from nodes where node_type = 'location' and slug = 'banana-reef' on conflict (node_id, media_id, role) do nothing;

-- hp-reef: exact match: images/diving/HP-reef-Male-Atoll.webp, used on release/public_html/articles/maldives-diving-spots.html and diving/maldives-diving.html to depict this site
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'hp-reef');
insert into node_media (node_id, media_id, role, sort_order) select id, 'e5e75530-eb83-0dd5-c871-bc41f28010a0', 'hero', 0 from nodes where node_type = 'location' and slug = 'hp-reef' on conflict (node_id, media_id, role) do nothing;

-- lankan-manta-point: exact match: images/diving/Manta-Point-Lankanfinolhu-Island.webp, referenced 2x in release/public_html/diving/manta-point-maldives.html
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'lankan-manta-point');
insert into node_media (node_id, media_id, role, sort_order) select id, 'bf39851a-0019-c28f-6f3c-8be91ec35ee0', 'hero', 0 from nodes where node_type = 'location' and slug = 'lankan-manta-point' on conflict (node_id, media_id, role) do nothing;

-- fish-head-mushimasmingili-thila: GENERIC fallback — no legacy photo names Fish Head specifically; real diving-environment photo from the same library
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'fish-head-mushimasmingili-thila');
insert into node_media (node_id, media_id, role, sort_order) select id, 'b7a13e6a-5efe-f05a-331f-4ddeaba017c9', 'hero', 0 from nodes where node_type = 'location' and slug = 'fish-head-mushimasmingili-thila' on conflict (node_id, media_id, role) do nothing;

-- kuda-rah-thila: GENERIC fallback — no legacy page/photo exists for Kuda Rah Thila specifically
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'kuda-rah-thila');
insert into node_media (node_id, media_id, role, sort_order) select id, '1b632642-8108-ecbf-5b74-aa4a3b6e5fe0', 'hero', 0 from nodes where node_type = 'location' and slug = 'kuda-rah-thila' on conflict (node_id, media_id, role) do nothing;

-- guraidhoo-kandu: exact match by real-world name: our seed data's own sourcing note ties Guraidhoo Kandu to Wikipedia's 'Fushi Kandu' name for the same site; images/diving/Fushi-Kandu-maldives.webp is used on release/public_html/diving/maldives-diving.html and scuba-diving-in-maldives.html
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'guraidhoo-kandu');
insert into node_media (node_id, media_id, role, sort_order) select id, 'fc4f382c-eb59-731f-ded0-a046bfb13c38', 'hero', 0 from nodes where node_type = 'location' and slug = 'guraidhoo-kandu' on conflict (node_id, media_id, role) do nothing;

-- kandooma-thila: exact match: images/diving/South-Male-Atoll-Kandooma-Thila-Maldives.webp, referenced in release/public_html/diving/kandooma-thila-maldives.html
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'kandooma-thila');
insert into node_media (node_id, media_id, role, sort_order) select id, '35ba29b0-e64b-dc11-a3ed-7ba968344ba0', 'hero', 0 from nodes where node_type = 'location' and slug = 'kandooma-thila' on conflict (node_id, media_id, role) do nothing;

-- maaya-thila: exact match: images/diving/Ari-Atoll-Maaya-Thila-Maldives.webp, referenced 3x in release/public_html/diving/maya-thila-maldives.html
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'maaya-thila');
insert into node_media (node_id, media_id, role, sort_order) select id, '21f35349-02c7-0ad2-d2f3-19f084ddaa86', 'hero', 0 from nodes where node_type = 'location' and slug = 'maaya-thila' on conflict (node_id, media_id, role) do nothing;

-- rasdhoo-madivaru: exact match: images/diving/Madivaru-Corner-maldives.webp, the actual header image on release/public_html/diving/rasdhoo-madivaru-maldives.html (2x)
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'rasdhoo-madivaru');
insert into node_media (node_id, media_id, role, sort_order) select id, '9b9a29e5-73ff-8a6a-30cf-5aaffcb1147c', 'hero', 0 from nodes where node_type = 'location' and slug = 'rasdhoo-madivaru' on conflict (node_id, media_id, role) do nothing;

-- kuda-giri-wreck: GENERIC fallback — real Maldives wreck-diving photo (a different named wreck), no legacy page exists for Kuda Giri Wreck specifically
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'kuda-giri-wreck');
insert into node_media (node_id, media_id, role, sort_order) select id, '6de043c9-baab-3903-e3dc-76a981383ddf', 'hero', 0 from nodes where node_type = 'location' and slug = 'kuda-giri-wreck' on conflict (node_id, media_id, role) do nothing;

-- okobe-thila: GENERIC fallback — no legacy page/photo exists for Okobe Thila specifically
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'okobe-thila');
insert into node_media (node_id, media_id, role, sort_order) select id, '7e6594bf-7b16-1a1a-47e0-79ca5ca1c1fe', 'hero', 0 from nodes where node_type = 'location' and slug = 'okobe-thila' on conflict (node_id, media_id, role) do nothing;

-- vaadhoo-caves: GENERIC fallback — real Maldives coral-garden photo (a different named site), no legacy page exists for Vaadhoo Caves specifically
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'vaadhoo-caves');
insert into node_media (node_id, media_id, role, sort_order) select id, 'b168136b-5954-7363-1938-3ebc25d6ef97', 'hero', 0 from nodes where node_type = 'location' and slug = 'vaadhoo-caves' on conflict (node_id, media_id, role) do nothing;

