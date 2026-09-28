import "server-only";

import { getHeroMediaByNodeIds } from "@/lib/media/repository";
import { cachedRead } from "@/lib/cache/cached-read";
import { createClient } from "@/lib/supabase/public";
import type { VehicleSummary, VehicleType } from "@/lib/vehicles/types";

const NODE_VEHICLE_SELECT =
  "id, slug, title, summary, vehicles!inner(vehicle_type, capacity, luggage_capacity, facilities)";

type VehicleFields = {
  vehicle_type: VehicleType;
  capacity: number;
  luggage_capacity: string | null;
  facilities: string[];
};

type NodeVehicleRow = {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  vehicles: VehicleFields | VehicleFields[] | null;
};

/** Returns [] until real fleet data exists — see this module's header
 * comment. The page that renders this list already handles an empty
 * result with an honest "fleet details coming soon" state rather than a
 * broken layout. */
async function getVehiclesUncached(): Promise<VehicleSummary[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_VEHICLE_SELECT)
    .eq("node_type", "vehicle")
    .eq("status", "published")
    .order("title", { ascending: true })
    .returns<NodeVehicleRow[]>();

  if (error || !data || data.length === 0) return [];

  const heroByNodeId = await getHeroMediaByNodeIds(data.map((r) => r.id));
  return data
    .map((row): VehicleSummary | null => {
      const v = Array.isArray(row.vehicles) ? row.vehicles[0] : row.vehicles;
      if (!v) return null;
      return {
        id: row.id,
        slug: row.slug,
        title: row.title,
        summary: row.summary,
        vehicleType: v.vehicle_type,
        capacity: v.capacity,
        luggageCapacity: v.luggage_capacity,
        facilities: v.facilities ?? [],
        heroImage: heroByNodeId.get(row.id) ?? null,
      };
    })
    .filter((v): v is VehicleSummary => v !== null);
}

export const getVehicles = cachedRead(getVehiclesUncached, ["vehicles"]);

