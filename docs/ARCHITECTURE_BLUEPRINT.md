# Maldives Tour Guide (MTG) — Technical Blueprint v1

Status: **Draft for approval — no database, no app code created yet.**
Domain: www.maldivestour.guide

This document is the architectural foundation for MTG: a Maldives tourism discovery, directory, content, and booking platform covering the Maldives → Atoll → Island → Locality hierarchy, with reusable entities (hotels, resorts, activities, fishing, diving, surfing, packages, travel guides) and shared systems for reviews, comments, favorites, media, search, and SEO.

---

## 1. Recommended Next.js Architecture

**Framework:** Next.js 15 (App Router), TypeScript strict mode, React Server Components by default.

**Why App Router:** native nested layouts map naturally to the location hierarchy (`/maldives/atolls/[atoll]/[island]/...`), built-in support for streaming, route-level metadata generation (needed for per-page SEO/structured data), and route handlers double as sitemap/JSON-LD/API endpoints without a separate backend.

**Rendering strategy (per route type):**

| Route type | Strategy |
|---|---|
| Location hub pages (`/maldives`, `/maldives/atolls/[atoll]`, islands) | ISR (revalidate on content change via on-demand `revalidatePath`) |
| Entity detail pages (hotel, resort, activity, package) | ISR + on-demand revalidation from admin actions |
| Search & filter results | Dynamic (SSR) — filter state lives in URL query params, not client state, so results stay crawlable and shareable |
| Travel guide articles | ISR, long revalidate window |
| User dashboard, favorites, booking flow | Fully dynamic, auth-gated, no caching |
| Sitemap / robots / JSON-LD feeds | Route handlers, cached at edge, revalidated on content mutation |

**Project structure (single app, domain-first, not framework-first):**

```
src/
  app/
    (marketing)/                 route group: static/marketing pages
    maldives/
      page.tsx                   Maldives hub
      atolls/
        page.tsx                 atoll index
        [atollSlug]/
          page.tsx                atoll hub (islands, hotels, activities in atoll)
          [islandSlug]/
            page.tsx               island hub
      hotels/[slug]/page.tsx
      resorts/[slug]/page.tsx
      activities/[slug]/page.tsx
      fishing/[slug]/page.tsx
      diving/[slug]/page.tsx
      surfing/[slug]/page.tsx
      packages/[slug]/page.tsx
      travel-guide/[slug]/page.tsx
      search/page.tsx
    api/                          route handlers only for webhooks/3rd-party callbacks
    sitemap.xml/route.ts
    sitemaps/[type]/route.ts      split sitemaps
    account/                      user dashboard, favorites, bookings
    admin/                        gated admin CMS (see §19)
  components/
    ui/                           shadcn/ui primitives
    entity/                       cards, galleries, rating widgets (shared across entity types)
    location/                     breadcrumbs, location pickers, atoll/island maps
    reviews/  comments/  favorites/  media/  search/  booking/
  lib/
    supabase/                     server/browser clients
    db/                           typed query functions (repository layer, see below)
    seo/                          metadata + JSON-LD builders
    search/                       search/filter query builder
  types/                          generated Supabase types + domain types
```

**Data access pattern:** a thin **repository layer** in `lib/db` wraps Supabase queries (e.g. `getEntityBySlug`, `getLocationTree`, `listEntitiesByLocation`). Pages and Server Components never call `supabase.from()` directly — this keeps query logic testable, reusable across pages, and gives one place to enforce the polymorphic joins described in §4.

**Mutations:** Next.js Server Actions for authenticated writes (reviews, favorites, comments, booking requests), validated with Zod schemas shared between client and server.

**Styling/UI:** Tailwind CSS + shadcn/ui (Radix primitives) — fast to build a directory-style UI (cards, filters, tabs, galleries) without heavy custom CSS.

**Hosting:** Vercel (first-class Next.js ISR/on-demand revalidation, edge network for the sitemap/SEO routes). Supabase remains the backend regardless of host.

---

## 2. Recommended Supabase Architecture

