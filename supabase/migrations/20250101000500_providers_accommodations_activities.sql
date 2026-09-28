-- MTG foundation: businesses, accommodation, activities.

create table providers (
  id                uuid primary key references nodes(id) on delete cascade,
  legal_name        text,
  contact_email     text,
  contact_phone     text,
  website_url       text,
  license_number    text,
  is_verified       boolean default false
);

create table accommodations (
  id                        uuid primary key references nodes(id) on delete cascade,
  accommodation_type        text not null check (accommodation_type in ('hotel','resort','guesthouse','villa','other')),
  operated_by_provider_id   uuid references providers(id),
  star_rating               smallint check (star_rating between 1 and 5),
  price_tier                text check (price_tier in ('budget','mid','luxury','ultra_luxury')),
  room_count                int,
  all_inclusive             boolean default false,
  overwater_villas          boolean default false,
  check_in_time             time,
  check_out_time            time,
  currency                  text default 'USD'
);
create index accommodations_type_idx     on accommodations(accommodation_type);
create index accommodations_provider_idx on accommodations(operated_by_provider_id);

create table activities (
  id                        uuid primary key references nodes(id) on delete cascade,
  activity_category         text not null check (activity_category in (
                               'general', 'fishing', 'diving', 'surfing', 'watersports',
                               'excursion', 'island_hopping', 'spa', 'culture'
                             )),
  operated_by_provider_id   uuid references providers(id),
  duration_minutes          int,
  min_age                   smallint,
  difficulty                text check (difficulty in ('beginner','intermediate','advanced','all_levels')),
  price_from                numeric(10,2),
  currency                  text default 'USD',
  max_participants          int
);
create index activities_category_idx on activities(activity_category);
create index activities_provider_idx on activities(operated_by_provider_id);
