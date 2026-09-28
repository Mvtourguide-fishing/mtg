-- MTG foundation: extensions
-- Source: docs/SYSTEM_ARCHITECTURE_AND_DATABASE_DESIGN.md (Task 2, Revision 3), section 13.

create extension if not exists pgcrypto;
create extension if not exists ltree;
create extension if not exists pg_trgm;