- **Postgres** as system of record, with extensions:
  - `pgcrypto` / `uuid-ossp` — UUID PKs
  - `ltree` — hierarchical location & category trees (fast ancestor/descendant queries for breadcrumbs, "everything under this atoll", internal linking)
  - `pg_trgm` — fuzzy/typo-tolerant search fallback
  - `postgis` (optional, phase 2+) — island/resort coordinates, "near me" queries, maps
- **Supabase Auth** for user accounts (email/password + Google/Apple OAuth). `auth.users` is the source of identity; a `profiles` table (1:1, PK = `auth.users.id`) holds public profile data.
- **Row Level Security (RLS)** enabled on every table from day one (see §21) — public read on published content, owner-scoped read/write on user-generated content (reviews, favorites, comments, bookings), admin/editor bypass via role claim.
- **Storage buckets:** `media` (public, images), `avatars` (public), with signed upload URLs issued server-side; image transformation via Supabase's built-in image resizing or a CDN layer (§11).
- **Edge Functions** for logic that shouldn't run in request path or needs elevated privileges: sitemap regeneration triggers, rating aggregation, booking confirmation emails, scheduled jobs (e.g. `pg_cron` for nightly aggregate refresh).
- **Database as the API surface** where possible: Next.js talks to Postgres via the Supabase client using RLS-protected views/functions rather than a hand-rolled REST/GraphQL layer. Complex reads (e.g. "entity + location breadcrumb + rating summary + primary image") are exposed as Postgres functions (`rpc`) or views to avoid N+1 round trips from the app.
- **Environments:** separate Supabase projects for `dev`/`staging`/`prod`, schema managed via versioned SQL migrations (Supabase CLI), never edited by hand in the dashboard for anything beyond prototyping.

---

## 3–5. Database Schema, Entity Relationships & Location Taxonomy

### 3.1 Core design decision: a unified "nodes" backbone

The requirement that locations, categories, and every content/bookable entity share reviews, media, favorites, comments, SEO metadata, and internal linking points at one architecture: **every addressable "thing" on the site is a row in one polymorphic backbone table**, with type-specific detail tables attached to it. This avoids building a separate reviews table, media table, and favorites table per entity type (hotels_reviews, activities_reviews, ...), which doesn't scale as new entity types are added.

```
nodes                        -- the universal backbone
  id                uuid PK
  node_type         enum: 'location' | 'category' | 'hotel' | 'resort' | 'activity'
                          | 'fishing_trip' | 'diving_site' | 'surf_spot' | 'package'
                          | 'article' | 'operator' (extensible — add types without new tables)
  slug              text UNIQUE
  title             text
  summary           text
  status            enum: 'draft' | 'published' | 'archived'
  rating_avg        numeric(3,2)        -- denormalized, maintained by trigger
  rating_count      int
  meta_title        text
  meta_description  text
  canonical_path    text                -- computed final URL, see §16
  created_at, updated_at, published_at
```

Type-specific tables share the same primary key as `nodes` (1:1 "class-table inheritance"), e.g.:

```
locations (id PK/FK -> nodes.id)
  location_type   enum: 'country' | 'atoll' | 'island' | 'locality'
  parent_id        uuid FK -> locations.id (nullable for country root)
  path             ltree          -- e.g. 'maldives.kaafu.thulusdhoo'
  lat, lng          numeric
  timezone          text

categories (id PK/FK -> nodes.id)
  category_group   text            -- 'activity-type' | 'hotel-type' | 'audience' | 'trip-style' ...
  parent_id        uuid FK -> categories.id
  path             ltree

hotels (id PK/FK -> nodes.id)
  star_rating, price_tier, room_count, check_in_time, ...

resorts (id PK/FK -> nodes.id)
  all_inclusive boolean, overwater_villas boolean, price_tier, ...

activities (id PK/FK -> nodes.id)      -- generic activity detail (also used as parent concept
  duration_minutes, difficulty, min_age, price_from, currency   for fishing/diving/surfing rows)

fishing_trips (id PK/FK -> nodes.id)
  trip_type enum: 'sport' | 'night' | 'big-game' | 'reef', duration_hours, boat_type

diving_sites (id PK/FK -> nodes.id)
  depth_min, depth_max, visibility_notes, certification_required

surf_spots (id PK/FK -> nodes.id)
  break_type, best_season_start, best_season_end, skill_level

packages (id PK/FK -> nodes.id)
  duration_days, price_from, currency

articles (id PK/FK -> nodes.id)
  body (markdown/rich text or portable-text JSON), reading_time_minutes
```

