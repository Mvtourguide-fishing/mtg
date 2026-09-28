import Link from "next/link";

import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { MediaImage } from "@/components/ui/media-image";
import { ATTRACTION_TYPE_LABEL, attractionHref, type AttractionSummary } from "@/lib/attractions/types";

export function AttractionCard({ attraction }: { attraction: AttractionSummary }) {
  return (
    <li className={CARD_CLASS}>
      {attraction.heroImage && (
        <div className={CARD_IMAGE_BLEED_CLASS}>
          <MediaImage asset={attraction.heroImage} alt={attraction.title} aspectClassName="aspect-[4/3]" />
        </div>
      )}
      <Link href={attractionHref(attraction)} className="text-lg font-medium text-ocean-900 transition-colors hover:text-maldives-600">
        {attraction.title}
      </Link>
      <div className="mt-1.5 flex flex-wrap gap-x-3 gap-y-1 text-sm text-neutral-600">
        {attraction.attractionType && <span>{ATTRACTION_TYPE_LABEL[attraction.attractionType] ?? attraction.attractionType}</span>}
        {attraction.island && <span>{attraction.island.title}</span>}
      </div>
      {attraction.summary && <p className="mt-1.5 text-sm text-neutral-600 line-clamp-2">{attraction.summary}</p>}
    </li>
  );
}
