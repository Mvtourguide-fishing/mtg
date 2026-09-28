-- Real photos for the 4 transfer routes shown on the homepage's
-- 'Getting Around' section (getTransferRoutes({ pageSize: 4 }),
-- ordered by title). Replaces whatever hero image (missing or wrong)
-- those 4 routes had before with the owner's own
-- assets/uploads/transfers/ photos.
-- GENERATED FILE, regenerate with:
--   node scripts/attach-transfer-homepage-images.mjs --commit

-- Route: guraidhoo-to-male
insert into media_assets (id, media_type, storage_path, alt_text) values ('4ba4f135-adc5-d431-cd31-9f5d7f75149c', 'image', 'uploads/assets/uploads/transfers/maldives-speedboat.webp', 'Speedboat transfer between Guraidhoo and Male') on conflict (id) do nothing;
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'transfer_route' and slug = 'guraidhoo-to-male');
insert into node_media (node_id, media_id, role, sort_order) select id, '4ba4f135-adc5-d431-cd31-9f5d7f75149c'::uuid, 'hero', 0 from nodes where node_type = 'transfer_route' and slug = 'guraidhoo-to-male' on conflict (node_id, media_id, role) do nothing;

-- Route: maafushi-to-male
insert into media_assets (id, media_type, storage_path, alt_text) values ('57316a45-c325-79d0-5ec4-be975efe817d', 'image', 'uploads/assets/uploads/transfers/maldives-speed-boat-transfers.webp', 'Speedboat transfer between Maafushi and Male') on conflict (id) do nothing;
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'transfer_route' and slug = 'maafushi-to-male');
insert into node_media (node_id, media_id, role, sort_order) select id, '57316a45-c325-79d0-5ec4-be975efe817d'::uuid, 'hero', 0 from nodes where node_type = 'transfer_route' and slug = 'maafushi-to-male' on conflict (node_id, media_id, role) do nothing;

-- Route: male-to-guraidhoo
insert into media_assets (id, media_type, storage_path, alt_text) values ('4901355e-64ea-e0ed-0e83-396558bc546c', 'image', 'uploads/assets/uploads/transfers/maafushi-map2.webp', 'Speedboat route map: Male Airport to Guraidhoo, Maafushi and Himmafushi') on conflict (id) do nothing;
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'transfer_route' and slug = 'male-to-guraidhoo');
insert into node_media (node_id, media_id, role, sort_order) select id, '4901355e-64ea-e0ed-0e83-396558bc546c'::uuid, 'hero', 0 from nodes where node_type = 'transfer_route' and slug = 'male-to-guraidhoo' on conflict (node_id, media_id, role) do nothing;

-- Route: male-to-himmafushi
insert into media_assets (id, media_type, storage_path, alt_text) values ('e3987935-b355-11fb-12b9-79a394a09ce5', 'image', 'uploads/assets/uploads/transfers/maldives-ferry-transfer.webp', 'Ferry transfer between Male and Himmafushi') on conflict (id) do nothing;
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'transfer_route' and slug = 'male-to-himmafushi');
insert into node_media (node_id, media_id, role, sort_order) select id, 'e3987935-b355-11fb-12b9-79a394a09ce5'::uuid, 'hero', 0 from nodes where node_type = 'transfer_route' and slug = 'male-to-himmafushi' on conflict (node_id, media_id, role) do nothing;