Why this over one-table-per-feature: adding a new entity type (e.g. "liveaboards" next year) means adding one detail table — reviews, media, favorites, comments-on-articles, location links, category links, search indexing, and internal linking all keep working with zero changes, because they all key off `nodes.id`.

### 3.2 Location hierarchy (reusable across the platform)

```
Maldives (country, root)
  └─ Atoll (e.g. Kaafu Atoll)
       └─ Island (e.g. Thulusdhoo)
            └─ Locality/district (only where relevant, e.g. a zone within Male')
```

Modeled as a self-referencing `locations` table using `parent_id` **and** a materialized `ltree` path column, kept in sync by trigger. `ltree` gives cheap, indexed answers to the queries this platform needs constantly:

- "All entities in Kaafu Atoll" → join entities whose location path is under `maldives.kaafu`
- Breadcrumbs → split the path
- Internal linking ("also see: hotels in this atoll") → ancestor/descendant queries, no recursive CTEs needed

### 3.3 Relationships — the reusability layer

The requirement "an activity can be associated with an island and atoll without creating duplicate activity records" and "a hotel can belong to Hotels, Family, Budget, Thulusdhoo, Kaafu Atoll" is solved with **junction tables**, not denormalized foreign keys, so one node can attach to many locations and many categories:

```
node_locations
  node_id       uuid FK -> nodes.id
  location_id   uuid FK -> locations.id
  relation      enum: 'primary' | 'secondary'   -- primary = canonical location for URL/breadcrumb
  PRIMARY KEY (node_id, location_id)

node_categories
  node_id       uuid FK -> nodes.id
  category_id   uuid FK -> categories.id
  PRIMARY KEY (node_id, category_id)
```

A fishing trip row: one `nodes` row (`node_type = 'fishing_trip'`) + one `fishing_trips` detail row + `node_categories` rows for {Fishing, Fishing Trips, Sport Fishing} + `node_locations` rows for {Kaafu Atoll (secondary), Thulusdhoo (primary)}. Because the atoll association isn't duplicated data, it's derived — a query, not a copy — the island's atoll is walked via `locations.parent_id`/`ltree`, so `node_locations` normally only needs the **most specific** location (island); the atoll and country ancestors are implied and don't need their own rows unless you want an explicit editorial override (e.g. a resort that spans no single island).

**Packages composing other entities** (hotel + activities + transfers) are modeled as a further junction, not a copy of data:

```
package_components
  package_id     uuid FK -> nodes.id (node_type = 'package')
  component_id   uuid FK -> nodes.id (the hotel/activity/fishing_trip/etc being included)
  quantity       int default 1
  notes          text
  sort_order     int
```

### 3.4 Flexible, per-entity-type filterable attributes

Star rating applies to hotels, not to diving sites; depth applies to diving sites, not hotels. Rather than sparse nullable columns piling up on shared tables, or a rigid schema-per-type that fights the "reusable" goal, filterable attributes use a light **EAV-via-JSONB** pattern:

```
nodes.attributes   jsonb    -- e.g. {"difficulty": "beginner", "price_from": 120, "duration_minutes": 180}
```

