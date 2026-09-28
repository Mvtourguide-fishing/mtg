import type { ReactNode } from "react";

import { Breadcrumbs, type BreadcrumbItem } from "@/components/location/breadcrumbs";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { MediaImage } from "@/components/ui/media-image";
import type { MediaAsset } from "@/lib/media/types";

/**
 * Reusable hero for directory/category pages (Task 12 §10). Two variants:
 *  - "ocean": a dark ocean-gradient band, reserved for the handful of top-
 *    level gateway pages (the homepage's own hero, /maldives/) so the
 *    gradient reads as a landmark rather than wallpaper everywhere.
 *  - "plain" (default): a calm off-white band, used on the rest of the
 *    directory/detail pages — keeps the site from being "entirely bright
 *    blue" per the design brief while still giving every page a proper,
 *    consistent hero band instead of a bare heading.
 */
export function PageHero({
  eyebrow,
  title,
  description,
  breadcrumbs,
  meta,
  action,
  variant = "plain",
  image,
}: {
  eyebrow?: string;
  title: ReactNode;
  description?: string;
  breadcrumbs?: BreadcrumbItem[];
  meta?: ReactNode;
  action?: ReactNode;
  variant?: "ocean" | "plain";
  /** A real matched hero photo for the entity this page is about (Task 14
   * §20) — null for the vast majority of pages today. When present, it
   * takes over the band (dark text always reads white against it) instead
   * of the plain/ocean gradient, which is itself just a fallback for when
   * there's no real photo. */
  image?: MediaAsset | null;
}) {
  const isOcean = variant === "ocean";
  const hasImage = Boolean(image && image.mediaType === "image" && image.storagePath);

  return (
    <section
      className={`relative ${hasImage ? "text-white" : isOcean ? "bg-gradient-to-br from-ocean-900 via-ocean-800 to-maldives-600 text-white" : "bg-sand-50"}`}
    >
      {hasImage && (
        <div className="absolute inset-0">
          <MediaImage asset={image} alt="" fillParent priority sizes="100vw" />
          <div className="absolute inset-0 bg-gradient-to-t from-ocean-950/85 via-ocean-900/55 to-ocean-900/20" />
        </div>
      )}
      <div className={`relative ${CONTAINER_CLASS} py-10 sm:py-14`}>
        {breadcrumbs && <Breadcrumbs items={breadcrumbs} tone={isOcean || hasImage ? "inverted" : "default"} />}

        {eyebrow && (
          <p className={`mt-4 text-xs font-semibold uppercase tracking-wide ${isOcean || hasImage ? "text-lagoon-200" : "text-maldives-600"}`}>
            {eyebrow}
          </p>
        )}

        <h1 className={`${breadcrumbs || eyebrow ? "mt-2" : ""} text-3xl font-semibold tracking-tight sm:text-4xl ${isOcean || hasImage ? "text-white" : "text-ocean-900"}`}>
          {title}
        </h1>

        {description && (
          <p className={`mt-3 max-w-2xl text-base ${isOcean || hasImage ? "text-lagoon-100" : "text-neutral-600"}`}>{description}</p>
        )}

        {meta && <div className="mt-5 flex flex-wrap gap-x-6 gap-y-2 text-sm">{meta}</div>}

        {action && <div className="mt-6">{action}</div>}
      </div>
    </section>
  );
}
