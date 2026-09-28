-- Attaches real legacy images to surf break location nodes (node_media
-- role = 'hero'). No new media_assets rows — every id below already
-- exists from 20250115000100_full_legacy_image_library.sql.
-- GENERATED FILE, regenerate with:
--   node scripts/attach-surf-break-images.mjs

-- cokes: legacy/images/surfing/maldives-surfing-wave-cokes.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'cokes');
insert into node_media (node_id, media_id, role, sort_order) select id, '845dac76-ddef-da0c-52e1-0b45c1c45318', 'hero', 0 from nodes where node_type = 'location' and slug = 'cokes' on conflict (node_id, media_id, role) do nothing;

-- chickens: legacy/images/surfing/maldives-surfing-wave-chicken.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'chickens');
insert into node_media (node_id, media_id, role, sort_order) select id, 'df9419bb-eba4-776f-9518-ff71f4d805b8', 'hero', 0 from nodes where node_type = 'location' and slug = 'chickens' on conflict (node_id, media_id, role) do nothing;

-- sultans: legacy/images/surfing/maldives-surfing-wave-sultans.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'sultans');
insert into node_media (node_id, media_id, role, sort_order) select id, 'ccff4cbb-585a-ab9c-1ed4-ba04dc942f52', 'hero', 0 from nodes where node_type = 'location' and slug = 'sultans' on conflict (node_id, media_id, role) do nothing;

-- jailbreak: legacy/images/surfing/maldives-surfing-wave-jailbreaks.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'jailbreak');
insert into node_media (node_id, media_id, role, sort_order) select id, '95e72247-381a-a20e-488c-f82fa68b7cdf', 'hero', 0 from nodes where node_type = 'location' and slug = 'jailbreak' on conflict (node_id, media_id, role) do nothing;

-- pasta-point: legacy/images/surfing/cinnamon-dhonveli-pasta-point.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'pasta-point');
insert into node_media (node_id, media_id, role, sort_order) select id, 'e221bdc4-deee-0ced-9182-d254644e4de2', 'hero', 0 from nodes where node_type = 'location' and slug = 'pasta-point' on conflict (node_id, media_id, role) do nothing;

-- yin-yang: legacy/images/surfing/maldives-surfing-wave-yin-yang.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'yin-yang');
insert into node_media (node_id, media_id, role, sort_order) select id, 'de86cd42-7b6c-fc47-a2d9-e652b288d4fa', 'hero', 0 from nodes where node_type = 'location' and slug = 'yin-yang' on conflict (node_id, media_id, role) do nothing;

-- tiger-stripes: legacy/images/surfing/maldives-surfing-tiger-stripes.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'tiger-stripes');
insert into node_media (node_id, media_id, role, sort_order) select id, '94e6b6c7-e138-5a26-b8c9-5afc81892c67', 'hero', 0 from nodes where node_type = 'location' and slug = 'tiger-stripes' on conflict (node_id, media_id, role) do nothing;

-- beacons: legacy/images/surfing/maldives-surfing-wave-beacons.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'beacons');
insert into node_media (node_id, media_id, role, sort_order) select id, '18e2b056-b50b-ac4f-d179-6c4701c3d418', 'hero', 0 from nodes where node_type = 'location' and slug = 'beacons' on conflict (node_id, media_id, role) do nothing;

