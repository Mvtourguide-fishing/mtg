-- Content fix (site owner request): every surf lesson/camp/rental activity
-- on /maldives/surfing/ had its hero image auto-matched during the earlier
-- 798-image round to a Google Maps screenshot of its island
-- (release/public_html/images/surfing/budget-surfing-island-*.webp is
-- literally a map, not a photo -- verified by viewing the files), not a
-- real surf photo. Real wave photos already exist as media_assets rows
-- from 20250115000100_full_legacy_image_library.sql (the same ids the
-- surf BREAK location pages already use successfully for cokes, sultans,
-- chickens, jailbreak, yin-yang -- see 20250122000800_surf_break_images.sql)
-- -- no new upload needed here, just re-pointing each activity's hero to
-- the real photo for its actual break/island where one exists, and to a
-- generic real surf photo (not a map) otherwise.

-- group-surf-lesson, surf-lesson, private-surf-lesson-cokes: all on
-- Thulusdhoo, operated by/named after "Cokes" -> the real Cokes wave photo.
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'activity' and slug = 'group-surf-lesson');
insert into node_media (node_id, media_id, role, sort_order) select id, '845dac76-ddef-da0c-52e1-0b45c1c45318', 'hero', 0 from nodes where node_type = 'activity' and slug = 'group-surf-lesson' on conflict (node_id, media_id, role) do nothing;

delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'activity' and slug = 'surf-lesson');
insert into node_media (node_id, media_id, role, sort_order) select id, '845dac76-ddef-da0c-52e1-0b45c1c45318', 'hero', 0 from nodes where node_type = 'activity' and slug = 'surf-lesson' on conflict (node_id, media_id, role) do nothing;

delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'activity' and slug = 'private-surf-lesson-cokes');
insert into node_media (node_id, media_id, role, sort_order) select id, '845dac76-ddef-da0c-52e1-0b45c1c45318', 'hero', 0 from nodes where node_type = 'activity' and slug = 'private-surf-lesson-cokes' on conflict (node_id, media_id, role) do nothing;

-- guided-surf-boat-trip: Thulusdhoo, boat-trip guests reach nearby breaks
-- like Sultans -> the real Sultans wave photo.
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'activity' and slug = 'guided-surf-boat-trip');
insert into node_media (node_id, media_id, role, sort_order) select id, 'ccff4cbb-585a-ab9c-1ed4-ba04dc942f52', 'hero', 0 from nodes where node_type = 'activity' and slug = 'guided-surf-boat-trip' on conflict (node_id, media_id, role) do nothing;

-- wave-surfing, wave-surfing-maafushi: Maafushi-based, reached by boat to
-- the same Kaafu Atoll break cluster -> real Chickens wave photo for one,
-- a real generic surf photo (not a map) for the other so the pair isn't
-- identical.
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'activity' and slug = 'wave-surfing');
insert into node_media (node_id, media_id, role, sort_order) select id, 'df9419bb-eba4-776f-9518-ff71f4d805b8', 'hero', 0 from nodes where node_type = 'activity' and slug = 'wave-surfing' on conflict (node_id, media_id, role) do nothing;

delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'activity' and slug = 'wave-surfing-maafushi');
insert into node_media (node_id, media_id, role, sort_order) select id, '41ff8158-2c09-fbc2-f765-298260573745', 'hero', 0 from nodes where node_type = 'activity' and slug = 'wave-surfing-maafushi' on conflict (node_id, media_id, role) do nothing;

-- surfboard-rental: not wave-specific -> a real generic surf photo.
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'activity' and slug = 'surfboard-rental');
insert into node_media (node_id, media_id, role, sort_order) select id, '07883d9d-2572-c697-5b66-717a5a9b728b', 'hero', 0 from nodes where node_type = 'activity' and slug = 'surfboard-rental' on conflict (node_id, media_id, role) do nothing;

-- multi-day-surf-camp-package: Himmafushi, operated by "Jailbreak Surf
-- Inn" -> the real Jailbreak wave photo (direct name + island match).
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'activity' and slug = 'multi-day-surf-camp-package');
insert into node_media (node_id, media_id, role, sort_order) select id, '95e72247-381a-a20e-488c-f82fa68b7cdf', 'hero', 0 from nodes where node_type = 'activity' and slug = 'multi-day-surf-camp-package' on conflict (node_id, media_id, role) do nothing;

-- beginner-lagoon-surf-lesson, first-green-wave-private-surf-lesson:
-- Olhuveli, Laamu Atoll, Six Senses -> the real Yin-Yang wave photo (the
-- only real Laamu Atoll break photo on file; Six Senses Laamu's own named
-- "First Green" wave has no separate photo available).
delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'activity' and slug = 'beginner-lagoon-surf-lesson');
insert into node_media (node_id, media_id, role, sort_order) select id, 'de86cd42-7b6c-fc47-a2d9-e652b288d4fa', 'hero', 0 from nodes where node_type = 'activity' and slug = 'beginner-lagoon-surf-lesson' on conflict (node_id, media_id, role) do nothing;

delete from node_media where role = 'hero' and node_id = (select id from nodes where node_type = 'activity' and slug = 'first-green-wave-private-surf-lesson');
insert into node_media (node_id, media_id, role, sort_order) select id, 'de86cd42-7b6c-fc47-a2d9-e652b288d4fa', 'hero', 0 from nodes where node_type = 'activity' and slug = 'first-green-wave-private-surf-lesson' on conflict (node_id, media_id, role) do nothing;
