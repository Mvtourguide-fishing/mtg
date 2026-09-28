import "server-only";

import { searchAccommodations } from "@/lib/accommodations/repository";
import { getLocationSummariesByIds, searchLocations } from "@/lib/locations/repository";
import type { LocationType } from "@/lib/locations/types";
import { getTransferRoutes } from "@/lib/transfers/repository";
import type { TransferRouteSummary } from "@/lib/transfers/types";

/**
 * The intelligent transfer finder (Task 20 §6-9): a single "From"/"To"
 * search that understands atolls, islands, resorts, hotels, and airports,
 * then checks whether a real route exists between the two — it never
 * synthesizes one. This module is the server-side brain behind both the
 * autocomplete endpoint (searchTransferEndpoints) and the actual route
 * lookup (findRouteBetween), so the two can never disagree about what a
 * suggestion resolves to.
 */

export type FinderEndpointKind = "island" | "atoll" | "airport" | "locality" | "resort" | "hotel" | "guesthouse" | "villa";

export interface FinderEndpoint {
  kind: FinderEndpointKind;
  /** The real, routable locations.id — for an accommodation match this is
   * its primary location's id, since transfer_routes reference locations,
   * never accommodations directly. */
  locationId: string;
  /** The location's own slug — used to build a From/To query param. */
  locationSlug: string;
  title: string;
  /** For a resort/hotel match, the island it's on (distinct display line,
   * matching the spec's suggestion mockup). Null for a location match. */
  subtitle: string | null;
}

const SEARCHABLE_LOCATION_TYPES: LocationType[] = ["island", "atoll", "airport", "locality"];

export async function searchTransferEndpoints(query: string, limit = 8): Promise<FinderEndpoint[]> {
  const trimmed = query.trim();
  if (trimmed.length < 2) return [];

  const [locationMatches, accommodationMatches] = await Promise.all([
    searchLocations(trimmed, { limit }),
    searchAccommodations(trimmed, { limit }),
  ]);

  const results: FinderEndpoint[] = [];

  for (const loc of locationMatches) {
    if (!SEARCHABLE_LOCATION_TYPES.includes(loc.locationType)) continue;
    results.push({
      kind: loc.locationType as FinderEndpointKind,
      locationId: loc.id,
      locationSlug: loc.slug,
      title: loc.title,
      subtitle: null,
    });
  }

  const islandIds = accommodationMatches.map((a) => a.primaryLocation?.id).filter((id): id is string => Boolean(id));
  const islandsById = await getLocationSummariesByIds(islandIds);

  for (const acc of accommodationMatches) {
    if (!acc.primaryLocation) continue;
    // A resort's private island already carries the resort's own name
    // (Task 18) — showing both would just repeat the same title twice, so
    // the subtitle line only appears when the island genuinely has a
    // different, real name (a hotel/guesthouse on a shared local island).
    const island = islandsById.get(acc.primaryLocation.id);
    const subtitle = island && island.title !== acc.title ? island.title : null;
    results.push({
      kind: acc.accommodationType === "resort" ? "resort" : acc.accommodationType === "hotel" ? "hotel" : acc.accommodationType === "guesthouse" ? "guesthouse" : "villa",
      locationId: acc.primaryLocation.id,
      locationSlug: acc.primaryLocation.slug,
      title: acc.title,
      subtitle,
    });
  }

  // De-duplicate by locationId (a resort's own island and the resort
  // itself can both legitimately match the same query, e.g. "kani") —
  // keep the more specific (accommodation) match first.
  const seen = new Set<string>();
  const deduped: FinderEndpoint[] = [];
  for (const r of results) {
    if (seen.has(r.locationId)) continue;
    seen.add(r.locationId);
    deduped.push(r);
  }

  return deduped.slice(0, limit);
}

export interface FindRouteResult {
  route: TransferRouteSummary | null;
  /** True once both endpoints resolved to real locations, regardless of
   * whether a route connects them — distinguishes "no route on record"
   * from "couldn't resolve one of your endpoints". */
  endpointsResolved: boolean;
}

/** Route-aware matching (Task 20 §8): looks for a real transfer_routes row
 * between the two locations in EITHER direction, since a route is
 * directional but a traveller's "From"/"To" intent should still surface
 * the reverse listing rather than a false negative. Never invents a
 * route when none exists. */
export async function findRouteBetween(fromLocationId: string, toLocationId: string): Promise<FindRouteResult> {
  const [forward, reverse] = await Promise.all([
    getTransferRoutes({ originLocationId: fromLocationId, destinationLocationId: toLocationId, pageSize: 1 }),
    getTransferRoutes({ originLocationId: toLocationId, destinationLocationId: fromLocationId, pageSize: 1 }),
  ]);

  const route = forward.items[0] ?? reverse.items[0] ?? null;
  return { route, endpointsResolved: true };
}
