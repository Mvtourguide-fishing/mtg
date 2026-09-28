interface RouteMapProps {
  originTitle: string;
  originLat: number | null;
  originLng: number | null;
  destinationTitle: string;
  destinationLat: number | null;
  destinationLng: number | null;
}

/**
 * Task 20 §33: From → To, using real coordinates only — never invented.
 * Uses OpenStreetMap's own public embed widget (no API key required,
 * dependency-free) rather than pulling in a mapping SDK for two points.
 * Renders nothing (not a broken/blank map) when either coordinate is
 * missing, which is the honest, expected state for most of the ~55
 * destinations Task 18 recovered without independently-confirmed
 * coordinates for both ends.
 */
export function RouteMap({ originTitle, originLat, originLng, destinationTitle, destinationLat, destinationLng }: RouteMapProps) {
  if (originLat === null || originLng === null || destinationLat === null || destinationLng === null) return null;

  const padding = 0.08;
  const minLat = Math.min(originLat, destinationLat) - padding;
  const maxLat = Math.max(originLat, destinationLat) + padding;
  const minLng = Math.min(originLng, destinationLng) - padding;
  const maxLng = Math.max(originLng, destinationLng) + padding;
  const bbox = `${minLng},${minLat},${maxLng},${maxLat}`;
  const src = `https://www.openstreetmap.org/export/embed.html?bbox=${bbox}&layer=mapnik&marker=${destinationLat},${destinationLng}`;

  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">Route Map</h2>
      <p className="mt-1 text-sm text-neutral-600">
        {originTitle} → {destinationTitle}
      </p>
      <div className="mt-3 overflow-hidden rounded-2xl border border-neutral-200">
        <iframe
          className="h-72 w-full sm:h-96"
          src={src}
          title={`Map: ${originTitle} to ${destinationTitle}`}
          loading="lazy"
        />
      </div>
    </section>
  );
}
