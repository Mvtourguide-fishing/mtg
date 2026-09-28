-- MTG foundation: nodes — the universal entity backbone.
-- Every location, category, provider, accommodation, activity, transfer
-- route, package and article shares this table's primary key.

create table nodes (
  id                   uuid primary key default gen_random_uuid(),
  node_type            text not null check (node_type in (
                          'location', 'category', 'provider', 'accommodation',
                          'activity', 'transfer_route', 'package', 'article'
                        )),
  slug                 text not null,
  title                text not null,
  summary              text,
  status               text not null default 'draft' check (status in ('draft','published','archived')),
  rating_avg           numeric(3,2) default 0,
  rating_count         int default 0,
  attributes           jsonb not null default '{}'::jsonb,
  legacy_slugs         text[] default '{}',           -- historical metadata only, see url_redirects
  meta_title           text,
  meta_description     text,
  og_image_media_id    uuid references media_assets(id),
  created_by           uuid references auth.users(id),
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now(),
  published_at         timestamptz,
  unique (node_type, slug)
);

create index nodes_status_idx      on nodes(status);
create index nodes_node_type_idx   on nodes(node_type);
create index nodes_attributes_gin  on nodes using gin (attributes jsonb_path_ops);
create index nodes_search_idx      on nodes using gin (to_tsvector('english', title || ' ' || coalesce(summary,'')));
create index nodes_legacy_slugs_gin on nodes using gin (legacy_slugs);

create or replace function set_updated_at() returns trigger as $$
begin
  new.updated_at := now();
  return new;
end;
$$ language plpgsql set search_path = public, pg_temp;

create trigger nodes_set_updated_at
  before update on nodes
  for each row execute function set_updated_at();
