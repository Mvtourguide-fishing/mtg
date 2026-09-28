-- Attaches real legacy images to island location nodes (node_media
-- role = 'hero'). No new media_assets rows — every id below already
-- exists from 20250115000100_full_legacy_image_library.sql.
-- GENERATED FILE, regenerate with:
--   node scripts/attach-island-images.mjs

-- fulidhoo: legacy/atolls/vaavu-atoll/images/vaavu-fulidhoo-island-maldives.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'fulidhoo');
insert into node_media (node_id, media_id, role, sort_order) select id, '9d02c258-3087-949a-bd78-8ebaa7e28fb3', 'hero', 0 from nodes where node_type = 'location' and slug = 'fulidhoo' on conflict (node_id, media_id, role) do nothing;

-- felidhoo: legacy/atolls/vaavu-atoll/images/vaavu-felidhoo-island-maldives.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'felidhoo');
insert into node_media (node_id, media_id, role, sort_order) select id, '93adf476-3d82-c5d1-469c-88a15d57815c', 'hero', 0 from nodes where node_type = 'location' and slug = 'felidhoo' on conflict (node_id, media_id, role) do nothing;

-- keyodhoo: legacy/atolls/vaavu-atoll/images/vaavu-keyodhoo-island-maldives.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'keyodhoo');
insert into node_media (node_id, media_id, role, sort_order) select id, '55e6a7a6-bdfa-fb21-5a4d-766f6f741f82', 'hero', 0 from nodes where node_type = 'location' and slug = 'keyodhoo' on conflict (node_id, media_id, role) do nothing;

-- rakeedhoo: legacy/atolls/vaavu-atoll/images/vaavu-rakeedhoo-island-maldives.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'rakeedhoo');
insert into node_media (node_id, media_id, role, sort_order) select id, '18f6a545-8af2-35d1-46bf-4d32705b69aa', 'hero', 0 from nodes where node_type = 'location' and slug = 'rakeedhoo' on conflict (node_id, media_id, role) do nothing;

-- thinadhoo: legacy/atolls/vaavu-atoll/images/vaavu-thinadhoo-island-maldives.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'thinadhoo');
insert into node_media (node_id, media_id, role, sort_order) select id, '18dcab31-f451-7d75-7f53-e70e7ff8be2e', 'hero', 0 from nodes where node_type = 'location' and slug = 'thinadhoo' on conflict (node_id, media_id, role) do nothing;

-- hinnavaru: legacy/atolls/lhaviyani-atoll/images/lhaviyani-hinnavaru-island-maldives.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'hinnavaru');
insert into node_media (node_id, media_id, role, sort_order) select id, '63c3040a-3ddb-6399-967c-32855f127304', 'hero', 0 from nodes where node_type = 'location' and slug = 'hinnavaru' on conflict (node_id, media_id, role) do nothing;

-- kurendhoo: legacy/atolls/lhaviyani-atoll/images/lhaviyani-kurendhoo-island-maldives.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'kurendhoo');
insert into node_media (node_id, media_id, role, sort_order) select id, '13b5b92d-ee8f-5067-4d93-055456e80408', 'hero', 0 from nodes where node_type = 'location' and slug = 'kurendhoo' on conflict (node_id, media_id, role) do nothing;

-- naifaru: legacy/atolls/lhaviyani-atoll/images/lhaviyani-naifaru-island-maldives.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'naifaru');
insert into node_media (node_id, media_id, role, sort_order) select id, '36533b4a-5fd1-03a9-e346-e61bb55bf3c8', 'hero', 0 from nodes where node_type = 'location' and slug = 'naifaru' on conflict (node_id, media_id, role) do nothing;

-- olhuvelifushi: legacy/atolls/lhaviyani-atoll/images/lhaviyani-olhuvelifushi-island-maldives.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'olhuvelifushi');
insert into node_media (node_id, media_id, role, sort_order) select id, 'ee3cc236-eb61-c738-6ab5-fdc717514616', 'hero', 0 from nodes where node_type = 'location' and slug = 'olhuvelifushi' on conflict (node_id, media_id, role) do nothing;

-- fuvahmulah: legacy/images/islands/fuvahmulah-island-maldives.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'fuvahmulah');
insert into node_media (node_id, media_id, role, sort_order) select id, 'bf01cbee-781a-da2f-93d4-bf41355494b0', 'hero', 0 from nodes where node_type = 'location' and slug = 'fuvahmulah' on conflict (node_id, media_id, role) do nothing;

-- maafushi: legacy/images/islands/kaafu-maafushi-island.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'maafushi');
insert into node_media (node_id, media_id, role, sort_order) select id, '6109d37c-fdf2-b948-d864-39bd596b0e97', 'hero', 0 from nodes where node_type = 'location' and slug = 'maafushi' on conflict (node_id, media_id, role) do nothing;

-- thulusdhoo: legacy/images/islands/thullusdhoo-island-maldives.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'thulusdhoo');
insert into node_media (node_id, media_id, role, sort_order) select id, '14abb358-afc7-69c5-9e9d-9493c7c6c1c5', 'hero', 0 from nodes where node_type = 'location' and slug = 'thulusdhoo' on conflict (node_id, media_id, role) do nothing;

-- hulhumale: legacy/images/islands/hulhumale-city-maldives.webp
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'location' and slug = 'hulhumale');
insert into node_media (node_id, media_id, role, sort_order) select id, 'd9107079-e4e4-514b-f806-f39de7861d51', 'hero', 0 from nodes where node_type = 'location' and slug = 'hulhumale' on conflict (node_id, media_id, role) do nothing;

