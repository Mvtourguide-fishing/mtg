import Link from "next/link";

import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { MediaImage } from "@/components/ui/media-image";
import type { SpeedboatSummary } from "@/lib/speedboats/types";

export function SpeedboatCard({ boat }: { boat: SpeedboatSummary }) {
  return (
    <li className={CARD_CLASS}>
      {boat.heroImage && (
        <div className={CARD_IMAGE_BLEED_CLASS}>
          <MediaImage asset={boat.heroImage} alt={boat.title} aspectClassName="aspect-[16/10]" />
        </div>
      )}
      <Link href={`/maldives-speedboats-charter/${boat.slug}/`} className="text-lg font-medium text-ocean-900 transition-colors hover:text-maldives-600">
        {boat.title}
      </Link>
      <div className="mt-1.5 flex flex-wrap gap-x-3 gap-y-1 text-sm text-neutral-600">
        <span>{boat.capacity} seats</span>
        {boat.lengthFeet && <span>{boat.lengthFeet} ft</span>}
        {boat.topSpeedKnots && <span>{boat.topSpeedKnots} knots</span>}
      </div>
      {boat.facilities.length > 0 && (
        <div className="mt-1.5 flex flex-wrap gap-1.5">
          {boat.facilities.map((f) => (
            <span key={f} className="rounded-full bg-lagoon-50 px-2 py-0.5 text-xs text-ocean-800">
              {f}
            </span>
          ))}
        </div>
      )}
      <p className="mt-2 text-sm text-neutral-600">Hourly, destination-based, or custom private charter — request a quote.</p>
      <Link href={`/maldives-speedboats-charter/${boat.slug}/`} className="mt-3 inline-block text-sm font-medium text-maldives-600 hover:underline">
        View boat →
      </Link>
    </li>
  );
}
