import "server-only";

import { getIslandsByAtollId, getLocationSummariesBySlugs } from "@/lib/locations/repository";
import type { LocationSummary } from "@/lib/locations/types";
import { getTransferRoutesByAtoll } from "@/lib/transfers/repository";

/**
 * "Nearby Islands" for an island detail page. Two real, verifiable
 * signals — never fabricated geographic coordinates, since none exist in
 * this project's data (confirmed: only Velana International Airport has
 * lat/lng, seeded specifically for transfer-distance display — see
 * supabase/migrations/20250114000100_velana_airport_coordinates.sql; no
 * island or atoll row has coordinates):
 *
 *   1. Editorial: content.nearbyIslandSlugs, a curated real list baked in
 *      at legacy-content-import time (scripts/import-legacy-island-content.mjs)
 *      — used as-is when present, since a human picked these deliberately.
 *   2. Computed fallback (only when no curated list exists): every other
 *      island in the same atoll — the one real geographic proxy available
 *      (Maldivian atolls are compact reef formations a few km to ~30km
 *      across, so "same atoll" is a genuinely reasonable nearby signal
 *      here, unlike in a large country) — ordered so islands with a real,
 *      verified transfer_routes connection to this island (a genuine
 *      practical-travel-relationship signal) sort first, then
 *      alphabetically. Never reaches into other atolls.
 *
 * This module (not locations/repository.ts) is the composition point
 * because it needs both locations/repository.ts AND
 * transfers/repository.ts, and transfers/repository.ts already imports
 * from locations/repository.ts — putting this here avoids a circular
 * import between the two.
 */
export async function getNearbyIslands(
  island: { id: string; parentId: string | null },
  curatedSlugs: string[],
  limit = 6,
): Promise<LocationSummary[]> {
  if (curatedSlugs.length > 0) {
    const bySlug = await getLocationSummariesBySlugs(curatedSlugs.slice(0, limit));
    const ordered = curatedSlugs.map((slug) => bySlug.get(slug)).filter((l): l is LocationSummary => Boolean(l));
    if (ordered.length > 0) return ordered.slice(0, limit);
  }

  if (!island.parentId) return [];

  const [siblingIslands, atollTransferRoutes] = await Promise.all([
    getIslandsByAtollId(island.parentId),
    getTransferRoutesByAtoll(island.parentId),
  ]);

  const others = siblingIslands.filter((sibling) => sibling.id !== island.id);
  if (others.length === 0) return [];

  const connectedIds = new Set<string>();
  for (const route of atollTransferRoutes) {
    if (route.origin?.id === island.id && route.destination) connectedIds.add(route.destination.id);
    if (route.destination?.id === island.id && route.origin) connectedIds.add(route.origin.id);
  }

  return [...others]
    .sort((a, b) => {
      const aConnected = connectedIds.has(a.id) ? 0 : 1;
      const bConnected = connectedIds.has(b.id) ? 0 : 1;
      if (aConnected !== bConnected) return aConnected - bConnected;
      return a.title.localeCompare(b.title);
    })
    .slice(0, limit);
}
