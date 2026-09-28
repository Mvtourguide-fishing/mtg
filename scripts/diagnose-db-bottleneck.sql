-- Read-only diagnostic queries to distinguish a hardware-constrained
-- database (needs a bigger compute tier) from a software-constrained one
-- (a specific bad query, missing index, lock, or bloat problem that a
-- compute upgrade wouldn't actually fix). Run each block separately in
-- the Supabase SQL Editor and share the results.

-- ── 1. What's running RIGHT NOW, and why is it waiting? ──────────────
-- wait_event_type = 'Lock'  -> something is blocked on a lock, not I/O.
-- wait_event_type = 'IO'    -> genuinely waiting on disk (supports the
--                              memory-pressure/swap theory).
-- wait_event_type = 'Client'-> waiting on the app/network, not the DB.
-- Run this a few times over a minute or two, ideally while reproducing
-- a slow page load, to catch a hang in progress.
select
  pid,
  state,
  wait_event_type,
  wait_event,
  now() - query_start as running_for,
  left(query, 200) as query
from pg_stat_activity
where state != 'idle'
  and pid != pg_backend_pid()
order by running_for desc;

-- ── 2. Is anything blocked waiting on a lock held by something else? ──
-- Empty result = no lock contention right now.
select
  blocked.pid as blocked_pid,
  blocked_query.query as blocked_query,
  blocking.pid as blocking_pid,
  blocking_query.query as blocking_query
from pg_locks blocked
join pg_stat_activity blocked_query on blocked_query.pid = blocked.pid
join pg_locks blocking on blocking.locktype = blocked.locktype
  and blocking.database is not distinct from blocked.database
  and blocking.relation is not distinct from blocked.relation
  and blocking.pid != blocked.pid
join pg_stat_activity blocking_query on blocking_query.pid = blocking.pid
where not blocked.granted;

-- ── 3. Which tables are getting full scans instead of index lookups? ──
-- High seq_scan on a large table (high n_live_tup) with low idx_scan is
-- the signature of a missing index or a query that can't use one.
select
  relname as table_name,
  seq_scan,
  seq_tup_read,
  idx_scan,
  n_live_tup as approx_rows
from pg_stat_user_tables
where seq_scan > 0
order by seq_scan desc, seq_tup_read desc
limit 20;

-- ── 4. Table bloat / vacuum health ────────────────────────────────────
-- A table with n_dead_tup close to or exceeding n_live_tup, or a
-- last_autovacuum that's null/very old, can make normally-fast queries
-- degrade badly -- and autovacuum itself running on a large table can
-- cause exactly the kind of unpredictable multi-second stall we're
-- chasing.
select
  relname as table_name,
  n_live_tup,
  n_dead_tup,
  last_vacuum,
  last_autovacuum,
  last_analyze,
  last_autoanalyze
from pg_stat_user_tables
order by n_dead_tup desc
limit 15;

-- ── 5. Current connection count vs. the tier's max ────────────────────
select count(*) as active_connections, max_conn.setting as max_connections
from pg_stat_activity, (select setting from pg_settings where name = 'max_connections') as max_conn
group by max_conn.setting;
