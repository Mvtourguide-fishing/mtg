-- MTG foundation: media_assets
-- Created before `nodes` because nodes.og_image_media_id references it
-- (Task 2 Revision 3 §2 — dependency-order fix; media_assets has no
-- foreign-key dependencies of its own).

create table media_assets (
  id             uuid primary key default gen_random_uuid(),
  media_type     text not null check (media_type in ('image','youtube')),
  storage_path   text,
  youtube_id     text,
  alt_text       text,
  credit         text,
  width          int,
  height         int,
  created_at     timestamptz not null default now()
);
