-- MTG foundation: reviews, article comments, favorites, node media.

create table reviews (
  id            uuid primary key default gen_random_uuid(),
  node_id       uuid not null references nodes(id) on delete cascade,
  user_id       uuid not null references auth.users(id),
  rating        smallint not null check (rating between 1 and 5),
  title         text,
  body          text,
  status        text not null default 'pending' check (status in ('pending','published','rejected')),
  created_at    timestamptz not null default now(),
  unique (node_id, user_id)
);
create index reviews_node_idx on reviews(node_id) where status = 'published';
create index reviews_status_idx on reviews(status);

create table article_comments (
  id                  uuid primary key default gen_random_uuid(),
  article_id          uuid not null references nodes(id) on delete cascade,
  user_id             uuid not null references auth.users(id),
  parent_comment_id   uuid references article_comments(id),
  body                text not null,
  status              text not null default 'visible' check (status in ('visible','flagged','removed')),
  created_at          timestamptz not null default now()
);
create index article_comments_article_idx on article_comments(article_id);

create table favorites (
  user_id     uuid not null references auth.users(id) on delete cascade,
  node_id     uuid not null references nodes(id) on delete cascade,
  created_at  timestamptz not null default now(),
  primary key (user_id, node_id)
);

create table node_media (
  node_id      uuid not null references nodes(id) on delete cascade,
  media_id     uuid not null references media_assets(id) on delete cascade,
  role         text not null check (role in ('hero','gallery','thumbnail')),
  sort_order   int default 0,
  primary key (node_id, media_id, role)
);
create index node_media_media_idx on node_media(media_id);
