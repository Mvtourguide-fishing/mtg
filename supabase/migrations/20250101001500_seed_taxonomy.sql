-- MTG foundation: seed data.
-- Only structural/taxonomy data required for the system to function is
-- seeded here — package taxonomy category values, the location hierarchy
-- validation rules, and one baseline platform setting. No hotels, resorts,
-- activities, transfer providers, prices, reviews, or Maldives location
-- data are seeded — those are real content for a later task, not
-- foundation data.

-- ═══════════════════════════════════════════════════════════════════
-- Package taxonomy values (Task 2 Revision 3 §8). Values are given for
-- traveler-type, package-style, duration-band, theme and inclusion, per
-- the approved architecture; accommodation-type/activity-type/amenity
-- remain valid category_group values with no seeded rows yet, since no
-- explicit value list was specified for them.
--
-- Note: 'island-hopping' is requested under both package-style and theme;
-- since a category is a node and slugs are unique per node_type, the theme
-- entry is seeded as 'island-hopping-theme' to avoid a slug collision
-- while keeping both concepts available.
-- ═══════════════════════════════════════════════════════════════════
-- Not ON COMMIT DROP: this migration runs as a sequence of auto-committed
-- statements, and ON COMMIT DROP would remove the table right after its own
-- CREATE TABLE statement commits, before the INSERTs that follow could use
-- it. A plain temporary table is scoped to the session instead, and is
-- dropped explicitly at the end of this script.
create temporary table _taxonomy_seed (
  id              uuid not null default gen_random_uuid(),
  category_group  text not null,
  slug            text not null,
  title           text not null
);

insert into _taxonomy_seed (category_group, slug, title) values
  -- traveler-type
  ('traveler-type', 'honeymoon',  'Honeymoon'),
  ('traveler-type', 'family',     'Family'),
  ('traveler-type', 'couple',     'Couple'),
  ('traveler-type', 'solo',       'Solo'),
  ('traveler-type', 'group',      'Group'),
  ('traveler-type', 'luxury',     'Luxury'),
  ('traveler-type', 'budget',     'Budget'),
  ('traveler-type', 'long-stay',  'Long Stay'),

  -- package-style
  ('package-style', 'local-island',         'Local Island'),
  ('package-style', 'resort',               'Resort'),
  ('package-style', 'hotel',                'Hotel'),
  ('package-style', 'guesthouse',           'Guesthouse'),
  ('package-style', 'mix-islands',          'Mix Islands'),
  ('package-style', 'local-island-resort',  'Local Island + Resort'),
  ('package-style', 'island-hopping',       'Island Hopping'),

  -- duration-band
  ('duration-band', '3-nights',  '3 Nights'),
  ('duration-band', '4-nights',  '4 Nights'),
  ('duration-band', '5-nights',  '5 Nights'),
  ('duration-band', '7-nights',  '7 Nights'),
  ('duration-band', '10-nights', '10 Nights'),
  ('duration-band', '14-nights', '14 Nights'),
  ('duration-band', 'custom',    'Custom'),

  -- theme
  ('theme', 'diving',               'Diving'),
  ('theme', 'fishing',              'Fishing'),
  ('theme', 'surfing',              'Surfing'),
  ('theme', 'island-hopping-theme', 'Island Hopping'),
  ('theme', 'beach-holiday',        'Beach Holiday'),
  ('theme', 'adventure',            'Adventure'),
  ('theme', 'culture',              'Culture'),
  ('theme', 'wellness',             'Wellness'),
  ('theme', 'romantic',             'Romantic'),
  ('theme', 'family-activities',    'Family Activities'),

  -- inclusion
  ('inclusion', 'accommodation',       'Accommodation'),
  ('inclusion', 'activities',          'Activities'),
  ('inclusion', 'transfers',           'Transfers'),
  ('inclusion', 'food',                'Food'),
  ('inclusion', 'breakfast',           'Breakfast'),
  ('inclusion', 'half-board',          'Half Board'),
  ('inclusion', 'full-board',          'Full Board'),
  ('inclusion', 'all-inclusive',       'All Inclusive'),
  ('inclusion', 'airport-transfer',    'Airport Transfer'),
  ('inclusion', 'speedboat-transfer',  'Speedboat Transfer'),
  ('inclusion', 'seaplane-transfer',   'Seaplane Transfer'),
  ('inclusion', 'domestic-flight',     'Domestic Flight'),
  ('inclusion', 'excursions',          'Excursions'),
  ('inclusion', 'tours',               'Tours');

insert into nodes (id, node_type, slug, title, status, published_at)
select id, 'category', slug, title, 'published', now() from _taxonomy_seed;

insert into categories (id, category_group, path)
select id, category_group, text2ltree(replace(slug, '-', '_')) from _taxonomy_seed;

-- ═══════════════════════════════════════════════════════════════════
-- Location hierarchy validation rules (Task 2 Revision 3 §9).
-- ═══════════════════════════════════════════════════════════════════
insert into location_type_hierarchy_rules (parent_type, child_type) values
  (null,      'country'),
  ('country', 'atoll'),
  ('atoll',   'island'),
  ('atoll',   'airport'),
  ('atoll',   'seaport'),
  ('atoll',   'harbour'),
  ('atoll',   'dive_site'),
  ('atoll',   'surf_break'),
  ('atoll',   'fishing_spot'),
  ('atoll',   'poi'),
  ('island',  'locality'),
  ('island',  'airport'),
  ('island',  'seaport'),
  ('island',  'harbour'),
  ('island',  'dive_site'),
  ('island',  'surf_break'),
  ('island',  'fishing_spot'),
  ('island',  'poi');

-- ═══════════════════════════════════════════════════════════════════
-- Baseline platform settings (Task 2 Revision 3 §6). The recipient is
-- data, not code — editable later via the admin without a deploy.
-- ═══════════════════════════════════════════════════════════════════
insert into platform_settings (key, value, description) values
  (
    'booking_notification_email',
    'contact@maldivestour.guide',
    'Default recipient for booking/inquiry notifications. Configurable — not hardcoded in application code.'
  );

drop table _taxonomy_seed;
