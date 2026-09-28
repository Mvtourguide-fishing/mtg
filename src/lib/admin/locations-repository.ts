import "server-only";

import { createClient } from "@/lib/supabase/server";
import type { NodeStatus } from "@/lib/admin/node-actions";

/**
 * Admin-only location reads (all statuses). Uses the explicit
 * `locations!locations_id_fkey!inner(...)` embed name established in
 * src/lib/locations/repository.ts — `nodes` reaches `locations` both
 * directly (this FK) and indirectly via `node_locations`, and the project
 * has hit real PostgREST ambiguity errors from omitting the explicit name
 * in exactly this situation.
 */

const PAGE_SIZE = 40;

const NODE_LOCATION_SELECT =
  "id, slug, title, summary, status, meta_title, meta_description, locations!locations_id_fkey!inner(location_type, parent_id, lat, lng, is_inhabited, administrative_code)";

interface NodeLocationRow {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  status: NodeStatus;
  meta_title: string | null;
  meta_description: string | null;
  locations:
    | LocationFields
    | LocationFields[]
    | null;
}

interface LocationFields {
  location_type: string;
  parent_id: string | null;
  lat: number | null;
  lng: number | null;
  is_inhabited: boolean | null;
  administrative_code: string | null;
}

export interface AdminLocationItem {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  status: NodeStatus;
  metaTitle: string | null;
  metaDescription: string | null;
  locationType: string;
  parentId: string | null;
  parentTitle: string | null;
  lat: number | null;
  lng: number | null;
  isInhabited: boolean | null;
  administrativeCode: string | null;
}

function toAdminLocation(row: NodeLocationRow): (AdminLocationItem & { _fields: LocationFields }) | null {
  const l = Array.isArray(row.locations) ? row.locations[0] : row.locations;
  if (!l) return null;
  return {
    id: row.id,
    slug: row.slug,
    title: row.title,
    summary: row.summary,
    status: row.status,
    metaTitle: row.meta_title,
    metaDescription: row.meta_description,
    locationType: l.location_type,
    parentId: l.parent_id,
    parentTitle: null,
    lat: l.lat,
    lng: l.lng,
    isInhabited: l.is_inhabited,
    administrativeCode: l.administrative_code,
    _fields: l,
  };
}

export interface AdminLocationListResult {
  items: AdminLocationItem[];
  total: number;
  page: number;
  pageSize: number;
}

export async function getLocationsAdmin(options: { search?: string; locationType?: string; page?: number } = {}): Promise<AdminLocationListResult> {
  const page = Math.max(1, options.page ?? 1);
  const from = (page - 1) * PAGE_SIZE;
  const to = from + PAGE_SIZE - 1;

  const supabase = await createClient();
  let query = supabase.from("nodes").select(NODE_LOCATION_SELECT, { count: "exact" }).eq("node_type", "location").order("title", { ascending: true });
  if (options.search?.trim()) query = query.ilike("title", `%${options.search.trim()}%`);
  if (options.locationType) query = query.eq("locations.location_type", options.locationType);

  const { data, error, count } = await query.range(from, to).returns<NodeLocationRow[]>();
  if (error || !data) return { items: [], total: 0, page, pageSize: PAGE_SIZE };

  const items = data.map(toAdminLocation).filter((l): l is NonNullable<typeof l> => l !== null);

  const parentIds = [...new Set(items.filter((l) => l.parentId).map((l) => l.parentId as string))];
  const { data: parents } = parentIds.length
    ? await supabase.from("nodes").select("id, title").in("id", parentIds).returns<Array<{ id: string; title: string }>>()
    : { data: [] as Array<{ id: string; title: string }> };
  const parentTitleById = new Map((parents ?? []).map((n) => [n.id, n.title]));

  const resolved: AdminLocationItem[] = items.map((item) => ({
    id: item.id,
    slug: item.slug,
    title: item.title,
    summary: item.summary,
    status: item.status,
    metaTitle: item.metaTitle,
    metaDescription: item.metaDescription,
    locationType: item.locationType,
    parentId: item.parentId,
    parentTitle: item.parentId ? (parentTitleById.get(item.parentId) ?? null) : null,
    lat: item.lat,
    lng: item.lng,
    isInhabited: item.isInhabited,
    administrativeCode: item.administrativeCode,
  }));

  return { items: resolved, total: count ?? resolved.length, page, pageSize: PAGE_SIZE };
}

export async function getLocationByIdAdmin(id: string): Promise<AdminLocationItem | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_LOCATION_SELECT)
    .eq("node_type", "location")
    .eq("id", id)
    .maybeSingle<NodeLocationRow>();
  if (error || !data) return null;

  const item = toAdminLocation(data);
  if (!item) return null;

  if (item.parentId) {
    const { data: parent } = await supabase.from("nodes").select("title").eq("id", item.parentId).maybeSingle<{ title: string }>();
    item.parentTitle = parent?.title ?? null;
  }
  return item;
}
