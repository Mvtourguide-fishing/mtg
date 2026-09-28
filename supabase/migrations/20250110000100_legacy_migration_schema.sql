-- Task 14: minimal schema extensions for the legacy content migration.
-- Extends the existing architecture rather than creating a parallel one —
-- `articles`, `node_media`, `categories`, and Storage already exist
-- (Task 2/3 foundation); this only widens two check constraints and
-- creates the public media bucket idempotently.

-- node_media already supports hero/gallery/thumbnail (Task 3). Article
-- body content and map images need two more roles.
alter table node_media drop constraint node_media_role_check;
alter table node_media add constraint node_media_role_check
  check (role in ('hero', 'gallery', 'thumbnail', 'content', 'map'));

-- categories.category_group already supports the 8 Task 2 taxonomy
-- groups. Article categories (Maldives Travel, Transportation, Airports,
-- ...) reuse the same categories/node_categories system rather than a
-- second content-category table.
alter table categories drop constraint categories_category_group_check;
alter table categories add constraint categories_category_group_check
  check (category_group in (
    'accommodation-type', 'activity-type', 'amenity',
    'traveler-type', 'package-style', 'duration-band', 'inclusion', 'theme',
    'article-category'
  ));

-- Public, read-only media bucket for migrated legacy images/videos.
-- Idempotent — safe to re-run. Uploads happen out-of-band via
-- scripts/upload-legacy-media.mjs (service-role key, never client code);
-- this migration only ensures the bucket itself exists.
insert into storage.buckets (id, name, public)
values ('media', 'media', true)
on conflict (id) do nothing;

-- Public read of files in the media bucket (the bucket is marked public
-- above, but storage.objects RLS still gates actual object access).
create policy media_bucket_public_read
  on storage.objects for select
  using (bucket_id = 'media');
