-- MTG: short editorial content for two islands whose communities have
-- relocated (see 20250122000300_mark_relocated_islands_uninhabited.sql
-- for the is_inhabited fix). Original writing based on Wikipedia/press
-- research (contentSource: mtg_editorial), not MTG's legacy site,
-- which never covered either island.

-- kalhaidhoo
update nodes set attributes = coalesce(attributes, '{}'::jsonb) || '{"island_content_source":"mtg_editorial","island_quick_facts":[{"label":"Location","value":"Laamu Atoll"},{"label":"Status","value":"Uninhabited since 2004"}],"island_overview":["Kalhaidhoo is no longer an inhabited island. Its community fled to the neighbouring island of Gan during the December 2004 Indian Ocean tsunami, and the government declared Kalhaidhoo permanently uninhabited a week later - the population has remained at zero ever since.","There is no local-island community, guesthouse, or tourism infrastructure here. If you''re researching Laamu Atoll for a local-island stay, Gan (the atoll capital, where Kalhaidhoo''s community resettled) or Fonadhoo are the relevant destinations instead."],"island_sections":[],"island_faqs":[],"island_nearby_slugs":[]}'::jsonb
where node_type = 'location' and slug = 'kalhaidhoo';

-- gaadhoo
update nodes set attributes = coalesce(attributes, '{}'::jsonb) || '{"island_content_source":"mtg_editorial","island_quick_facts":[{"label":"Location","value":"Laamu Atoll"},{"label":"Status","value":"Community relocating to Fonadhoo"}],"island_overview":["Gaadhoo is in the process of being depopulated. Its residents have been relocating to Fonadhoo in the same atoll, with island administration being wound down - this is an active, government-organized resettlement rather than a historical event, so the island''s status may continue to change.","There is no active local-island tourism infrastructure here. If you''re researching Laamu Atoll for a local-island stay, Fonadhoo (the atoll capital, where Gaadhoo''s community is resettling) is the relevant destination instead."],"island_sections":[],"island_faqs":[],"island_nearby_slugs":[]}'::jsonb
where node_type = 'location' and slug = 'gaadhoo';

