import "server-only";

import { createClient } from "@/lib/supabase/server";
import type { BookingStatus } from "@/lib/admin/booking-status";

/**
 * Admin-only booking reads. Governed by the existing `bookings_staff_read`
 * RLS policy (supabase/migrations/20250101001400_rls_policies.sql) — this
 * file adds no new access path, it just queries the same table an
 * authorized staff session can already read.
 *
 * Product titles are resolved via separate batched lookups rather than a
 * single embedded `.select()`, deliberately: `bookings` has two distinct
 * product FKs (product_node_id -> bookable_products, transfer_service_id
 * -> transfer_services) and two distinct location FKs (origin/destination
 * -> locations), and the project has hit real PostgREST relationship-
 * ambiguity bugs before from embedding a table reachable more than one way
 * (see src/lib/locations/repository.ts's `locations!locations_id_fkey`
 * comment). Plain `.in("id", [...])` batch lookups sidestep that class of
 * bug entirely, at the cost of a couple of extra small queries — a fine
 * trade on a paginated admin list, not a hot path.
 */

const PAGE_SIZE = 25;

export interface AdminBookingListItem {
  id: string;
  bookingReference: string;
  productType: "node" | "transfer_service";
  productTitle: string;
  customerName: string;
  customerEmail: string;
  status: BookingStatus;
  source: string | null;
  travelDate: string | null;
  adults: number;
  children: number;
  createdAt: string;
}

export interface AdminBookingFilters {
  search?: string;
  status?: BookingStatus;
  productType?: "node" | "transfer_service";
  dateFrom?: string;
  dateTo?: string;
  page?: number;
}

export interface AdminBookingListResult {
  items: AdminBookingListItem[];
  total: number;
  page: number;
  pageSize: number;
}

export interface AdminBookingDetail extends AdminBookingListItem {
  customerPhone: string | null;
  customerWhatsapp: string | null;
  originTitle: string | null;
  destinationTitle: string | null;
  travelTime: string | null;
  returnDate: string | null;
  returnTime: string | null;
  tripType: string | null;
  infants: number;
  flightNumber: string | null;
  specialRequests: string | null;
  estimatedPrice: number | null;
  quotedPrice: number | null;
  currency: string;
  internalNotes: string | null;
  notificationStatus: string;
  updatedAt: string;
}

interface BookingRow {
  id: string;
  booking_reference: string;
  product_type: "node" | "transfer_service";
  product_node_id: string | null;
  transfer_service_id: string | null;
  customer_name: string;
  customer_email: string;
  customer_phone: string | null;
  customer_whatsapp: string | null;
  origin_location_id: string | null;
  destination_location_id: string | null;
  travel_date: string | null;
  travel_time: string | null;
  return_date: string | null;
  return_time: string | null;
  trip_type: string | null;
  adults: number;
  children: number;
  infants: number;
  flight_number: string | null;
  special_requests: string | null;
  estimated_price: number | null;
  quoted_price: number | null;
  currency: string;
  internal_notes: string | null;
  status: BookingStatus;
  source: string | null;
  notification_status: string;
  created_at: string;
  updated_at: string;
}

type AdminSupabaseClient = Awaited<ReturnType<typeof createClient>>;

async function resolveProductTitles(supabase: AdminSupabaseClient, rows: BookingRow[]): Promise<Map<string, string>> {
  const titles = new Map<string, string>();

  const nodeIds = [...new Set(rows.filter((r) => r.product_type === "node" && r.product_node_id).map((r) => r.product_node_id as string))];
  const serviceIds = [
    ...new Set(rows.filter((r) => r.product_type === "transfer_service" && r.transfer_service_id).map((r) => r.transfer_service_id as string)),
  ];

  if (nodeIds.length > 0) {
    const { data } = await supabase.from("nodes").select("id, title").in("id", nodeIds).returns<Array<{ id: string; title: string }>>();
    for (const n of data ?? []) titles.set(`node:${n.id}`, n.title);
  }

  if (serviceIds.length > 0) {
    const { data: services } = await supabase
      .from("transfer_services")
      .select("id, transfer_type, route_id")
      .in("id", serviceIds)
      .returns<Array<{ id: string; transfer_type: string; route_id: string }>>();

    const routeIds = [...new Set((services ?? []).map((s) => s.route_id))];
    const { data: routeNodes } =
      routeIds.length > 0
        ? await supabase.from("nodes").select("id, title").in("id", routeIds).returns<Array<{ id: string; title: string }>>()
        : { data: [] as Array<{ id: string; title: string }> };
    const routeTitleById = new Map((routeNodes ?? []).map((n) => [n.id, n.title]));

    for (const s of services ?? []) {
      const routeTitle = routeTitleById.get(s.route_id) ?? "Transfer route";
      titles.set(`service:${s.id}`, `${routeTitle} (${s.transfer_type.replace(/_/g, " ")})`);
    }
  }

  return titles;
}

