-- Task 21 follow-on: backfill hero images for real accommodations
-- that Task 14's original high-confidence-only import missed, now
-- matched against the FULL resorts/ and hotels/ image libraries.
-- GENERATED FILE, regenerate with:
--   node scripts/attach-accommodation-images.mjs --commit

delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'accommodation' and title = 'Kurumba Maldives');
insert into node_media (node_id, media_id, role, sort_order) select id, '86add9a7-4d73-efe1-23c6-dea96c118390', 'hero', 0 from nodes where node_type = 'accommodation' and title = 'Kurumba Maldives' on conflict (node_id, media_id, role) do nothing;
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'accommodation' and title = 'Soneva Fushi');
insert into node_media (node_id, media_id, role, sort_order) select id, '9b8db8dc-f547-6730-e627-efa5b1c20fb5', 'hero', 0 from nodes where node_type = 'accommodation' and title = 'Soneva Fushi' on conflict (node_id, media_id, role) do nothing;
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'accommodation' and title = 'Velassaru Maldives');
insert into node_media (node_id, media_id, role, sort_order) select id, '3010fffd-82b4-262f-3bf4-415ae933062c', 'hero', 0 from nodes where node_type = 'accommodation' and title = 'Velassaru Maldives' on conflict (node_id, media_id, role) do nothing;
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'accommodation' and title = 'Six Senses Laamu');
insert into node_media (node_id, media_id, role, sort_order) select id, '48f4113a-34bb-51ab-4a70-56791633dae9', 'hero', 0 from nodes where node_type = 'accommodation' and title = 'Six Senses Laamu' on conflict (node_id, media_id, role) do nothing;
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'accommodation' and title = 'Baros Maldives');
insert into node_media (node_id, media_id, role, sort_order) select id, '177d517a-c13c-80a3-5909-99f4d4076cbe', 'hero', 0 from nodes where node_type = 'accommodation' and title = 'Baros Maldives' on conflict (node_id, media_id, role) do nothing;
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'accommodation' and title = 'Gili Lankanfushi');
insert into node_media (node_id, media_id, role, sort_order) select id, '72d57239-0ddf-2e16-248f-15b5a91edac0', 'hero', 0 from nodes where node_type = 'accommodation' and title = 'Gili Lankanfushi' on conflict (node_id, media_id, role) do nothing;
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'accommodation' and title = 'Arena Beach Hotel');
insert into node_media (node_id, media_id, role, sort_order) select id, '9575e9f7-bf40-8629-751f-2297690462b3', 'hero', 0 from nodes where node_type = 'accommodation' and title = 'Arena Beach Hotel' on conflict (node_id, media_id, role) do nothing;
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'accommodation' and title = 'Kaani Beach Hotel');
insert into node_media (node_id, media_id, role, sort_order) select id, '57d97e22-92a2-a86e-45b0-b3d487546305', 'hero', 0 from nodes where node_type = 'accommodation' and title = 'Kaani Beach Hotel' on conflict (node_id, media_id, role) do nothing;
