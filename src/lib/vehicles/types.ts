import type { MediaAsset } from "@/lib/media/types";

/**
 * A vehicle (car transfer fleet) is a `nodes` row (node_type = 'vehicle')
 * extended by the `vehicles` table — identical shape to speedboats. No
 * fleet has been entered yet (Task 20: no legacy or owner-supplied data
 * exists for the described 2x4-seater/2x6-seater/minibus/bus fleet at
 * build time), so this type/repository exist ready to receive real rows
 * without any UI changes once they're added.
 */

export type VehicleType = "car" | "minibus" | "bus";

export interface VehicleSummary {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  vehicleType: VehicleType;
  capacity: number;
  luggageCapacity: string | null;
  facilities: string[];
  heroImage: MediaAsset | null;
}
