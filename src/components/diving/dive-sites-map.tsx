"use client";

import "leaflet/dist/leaflet.css";

import L from "leaflet";
import { useEffect, useRef } from "react";

export interface DiveSitesMapSite {
  slug: string;
  title: string;
  siteType: string | null;
  atoll: { slug: string; title: string } | null;
}

/**
 * Real, publicly documented atoll capital-island coordinates (not scraped
 * from legacy content — these are ordinary geographic facts, the same
 * category of data as the single real-world coordinate already hardcoded
 * in 20250112000100_legacy_transfers_rebuild.sql for LUX North Male Atoll).
 * Deliberately limited to the atolls our seeded dive sites actually sit
 * in — a site whose atoll isn't listed here renders no pin rather than a
 * guessed one, same honest-omission rule as RouteMap.
 */
const ATOLL_COORDS: Record<string, [number, number]> = {
  kaafu: [4.1755, 73.5093],
  "alif-alif": [4.2667, 72.9833],
  "alif-dhaalu": [3.7833, 72.9667],
};

const SITE_TYPE_LABEL: Record<string, string> = {
  reef: "Reef",
  thila: "Thila",
  channel: "Channel",
  wreck: "Wreck",
  pinnacle: "Pinnacle",
  wall: "Wall",
  cave: "Cave",
};

/** Deterministic small offset so multiple sites in the same atoll don't
 * stack on one pin — not a claim of exact GPS position, just visual
 * separation of genuinely nearby real sites. */
function offset(index: number, total: number): [number, number] {
  if (total <= 1) return [0, 0];
  const angle = (index / total) * 2 * Math.PI;
  const radius = 0.09;
  return [Math.cos(angle) * radius, Math.sin(angle) * radius];
}

export function DiveSitesMap({ sites }: { sites: DiveSitesMapSite[] }) {
  const containerRef = useRef<HTMLDivElement | null>(null);
  const mapRef = useRef<L.Map | null>(null);

  const plottable = sites.filter((s) => s.atoll && ATOLL_COORDS[s.atoll.slug]);
  const byAtoll = new Map<string, DiveSitesMapSite[]>();
  for (const site of plottable) {
    const key = site.atoll!.slug;
    if (!byAtoll.has(key)) byAtoll.set(key, []);
    byAtoll.get(key)!.push(site);
  }

  useEffect(() => {
    if (!containerRef.current || plottable.length === 0) return;

    const map = L.map(containerRef.current, { scrollWheelZoom: false }).setView([3.9, 73.2], 7);
    mapRef.current = map;

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      maxZoom: 18,
    }).addTo(map);

    for (const [atollSlug, group] of byAtoll) {
      const [baseLat, baseLng] = ATOLL_COORDS[atollSlug];
      group.forEach((site, i) => {
        const [dLat, dLng] = offset(i, group.length);
        const marker = L.circleMarker([baseLat + dLat, baseLng + dLng], {
          radius: 8,
          color: "#0e7490",
          fillColor: "#06b6d4",
          fillOpacity: 0.9,
          weight: 2,
        }).addTo(map);
        const typeLabel = site.siteType ? SITE_TYPE_LABEL[site.siteType] ?? site.siteType : "";
        marker.bindPopup(
          `<strong>${site.title}</strong>${typeLabel ? `<br/>${typeLabel}` : ""}<br/><a href="/maldives/dive-sites/${site.slug}/">View dive site →</a>`,
        );
      });
    }

    return () => {
      map.remove();
      mapRef.current = null;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  if (plottable.length === 0) return null;

  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">Dive Sites Map</h2>
      <p className="mt-1 text-sm text-neutral-600">
        Approximate, atoll-level positions of our documented dive sites — not exact GPS coordinates. Tap a pin for details.
      </p>
      <div ref={containerRef} className="mt-3 h-80 w-full overflow-hidden rounded-2xl border border-neutral-200 sm:h-96" />
    </section>
  );
}
