-- Task 14: high-confidence legacy media attached to existing MTG entities.
-- GENERATED FILE - do not hand-edit. Regenerate with:
--   node scripts/import-legacy-media.mjs --commit
-- Source: data/maldives/media/media-match-report.json (highConfidenceMatches).
--
-- media_assets.storage_path values below are where
-- scripts/upload-legacy-media.mjs uploads the matching local file - run
-- that script (separately, needs live Supabase Storage access) so these
-- paths resolve to a real object. Idempotent: media_assets uses a
-- deterministic id (ON CONFLICT DO NOTHING), node_media uses its own
-- primary key.

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('c1923bd4-36fe-1be9-42c9-4f3d0f617eb5'::uuid, 'image', 'legacy/atolls/alifu-alifu/images/alifu-alifu-atoll-maldives.webp', 'Alif Alif Atoll, Maldives', 'Legacy MTG site archive', 1279, 1280) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'c1923bd4-36fe-1be9-42c9-4f3d0f617eb5'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'alif-alif' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('ba5be1c2-5c60-13b6-b2d6-aa99348f1d4f'::uuid, 'image', 'legacy/atolls/gnaviyani-atoll/images/fuvahmulah-island.webp', 'Fuvahmulah Island, Maldives', 'Legacy MTG site archive', 640, 425) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'ba5be1c2-5c60-13b6-b2d6-aa99348f1d4f'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'fuvahmulah' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('c901901e-aa1d-3454-a8c7-6f98c07a4427'::uuid, 'image', 'legacy/atolls/gnaviyani-atoll/images/fuvahmulah-maldives.webp', 'Fuvahmulah Island, Maldives', 'Legacy MTG site archive', 640, 360) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'c901901e-aa1d-3454-a8c7-6f98c07a4427'::uuid, 'gallery', 1 from nodes n where n.node_type = 'location' and n.slug = 'fuvahmulah' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('2be9109f-2943-0bb6-faea-544b93947e25'::uuid, 'image', 'legacy/images/activities/fuvahmulah-atoll-maldives.webp', 'Fuvahmulah Island, Maldives', 'Legacy MTG site archive', 640, 480) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '2be9109f-2943-0bb6-faea-544b93947e25'::uuid, 'gallery', 2 from nodes n where n.node_type = 'location' and n.slug = 'fuvahmulah' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('05c0c49b-a94c-d928-c803-8faee993d8e5'::uuid, 'image', 'legacy/images/diving/fuvahmulah-atoll-maldives.webp', 'Fuvahmulah Island, Maldives', 'Legacy MTG site archive', 640, 480) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '05c0c49b-a94c-d928-c803-8faee993d8e5'::uuid, 'gallery', 3 from nodes n where n.node_type = 'location' and n.slug = 'fuvahmulah' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('bf01cbee-781a-da2f-93d4-bf41355494b0'::uuid, 'image', 'legacy/images/islands/fuvahmulah-island-maldives.webp', 'Fuvahmulah Island, Maldives', 'Legacy MTG site archive', 640, 360) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'bf01cbee-781a-da2f-93d4-bf41355494b0'::uuid, 'gallery', 4 from nodes n where n.node_type = 'location' and n.slug = 'fuvahmulah' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('71827319-e472-4916-d8d9-12e4a314b87d'::uuid, 'image', 'legacy/images/maldives/fuvahmulah-island-maldives.webp', 'Fuvahmulah Island, Maldives', 'Legacy MTG site archive', 640, 400) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '71827319-e472-4916-d8d9-12e4a314b87d'::uuid, 'gallery', 5 from nodes n where n.node_type = 'location' and n.slug = 'fuvahmulah' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('972921db-90ec-5d43-45e8-b3a87da18fe6'::uuid, 'image', 'legacy/atolls/lhaviyani-atoll/images/lhaviyani-felivaru-island-maldives.webp', 'Lhaviyani Atoll, Maldives', 'Legacy MTG site archive', 1667, 1053) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '972921db-90ec-5d43-45e8-b3a87da18fe6'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'lhaviyani' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('e639b5c7-5366-3384-60ce-601340c72055'::uuid, 'image', 'legacy/hotels/images/hotels-in-male.webp', 'Male Island, Maldives', 'Legacy MTG site archive', 400, 225) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'e639b5c7-5366-3384-60ce-601340c72055'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'male' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('1b561b49-4212-7ce6-57a1-8dbecae18baf'::uuid, 'image', 'legacy/hotels/images/male-maldives-hotels.webp', 'Male Island, Maldives', 'Legacy MTG site archive', 400, 225) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '1b561b49-4212-7ce6-57a1-8dbecae18baf'::uuid, 'gallery', 1 from nodes n where n.node_type = 'location' and n.slug = 'male' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('b5f6c10b-a91c-0a96-3131-09bcb77d2d69'::uuid, 'image', 'legacy/images/maldives/male-island.webp', 'Male Island, Maldives', 'Legacy MTG site archive', 720, 508) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'b5f6c10b-a91c-0a96-3131-09bcb77d2d69'::uuid, 'gallery', 2 from nodes n where n.node_type = 'location' and n.slug = 'male' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('638cee71-770a-f4f2-98b7-29fc7b4804c0'::uuid, 'image', 'legacy/images/male.jpg', 'Male Island, Maldives', 'Legacy MTG site archive', 1625, 833) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '638cee71-770a-f4f2-98b7-29fc7b4804c0'::uuid, 'gallery', 3 from nodes n where n.node_type = 'location' and n.slug = 'male' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('ff119bc5-97bf-f729-06cf-38367d9908f3'::uuid, 'image', 'legacy/images/male.webp', 'Male Island, Maldives', 'Legacy MTG site archive', 1625, 833) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'ff119bc5-97bf-f729-06cf-38367d9908f3'::uuid, 'gallery', 4 from nodes n where n.node_type = 'location' and n.slug = 'male' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('a9f14a0c-42d3-88da-83cb-a44cba21db51'::uuid, 'image', 'legacy/images/male/male-island.webp', 'Male Island, Maldives', 'Legacy MTG site archive', 720, 508) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'a9f14a0c-42d3-88da-83cb-a44cba21db51'::uuid, 'gallery', 5 from nodes n where n.node_type = 'location' and n.slug = 'male' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('f16e57bc-78bc-5a11-3c5a-ca8608f2052b'::uuid, 'image', 'legacy/images/activities/six-senses-laamu.webp', 'Six Senses Laamu, Maldives resort', 'Legacy MTG site archive', 640, 360) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'f16e57bc-78bc-5a11-3c5a-ca8608f2052b'::uuid, 'hero', 0 from nodes n where n.node_type = 'accommodation' and n.slug = 'six-senses-laamu' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('3e271020-8654-dbc0-b450-ab4ee50839da'::uuid, 'image', 'legacy/images/surfing/six-senses-laamu.webp', 'Six Senses Laamu, Maldives resort', 'Legacy MTG site archive', 680, 382) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '3e271020-8654-dbc0-b450-ab4ee50839da'::uuid, 'gallery', 1 from nodes n where n.node_type = 'accommodation' and n.slug = 'six-senses-laamu' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('48f4113a-34bb-51ab-4a70-56791633dae9'::uuid, 'image', 'legacy/resorts/six-senses-laamu/images/six-senses-laamu-maldives-beach.webp', 'Six Senses Laamu, Maldives resort', 'Legacy MTG site archive', 1920, 1080) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '48f4113a-34bb-51ab-4a70-56791633dae9'::uuid, 'gallery', 2 from nodes n where n.node_type = 'accommodation' and n.slug = 'six-senses-laamu' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('9d6a7b3d-a111-add5-1d55-52c88556bf80'::uuid, 'image', 'legacy/resorts/six-senses-laamu/images/six-senses-laamu-maldives-dinning.webp', 'Six Senses Laamu, Maldives resort', 'Legacy MTG site archive', 1920, 1080) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '9d6a7b3d-a111-add5-1d55-52c88556bf80'::uuid, 'gallery', 3 from nodes n where n.node_type = 'accommodation' and n.slug = 'six-senses-laamu' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('42c37644-f67a-65c3-e39c-420c7b25ba29'::uuid, 'image', 'legacy/resorts/six-senses-laamu/images/six-senses-laamu-maldives-diving.webp', 'Six Senses Laamu, Maldives resort', 'Legacy MTG site archive', 1920, 1080) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '42c37644-f67a-65c3-e39c-420c7b25ba29'::uuid, 'gallery', 4 from nodes n where n.node_type = 'accommodation' and n.slug = 'six-senses-laamu' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('09039b1c-8c82-8d3e-957b-405d9d1576bc'::uuid, 'image', 'legacy/resorts/six-senses-laamu/images/six-senses-laamu-maldives-excursions.webp', 'Six Senses Laamu, Maldives resort', 'Legacy MTG site archive', 1920, 1080) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '09039b1c-8c82-8d3e-957b-405d9d1576bc'::uuid, 'gallery', 5 from nodes n where n.node_type = 'accommodation' and n.slug = 'six-senses-laamu' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('9b169d5c-e9ca-e9aa-9a0b-8ae88bb5c75e'::uuid, 'image', 'legacy/images/activities/maafushi-island.jpg', 'Maafushi Island, Maldives', 'Legacy MTG site archive', 500, 375) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '9b169d5c-e9ca-e9aa-9a0b-8ae88bb5c75e'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'maafushi' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('b3787b70-ef88-f3ef-48ef-0c388737dca8'::uuid, 'image', 'legacy/images/activities/maafushi-island.webp', 'Maafushi Island, Maldives', 'Legacy MTG site archive', 500, 375) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'b3787b70-ef88-f3ef-48ef-0c388737dca8'::uuid, 'gallery', 1 from nodes n where n.node_type = 'location' and n.slug = 'maafushi' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('fbf1f83d-d4a3-8b69-c09f-f9c74ecbbcd6'::uuid, 'image', 'legacy/images/maldives/maafushi-island.webp', 'Maafushi Island, Maldives', 'Legacy MTG site archive', 640, 427) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'fbf1f83d-d4a3-8b69-c09f-f9c74ecbbcd6'::uuid, 'gallery', 2 from nodes n where n.node_type = 'location' and n.slug = 'maafushi' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('33b829af-f13e-0087-2f8f-7484bae54e8f'::uuid, 'image', 'legacy/images/hotels/kaani-beach-hotel-in-maafushi-maldives.webp', 'Kaani Beach Hotel, Maldives hotel', 'Legacy MTG site archive', 230, 153) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '33b829af-f13e-0087-2f8f-7484bae54e8f'::uuid, 'hero', 0 from nodes n where n.node_type = 'accommodation' and n.slug = 'kaani-beach-hotel' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('436e2d7a-d987-bba2-df24-10b406ad2ae3'::uuid, 'image', 'legacy/images/maldives/dharavandhoo-island-maldives.webp', 'Dharavandhoo Island, Maldives', 'Legacy MTG site archive', 640, 427) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '436e2d7a-d987-bba2-df24-10b406ad2ae3'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'dharavandhoo' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('d24425bd-caa8-f1ee-2fac-daa5b913ab8a'::uuid, 'image', 'legacy/images/maldives/dhigurah-island-maldives.webp', 'Dhigurah Island, Maldives', 'Legacy MTG site archive', 640, 360) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'd24425bd-caa8-f1ee-2fac-daa5b913ab8a'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'dhigurah' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('7c2751c2-0c20-b61e-a6c1-80bf0646075d'::uuid, 'image', 'legacy/images/maldives/funadhoo-island-maldives.webp', 'Funadhoo Island, Maldives', 'Legacy MTG site archive', 640, 360) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '7c2751c2-0c20-b61e-a6c1-80bf0646075d'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'funadhoo' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('6374748b-a9e5-017d-84b7-e81314aa406c'::uuid, 'image', 'legacy/images/maldives/maradhoo-island-maldives.webp', 'Maradhoo Island, Maldives', 'Legacy MTG site archive', 640, 360) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '6374748b-a9e5-017d-84b7-e81314aa406c'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'maradhoo' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('009ed9dc-7673-ab47-0ecc-8789fe70261e'::uuid, 'image', 'legacy/images/maldives/olhuveli-island-maldives.webp', 'Olhuveli Island, Maldives', 'Legacy MTG site archive', 720, 405) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '009ed9dc-7673-ab47-0ecc-8789fe70261e'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'olhuveli' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('eac98f73-7326-1ec3-07bb-cc47016c21d2'::uuid, 'image', 'legacy/images/maldives/thoddoo-island-maldives.webp', 'Thoddoo Island, Maldives', 'Legacy MTG site archive', 720, 405) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'eac98f73-7326-1ec3-07bb-cc47016c21d2'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'thoddoo' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('64ac712a-db77-b067-a90e-664397d49268'::uuid, 'image', 'legacy/images/maldives/thulusdhoo-island-maldives.webp', 'Thulusdhoo Island, Maldives', 'Legacy MTG site archive', 640, 360) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '64ac712a-db77-b067-a90e-664397d49268'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'thulusdhoo' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('df1a234a-f8a1-743d-7069-cc0750519361'::uuid, 'image', 'legacy/images/maldives/ukulhas-island-maldives.webp', 'Ukulhas Island, Maldives', 'Legacy MTG site archive', 720, 405) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'df1a234a-f8a1-743d-7069-cc0750519361'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'ukulhas' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('8d9a66a1-39a6-1bd4-7b55-1d30a7cb021a'::uuid, 'image', 'legacy/images/maldives/villingili-resort-island.webp', 'Villingili Island, Maldives', 'Legacy MTG site archive', 720, 405) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '8d9a66a1-39a6-1bd4-7b55-1d30a7cb021a'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'villingili' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('1e7c5424-22a2-ed33-791f-9fcd358c1756'::uuid, 'image', 'legacy/images/maldives/hulhumale-island.webp', 'Hulhumale Island, Maldives', 'Legacy MTG site archive', 640, 400) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '1e7c5424-22a2-ed33-791f-9fcd358c1756'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'hulhumale' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('9f2c0836-c03d-1d42-7c35-a0aa8e0e3826'::uuid, 'image', 'legacy/images/maldives/utheemu-island.webp', 'Utheemu Island, Maldives', 'Legacy MTG site archive', 640, 480) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '9f2c0836-c03d-1d42-7c35-a0aa8e0e3826'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'utheemu' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('177d517a-c13c-80a3-5909-99f4d4076cbe'::uuid, 'image', 'legacy/resorts/baros-island/images/baros-isalnd-maldives-resort.webp', 'Baros Maldives, Maldives resort', 'Legacy MTG site archive', 480, 320) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '177d517a-c13c-80a3-5909-99f4d4076cbe'::uuid, 'hero', 0 from nodes n where n.node_type = 'accommodation' and n.slug = 'baros-maldives' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('14f3f7ff-4796-b623-07cd-74c3e9a8d94f'::uuid, 'image', 'legacy/resorts/baros-island/images/baros-island-maldives-island-map.webp', 'Baros Maldives, Maldives resort', 'Legacy MTG site archive', 465, 363) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '14f3f7ff-4796-b623-07cd-74c3e9a8d94f'::uuid, 'gallery', 1 from nodes n where n.node_type = 'accommodation' and n.slug = 'baros-maldives' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('4359e47b-9e3e-8807-1a61-e32049d32a69'::uuid, 'image', 'legacy/resorts/baros-island/images/baros-maldives-deluxe-villa.webp', 'Baros Maldives, Maldives resort', 'Legacy MTG site archive', 600, 337) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '4359e47b-9e3e-8807-1a61-e32049d32a69'::uuid, 'gallery', 2 from nodes n where n.node_type = 'accommodation' and n.slug = 'baros-maldives' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('c5c64122-32bf-bc81-0a4f-e1b5d643595d'::uuid, 'image', 'legacy/resorts/baros-island/images/baros-maldives-deluxe-villa1.webp', 'Baros Maldives, Maldives resort', 'Legacy MTG site archive', 600, 337) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'c5c64122-32bf-bc81-0a4f-e1b5d643595d'::uuid, 'gallery', 3 from nodes n where n.node_type = 'accommodation' and n.slug = 'baros-maldives' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('1907c26d-f2cb-85fa-2760-21dcfe4c0fa0'::uuid, 'image', 'legacy/resorts/baros-island/images/baros-maldives-island-resort-beach-dinner.webp', 'Baros Maldives, Maldives resort', 'Legacy MTG site archive', 1280, 720) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '1907c26d-f2cb-85fa-2760-21dcfe4c0fa0'::uuid, 'gallery', 4 from nodes n where n.node_type = 'accommodation' and n.slug = 'baros-maldives' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('ea357590-893c-721b-cf78-f24fa707b820'::uuid, 'image', 'legacy/resorts/baros-island/images/baros-maldives-island-resort-beach.webp', 'Baros Maldives, Maldives resort', 'Legacy MTG site archive', 1280, 720) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'ea357590-893c-721b-cf78-f24fa707b820'::uuid, 'gallery', 5 from nodes n where n.node_type = 'accommodation' and n.slug = 'baros-maldives' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('72d57239-0ddf-2e16-248f-15b5a91edac0'::uuid, 'image', 'legacy/resorts/gili-lankanfushi/images/gili-lankanfushi-maldives-activities.webp', 'Gili Lankanfushi, Maldives resort', 'Legacy MTG site archive', 1920, 1080) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '72d57239-0ddf-2e16-248f-15b5a91edac0'::uuid, 'hero', 0 from nodes n where n.node_type = 'accommodation' and n.slug = 'gili-lankanfushi' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('5c1754f5-99f1-534b-d679-108b703ae900'::uuid, 'image', 'legacy/resorts/gili-lankanfushi/images/gili-lankanfushi-maldives-beach-breakfast.webp', 'Gili Lankanfushi, Maldives resort', 'Legacy MTG site archive', 1920, 1080) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '5c1754f5-99f1-534b-d679-108b703ae900'::uuid, 'gallery', 1 from nodes n where n.node_type = 'accommodation' and n.slug = 'gili-lankanfushi' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('dade04d5-5f37-2fcb-038b-f8cd261bc424'::uuid, 'image', 'legacy/resorts/gili-lankanfushi/images/gili-lankanfushi-maldives-beach-north-male-atoll.webp', 'Gili Lankanfushi, Maldives resort', 'Legacy MTG site archive', 480, 320) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'dade04d5-5f37-2fcb-038b-f8cd261bc424'::uuid, 'gallery', 2 from nodes n where n.node_type = 'accommodation' and n.slug = 'gili-lankanfushi' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('4304563f-d2ef-f760-1292-9bed538a3f95'::uuid, 'image', 'legacy/resorts/gili-lankanfushi/images/gili-lankanfushi-maldives-beach.webp', 'Gili Lankanfushi, Maldives resort', 'Legacy MTG site archive', 1920, 1080) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '4304563f-d2ef-f760-1292-9bed538a3f95'::uuid, 'gallery', 3 from nodes n where n.node_type = 'accommodation' and n.slug = 'gili-lankanfushi' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('5855b9d8-4a35-ed83-2b32-462d79a1ecd3'::uuid, 'image', 'legacy/resorts/gili-lankanfushi/images/gili-lankanfushi-maldives-dinner.webp', 'Gili Lankanfushi, Maldives resort', 'Legacy MTG site archive', 1920, 1080) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '5855b9d8-4a35-ed83-2b32-462d79a1ecd3'::uuid, 'gallery', 4 from nodes n where n.node_type = 'accommodation' and n.slug = 'gili-lankanfushi' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('02a669bb-fb30-0e46-9de2-3aea8f81fb19'::uuid, 'image', 'legacy/resorts/gili-lankanfushi/images/gili-lankanfushi-maldives-family-villa.webp', 'Gili Lankanfushi, Maldives resort', 'Legacy MTG site archive', 1920, 1080) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '02a669bb-fb30-0e46-9de2-3aea8f81fb19'::uuid, 'gallery', 5 from nodes n where n.node_type = 'accommodation' and n.slug = 'gili-lankanfushi' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('65e430a8-0568-3568-5ce3-dcb66e6759ee'::uuid, 'image', 'legacy/resorts/velassaru/images/velassaru-maldives-island-resort.webp', 'Velassaru Island, Maldives', 'Legacy MTG site archive', 1920, 1080) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '65e430a8-0568-3568-5ce3-dcb66e6759ee'::uuid, 'hero', 0 from nodes n where n.node_type = 'location' and n.slug = 'velassaru' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('f2eea1a0-cb45-28cc-ae51-386730092284'::uuid, 'image', 'legacy/resorts/velassaru/images/velassaru-maldives-resort.webp', 'Velassaru Island, Maldives', 'Legacy MTG site archive', 1920, 1080) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, 'f2eea1a0-cb45-28cc-ae51-386730092284'::uuid, 'gallery', 1 from nodes n where n.node_type = 'location' and n.slug = 'velassaru' on conflict (node_id, media_id, role) do nothing;

insert into media_assets (id, media_type, storage_path, alt_text, credit, width, height) values ('68a6101f-09a4-0320-5a39-c4a8ecbbe92e'::uuid, 'image', 'legacy/resorts/velassaru/images/velassaru-maldives.webp', 'Velassaru Island, Maldives', 'Legacy MTG site archive', 1920, 1080) on conflict (id) do nothing;

insert into node_media (node_id, media_id, role, sort_order) select n.id, '68a6101f-09a4-0320-5a39-c4a8ecbbe92e'::uuid, 'gallery', 2 from nodes n where n.node_type = 'location' and n.slug = 'velassaru' on conflict (node_id, media_id, role) do nothing;

