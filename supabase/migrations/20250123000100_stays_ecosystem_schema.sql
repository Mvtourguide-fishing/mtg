-- Stays/Resorts/Guesthouses/Hotels/Liveaboards SEO ecosystem: schema
-- additions. Phase 1's audit (release/public_html/resorts + hotels, 150
-- real properties) found:
--   - Legacy per-room/villa data is real but thin: name, a fixed 2-person
--     price, bed type, max occupancy, 1-2 photos — nothing more (the
--     "Room Facilities" list is identical boilerplate on every property,
--     confirmed not real per-room data). accommodation_rooms below is
--     deliberately lightweight to match — no invented per-room facilities
--     column.
--   - A genuine "starting from" price exists per property (its cheapest
--     room), usable on cards; but individual property pages must never
--     show a fixed/guaranteed price (spec requirement — prices go stale
--     and legacy prices are pre-tax-inclusive marketing figures, not live
--     rates). price_from is for card/listing display only.
--   - 109/110 resorts (not hotels/guesthouses) have a real YouTube video.
--   - Liveaboards have ZERO real bookable content in the legacy export —
--     no vessel names, operators, cabins, or pricing (only a B2B partner
--     sign-up form and generic itinerary-template pages). Per user
--     decision: add the type now so routing/schema is ready, but do not
--     seed any liveaboard rows this round — there is nothing real to seed.

alter table accommodations add column price_from numeric(10,2);
-- The bare YouTube video id (e.g. "CZGxcfCXJz0"), matching the convention
-- media_assets.youtube_id already uses — never a full URL, so every
-- consumer embeds it the same way (`youtube.com/embed/{id}`).
alter table accommodations add column video_youtube_id text;

alter table accommodations drop constraint accommodations_accommodation_type_check;
alter table accommodations add constraint accommodations_accommodation_type_check
  check (accommodation_type in ('hotel','resort','guesthouse','villa','liveaboard','other'));

-- Lightweight room/villa-type records — one row per distinct room/villa
-- type a property lists (e.g. "Garden Villa", "Ocean Villa"). Never a
-- doorway page target on its own; rendered as part of the parent
-- accommodation's Rooms & Villas section.
create table accommodation_rooms (
  id               uuid primary key default gen_random_uuid(),
  accommodation_id uuid not null references accommodations(id) on delete cascade,
  name             text not null,
  price_from       numeric(10,2),
  price_currency   text default 'USD',
  bed_type         text,
  max_occupancy    smallint,
  sort_order       int default 0,
  -- Room names are unique per property in the source data — this is also
  -- what gives the seed generator a real idempotency key (id is a random
  -- uuid, so ON CONFLICT needs an explicit target).
  unique (accommodation_id, name)
);
create index accommodation_rooms_accommodation_idx on accommodation_rooms(accommodation_id);

-- Room-specific photos (the 1-2 real images the legacy carousel showed
-- for that exact room type) — kept separate from node_media since a room
-- isn't a node.
create table accommodation_room_media (
  room_id    uuid not null references accommodation_rooms(id) on delete cascade,
  media_id   uuid not null references media_assets(id) on delete cascade,
  sort_order int default 0,
  primary key (room_id, media_id)
);
