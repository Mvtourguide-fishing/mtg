-- Manual fix: visit-male-city.webp <- Malé City location (see
-- scripts/attach-male-city-hero.mjs for why this needed a manual match
-- instead of the round 2/3 automated matcher).
insert into media_assets (id, media_type, storage_path, alt_text) values ('d28e66a0-b996-345d-b8d3-b6ccb97968b1', 'image', 'uploads/assets/uploads/articles/visit-male-city.webp', 'visit male city') on conflict (id) do nothing;
insert into node_media (node_id, media_id, role, sort_order) select id, 'd28e66a0-b996-345d-b8d3-b6ccb97968b1', 'hero', 0 from nodes where node_type = 'location' and slug = 'male-city' on conflict (node_id, media_id, role) do nothing;
