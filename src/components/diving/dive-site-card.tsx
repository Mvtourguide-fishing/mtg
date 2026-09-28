import Link from "next/link";

import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { MediaImage } from "@/components/ui/media-image";
import type { DiveSiteSummary } from "@/lib/diving/types";

const SITE_TYPE_LABEL: Record<string, string> = {
  reef: "Reef",
  thila: "Thila",
  channel: "Channel",
  wreck: "Wreck",
  pinnacle: "Pinnacle",
  wall: "Wall",
  cave: "Cave",
};

export function DiveSiteCard({ site }: { site: DiveSiteSummary }) {
  return (
    <li className={CARD_CLASS}>
      {site.heroImage && (
        <div className={CARD_IMAGE_BLEED_CLASS}>
          <MediaImage asset={site.heroImage} alt={site.title} aspectClassName="aspect-[4/3]" />
        </div>
      )}
      <Link href={`/maldives/dive-sites/${site.slug}/`} className="text-lg font-medium text-ocean-900 transition-colors hover:text-maldives-600">
        {site.title}
      </Link>
      {site.siteType && (
        <div className="mt-1.5 text-sm text-neutral-600">{SITE_TYPE_LABEL[site.siteType] ?? site.siteType}</div>
      )}
    </li>
  );
}
