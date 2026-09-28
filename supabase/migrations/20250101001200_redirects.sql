-- MTG foundation: URL redirect management (schema only — no redirects are
-- created or populated by this task; see docs/SYSTEM_ARCHITECTURE_AND_DATABASE_DESIGN.md
-- §5/§11 for the migration rules the later SEO migration task will follow).
--
-- url_redirects is the sole authoritative redirect system. nodes.legacy_slugs
-- is historical metadata only and never drives redirect resolution on its own.

create table url_redirects (
  id               uuid primary key default gen_random_uuid(),
  source_path      text not null unique,
  target_type      text not null check (target_type in ('node','path','external_url')),
  target_node_id   uuid references nodes(id),
  target_path      text,
  status_code      smallint not null default 301 check (status_code in (301,302,308)),
  is_active        boolean not null default true,
  notes            text,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),
  constraint url_redirects_target_shape check (
    (target_type = 'node'         and target_node_id is not null and target_path is null)
    or
    (target_type = 'path'          and target_path is not null and target_node_id is null)
    or
    (target_type = 'external_url'  and target_path is not null and target_node_id is null)
  )
);
create index url_redirects_active_idx on url_redirects(source_path) where is_active;

create trigger url_redirects_set_updated_at
  before update on url_redirects
  for each row execute function set_updated_at();
-- Chain-prevention trigger is added in the functions/triggers migration.
