"use client";

import { useEffect, useRef } from "react";
import type { Map as LeafletMap, Marker } from "leaflet";
import "leaflet/dist/leaflet.css";

interface LocationMapProps {
  title: string;
  lat: number | null;
  lng: number | null;
  className?: string;
}

export function LocationMap({ title, lat, lng, className = "" }: LocationMapProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const mapRef = useRef<LeafletMap | null>(null);
  const markerRef = useRef<Marker | null>(null);

  useEffect(() => {
    if (!containerRef.current || lat === null || lng === null || mapRef.current) return;

    let cancelled = false;
    void import("leaflet").then(({ default: L }) => {
      if (cancelled || !containerRef.current || mapRef.current) return;
      const map = L.map(containerRef.current, { scrollWheelZoom: false, attributionControl: true }).setView([lat, lng], 11);
      L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        maxZoom: 19,
      }).addTo(map);
      markerRef.current = L.marker([lat, lng]).addTo(map).bindPopup(title);
      mapRef.current = map;
    });

    return () => {
      cancelled = true;
      markerRef.current?.remove();
      markerRef.current = null;
      mapRef.current?.remove();
      mapRef.current = null;
    };
  }, [lat, lng, title]);

  if (lat === null || lng === null) return null;

  return (
    <section className={`mt-10 overflow-hidden rounded-2xl border border-neutral-200 bg-sand-50 ${className}`} aria-label={`Map showing ${title}`}>
      <div className="border-b border-neutral-200 px-5 py-4">
        <h2 className="text-xl font-semibold text-ocean-900">Where is {title}?</h2>
        <p className="mt-1 text-sm text-neutral-600">Explore the location on the map.</p>
      </div>
      <div ref={containerRef} className="h-72 w-full sm:h-96" />
      <p className="border-t border-neutral-200 px-5 py-3 text-xs text-neutral-500">Map data &copy; OpenStreetMap contributors.</p>
    </section>
  );
}

export function LocationMapSkeleton() {
  return <div className="mt-10 h-72 animate-pulse rounded-2xl bg-sand-100 sm:h-96" aria-hidden="true" />;
}

export default LocationMap;
