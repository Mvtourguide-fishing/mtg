import "server-only";

import { ACCOMMODATION_TYPE_SEGMENT } from "@/lib/accommodations/types";
import { createClient } from "@/lib/supabase/public";

export interface EntityLinkTarget {
  /** The exact real-world name/phrase this entity is known by — matched
   * case-insensitively against article prose, but the ORIGINAL casing found
   * in the prose is always what gets linked (never rewritten to this). */
  phrase: string;
  href: string;
}

/**
 * A small, fixed set of the site's own vertical-hub labels (Task 23 §42's
 * own example map). These aren't rows in any one table — they're the
 * site's structural taxonomy, identical to what the header/footer already
 * hardcode — so a short literal list here is the correct, not the lazy,
 * choice; the DB-backed part below (atolls/islands/accommodations) is what
 * actually must never be hand-maintained.
 */
const HUB_PHRASES: EntityLinkTarget[] = [
  { phrase: "Maldives Resorts", href: "/maldives/resorts/" },
  { phrase: "Maldives Hotels", href: "/maldives/hotels/" },
  { phrase: "Maldives Guesthouses", href: "/maldives/guesthouses/" },
  { phrase: "Maldives Activities", href: "/maldives/activities/" },
  { phrase: "Maldives Fishing", href: "/maldives/fishing/" },
  { phrase: "Maldives Diving", href: "/maldives/diving/" },
  { phrase: "Maldives Surfing", href: "/maldives/surfing/" },
  { phrase: "Maldives Transfers", href: "/maldives/transfers/" },
  { phrase: "Maldives Packages", href: "/maldives/packages/" },
  { phrase: "Maldives Travel Guide", href: "/maldives/travel-guide/" },
  { phrase: "Maldives Atolls", href: "/maldives/atolls/" },
  { phrase: "Maldives Islands", href: "/maldives/islands/" },
];

interface NodeTitleRow {
  slug: string;
  title: string;
}

/**
 * The DB-generated part of the map (Task 23 §42: "Do NOT manually maintain
 * this list if the database can generate it") — every published atoll,
 * island, and accommodation, keyed by their own real title, never a second
 * hand-authored list. Two lean queries (no hero-media joins, no pagination
 * loop) — not the full getAtolls()/getIslands()/getAccommodations()
 * repository functions, which fetch more than a title+slug+href needs.
 */
export async function buildEntityLinkMap(): Promise<EntityLinkTarget[]> {
  const supabase = await createClient();

  const [locationsResult, accommodationsResult] = await Promise.all([
    supabase
      .from("nodes")
      .select("slug, title, locations!locations_id_fkey!inner(location_type)")
      .eq("node_type", "location")
      .eq("status", "published")
      .in("locations.location_type", ["atoll", "island"])
      .returns<Array<NodeTitleRow & { locations: { location_type: "atoll" | "island" } }>>(),
    supabase
      .from("nodes")
      .select("slug, title, accommodations!inner(accommodation_type)")
      .eq("node_type", "accommodation")
      .eq("status", "published")
      .returns<Array<NodeTitleRow & { accommodations: { accommodation_type: keyof typeof ACCOMMODATION_TYPE_SEGMENT } }>>(),
  ]);

  const entities: EntityLinkTarget[] = [...HUB_PHRASES];

  for (const row of locationsResult.data ?? []) {
    if (!row.title || !row.slug) continue;
    const segment = row.locations.location_type === "atoll" ? "atolls" : "islands";
    entities.push({ phrase: row.title, href: `/maldives/${segment}/${row.slug}/` });
  }

  for (const row of accommodationsResult.data ?? []) {
    if (!row.title || !row.slug) continue;
    const segment = ACCOMMODATION_TYPE_SEGMENT[row.accommodations.accommodation_type] ?? "hotels";
    entities.push({ phrase: row.title, href: `/maldives/${segment}/${row.slug}/` });
  }

  return entities;
}