with a GIN index (`USING gin (attributes jsonb_path_ops)`) and an `attribute_definitions` table per `node_type`/`category_group` driving what the admin UI shows and what the filter UI renders (label, data type, unit, whether it's filterable/facetable). This keeps the relational schema stable while filters evolve.

---

## 6. Category/Taxonomy System

Categories are structurally identical to locations (self-referencing tree via `parent_id` + `ltree`) but grouped by `category_group` so unrelated taxonomies don't collide:

- `activity-type`: Fishing → Sport Fishing / Night Fishing; Diving → Wreck Diving / Reef Diving; Surfing
- `hotel-type`: Family, Budget, Luxury, Boutique
- `audience`: Couples, Families, Solo, Groups
- `trip-style`: Adventure, Relaxation, Honeymoon

A node attaches to **any number** of categories across **any number** of groups via `node_categories` — this is exactly how "Hotels + Family + Budget" or "Fishing + Fishing Trips + Sport Fishing" is expressed without new columns per tag.

---

## 7. Review/Rating Architecture

Single generic system, since every `node` can be reviewed:

```
reviews
  id            uuid PK
  node_id       uuid FK -> nodes.id
  user_id       uuid FK -> auth.users.id
  rating        smallint (1-5)
  title         text
  body          text
  status        enum: 'pending' | 'published' | 'rejected'
  created_at
  UNIQUE (node_id, user_id)     -- one review per user per entity
```

`nodes.rating_avg`/`rating_count` are denormalized and refreshed by an `AFTER INSERT/UPDATE/DELETE` trigger on `reviews` (cheap at this scale; revisit with a materialized view only if volume demands it). Moderation is a `status` state machine — new reviews default to `pending` unless the author is an established/trusted user, moving out of "invent unnecessary features" territory by keeping this a boolean-ish gate rather than a full workflow engine initially.

---

## 8. User/Profile Architecture

```
profiles (id PK/FK -> auth.users.id)
  display_name, avatar_url, bio, home_country, created_at
  role   enum: 'user' | 'editor' | 'admin'   -- drives RLS + admin access, see §21
```

Auth stays entirely in Supabase Auth (`auth.users`); `profiles` only carries public-facing/app-specific fields, never duplicates credentials. Editors/admins are just `profiles.role`, no separate staff table needed at this scale.

---

## 9. Comments Architecture

Distinct from reviews per your requirement — comments are conversational and threaded, and (for now) scoped to articles rather than every node type, since open comment threads on a hotel page invite spam/duplicate the review system:

```
article_comments
  id                uuid PK
  article_id        uuid FK -> nodes.id (node_type = 'article')
  user_id           uuid FK -> auth.users.id
  parent_comment_id uuid FK -> article_comments.id (nullable, enables one level or nested replies)
  body              text
  status            enum: 'visible' | 'flagged' | 'removed'
  created_at
```

If down the line comments are wanted on other node types, this table generalizes to `node_id` FK → `nodes.id` with no structural change — kept article-scoped now deliberately, per "don't invent unnecessary features."

---

## 10. Favorites Architecture

```
favorites
  user_id   uuid FK -> auth.users.id
  node_id   uuid FK -> nodes.id
  created_at
  PRIMARY KEY (user_id, node_id)
```

Works uniformly across hotels, activities, packages, articles — "save this island guide" and "favorite this resort" are the same mechanism.

---

## 11. Media/Image/Video Architecture

```
media_assets
  id            uuid PK
  media_type    enum: 'image' | 'youtube'
  storage_path  text          -- Supabase Storage path, for images
  youtube_id    text          -- for videos
  alt_text      text
  credit        text
  width, height int

node_media
  node_id       uuid FK -> nodes.id
  media_id      uuid FK -> media_assets.id
  role          enum: 'hero' | 'gallery' | 'thumbnail'
  sort_order    int
  PRIMARY KEY (node_id, media_id, role)
```

Because media attaches to `node_id`, the same table serves hotel galleries, island hero shots, category header images, and embedded YouTube videos on a diving site page — one upload/attach flow, one admin UI, one component library. Images served via Supabase Storage + Next.js `<Image>` with a remote loader (or a CDN image-resizing layer, e.g. Supabase's transform API or Cloudinary, added when traffic justifies it — not day one).

---

## 12. Search Architecture

**Phase 1 (launch):** Postgres full-text search — a generated `tsvector` column on `nodes` (title + summary + category names, weighted), combined with `pg_trgm` for typo tolerance, exposed via a Postgres function (`search_nodes(query, filters)`) called through Supabase RPC. This avoids standing up and paying for a separate search service before there's content/traffic to justify it.

**Phase 2 (when catalog/traffic grows):** swap the query layer for Typesense or Meilisearch (self-hostable, cheaper than Algolia, both have first-class faceting) — because search is accessed through one repository function (`lib/search`), this is a backend swap, not a rewrite of every page that searches.

Search always filters to `status = 'published'` and is location- and category-aware (search "diving in Kaafu" = full-text match + location facet).

---

## 13. Filter Architecture

Filters are driven by three orthogonal facets, all indexed:

1. **Location** — `node_locations` joined against the `ltree` path (filter by atoll = everything under it, incl. islands)
2. **Category** — `node_categories`, filterable per `category_group` (so the UI can show "Type: Family, Budget" and "Activity: Sport Fishing" as separate filter groups)
3. **Attributes** — the `attributes` JSONB column (price range, duration, difficulty, star rating), rendered dynamically per `node_type` from `attribute_definitions`

Filter state lives in the URL (`?atoll=kaafu&type=family&price_max=200`) so results are shareable, bookmarkable, and crawlable — never client-only state.

---

## 14. Internal Linking Architecture

Because relationships are explicit rows (`node_locations`, `node_categories`, `package_components`) rather than free-text links, related content is **queried, not authored**:

- "Other hotels on Thulusdhoo" → same `location_id`, different node
- "Other Sport Fishing trips in Kaafu Atoll" → same category + ancestor location
- "Packages that include this activity" → reverse lookup on `package_components`
- Article → entity linking: articles can optionally tag `node_categories`/`node_locations` too, so a "Diving in Kaafu Atoll" guide automatically surfaces links to every diving site/operator in Kaafu without manual link insertion

A single reusable `<RelatedNodes>` server component takes a node + strategy ("same location", "same category", "same package") and renders a link block — used across every entity/location/category page. This is the mechanism that also feeds the sitemap's internal link graph and topic clusters for SEO.

---

## 15. SEO Architecture

- Per-node `meta_title`/`meta_description` with sane generated fallbacks (e.g. `"{title} — {primary location}, Maldives | MTG"`), overridable by editors.
- Canonical URLs generated from the node's primary location + slug (§16); enforced via `<link rel="canonical">` even if a node is reachable through more than one filtered/query-param URL.
- Breadcrumbs generated from the `ltree` path, also emitted as `BreadcrumbList` structured data.
- OpenGraph/Twitter card metadata generated from the node's hero image + summary.
- Automatic internal linking (§14) doubles as topical SEO clustering (location hub ↔ entities ↔ articles all interlink).

---

## 16. URL Structure

Flat, category-first URLs for entities (avoids URL-count explosion from crossing every category with every location, and avoids duplicate-content risk from the same hotel having multiple valid location-prefixed URLs):

```
/maldives/
/maldives/atolls/
/maldives/atolls/[atoll-slug]/
/maldives/atolls/[atoll-slug]/[island-slug]/
/maldives/hotels/[hotel-slug]/
/maldives/resorts/[resort-slug]/
/maldives/activities/[activity-slug]/
/maldives/fishing/[trip-slug]/
/maldives/diving/[site-slug]/
/maldives/surfing/[spot-slug]/
/maldives/packages/[package-slug]/
/maldives/travel-guide/[article-slug]/
/maldives/search?...
```

Location hub pages (`/maldives/atolls/[atoll]/`, island pages) are where location-scoped browsing happens — they list every hotel/activity/article associated with that location via `node_locations`, rather than the URL itself being nested per entity. Slugs are globally unique per `node_type` (enforced by a `UNIQUE (node_type, slug)` constraint), so a hotel and an article can't collide.

---

## 17. Sitemap Strategy

Split sitemaps (single-file sitemaps degrade past ~50k URLs and are harder to reason about well before that):

```
/sitemap.xml                 -- sitemap index
/sitemaps/locations.xml
/sitemaps/hotels.xml
/sitemaps/resorts.xml
/sitemaps/activities.xml
/sitemaps/packages.xml
/sitemaps/travel-guide.xml
```

Each generated by a Next.js route handler querying `nodes` filtered by `node_type`/`status = 'published'`, cached at the edge, invalidated on publish/unpublish via on-demand revalidation (not full rebuilds).

---

## 18. Structured-Data Strategy

JSON-LD emitted per node type, generated server-side from the same repository data already fetched for the page (no separate query):

| Node type | Schema.org type |
|---|---|
| Hotel / Resort | `Hotel` / `Resort` (+ `AggregateRating`, `Review`) |
| Activity / Fishing / Diving / Surfing | `TouristAttraction` or `Product` (+ `AggregateRating`) |
| Package | `Product` / `TouristTrip` (+ `Offer`) |
| Travel guide article | `Article` |
| Every page | `BreadcrumbList` |
| Site-wide | `Organization`/`WebSite` with `SearchAction` |

A `lib/seo/jsonld.ts` builder module keeps schema generation centralized and typed, rather than hand-writing JSON-LD in every page.

---

## 19. Admin/Content-Management Strategy

Given the schema's centrality (one `nodes` backbone + typed detail tables + junctions), a bespoke lightweight admin is more maintainable than force-fitting a generic headless CMS onto this relational structure:

- `/admin` route group, gated by `profiles.role IN ('editor','admin')`, enforced both in middleware and RLS (never trust the client).
- CRUD screens built with shadcn/ui + Server Actions, generated around common patterns (a "node editor" shell reused for hotels/resorts/activities/etc., with type-specific field panels).
- Media upload flow → Supabase Storage with signed URLs.
- Review/comment moderation queue.
- Draft/publish workflow (`status` field) with on-demand revalidation triggered on publish.

This is explicitly **not** phase 1 to build — it's designed now so the schema supports it cleanly, but per your instruction we are not building pages yet.

---

## 20. Booking Architecture

Kept deliberately minimal at the architecture stage — real payment/inventory integration is a phase-3+ decision, not a schema-day-one one. Two supported paths, same schema either way:

```
bookable_products (id PK/FK -> nodes.id)
  booking_mode   enum: 'inquiry' | 'instant'   -- v1 ships 'inquiry' only
  base_price, currency, max_guests, ...

bookings
  id                uuid PK
  product_id        uuid FK -> nodes.id
  user_id           uuid FK -> auth.users.id
  status             enum: 'requested' | 'confirmed' | 'cancelled' | 'completed'
  travel_date_start, travel_date_end
  guests             int
  total_price, currency
  created_at
```

**v1 = "inquiry/lead" bookings**: user submits a request, operator/admin confirms manually, no payment processing, no availability engine — this covers "Bookings" in the requirements without inventing a reservation system before there's a reason to. **v2+** can add real-time availability + payment (Stripe) or integrate a specialist booking engine (FareHarbor/Rezdy) behind the same `bookable_products`/`bookings` interface, without changing how the rest of the site links to bookable entities.

---

## 21. Security and Permissions

- **RLS on every table**, default-deny. Illustrative policy shape:
  - `nodes`, `locations`, `categories`, `media_assets`, `node_media`, `node_locations`, `node_categories`: `SELECT` public where `status = 'published'`; `INSERT/UPDATE/DELETE` restricted to `role IN ('editor','admin')`.
  - `reviews`, `favorites`, `article_comments`: `INSERT` requires `auth.uid() = user_id`; `UPDATE/DELETE` requires ownership; `SELECT` public for published/visible rows.
  - `bookings`: `SELECT/UPDATE` restricted to the owning user or admin/editor.
  - `profiles`: user can update own row; role column is **not** user-writable (excluded from the update policy / guarded by a trigger) to prevent privilege escalation.
- Server Actions re-validate everything with Zod even though the client also validates — never trust client input.
- Service-role Supabase key never shipped to the browser; used only in trusted server contexts (Edge Functions, admin server actions) for operations RLS can't express.
- Rate limiting on review/comment/booking submission (e.g. Upstash Redis or Supabase-based throttling) to deter spam/abuse.
- Standard web hardening: CSP headers, sanitized rich text (article bodies, review text) before render to prevent stored XSS.

---

## 22. Migration/Build Order

1. **Foundation** — Next.js app scaffold, Supabase project, auth wiring, design system (Tailwind/shadcn), repository-layer pattern established.
2. **Location taxonomy** — `locations` table + `ltree`, seed Maldives → atolls → islands, location hub pages (read-only, minimal styling) to validate the hierarchy end-to-end.
3. **Category taxonomy** — `categories` table, seed core taxonomies (activity-type, hotel-type, audience).
4. **Core entities, one type at a time** — `nodes` + `hotels` first (smallest surface to prove the pattern), then `activities`/`fishing_trips`/`diving_sites`/`surf_spots`, then `resorts`, then `packages`, then `articles`. Each addition validates that the shared backbone (reviews/media/favorites/linking) needs zero changes — the proof the architecture works.
5. **Media** — upload flow + gallery components, applied first to hotels, then rolled out.
6. **Reviews & ratings** — generic system, applied uniformly.
7. **Favorites**.
8. **Comments** — article-scoped.
9. **Search & filters** — Postgres FTS + facet UI.
10. **Internal linking + SEO + structured data + sitemaps** — once enough real content exists to make this meaningful to test.
11. **Admin/CMS** — once the public schema/UX patterns are stable, build editor tooling against them (building admin too early means rebuilding it as the schema settles).
12. **Bookings (inquiry mode)**.
13. **Hardening pass** — RLS audit, rate limiting, structured-data validation, Lighthouse/SEO audit.

Each phase should be shippable/demoable before starting the next — no phase depends on speculative future schema.

---

## 23. Recommended Packages/Dependencies

| Purpose | Package |
|---|---|
| Framework | `next`, `react`, `react-dom`, `typescript` |
| Styling/UI | `tailwindcss`, `shadcn/ui` (Radix-based), `lucide-react`, `embla-carousel-react` |
| Backend/data | `@supabase/supabase-js`, `@supabase/ssr` |
| Validation | `zod` |
| Forms | `react-hook-form`, `@hookform/resolvers` |
| Dates | `date-fns` |
| SEO | custom `lib/seo` (no heavy package needed; `next-sitemap` optional convenience) |
| Rich text (articles) | `@tiptap/react` (editor, admin-side) rendering to sanitized HTML/portable text |
| Sanitization | `isomorphic-dompurify` (or `sanitize-html`) for any user/editor-submitted rich text |
| Rate limiting | `@upstash/ratelimit` + `@upstash/redis` |
| Email (booking/review notifications) | `resend` |
| Error monitoring | `@sentry/nextjs` |
| Testing | `vitest` / `@testing-library/react`, `playwright` for e2e |
| Type generation | Supabase CLI `gen types typescript` |

Deferred until needed (explicitly not added at foundation stage): dedicated search service client, Stripe, mapping library (added with PostGIS in phase 2+), CMS SDKs.

---

## 24. Scalability Considerations

- **Hierarchy queries scale via `ltree` + GIN indexes**, not recursive CTEs — this matters once there are hundreds of islands and thousands of entities.
- **Denormalized rating aggregates** avoid recomputing `AVG(rating)` on every page view.
- **ISR + on-demand revalidation** means most traffic hits Vercel's edge cache, not the database — the DB only serves writes and the revalidation trigger, not every page view.
- **Read-heavy workload** suits Supabase's connection pooler (PgBouncer/Supavisor) comfortably; revisit read replicas only if metrics show it's needed.
- **Search is swappable** (§12) without touching the schema or callers, so early Postgres FTS doesn't become a rewrite-everything decision later.
- **New entity types are additive** (§3.1) — the schema doesn't need to be re-architected as "Liveaboards" or "Spa & Wellness" or other categories get added; it's a new detail table + `node_type` enum value.
- **Image delivery** starts on Supabase Storage + Next.js `<Image>`; a CDN/image-transform layer (Cloudinary or Supabase's image transform) is a drop-in swap when traffic justifies the cost, not a foundation-day dependency.
- **Background/async work** (rating recompute, sitemap regen, email sends) uses triggers + Edge Functions/`pg_cron` now; graduates to a real queue (e.g. Inngest, or Supabase's upcoming queue primitives) only if job volume/latency requires it.

---

## Open questions / things I'd like your call on before implementation

1. **Booking model for v1**: confirm "inquiry/lead" bookings (no payments) is the right scope for launch, vs. wanting a payment-capable flow sooner.
2. **Content authoring**: are you (or a small team) entering content directly via the admin, or is there a bulk-import source (spreadsheet, existing data) we should design an import path for?
3. **Multi-language**: is English-only fine for launch, or should the schema reserve for i18n now (it's much cheaper to add `locale` columns before content exists than after)?
4. **Map/coordinates**: do you want PostGIS + interactive maps in phase 1, or is that safe to defer to phase 2 as scoped above?

---

**Nothing has been built yet** — no Supabase project, no database, no app pages. This document is for your review. On approval, implementation follows the phase order in §22, starting with foundation scaffolding + the location taxonomy.
