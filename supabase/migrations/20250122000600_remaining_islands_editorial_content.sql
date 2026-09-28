-- MTG: short editorial content for the remaining confirmed-real islands
-- that had no legacy page (see the island-legacy-reconciliation.json
-- report). Original writing based on Wikipedia/press research
-- (contentSource: mtg_editorial), not MTG legacy content, which never
-- covered any of these six islands. Kunburudhoo also gets its
-- is_inhabited fix in a companion migration
-- (20250122000500_kunburudhoo_uninhabited.sql).

-- hoarafushi
update nodes set attributes = coalesce(attributes, '{}'::jsonb) || '{"island_content_source":"mtg_editorial","island_quick_facts":[{"label":"Location","value":"Haa Alif Atoll"},{"label":"Population","value":"3,613 (2025 census)"},{"label":"Distance from Male","value":"About 318 km north"}],"island_overview":["Hoarafushi is one of the larger inhabited islands of Haa Alif Atoll, at the far north of the Maldives, sitting within the country''s largest fringing reef system. The island takes its name from the great frigatebird - hoara in Dhivehi - once commonly seen there.","Its community has deep roots: settlers from the nearby island of Huvahandhoo established Hoarafushi roughly 300 years ago, and by the 1912 census it was already the fourth-largest locality in the Maldives. It remains a substantial local-island community today."],"island_sections":[],"island_faqs":[],"island_nearby_slugs":[]}'::jsonb
where node_type = 'location' and slug = 'hoarafushi';

-- maradhoo-feydhoo
update nodes set attributes = coalesce(attributes, '{}'::jsonb) || '{"island_content_source":"mtg_editorial","island_quick_facts":[{"label":"Location","value":"Seenu (Addu) Atoll"},{"label":"Population","value":"1,954 (2024 census)"}],"island_overview":["Maradhoo-Feydhoo is a district of Addu City, physically part of the same natural island as Maradhoo (which it borders to the north) but administered as a separate community, with Feydhoo bordering it to the south. Its residents originally came from Feydhoo, relocating here in 1957.","It''s one of several connected local-island communities that make up Addu Atoll''s linked-island chain - Hithadhoo, Maradhoo, Feydhoo, Maradhoo-Feydhoo, Hulhudhoo-Meedhoo and Gan - the southernmost inhabited stretch of the Maldives."],"island_sections":[],"island_faqs":[],"island_nearby_slugs":[]}'::jsonb
where node_type = 'location' and slug = 'maradhoo-feydhoo';

-- dhiyadhoo
update nodes set attributes = coalesce(attributes, '{}'::jsonb) || '{"island_content_source":"mtg_editorial","island_quick_facts":[{"label":"Location","value":"Gaafu Alifu Atoll"},{"label":"Distance from Male","value":"About 410 km"}],"island_overview":["Dhiyadhoo is one of nine inhabited islands in Gaafu Alifu Atoll (Northern Huvadhu Atoll), one of the southern administrative atolls of the Maldives, whose capital is Vilingili.","It''s a genuine local-island community, though detailed public information about it is limited - this page will be expanded as more verified detail becomes available."],"island_sections":[],"island_faqs":[],"island_nearby_slugs":[]}'::jsonb
where node_type = 'location' and slug = 'dhiyadhoo';

-- bodufolhudhoo
update nodes set attributes = coalesce(attributes, '{}'::jsonb) || '{"island_content_source":"mtg_editorial","island_quick_facts":[{"label":"Location","value":"Alif Alif (North Ari) Atoll"},{"label":"Population","value":"704 (2022 census)"},{"label":"Distance from Male","value":"About 82 km west"}],"island_overview":["Bodufolhudhoo is an inhabited island of Alif Alif Atoll, notable as the first island in the Maldives to ban single-use plastic bags - a genuine point of local distinction.","The island''s economy was traditionally built on fishing until the early 1990s, and has since shifted toward tourism-related work as Ari Atoll''s resort industry grew around it."],"island_sections":[],"island_faqs":[],"island_nearby_slugs":[]}'::jsonb
where node_type = 'location' and slug = 'bodufolhudhoo';

-- rinbudhoo
update nodes set attributes = coalesce(attributes, '{}'::jsonb) || '{"island_content_source":"mtg_editorial","island_quick_facts":[{"label":"Location","value":"Dhaalu Atoll"},{"label":"Population","value":"316 (2022 census)"},{"label":"Distance from Male","value":"About 154 km southwest"}],"island_overview":["Rinbudhoo is a small inhabited island of Dhaalu Atoll, known within the Maldives for its skilled goldsmiths and silversmiths - a traditional craft that remains part of the island''s identity alongside fishing and construction work.","Its population has grown steadily in recent censuses, from 207 in 2006 to 316 in 2022."],"island_sections":[],"island_faqs":[],"island_nearby_slugs":[]}'::jsonb
where node_type = 'location' and slug = 'rinbudhoo';

-- kunburudhoo
update nodes set attributes = coalesce(attributes, '{}'::jsonb) || '{"island_content_source":"mtg_editorial","island_quick_facts":[{"label":"Location","value":"Haa Dhaalu Atoll"},{"label":"Status","value":"Uninhabited since 2014"}],"island_overview":["Kunburudhoo (Haa Dhaalu Atoll) is no longer an inhabited island - not to be confused with the separate, genuinely inhabited island of the same name in Alif Dhaalu Atoll. Its population reached zero by the 2014 census; residents relocated to Nolhivaranfaru under a government island-consolidation program launched in 2009, driven partly by severe coastal erosion that had reached the island''s office, water tanks, and homes.","There is no local-island community, guesthouse, or tourism infrastructure here. If you''re researching Haa Dhaalu Atoll for a local-island stay, Nolhivaranfaru - where Kunburudhoo''s community resettled - is the relevant destination instead."],"island_sections":[],"island_faqs":[],"island_nearby_slugs":[]}'::jsonb
where node_type = 'location' and slug = 'kunburudhoo';

