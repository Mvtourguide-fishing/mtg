-- MTG: surfing vertical seed (Task 9).
-- GENERATED FILE — do not hand-edit. Source of truth:
--   data/maldives/surfing/activities.json
--   data/maldives/surfing/surf_breaks.json
--   data/maldives/surfing/SOURCES.md
-- Regenerate with: node scripts/generate-surfing-seed.mjs
--
-- Idempotent (ON CONFLICT DO NOTHING, keyed by slug). Surfing activities use
-- the same `activities` table as every other activity (activity_category =
-- 'surfing'); surf TYPE is a categories/node_categories tag (category_group =
-- 'activity-type'), not a column, matching Task 7/8 §2. Surf BREAKS are
-- physical locations (location_type = 'surf_break', parented under their
-- atoll) — they are never activities and never get a bookable_products row.
-- Providers are reused from Task 5/6/7/8 by exact name match where they apply
-- (harmless no-op insert against the existing row).

-- Surf-type taxonomy (category_group = 'activity-type') — only the types
-- actually used by a sourced activity below (new or pre-existing) are seeded.
insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'surf-lessons', 'Surf Lessons', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'surf_lessons'::ltree from nodes where node_type = 'category' and slug = 'surf-lessons'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'guided-surfing', 'Guided Surfing', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'guided_surfing'::ltree from nodes where node_type = 'category' and slug = 'guided-surfing'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'board-rental', 'Board Rental', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'board_rental'::ltree from nodes where node_type = 'category' and slug = 'board-rental'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, status, published_at)
values ('category', 'surf-camp', 'Surf Camp', 'published', now())
on conflict (node_type, slug) do nothing;

insert into categories (id, category_group, path)
select id, 'activity-type', 'surf_camp'::ltree from nodes where node_type = 'category' and slug = 'surf-camp'
on conflict (id) do nothing;

-- Providers (reused from Task 5/6/7/8 where the name matches exactly, else new)
insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'the-perfect-wave-cokes-surf-camp', 'The Perfect Wave Cokes Surf Camp', 'The Perfect Wave Cokes Surf Camp operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'the-perfect-wave-cokes-surf-camp'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'twin-palms-surfhouse', 'Twin Palms Surfhouse', 'Twin Palms Surfhouse operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'twin-palms-surfhouse'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'amphibuzz', 'Amphibuzz', 'Amphibuzz operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'amphibuzz'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'maafushi-dive-and-water-sports', 'Maafushi Dive and Water Sports', 'Maafushi Dive and Water Sports operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'maafushi-dive-and-water-sports'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'active-watersports-maafushi', 'Active Watersports Maafushi', 'Active Watersports Maafushi operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'active-watersports-maafushi'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'jailbreak-surf-inn', 'Jailbreak Surf Inn', 'Jailbreak Surf Inn operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'jailbreak-surf-inn'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, published_at)
values ('provider', 'six-senses', 'Six Senses', 'Six Senses operates activities and services in the Maldives.', 'published', now())
on conflict (node_type, slug) do nothing;

insert into providers (id)
select id from nodes where node_type = 'provider' and slug = 'six-senses'
on conflict (id) do nothing;

-- Surf breaks: physical locations, location_type = 'surf_break'. These are
-- never activities and never get a bookable_products row.
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'cokes', 'Cokes', 'Cokes is a reef break in Kaafu Atoll, Maldives.', 'published', 'Cokes | Maldives Surf Breaks | MTG', 'Cokes is a reef break in Kaafu Atoll, Maldives.', '{"break_type":"reef_break","wave_notes":"A right-hand reef break, described by multiple sources (ahmedaznil.com, evendo.com, surf-forecast.com''s ''Colas'' guide) as lightning-fast, hollow and powerful, with a pitching, steep takeoff and two sections, both of which throw a curling lip -- the inside second section, where the reef is shallowest, gives the longest cover-up/barrel. Named after a nearby Coca-Cola bottling plant visible from the break.","season_notes":"General North Male Atoll surf season is typically given as March to October, with the most consistent swells in June-September (dreamingofmaldives.com/airial.travel summaries); treated as a hedge, not a guarantee, and not sourced specifically to Cokes alone.","access_notes":"Breaks directly off Thulusdhoo Island, in front of the island''s own guesthouses/surf camps; the existing ''Private Surf Lesson (Cokes)'' activity in this dataset confirms The Perfect Wave Cokes Surf Camp sits directly on this break."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'surf_break', p.id, (p_loc.path || 'cokes'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'cokes'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'location' and n.slug = 'cokes'
  and l.node_type = 'location' and l.slug = 'thulusdhoo'