async function resolveLocationTitles(supabase: AdminSupabaseClient, locationIds: string[]): Promise<Map<string, string>> {
  const titles = new Map<string, string>();
  if (locationIds.length === 0) return titles;
  const { data } = await supabase.from("nodes").select("id, title").in("id", locationIds).returns<Array<{ id: string; title: string }>>();
  for (const n of data ?? []) titles.set(n.id, n.title);
  return titles;
}

function toListItem(row: BookingRow, titles: Map<string, string>): AdminBookingListItem {
  const key = row.product_type === "node" ? `node:${row.product_node_id}` : `service:${row.transfer_service_id}`;
  return {
    id: row.id,
    bookingReference: row.booking_reference,
    productType: row.product_type,
    productTitle: titles.get(key) ?? "(product not found)",
    customerName: row.customer_name,
    customerEmail: row.customer_email,
    status: row.status,
    source: row.source,
    travelDate: row.travel_date,
    adults: row.adults,
    children: row.children,
    createdAt: row.created_at,
  };
}

export async function getBookingsAdmin(filters: AdminBookingFilters = {}): Promise<AdminBookingListResult> {
  const page = Math.max(1, filters.page ?? 1);
  const from = (page - 1) * PAGE_SIZE;
  const to = from + PAGE_SIZE - 1;

  const supabase = await createClient();
  let query = supabase.from("bookings").select("*", { count: "exact" }).order("created_at", { ascending: false });

  if (filters.status) query = query.eq("status", filters.status);
  if (filters.productType) query = query.eq("product_type", filters.productType);
  if (filters.dateFrom) query = query.gte("travel_date", filters.dateFrom);
  if (filters.dateTo) query = query.lte("travel_date", filters.dateTo);
  if (filters.search?.trim()) {
    const term = filters.search.trim();
    query = query.or(`booking_reference.ilike.%${term}%,customer_name.ilike.%${term}%,customer_email.ilike.%${term}%`);
  }

  const { data, error, count } = await query.range(from, to).returns<BookingRow[]>();
  if (error || !data) return { items: [], total: 0, page, pageSize: PAGE_SIZE };

  const titles = await resolveProductTitles(supabase, data);
  return { items: data.map((row) => toListItem(row, titles)), total: count ?? data.length, page, pageSize: PAGE_SIZE };
}

export async function getBookingByIdAdmin(id: string): Promise<AdminBookingDetail | null> {
  const supabase = await createClient();
  const { data: row, error } = await supabase.from("bookings").select("*").eq("id", id).maybeSingle<BookingRow>();
  if (error || !row) return null;

  const [titles, locationTitles] = await Promise.all([
    resolveProductTitles(supabase, [row]),
    resolveLocationTitles(supabase, [row.origin_location_id, row.destination_location_id].filter((v): v is string => Boolean(v))),
  ]);

  return {
    ...toListItem(row, titles),
    customerPhone: row.customer_phone,
    customerWhatsapp: row.customer_whatsapp,
    originTitle: row.origin_location_id ? (locationTitles.get(row.origin_location_id) ?? null) : null,
    destinationTitle: row.destination_location_id ? (locationTitles.get(row.destination_location_id) ?? null) : null,
    travelTime: row.travel_time,
    returnDate: row.return_date,
    returnTime: row.return_time,
    tripType: row.trip_type,
    infants: row.infants,
    flightNumber: row.flight_number,
    specialRequests: row.special_requests,
    estimatedPrice: row.estimated_price,
    quotedPrice: row.quoted_price,
    currency: row.currency,
    internalNotes: row.internal_notes,
    notificationStatus: row.notification_status,
    updatedAt: row.updated_at,
  };
}
