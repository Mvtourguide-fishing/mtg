import "server-only";

import { publicStorageUrl } from "@/lib/media/types";
import type { MediaAsset, MediaRole, NodeMediaItem } from "@/lib/media/types";
import { createClient } from "@/lib/supabase/public";

/**
 * Server-side media data-access layer (Task 14). `media_assets` +
 * `node_media` are part of the Task 2/3 foundation schema
 * (supabase/migrations/20250101000200_media_assets.sql,
 * .../20250101000900_community.sql) but were never read from anywhere in
 * the app until this task — every image on the site up to Task 13 was
 * either absent or a hardcoded placeholder.
 *
 * node_media -> media_assets is a single, unambiguous FK path (no second
 * route between the two tables the way nodes <-> categories or nodes <->
 * locations have), so no `!inner`/named-relationship embed ambiguity
 * applies here. This still resolves it as two plain batched queries
 * (node_media, then media_assets) rather than an embed, matching every
 * other attach-* helper in this codebase (see attachDestinations in
 * src/lib/packages/repository.ts) — consistency, not a workaround.
 */

type MediaAssetRow = {
  id: string;
  media_type: "image" | "youtube";
  storage_path: string | null;
  youtube_id: string | null;
  alt_text: string | null;
  credit: string | null;
  width: number | null;
  height: number | null;
};

function mediaAssetOf(row: MediaAssetRow): MediaAsset {
  return {
    id: row.id,
    mediaType: row.media_type,
    storagePath: row.storage_path,
    youtubeId: row.youtube_id,
    altText: row.alt_text,
    credit: row.credit,
    width: row.width,
    height: row.height,
  };
}

/** Direct media_assets lookup by id — for the rare case (ferry_routes'
 * hero_media_id) where a non-node table references media_assets straight,
 * without going through node_media. */
export async function getMediaAssetsByIds(ids: string[]): Promise<Map<string, MediaAsset>> {
  const map = new Map<string, MediaAsset>();
  if (ids.length === 0) return map;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("media_assets")
    .select("id, media_type, storage_path, youtube_id, alt_text, credit, width, height")
    .in("id", ids)
    .returns<MediaAssetRow[]>();

  if (error || !data) return map;
  for (const row of data) map.set(row.id, mediaAssetOf(row));
  return map;
}

/** Batch-resolve the single hero image for each of `nodeIds` — the
 * lowest-sort_order 'hero' row per node. For card grids/listing pages;
 * use getMediaForNode for a single detail page's full gallery. */
export async function getHeroMediaByNodeIds(nodeIds: string[]): Promise<Map<string, MediaAsset>> {
  const result = new Map<string, MediaAsset>();
  if (nodeIds.length === 0) return result;

  const supabase = await createClient();
  const { data, error } = await supabase
    .from("node_media")
    .select("node_id, media_id, sort_order")
    .in("node_id", nodeIds)
    .eq("role", "hero")
    .order("sort_order", { ascending: true })
    .returns<Array<{ node_id: string; media_id: string; sort_order: number }>>();

  if (error || !data || data.length === 0) return result;

  // Rows already arrive sorted by sort_order — keep the first (lowest)
  // one seen per node rather than issuing a second round trip.
  const heroMediaIdByNode = new Map<string, string>();
  for (const row of data) {
    if (!heroMediaIdByNode.has(row.node_id)) heroMediaIdByNode.set(row.node_id, row.media_id);
  }

  const assetsById = await getMediaAssetsByIds(Array.from(new Set(heroMediaIdByNode.values())));
  for (const [nodeId, mediaId] of heroMediaIdByNode) {
    const asset = assetsById.get(mediaId);
    if (asset) result.set(nodeId, asset);
  }
  return result;
}

/** Every media item attached to one node, in role then sort_order order —
 * for a detail page's full gallery/hero/map images. */
export async function getMediaForNode(nodeId: string): Promise<NodeMediaItem[]> {
  const supabase = await createClient();
  const { data, error } = await supabase
    .from("node_media")
    .select("media_id, role, sort_order")
    .eq("node_id", nodeId)
    .order("role", { ascending: true })
    .order("sort_order", { ascending: true })
    .returns<Array<{ media_id: string; role: MediaRole; sort_order: number }>>();

  if (error || !data || data.length === 0) return [];

  const assetsById = await getMediaAssetsByIds(data.map((row) => row.media_id));
  return data
    .map((row): NodeMediaItem | null => {
      const asset = assetsById.get(row.media_id);
      return asset ? { role: row.role, sortOrder: row.sort_order, asset } : null;
    })
    .filter((item): item is NodeMediaItem => item !== null);
}

/**
 * Rewrites every `<figure><img src="...">...</figure>` in an article body
 * to use a real public Storage URL in place of the bare storage_path the
 * migration wrote (see scripts/import-legacy-articles.mjs's renderHtml —
 * every image block it emits already references a real uploaded file, so
 * this is a pure lookup/rewrite, never a fresh match). If no URL can be
 * built (Storage not configured), the whole figure is dropped rather than
 * left as a broken image reference.
 */
export function resolveStorageImageSrcs(html: string): string {
  return html.replace(/<figure><img\b[^>]*\bsrc="([^"]*)"[^>]*\/?>\s*<\/figure>/g, (full, storagePath: string) => {
    const url = publicStorageUrl(storagePath);
    if (!url) return "";
    return full.replace(`src="${storagePath}"`, `src="${url}"`);
  });
}
