# Maldives Tour Guide (MTG)

Next.js + Supabase foundation for the MTG platform. See `docs/ARCHITECTURE_BLUEPRINT.md`
and `docs/SYSTEM_ARCHITECTURE_AND_DATABASE_DESIGN.md` for the approved architecture and
database design — this codebase implements that design and does not redefine it.

## Getting started

```bash
npm install
cp .env.example .env.local   # then fill in your Supabase project's values
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

## Environment variables

See `.env.example`. `SUPABASE_SERVICE_ROLE_KEY` is server-only — never prefix it with
`NEXT_PUBLIC_`, and only import `src/lib/supabase/admin.ts` from server-side code.

## Database

All schema is defined as SQL migrations in `supabase/migrations/`, applied in filename
(timestamp) order. They implement the schema, RLS policies, and functions from
`docs/SYSTEM_ARCHITECTURE_AND_DATABASE_DESIGN.md` §13.

Once you have a Supabase project:

```bash
npx supabase login
npx supabase link --project-ref <your-project-ref>
npx supabase db push
```

To regenerate typed database types after any migration change:

```bash
npx supabase gen types typescript --db-url "<your-db-connection-string>" > src/types/database.ts
```

`src/types/database.ts` currently ships as an empty placeholder — this sandbox has no
Docker daemon available, and `supabase gen types typescript` requires it even for a
plain `--db-url` connection, so real types could not be generated here. The migrations
themselves were fully applied and functionally verified against a local Postgres 16
instance (see the Task 3 implementation report for what was checked).

## Project structure

```
src/
  app/                    Next.js App Router routes
  lib/supabase/
    client.ts             browser Supabase client (anon key)
    server.ts             Server Component / Server Action client (anon key + session)
    admin.ts               service-role client — server-only, never import from client code
    proxy.ts                session-refresh helper used by src/proxy.ts
  proxy.ts                 Next.js Proxy (formerly "middleware") — refreshes the auth session
  types/database.ts         generated Supabase types (placeholder, see above)
supabase/
  migrations/               dependency-ordered SQL migrations
  config.toml                Supabase CLI project config
```

## Learn more

- [Next.js Documentation](https://nextjs.org/docs)
- [Supabase Documentation](https://supabase.com/docs)
