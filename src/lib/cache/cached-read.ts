import "server-only";

import { unstable_cache } from "next/cache";

/**
 * Wraps a public, read-only Supabase data-access function (nothing that
 * touches `auth.*` or a signed-in user's own rows) in Next's time-based
 * Data Cache.
 *
 * Why this exists: the catalog/directory pages (fishing, diving, activities,
 * packages, ...) had zero caching anywhere — every single page view,
 * including every search-engine crawler request against the many
 * filter/query-param combinations those pages support, re-ran the full set
 * of Supabase queries from scratch. That query volume, multiplied across a
 * few hours of traffic, was exhausting the Supabase project's daily Burst
 * Disk I/O allowance (see the Supabase support message this fix responds
 * to), which is exactly why pages "worked fine at first, then stopped
 * loading after a few hours."
 *
 * This content changes rarely (an admin edit, not per-visitor), so serving
 * it up to `revalidateSeconds` stale is the right trade: it collapses
 * repeat/bot traffic against the same query into a single Supabase round
 * trip per cache window instead of one per request.
 *
 * Only wrap functions that are pure w.r.t. their arguments — no cookies(),
 * no per-user RLS context — which is already true of everything using
 * `@/lib/supabase/public`'s stateless client.
 */
export function cachedRead<Args extends unknown[], Result>(
  fn: (...args: Args) => Promise<Result>,
  keyParts: string[],
  revalidateSeconds = 300,
): (...args: Args) => Promise<Result> {
  return unstable_cache(fn, keyParts, { revalidate: revalidateSeconds });
}
