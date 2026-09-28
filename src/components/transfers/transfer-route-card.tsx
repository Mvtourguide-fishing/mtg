import Link from "next/link";

import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { MediaImage } from "@/components/ui/media-image";
import type { TransferRouteSummary } from "@/lib/transfers/types";

function formatDuration(minutes: number | null): string | null {
  if (!minutes) return null;
  if (minutes < 60) return `${minutes} min`;
  const hours = minutes / 60;
  return Number.isInteger(hours) ? `${hours} hr` : `${hours.toFixed(1)} hr`;
}

export function TransferRouteCard({ route }: { route: TransferRouteSummary }) {
  const duration = formatDuration(route.typicalDurationMinutes);

  return (
    <li className={CARD_CLASS}>
      {route.heroImage && (
        <div className={CARD_IMAGE_BLEED_CLASS}>
          <MediaImage asset={route.heroImage} alt={route.title} aspectClassName="aspect-[16/10]" />
        </div>
      )}
      <Link href={`/maldives/transfers/${route.slug}/`} className="text-lg font-medium text-ocean-900 transition-colors hover:text-maldives-600">
        {route.title}
      </Link>
      <div className="mt-1.5 flex flex-wrap gap-x-3 gap-y-1 text-sm text-neutral-600">
        {duration && <span>{duration}</span>}
        {route.distanceKm !== null && <span>{route.distanceKm} km</span>}
        {route.priceFrom !== null && (
          <span>
            From {route.currency ?? "USD"} {route.priceFrom}
          </span>
        )}
      </div>
    </li>
  );
}
