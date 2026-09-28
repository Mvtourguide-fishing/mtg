import "server-only";

import { BOOKING_STATUSES, type BookingStatus } from "@/lib/admin/booking-status";
import { createClient } from "@/lib/supabase/server";

/**
 * Real counts only — every number here is a live `count: "exact", head:
 * true` query against a table that actually exists, run as the signed-in
 * staff user (so it's governed by the same `*_staff_read`/`*_staff_all`
 * RLS policies as everything else, not a service-role bypass). No
 * revenue/traffic/conversion figures are computed anywhere in this file —
 * this app has no analytics/payment data to compute them from, and the
 * spec is explicit: don't invent statistics.
 */

export { BOOKING_STATUSES };
export type { BookingStatus };

export interface DashboardStats {
  bookingsByStatus: Record<BookingStatus, number>;
  bookingsTotal: number;
  accommodations: number;
  activitiesTotal: number;
  activitiesFishing: number;
  activitiesDiving: number;
  activitiesSurfing: number;
  transferRoutes: number;
  packages: number;
  articles: number;
  providers: number;
  atolls: number;
  islands: number;
  media: number;
  reviewsPending: number;
  reviewsTotal: number;
  commentsTotal: number;
  commentsFlagged: number;
  redirects: number;
}

type SupabaseServerClient = Awaited<ReturnType<typeof createClient>>;

async function countRows(supabase: SupabaseServerClient, table: string, filters: Record<string, string> = {}): Promise<number> {
  // Same placeholder-Database-types workaround as everywhere else in this
  // codebase (src/lib/bookings/notifications.ts, src/lib/bookings/
  // actions.ts) — src/types/database.ts has no real Tables map yet.
  let query = (supabase.from as (table: string) => ReturnType<typeof supabase.from>)(table).select("id", { count: "exact", head: true });
  for (const [column, value] of Object.entries(filters)) {
    query = query.eq(column, value);
  }
  const { count, error } = await query;
  if (error) {
    console.error(`[admin dashboard] count(${table}${Object.keys(filters).length ? `, ${JSON.stringify(filters)}` : ""}) failed:`, error.message);
    return 0;
  }
  return count ?? 0;
}

export async function getDashboardStats(): Promise<DashboardStats> {
  const supabase = await createClient();

  const [
    bookingCounts,
    accommodations,
    activitiesTotal,
    activitiesFishing,
    activitiesDiving,
    activitiesSurfing,
    transferRoutes,
    packages,
    articles,
    providers,
    atolls,
    islands,
    media,
    reviewsPending,
    reviewsTotal,
    commentsTotal,
    commentsFlagged,
    redirects,
  ] = await Promise.all([
    Promise.all(BOOKING_STATUSES.map((status) => countRows(supabase, "bookings", { status }))),
    countRows(supabase, "accommodations"),
    countRows(supabase, "activities"),
    countRows(supabase, "activities", { activity_category: "fishing" }),
    countRows(supabase, "activities", { activity_category: "diving" }),
    countRows(supabase, "activities", { activity_category: "surfing" }),
    countRows(supabase, "transfer_routes"),
    countRows(supabase, "packages"),
    countRows(supabase, "articles"),
    countRows(supabase, "providers"),
    countRows(supabase, "locations", { location_type: "atoll" }),
    countRows(supabase, "locations", { location_type: "island" }),
    countRows(supabase, "media_assets"),
    countRows(supabase, "reviews", { status: "pending" }),
    countRows(supabase, "reviews"),
    countRows(supabase, "article_comments"),
    countRows(supabase, "article_comments", { status: "flagged" }),
    countRows(supabase, "url_redirects"),
  ]);

  const bookingsByStatus = Object.fromEntries(BOOKING_STATUSES.map((status, i) => [status, bookingCounts[i]])) as Record<
    BookingStatus,
    number
  >;

  return {
    bookingsByStatus,
    bookingsTotal: bookingCounts.reduce((sum, n) => sum + n, 0),
    accommodations,
    activitiesTotal,
    activitiesFishing,
    activitiesDiving,
    activitiesSurfing,
    transferRoutes,
    packages,
    articles,
    providers,
    atolls,
    islands,
    media,
    reviewsPending,
    reviewsTotal,
    commentsTotal,
    commentsFlagged,
    redirects,
  };
}
