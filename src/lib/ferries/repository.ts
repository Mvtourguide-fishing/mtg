import "server-only";

import { getLocationSummariesByIds } from "@/lib/locations/repository";
import { getMediaAssetsByIds } from "@/lib/media/repository";
import { createClient } from "@/lib/supabase/public";
import type { FerryRoute, FerryStop } from "@/lib/ferries/types";

type FerryRouteRow = {
  id: string;
  route_number: string;
  variant_label: string | null;
  title: string;
  province: string;
  operating_days: string;
  origin_location_id: string | null;
  destination_location_id: string | null;
  stops: FerryStop[];
  notes: string | null;
  hero_media_id: string | null;
  source_legacy_url: string | null;
  sort_order: number;
};

export async function getFerryRoutes(): Promise<FerryRoute[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("ferry_routes")
    .select("id, route_number, variant_label, title, province, operating_days, origin_location_id, destination_location_id, stops, notes, hero_media_id, source_legacy_url, sort_order")
    .eq("active", true)
    .order("sort_order", { ascending: true })
    .returns<FerryRouteRow[]>();

  if (error || !data) return [];

  const locationIds = Array.from(
    new Set(data.flatMap((r) => [r.origin_location_id, r.destination_location_id]).filter((id): id is string => Boolean(id))),
  );
  const mediaIds = Array.from(new Set(data.map((r) => r.hero_media_id).filter((id): id is string => Boolean(id))));
  const [locationsById, mediaById] = await Promise.all([getLocationSummariesByIds(locationIds), getMediaAssetsByIds(mediaIds)]);

  return data.map((row) => ({
    id: row.id,
    routeNumber: row.route_number,
    variantLabel: row.variant_label,
    title: row.title,
    province: row.province,
    operatingDays: row.operating_days,
    origin: row.origin_location_id ? locationsById.get(row.origin_location_id) ?? null : null,
    destination: row.destination_location_id ? locationsById.get(row.destination_location_id) ?? null : null,
    stops: row.stops ?? [],
    notes: row.notes,
    sourceLegacyUrl: row.source_legacy_url,
    heroImage: row.hero_media_id ? mediaById.get(row.hero_media_id) ?? null : null,
  }));
}
