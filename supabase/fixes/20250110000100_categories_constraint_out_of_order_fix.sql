-- One-off recovery file — NOT part of the normal migration sequence.
--
-- For anyone who ran 20250113000100_transfers_platform_schema.sql (and
-- 20250113000200_transfers_platform_data.sql, which inserts a real
-- 'transfer-category' categories row) BEFORE running
-- 20250110000100_legacy_migration_schema.sql. That file tries to narrow
-- categories_category_group_check back down to only 9 values (missing
-- 'transfer-category'), which now fails with:
--   ERROR: check constraint "categories_category_group_check" of
--   relation "categories" is violated by some row
-- because a row using the 10th value already exists.
--
-- This does exactly what 20250110000100 does, except the categories
-- constraint here already includes 'transfer-category' (the same 10-value
-- list 20250113000100 sets), so it matches your database's actual current
-- state instead of an earlier, narrower one. The node_media_role_check
-- widening, storage bucket, and RLS policy are unchanged from the
-- original file — reproduced verbatim on local Postgres against this
-- exact out-of-order scenario before being handed over.
--
-- If you have NOT already run 20250113000100/20250113000200, don't use
-- this file — run 20250110000100_legacy_migration_schema.sql as normal
-- instead, in its original place in the sequence.
--
-- Every statement here is written to be safe regardless of exactly how
-- far the original run got before it errored (checked directly: when a
-- multi-statement paste like this hits an error partway through, the
-- statements AFTER the error still run — they are not rolled back as one
-- transaction. Reproducing your exact scenario on local Postgres showed
-- node_media_role_check, the storage bucket insert, and the RLS policy
-- had all already succeeded, and only categories_category_group_check
-- was left in a dropped-but-not-replaced state). Uses `if exists`/`if not
-- exists` guards throughout so it's safe to run whether that's your exact
-- state or not.

alter table node_media drop constraint if exists node_media_role_check;
alter table node_media add constraint node_media_role_check
  check (role in ('hero', 'gallery', 'thumbnail', 'content', 'map'));

alter table categories drop constraint if exists categories_category_group_check;
alter table categories add constraint categories_category_group_check
  check (category_group in (
    'accommodation-type', 'activity-type', 'amenity',
    'traveler-type', 'package-style', 'duration-band', 'inclusion', 'theme',
    'article-category', 'transfer-category'
  ));

insert into storage.buckets (id, name, public)
values ('media', 'media', true)
on conflict (id) do nothing;

drop policy if exists media_bucket_public_read on storage.objects;
create policy media_bucket_public_read
  on storage.objects for select
  using (bucket_id = 'media');
