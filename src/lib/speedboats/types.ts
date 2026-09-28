import type { MediaAsset } from "@/lib/media/types";

/**
 * A speedboat is a `nodes` row (node_type = 'speedboat') extended by the
 * `speedboats` table — same shape as accommodations/activities. There is
 * deliberately no price field anywhere in this type: charter pricing is
 * never public on this platform (Task 20 §14), only an inquiry flow.
 */

export interface SpeedboatSummary {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  capacity: number;
  lengthFeet: number | null;
  engineCount: number | null;
  horsepower: number | null;
  topSpeedKnots: number | null;
  facilities: string[];
  charterOptions: string[];
  heroImage: MediaAsset | null;
}

export interface SpeedboatDetail extends SpeedboatSummary {
  metaTitle: string | null;
  metaDescription: string | null;
  gallery: MediaAsset[];
  isBookable: boolean;
}
