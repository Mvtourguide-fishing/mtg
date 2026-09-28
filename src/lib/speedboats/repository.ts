import "server-only";

import { getHeroMediaByNodeIds, getMediaForNode } from "@/lib/media/repository";
import { cachedRead } from "@/lib/cache/cached-read";
import { createClient } from "@/lib/supabase/public";
import type { SpeedboatDetail, SpeedboatSummary } from "@/lib/speedboats/types";

/**
 * Server-side speedboat data-access layer (Task 20). Same pattern as
 * every other type-extension repository: pages call these functions,
 * never Supabase directly.
 */

const NODE_SPEEDBOAT_SELECT =
  "id, slug, title, summary, meta_title, meta_description, speedboats!inner(capacity, length_feet, engine_count, horsepower, top_speed_knots, facilities, charter_options)";

type SpeedboatFields = {
  capacity: number;
  length_feet: number | null;
  engine_count: number | null;
  horsepower: number | null;
  top_speed_knots: number | null;
  facilities: string[];
  charter_options: string[];
};

type NodeSpeedboatRow = {
  id: string;
  slug: string;
  title: string;
  summary: string | null;
  meta_title: string | null;
  meta_description: string | null;
  speedboats: SpeedboatFields | SpeedboatFields[] | null;
};

function summaryOf(row: NodeSpeedboatRow, heroImage: import("@/lib/media/types").MediaAsset | null): SpeedboatSummary | null {
  const b = Array.isArray(row.speedboats) ? row.speedboats[0] : row.speedboats;
  if (!b) return null;
  return {
    id: row.id,
    slug: row.slug,
    title: row.title,
    summary: row.summary,
    capacity: b.capacity,
    lengthFeet: b.length_feet,
    engineCount: b.engine_count,
    horsepower: b.horsepower,
    topSpeedKnots: b.top_speed_knots,
    facilities: b.facilities ?? [],
    charterOptions: b.charter_options ?? [],
    heroImage,
  };
}

async function getSpeedboatsUncached(): Promise<SpeedboatSummary[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_SPEEDBOAT_SELECT)
    .eq("node_type", "speedboat")
    .eq("status", "published")
    .order("title", { ascending: true })
    .returns<NodeSpeedboatRow[]>();

  if (error || !data) return [];

  const heroByNodeId = await getHeroMediaByNodeIds(data.map((r) => r.id));
  return data
    .map((row) => summaryOf(row, heroByNodeId.get(row.id) ?? null))
    .filter((s): s is SpeedboatSummary => s !== null);
}

export const getSpeedboats = cachedRead(getSpeedboatsUncached, ["speedboats"]);

export async function getSpeedboatBySlug(slug: string): Promise<SpeedboatDetail | null> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("nodes")
    .select(NODE_SPEEDBOAT_SELECT)
    .eq("node_type", "speedboat")
    .eq("status", "published")
    .eq("slug", slug)
    .maybeSingle<NodeSpeedboatRow>();

  if (error || !data) return null;

  const [gallery, bookableRow] = await Promise.all([
    getMediaForNode(data.id),
    supabase.from("bookable_products").select("id").eq("id", data.id).maybeSingle(),
  ]);
  const hero = gallery.find((m) => m.role === "hero")?.asset ?? null;
  const summary = summaryOf(data, hero);
  if (!summary) return null;

  return {
    ...summary,
    metaTitle: data.meta_title,
    metaDescription: data.meta_description,
    gallery: gallery.filter((m) => m.role === "gallery").map((m) => m.asset),
    isBookable: Boolean(bookableRow.data),
  };
}
