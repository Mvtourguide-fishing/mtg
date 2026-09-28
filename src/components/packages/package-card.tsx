import Link from "next/link";

import { Badge } from "@/components/ui/badge";
import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { MediaImage } from "@/components/ui/media-image";
import { PACKAGE_CATEGORY_TITLE } from "@/lib/packages/view-types";
import type { PackageView } from "@/lib/packages/view-types";

const PRICE_TYPE_LABEL: Record<string, string> = {
  "per-person": "per person",
  "per-couple": "per couple",
  "per-package": "per package",
};

export function PackageCard({ pkg }: { pkg: PackageView }) {
  const primaryDestination = pkg.destinations[0] ?? null;
  const primaryCategory = pkg.categories[0] ?? null;

  return (
    <li className={CARD_CLASS}>
      {pkg.heroImage && (
        <div className={CARD_IMAGE_BLEED_CLASS}>
          <MediaImage asset={pkg.heroImage} alt={pkg.title} aspectClassName="aspect-[4/3]" />
        </div>
      )}

      <div className="flex flex-wrap items-start justify-between gap-2">
        <Link href={`/maldives/packages/${pkg.slug}/`} className="text-lg font-medium text-ocean-900 transition-colors hover:text-maldives-600">
          {pkg.title}
        </Link>
        {pkg.isMtgCurated && !pkg.isDemo && (
          <Badge tone="aqua" className="shrink-0">
            MTG-curated
          </Badge>
        )}
      </div>

      <div className="mt-1 flex flex-wrap items-center gap-x-2 gap-y-1 text-sm text-neutral-600">
        {primaryDestination && <span>{primaryDestination.title}</span>}
        {primaryCategory && (
          <>
            {primaryDestination && <span aria-hidden="true">·</span>}
            <span>{PACKAGE_CATEGORY_TITLE[primaryCategory]}</span>
          </>
        )}
      </div>

      {pkg.rating !== null && (
        <div className="mt-1 flex items-center gap-1 text-sm text-amber-600">
          <span aria-hidden="true">&#9733;</span>
          <span className="font-medium">{pkg.rating.toFixed(1)}</span>
          {pkg.ratingCount !== null && <span className="text-neutral-500">({pkg.ratingCount})</span>}
        </div>
      )}

      <div className="mt-2 flex flex-wrap items-baseline gap-x-3 gap-y-1">
        {pkg.nights !== null && (
          <span className="text-base font-semibold text-ocean-900">
            {pkg.nights} Night{pkg.nights === 1 ? "" : "s"} / {pkg.days} Days
          </span>
        )}
      </div>

      <div className="mt-1 text-sm text-neutral-700">
        {pkg.price !== null ? (
          <>
            <span className="font-medium text-ocean-900">
              From {pkg.currency ?? "USD"} {pkg.price.toLocaleString()}
            </span>{" "}
            {pkg.priceType && <span className="text-neutral-500">{PRICE_TYPE_LABEL[pkg.priceType]}</span>}
          </>
        ) : (
          <span>Quote on request</span>
        )}
      </div>

      {pkg.highlights.length > 0 && (
        <ul className="mt-2 space-y-0.5 text-sm text-neutral-600">
          {pkg.highlights.slice(0, 3).map((h) => (
            <li key={h} className="flex gap-1.5">
              <span aria-hidden="true" className="text-maldives-600">
                &#10003;
              </span>
              <span>{h}</span>
            </li>
          ))}
        </ul>
      )}

      <Link
        href={`/maldives/packages/${pkg.slug}/`}
        className="mt-3 inline-flex items-center justify-center rounded-full bg-maldives-600 px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-ocean-800"
      >
        View Package
      </Link>
    </li>
  );
}
