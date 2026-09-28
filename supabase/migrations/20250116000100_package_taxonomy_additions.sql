-- Task 21: two package categories requested by the owner's "11 categories"
-- list (Luxury, Family, Adults Only, Long Stay, Budget, Honeymoon, Solo,
-- Diving, Fishing, Surfing, Liveaboard) that weren't in the existing
-- taxonomy seed — 9 of the 11 already existed (traveler-type: honeymoon,
-- family, couple, solo, group, luxury, budget, long-stay; theme: diving,
-- fishing, surfing). Only 'adults-only' (traveler-type) and 'liveaboard'
-- (theme, alongside diving/fishing/surfing) are new. Same insert pattern
-- as every other category-node addition this project (see
-- supabase/migrations/20250113000200_transfers_platform_data.sql's
-- transfer-category rows): a category IS a node, so nodes then categories.

insert into nodes (id, node_type, slug, title, status, published_at) values
  ('c3f2a611-6b2a-4a3f-9b0a-2f6a3a1d7e10', 'category', 'adults-only', 'Adults Only', 'published', now())
on conflict (node_type, slug) do nothing;
insert into categories (id, category_group, path)
  select id, 'traveler-type', 'adults_only'::ltree from nodes where node_type = 'category' and slug = 'adults-only'
on conflict (id) do nothing;

insert into nodes (id, node_type, slug, title, status, published_at) values
  ('d4a3b722-7c3b-4b4a-8c1b-3a7b4b2e8f21', 'category', 'liveaboard', 'Liveaboard', 'published', now())
on conflict (node_type, slug) do nothing;
insert into categories (id, category_group, path)
  select id, 'theme', 'liveaboard'::ltree from nodes where node_type = 'category' and slug = 'liveaboard'
on conflict (id) do nothing;
