# Maldives location source data

This directory is the **source of truth** for the Maldives geographic hierarchy seeded
into the database. It is not itself SQL — `scripts/generate-location-seed.mjs` reads
these files and generates `supabase/migrations/20250102000100_seed_maldives_locations.sql`
from them.

## Files

- `atolls.json` — every administrative atoll of the Maldives.
- `islands.json` — every inhabited island, with its parent atoll's administrative code.
- `SOURCES.md` — where this data came from, and any known gaps or low-confidence entries.

## Updating the dataset

1. Edit `atolls.json` / `islands.json` (and update `SOURCES.md` if you changed what a
   value is based on).
2. Regenerate the migration: `npm run seed:locations`.
3. Apply it: `npx supabase db push` (or re-run migrations locally).

The generator is idempotent — every row is inserted keyed by its slug with
`ON CONFLICT DO NOTHING`, so re-running the same source data twice does not create
duplicates or change existing ids. It does not bypass the hierarchy-validation triggers
from `20250101001300_functions_triggers.sql`; an invalid parent/child combination in the
source data will make the migration fail loudly rather than silently import bad data.

## What is deliberately NOT here

No coordinates, descriptions beyond a short factual template, photos, hotels, resorts,
activities, or any other commercial content — this directory is geography only. See
`docs/SYSTEM_ARCHITECTURE_AND_DATABASE_DESIGN.md` for how other entity types will
reference these locations later without duplicating them.
