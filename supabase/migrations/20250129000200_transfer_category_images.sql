-- media_assets rows for the transfer category hero images repointed
-- in src/lib/transfers/category-images.ts (not node-backed, so no
-- node_media rows here -- the code file itself carries the id/path).
-- GENERATED FILE, regenerate with:
--   node scripts/attach-transfer-category-images.mjs --commit

insert into media_assets (id, media_type, storage_path, alt_text) values ('4ed61c4d-2c5d-5d73-af3f-79fee2418314', 'image', 'uploads/assets/uploads/transfers/maldives-transfers.webp', 'Maldives transfers') on conflict (id) do nothing;
insert into media_assets (id, media_type, storage_path, alt_text) values ('47c95968-8088-625a-98d2-20130258283c', 'image', 'uploads/assets/uploads/transfers/maldives-taxi-transfer.webp', 'Maldives airport transfers') on conflict (id) do nothing;
insert into media_assets (id, media_type, storage_path, alt_text) values ('79238d89-7cc6-2d55-bafe-9e7affa84902', 'image', 'uploads/assets/uploads/transfers/maldives-resort-transfer-300x300.webp', 'Maldives resort transfers') on conflict (id) do nothing;
insert into media_assets (id, media_type, storage_path, alt_text) values ('309f778c-2470-d34d-9428-64310c62eb13', 'image', 'uploads/assets/uploads/transfers/maldives-island-transfers.webp', 'Maldives island transfers') on conflict (id) do nothing;
insert into media_assets (id, media_type, storage_path, alt_text) values ('621881e3-d458-7642-3d73-a3ccec438396', 'image', 'uploads/assets/uploads/transfers/maldives-bus-transfer.webp', 'Maldives hotel transfers') on conflict (id) do nothing;
insert into media_assets (id, media_type, storage_path, alt_text) values ('57316a45-c325-79d0-5ec4-be975efe817d', 'image', 'uploads/assets/uploads/transfers/maldives-speed-boat-transfers.webp', 'Maldives speedboat transfers') on conflict (id) do nothing;
insert into media_assets (id, media_type, storage_path, alt_text) values ('2492fc47-c79b-8611-5825-74dd404540ce', 'image', 'uploads/assets/uploads/transfers/maldives-speed-boat-transfers-870x500.webp', 'Private speedboat charter in the Maldives') on conflict (id) do nothing;
insert into media_assets (id, media_type, storage_path, alt_text) values ('d865b111-b65a-6d09-bf58-728668c5829a', 'image', 'uploads/assets/uploads/transfers/maldives-transportation.webp', 'Maldives public transportation') on conflict (id) do nothing;
insert into media_assets (id, media_type, storage_path, alt_text) values ('0740246b-2750-179c-8fa7-927170412361', 'image', 'uploads/assets/uploads/transfers/maldives-seaplane-transfers.webp', 'Maldives seaplane transfers') on conflict (id) do nothing;
