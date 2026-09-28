import { MediaImage } from "@/components/ui/media-image";
import type { MediaAsset } from "@/lib/media/types";

/** Task 20 §23/§24: seaplane and domestic flight transfers, "Coming
 * Soon" — no invented operators, prices, schedules, or availability.
 * `image` is optional and, when given, is always a real legacy photo
 * (see src/lib/transfers/category-images.ts) — never a placeholder. */
export function ComingSoonSection({ title, description, image }: { title: string; description: string; image?: MediaAsset }) {
  return (
    <section className="mt-10 flex flex-col gap-4 sm:flex-row sm:items-start">
      {image && (
        <div className="w-full shrink-0 overflow-hidden rounded-2xl sm:w-48">
          <MediaImage asset={image} alt={title} aspectClassName="aspect-[16/10]" />
        </div>
      )}
      <div>
        <div className="flex flex-wrap items-baseline gap-2">
          <h2 className="text-xl font-semibold text-ocean-900">{title}</h2>
          <span className="rounded-full bg-amber-100 px-3 py-1 text-xs font-medium text-amber-800">Coming Soon</span>
        </div>
        <p className="mt-2 max-w-2xl text-sm text-neutral-600">{description}</p>
      </div>
    </section>
  );
}
