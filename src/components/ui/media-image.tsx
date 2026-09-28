import Image from "next/image";

import { publicStorageUrl } from "@/lib/media/types";
import type { MediaAsset } from "@/lib/media/types";

/**
 * The one place in the app that turns a `MediaAsset` into an actual
 * `<img>` (via `next/image`, for its automatic resizing/lazy-loading —
 * Task 14 §20). Renders nothing when there's no real image behind the
 * asset (wrong media type, no storage_path, or Storage isn't configured)
 * rather than a placeholder — this codebase never shows a stock/fake image
 * in place of a real one (see the migration scripts' identical rule).
 *
 * Always fills a positioned, aspect-ratio-constrained wrapper rather than
 * rendering at intrinsic size — every caller (cards, heroes, galleries)
 * needs a predictable box, and `next/image`'s `fill` mode is what makes
 * `sizes` actually effective for responsive loading.
 */
export function MediaImage({
  asset,
  alt,
  aspectClassName = "aspect-[4/3]",
  sizes = "(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 400px",
  priority = false,
  className = "",
  fillParent = false,
}: {
  asset: MediaAsset | null | undefined;
  /** Fallback alt text used only when the asset has none of its own
   * (every migrated asset does — see altTextFor() in
   * scripts/import-legacy-media.mjs — but a future manually-added one
   * might not). */
  alt: string;
  aspectClassName?: string;
  sizes?: string;
  /** True only for a genuine above-the-fold hero — every other usage
   * should lazy-load (next/image's default). */
  priority?: boolean;
  className?: string;
  /** Skip the built-in relative/aspect-ratio wrapper and fill whatever
   * positioned ancestor the caller already provides — for a full-bleed
   * hero band (see PageHero) where the section itself defines the box. */
  fillParent?: boolean;
}) {
  if (!asset || asset.mediaType !== "image" || !asset.storagePath) return null;

  const url = publicStorageUrl(asset.storagePath);
  if (!url) return null;

  if (fillParent) {
    return (
      <Image
        src={url}
        alt={asset.altText || alt}
        fill
        sizes={sizes}
        className={["object-cover", className].filter(Boolean).join(" ")}
        priority={priority}
      />
    );
  }

  return (
    <div className={["relative overflow-hidden", aspectClassName, className].filter(Boolean).join(" ")}>
      <Image src={url} alt={asset.altText || alt} fill sizes={sizes} className="object-cover" priority={priority} />
    </div>
  );
}