on conflict (node_id, location_id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'chickens', 'Chickens', 'Chickens is a reef break in Kaafu Atoll, Maldives.', 'published', 'Chickens | Maldives Surf Breaks | MTG', 'Chickens is a reef break in Kaafu Atoll, Maldives.', '{"break_type":"reef_break","wave_notes":"A long, fast left-hand reef break, described as one of the longest lefts in the Maldives, with rides reported up to ~500m on a good day across multiple (some sources say up to six) sections, several capable of barrelling. surfsphere.com/jonnymelon.com describe skill level as ''Intermediate to Advanced'' -- a range rather than a single term, so difficulty was left null here rather than collapsed to one value, per the task''s hard rule against upgrading a hedge.","season_notes":"Sources give May-October as the ideal window, with July-August southeast swells cited as most consistent, typically 2-8ft (jonnymelon.com/surfsphere.com summaries) -- kept as a hedge, not a guarantee.","access_notes":"Reached by a short boat/dhoni ride from Thulusdhoo (~$10 USD per person round-trip per several sources), which functions as the practical access point even though the wave itself breaks off a separate, uninhabited island."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'surf_break', p.id, (p_loc.path || 'chickens'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'chickens'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'sultans', 'Sultans', 'Sultans is a point break in Kaafu Atoll, Maldives.', 'published', 'Sultans | Maldives Surf Breaks | MTG', 'Sultans is a point break in Kaafu Atoll, Maldives.', '{"break_type":"point_break","wave_notes":"An exposed right-hand point break with consistent surf, breaking off the southern tip of Thanburudhoo Island on the eastern reef of North Male Atoll; known for very long rides with barrelling sections (surfatoll.com, amaldives.com).","season_notes":"Falls within the general North Male Atoll surf season (typically March-October, peak June-September per dreamingofmaldives.com/airial.travel) -- not independently confirmed for Sultans specifically.","access_notes":"Accessible by boat, typically from nearby resorts/guesthouses or organized surf tours/day trips out of Thulusdhoo and Himmafushi."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'surf_break', p.id, (p_loc.path || 'sultans'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'sultans'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'honkys', 'Honky''s', 'Honky''s is a point break in Kaafu Atoll, Maldives.', 'published', 'Honky''s | Maldives Surf Breaks | MTG', 'Honky''s is a point break in Kaafu Atoll, Maldives.', '{"break_type":"point_break","wave_notes":"A long, wrapping left-hander that breaks around the western side of Thanburudhoo Island (Sultans breaks on the same island''s other side); swellnet.com and surfatoll.com describe it as a point break, with rides that can build to well over 100 yards as the wave moves inside. Competes with Chickens for the region''s best wave when conditions align.","season_notes":"Falls within the general North Male Atoll surf season (typically March-October, peak June-September) -- not independently confirmed for Honky''s specifically.","access_notes":"Accessible by boat from nearby islands/resorts, commonly bundled into Thulusdhoo- or Himmafushi-based surf camp boat trips alongside Sultans and Jailbreak."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'surf_break', p.id, (p_loc.path || 'honkys'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'honkys'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'ninjas', 'Ninjas', 'Ninjas is a reef break in Kaafu Atoll, Maldives.', 'published', 'Ninjas | Maldives Surf Breaks | MTG', 'Ninjas is a reef break in Kaafu Atoll, Maldives.', '{"break_type":"reef_break","difficulty":"beginner","wave_notes":"A right-hand reef break peeling over dead coral in front of the Club Med Kani resort on Kanifinolhu; surfnerd.com and stokedfortravel.com describe it as slow and easygoing, explicitly ''good for beginners and long-boarders'', closing out once surf pushes past shoulder-high (works roughly 1-5ft). Named for the Japanese surfers who favored the break.","season_notes":"surfnerd.com notes it works best on W-NW winds with a moderate south swell -- a condition-specific hedge, not a fixed calendar season.","access_notes":"Reached by boat from nearby North Male Atoll islands/resorts; the reef is shallow enough that reef boots are commonly recommended (surfnerd.com)."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'surf_break', p.id, (p_loc.path || 'ninjas'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'ninjas'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'jailbreak', 'Jailbreak', 'Jailbreak is a reef break in Kaafu Atoll, Maldives.', 'published', 'Jailbreak | Maldives Surf Breaks | MTG', 'Jailbreak is a reef break in Kaafu Atoll, Maldives.', '{"break_type":"reef_break","wave_notes":"A long right-hand reef break directly off Himmafushi Island (named for a former jail on the point), described as a ''perfect right-hand reef break with a big wackable wall and fast sections'', capable of getting hollow/barrelling on bigger days; generally regarded as a bit smaller/friendlier than its cross-channel neighbor Honky''s (mondo.surf, various guesthouse listings). thesurftribe.com-linked summaries describe it as ''challenging but also suitable for intermediate surfers'' -- a range, not a single term, so difficulty was left null.","season_notes":"Falls within the general North Male Atoll surf season (typically March-October, peak June-September) -- not independently confirmed for Jailbreak specifically.","access_notes":"A roughly 10-minute walk across Himmafushi Island from the Jail Break Surf Inn guesthouse to the point, then a short paddle out over coral."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'surf_break', p.id, (p_loc.path || 'jailbreak'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'jailbreak'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'location' and n.slug = 'jailbreak'
  and l.node_type = 'location' and l.slug = 'himmafushi'
on conflict (node_id, location_id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'guraidhoo-corner', 'Guraidhoo Corner', 'Guraidhoo Corner is a reef break in Kaafu Atoll, Maldives.', 'published', 'Guraidhoo Corner | Maldives Surf Breaks | MTG', 'Guraidhoo Corner is a reef break in Kaafu Atoll, Maldives.', '{"break_type":"reef_break","wave_notes":"A reef break off Guraidhoo Island in South Male Atoll. Sources conflict on suitability: islandii.com and mytourway.com/roamingsurfer.com describe it as best suited to intermediate-to-advanced surfers, while both operators offering commercial surf sessions here (Active Watersports Maafushi and Maafushi Dive and Water Sports) explicitly market it to beginners with on-beach instruction. Given that conflict, difficulty was left null rather than picking one side.","season_notes":"Not independently confirmed beyond the general North/South Male Atoll surf season (typically March-October, peak June-September).","access_notes":"A 10-15 minute boat ride from Maafushi Island (activemaldives.com, maafushidive.com), which is how both Maafushi-based water sports operators in this dataset''s activities.json reach it."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'surf_break', p.id, (p_loc.path || 'guraidhoo_corner'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'guraidhoo-corner'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'location' and n.slug = 'guraidhoo-corner'
  and l.node_type = 'location' and l.slug = 'guraidhoo'
on conflict (node_id, location_id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'pasta-point', 'Pasta Point', 'Pasta Point is a reef break in Kaafu Atoll, Maldives.', 'published', 'Pasta Point | Maldives Surf Breaks | MTG', 'Pasta Point is a reef break in Kaafu Atoll, Maldives.', '{"break_type":"reef_break","wave_notes":"A left-hand reef break described as North Male Atoll''s most consistent ''wave machine'', less wind-affected than most other spots in the area; waves typically 4-6ft but reportedly break with the same shape even at 1-2ft. Three sections capable of a 100+ yard ride. The name comes from an Italian restaurant that once stood on the site and discarded leftover pasta into the surf (atolltravel.com, stokedfortravel.com, waterwaystravel.com).","season_notes":"waterwaystravel.com/nomadsurfers.com summaries give May-August as the best window, when south-to-southwest trade winds keep conditions offshore and southern swells are most consistent; swell size is described as starting at 1m/3ft and holding up to 4m/12ft.","access_notes":"Directly in front of the resort now branded Cinnamon Dhonveli Maldives (formerly Chaaya Island Dhonveli), which markets exclusive guest access to the break; Sultans, Honky''s and Jailbreak are each described as within about 10 minutes by boat."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'surf_break', p.id, (p_loc.path || 'pasta_point'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'pasta-point'
  and p.node_type = 'location' and p.slug = 'kaafu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'yin-yang', 'Yin-Yang', 'Yin-Yang is a reef break in Laamu Atoll, Maldives.', 'published', 'Yin-Yang | Maldives Surf Breaks | MTG', 'Yin-Yang is a reef break in Laamu Atoll, Maldives.', '{"break_type":"reef_break","wave_notes":"A long right-hand reef pass, described as arguably the most consistent wave in this part of the Maldives: a mellow outside wall in deep water that wraps into a long, hollow inside barrel section under a strong southeast swell (surfatoll.com, oceandimensions.com, amaldives.com). dreamingofmaldives.com describes it as ''generally better suited to intermediate and advanced surfers'' -- a range, not a single term, so difficulty was left null rather than upgraded to one label.","season_notes":"Sources describe it as best under a strong southeast swell rather than giving a specific calendar window; no independently-confirmed month range surfaced for Yin-Yang specifically, so none was added.","access_notes":"A few minutes by boat from Six Senses Laamu (Olhuveli island), per the resort''s own Tropicsurf-run surf program."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'surf_break', p.id, (p_loc.path || 'yin_yang'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'yin-yang'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'location' and n.slug = 'yin-yang'
  and l.node_type = 'location' and l.slug = 'olhuveli'
on conflict (node_id, location_id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'isdoo-corner', 'Isdoo Corner', 'Isdoo Corner is a surf break in Laamu Atoll, Maldives.', 'published', 'Isdoo Corner | Maldives Surf Breaks | MTG', 'Isdoo Corner is a surf break in Laamu Atoll, Maldives.', '{"wave_notes":"A right-hander (also referenced by the older name ''Langon Bank'') on the northeast tip of Laamu Atoll, described as working well on a big south-to-southeasterly swell and well protected from southerly winds (stormrider.surf regional guide summary). No source in the snippets reviewed used an explicit ''reef break''/''point break''/etc. type label for this specific spot, so break_type was left null.","season_notes":"Best on a big south-to-southeasterly swell per the source; no specific calendar month range surfaced.","access_notes":"Described as rarely surfed due to a lack of safe boat anchorage nearby; visited mainly by the occasional surf charter boat transiting between Laamu and Thaa Atolls rather than as a standalone day-trip destination."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'surf_break', p.id, (p_loc.path || 'isdoo_corner'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'isdoo-corner'
  and p.node_type = 'location' and p.slug = 'laamu'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'location' and n.slug = 'isdoo-corner'
  and l.node_type = 'location' and l.slug = 'isdhoo'
on conflict (node_id, location_id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'tiger-stripes', 'Tiger Stripes', 'Tiger Stripes is a reef break in Gaafu Dhaalu Atoll, Maldives.', 'published', 'Tiger Stripes | Maldives Surf Breaks | MTG', 'Tiger Stripes is a reef break in Gaafu Dhaalu Atoll, Maldives.', '{"break_type":"reef_break","wave_notes":"A long, playful left-hander on a coral reef, named for the narrow gouges in the reef that create a striped effect; can be tricky on takeoff, growling into a long, speedy wall before an inside tube section, on swells from about 2-8ft (bluestarsurfaris.com, airial.travel). Described by one summary as suited to intermediate-to-expert surfers -- a range, not a single term, so difficulty was left null.","season_notes":"Falls within the general Gaafu Dhaalu/Huvadhoo Atoll surf season, given by blue-horizon.com.mv as best ''early March-April and later October-November'' -- a hedge from an atoll-wide guide, not confirmed specifically for Tiger Stripes.","access_notes":"Located on the southeast part of Gaafu Dhaalu Atoll; reached via surf charter/boat trip, per multiple southern-atoll surf-boat operator sites (suddenrush.com, bluestarsurfaris.com)."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'surf_break', p.id, (p_loc.path || 'tiger_stripes'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'tiger-stripes'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'beacons', 'Beacons', 'Beacons is a reef break in Gaafu Dhaalu Atoll, Maldives.', 'published', 'Beacons | Maldives Surf Breaks | MTG', 'Beacons is a reef break in Gaafu Dhaalu Atoll, Maldives.', '{"break_type":"reef_break","wave_notes":"Described by local accounts as the most powerful and dangerous surf spot in the region: a grinding right-hander with a solid barrel on a good southwest swell, breaking hard over very shallow, sharp coral with little margin for error (bluestarsurfaris.com, dreamingofmaldives.com). One summary labels it ''expert only'', which was not carried into the difficulty field since it doesn''t map cleanly onto this dataset''s beginner/intermediate/advanced/all_levels scale -- kept instead as a direct hedge here.","season_notes":"Falls within the general Gaafu Dhaalu Atoll surf season, given by blue-horizon.com.mv as best ''early March-April and later October-November''.","access_notes":"Located on the southwest part of Gaafu Dhaalu Atoll; reached via surf charter/boat trip."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'surf_break', p.id, (p_loc.path || 'beacons'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'beacons'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, attributes, published_at)
values ('location', 'castaways', 'Castaways', 'Castaways is a surf break in Gaafu Dhaalu Atoll, Maldives.', 'published', 'Castaways | Maldives Surf Breaks | MTG', 'Castaways is a surf break in Gaafu Dhaalu Atoll, Maldives.', '{"wave_notes":"An advanced, technical, barrelling right-hander; very shallow, surfable only around high tide when the swell exceeds about 4ft, in front of a small uninhabited (''desert'') island (dreamingofmaldives.com, bluestarsurfaris.com). No source in the snippets reviewed used an explicit ''reef break'' label for this specific spot (unlike Tiger Stripes and Beacons), so break_type was left null despite the shallow-coral description.","season_notes":"Falls within the general Gaafu Dhaalu Atoll surf season, given by blue-horizon.com.mv as best ''early March-April and later October-November''.","access_notes":"Reached via surf charter/boat trip in Gaafu Dhaalu Atoll; tide-dependent access (high tide only)."}'::jsonb, now())
on conflict (node_type, slug) do nothing;

insert into locations (id, location_type, parent_id, path)
select n.id, 'surf_break', p.id, (p_loc.path || 'castaways'::ltree)
from nodes n, nodes p join locations p_loc on p_loc.id = p.id
where n.node_type = 'location' and n.slug = 'castaways'
  and p.node_type = 'location' and p.slug = 'gaafu-dhaalu'
on conflict (id) do nothing;

-- Surfing activities
insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'group-surf-lesson', 'Group Surf Lesson', 'Group Surf Lesson is a surf lessons activity on Thulusdhoo, Kaafu Atoll. Duration: 120 minutes. It is operated by The Perfect Wave Cokes Surf Camp.', 'published', 'Group Surf Lesson | Maldives Surfing | MTG', 'Group Surf Lesson is a surf lessons activity on Thulusdhoo, Kaafu Atoll. Duration: 120 minutes. It is operated by The Perfect Wave Cokes Surf Camp.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'surfing',
  (select id from nodes where node_type = 'provider' and slug = 'the-perfect-wave-cokes-surf-camp'),
  120, null, null, null, 4
from nodes n where n.node_type = 'activity' and n.slug = 'group-surf-lesson'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'group-surf-lesson'
  and l.node_type = 'location' and l.slug = 'thulusdhoo'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'group-surf-lesson'
  and c.node_type = 'category' and c.slug = 'surf-lessons'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'group-surf-lesson'
  and l.node_type = 'location' and l.slug = 'chickens'
on conflict (node_id, location_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'group-surf-lesson'
  and l.node_type = 'location' and l.slug = 'ninjas'
on conflict (node_id, location_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'group-surf-lesson'
  and l.node_type = 'location' and l.slug = 'sultans'
on conflict (node_id, location_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'group-surf-lesson'
  and l.node_type = 'location' and l.slug = 'honkys'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'group-surf-lesson'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'guided-surf-boat-trip', 'Guided Surf Boat Trip', 'Guided Surf Boat Trip is a guided surfing activity on Thulusdhoo, Kaafu Atoll. Duration: 180 minutes. It is operated by Twin Palms Surfhouse.', 'published', 'Guided Surf Boat Trip | Maldives Surfing | MTG', 'Guided Surf Boat Trip is a guided surfing activity on Thulusdhoo, Kaafu Atoll. Duration: 180 minutes. It is operated by Twin Palms Surfhouse.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'surfing',
  (select id from nodes where node_type = 'provider' and slug = 'twin-palms-surfhouse'),
  180, null, null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'guided-surf-boat-trip'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'guided-surf-boat-trip'
  and l.node_type = 'location' and l.slug = 'thulusdhoo'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'guided-surf-boat-trip'
  and c.node_type = 'category' and c.slug = 'guided-surfing'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'guided-surf-boat-trip'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'surf-lesson', 'Surf Lesson', 'Surf Lesson is a surf lessons activity on Thulusdhoo, Kaafu Atoll. It is operated by Amphibuzz.', 'published', 'Surf Lesson | Maldives Surfing | MTG', 'Surf Lesson is a surf lessons activity on Thulusdhoo, Kaafu Atoll. It is operated by Amphibuzz.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'surfing',
  (select id from nodes where node_type = 'provider' and slug = 'amphibuzz'),
  null, null, null, 75, null
from nodes n where n.node_type = 'activity' and n.slug = 'surf-lesson'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'surf-lesson'
  and l.node_type = 'location' and l.slug = 'thulusdhoo'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'surf-lesson'
  and c.node_type = 'category' and c.slug = 'surf-lessons'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'surf-lesson'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'surfboard-rental', 'Surfboard Rental', 'Surfboard Rental is a board rental activity on Thulusdhoo, Kaafu Atoll. It is operated by Amphibuzz.', 'published', 'Surfboard Rental | Maldives Surfing | MTG', 'Surfboard Rental is a board rental activity on Thulusdhoo, Kaafu Atoll. It is operated by Amphibuzz.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'surfing',
  (select id from nodes where node_type = 'provider' and slug = 'amphibuzz'),
  null, null, null, 35, null
from nodes n where n.node_type = 'activity' and n.slug = 'surfboard-rental'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'surfboard-rental'
  and l.node_type = 'location' and l.slug = 'thulusdhoo'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'surfboard-rental'
  and c.node_type = 'category' and c.slug = 'board-rental'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'surfboard-rental'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'wave-surfing', 'Wave Surfing', 'Wave Surfing is a surf lessons activity on Maafushi, Kaafu Atoll. Duration: 60 minutes. It is operated by Maafushi Dive and Water Sports.', 'published', 'Wave Surfing | Maldives Surfing | MTG', 'Wave Surfing is a surf lessons activity on Maafushi, Kaafu Atoll. Duration: 60 minutes. It is operated by Maafushi Dive and Water Sports.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'surfing',
  (select id from nodes where node_type = 'provider' and slug = 'maafushi-dive-and-water-sports'),
  60, null, null, null, 4
from nodes n where n.node_type = 'activity' and n.slug = 'wave-surfing'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'wave-surfing'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'wave-surfing'
  and c.node_type = 'category' and c.slug = 'surf-lessons'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'wave-surfing'
  and l.node_type = 'location' and l.slug = 'guraidhoo-corner'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'wave-surfing'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'wave-surfing-maafushi', 'Wave Surfing', 'Wave Surfing is a surf lessons activity on Maafushi, Kaafu Atoll. Duration: 60 minutes. It is operated by Active Watersports Maafushi.', 'published', 'Wave Surfing | Maldives Surfing | MTG', 'Wave Surfing is a surf lessons activity on Maafushi, Kaafu Atoll. Duration: 60 minutes. It is operated by Active Watersports Maafushi.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'surfing',
  (select id from nodes where node_type = 'provider' and slug = 'active-watersports-maafushi'),
  60, null, 'all_levels', null, 20
from nodes n where n.node_type = 'activity' and n.slug = 'wave-surfing-maafushi'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'wave-surfing-maafushi'
  and l.node_type = 'location' and l.slug = 'maafushi'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'wave-surfing-maafushi'
  and c.node_type = 'category' and c.slug = 'surf-lessons'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'wave-surfing-maafushi'
  and l.node_type = 'location' and l.slug = 'guraidhoo-corner'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'wave-surfing-maafushi'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'multi-day-surf-camp-package', 'Multi-Day Surf Camp Package', 'Multi-Day Surf Camp Package is a surf camp activity on Himmafushi, Kaafu Atoll. It is operated by Jailbreak Surf Inn.', 'published', 'Multi-Day Surf Camp Package | Maldives Surfing | MTG', 'Multi-Day Surf Camp Package is a surf camp activity on Himmafushi, Kaafu Atoll. It is operated by Jailbreak Surf Inn.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'surfing',
  (select id from nodes where node_type = 'provider' and slug = 'jailbreak-surf-inn'),
  null, null, null, null, null
from nodes n where n.node_type = 'activity' and n.slug = 'multi-day-surf-camp-package'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'multi-day-surf-camp-package'
  and l.node_type = 'location' and l.slug = 'himmafushi'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'multi-day-surf-camp-package'
  and c.node_type = 'category' and c.slug = 'surf-camp'
on conflict (node_id, category_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'multi-day-surf-camp-package'
  and l.node_type = 'location' and l.slug = 'jailbreak'
on conflict (node_id, location_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'multi-day-surf-camp-package'
  and l.node_type = 'location' and l.slug = 'honkys'
on conflict (node_id, location_id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'secondary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'multi-day-surf-camp-package'
  and l.node_type = 'location' and l.slug = 'sultans'
on conflict (node_id, location_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'multi-day-surf-camp-package'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'beginner-lagoon-surf-lesson', 'Beginner Lagoon Surf Lesson', 'Beginner Lagoon Surf Lesson is a surf lessons activity on Olhuveli, Laamu Atoll. Duration: 60 minutes. It is operated by Six Senses.', 'published', 'Beginner Lagoon Surf Lesson | Maldives Surfing | MTG', 'Beginner Lagoon Surf Lesson is a surf lessons activity on Olhuveli, Laamu Atoll. Duration: 60 minutes. It is operated by Six Senses.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'surfing',
  (select id from nodes where node_type = 'provider' and slug = 'six-senses'),
  60, null, 'beginner', 95, null
from nodes n where n.node_type = 'activity' and n.slug = 'beginner-lagoon-surf-lesson'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'beginner-lagoon-surf-lesson'
  and l.node_type = 'location' and l.slug = 'olhuveli'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'beginner-lagoon-surf-lesson'
  and c.node_type = 'category' and c.slug = 'surf-lessons'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'beginner-lagoon-surf-lesson'
on conflict (id) do nothing;

insert into nodes (node_type, slug, title, summary, status, meta_title, meta_description, published_at)
values ('activity', 'first-green-wave-private-surf-lesson', 'First Green Wave Private Surf Lesson', 'First Green Wave Private Surf Lesson is a surf lessons activity on Olhuveli, Laamu Atoll. Duration: 90 minutes. It is operated by Six Senses.', 'published', 'First Green Wave Private Surf Lesson | Maldives Surfing | MTG', 'First Green Wave Private Surf Lesson is a surf lessons activity on Olhuveli, Laamu Atoll. Duration: 90 minutes. It is operated by Six Senses.', now())
on conflict (node_type, slug) do nothing;

insert into activities (
  id, activity_category, operated_by_provider_id, duration_minutes, min_age, difficulty, price_from, max_participants
)
select
  n.id, 'surfing',
  (select id from nodes where node_type = 'provider' and slug = 'six-senses'),
  90, null, 'beginner', 145, null
from nodes n where n.node_type = 'activity' and n.slug = 'first-green-wave-private-surf-lesson'
on conflict (id) do nothing;

insert into node_locations (node_id, location_id, relation)
select n.id, l.id, 'primary'
from nodes n, nodes l
where n.node_type = 'activity' and n.slug = 'first-green-wave-private-surf-lesson'
  and l.node_type = 'location' and l.slug = 'olhuveli'
on conflict (node_id, location_id) do nothing;

insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'first-green-wave-private-surf-lesson'
  and c.node_type = 'category' and c.slug = 'surf-lessons'
on conflict (node_id, category_id) do nothing;

insert into bookable_products (id, booking_mode)
select id, 'inquiry' from nodes where node_type = 'activity' and slug = 'first-green-wave-private-surf-lesson'
on conflict (id) do nothing;

-- Surf-type tag for the pre-existing Task 6 surfing activity (named
-- unambiguously by its own product title — no new facts introduced).
insert into node_categories (node_id, category_id)
select n.id, c.id
from nodes n, nodes c
where n.node_type = 'activity' and n.slug = 'private-surf-lesson-cokes'
  and c.node_type = 'category' and c.slug = 'surf-lessons'
on conflict (node_id, category_id) do nothing;

