import Link from "next/link";

import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { MediaImage } from "@/components/ui/media-image";
import type { LocationSummary } from "@/lib/locations/types";

/** Real per-island photos now exist for 13 islands (see
 * scripts/attach-island-images.mjs) — most islands still have none, which
 * is the normal case, not an error; the card just renders without an
 * image rather than a placeholder or a borrowed generic photo. */
export function IslandCard({ island }: { island: LocationSummary }) {
  return (
    <li className={CARD_CLASS}>
      {island.heroImage && (
        <div className={CARD_IMAGE_BLEED_CLASS}>
          <MediaImage asset={island.heroImage} alt={island.title} aspectClassName="aspect-[4/3]" />
        </div>
      )}
      <Link href={`/maldives/islands/${island.slug}/`} className="text-lg font-medium text-ocean-900 transition-colors hover:text-maldives-600">
        {island.title}
      </Link>
      {island.summary && <p className="mt-1.5 text-sm text-neutral-600 line-clamp-2">{island.summary}</p>}
    </li>
  );
}
