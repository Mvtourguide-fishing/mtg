import type { AccommodationSummary } from "@/lib/accommodations/types";
import { ACCOMMODATION_TYPE_SEGMENT } from "@/lib/accommodations/types";
import type { ActivitySummary } from "@/lib/activities/types";
import { activityHref } from "@/lib/activities/types";
import type { LocationSummary } from "@/lib/locations/types";
import type { MediaAsset } from "@/lib/media/types";
import { ACCOMMODATION_GALLERY_IMAGES, PACKAGE_HERO_OVERRIDES } from "@/lib/packages/package-images";
import type { PackageDetail, PackageItineraryStage } from "@/lib/packages/types";
import type {
  PackageCategorySlug,
  PackageFaq,
  PackageItineraryDayView,
  PackageLinkedAccommodation,
  PackageLinkedActivity,
  PackagePriceType,
  PackageView,
} from "@/lib/packages/view-types";
import { PACKAGE_CATEGORIES } from "@/lib/packages/view-types";

/**
 * Task 21: pure mapping functions only — no Supabase access here (that
 * lives in view-repository.ts). Both the real-package path
 * (realPackageToView) and the demo-package path (in demo.ts, which
 * imports the helpers below) build a PackageView through this module, so
 * there's exactly one accommodationHref/itinerary-normalization/etc.
 * implementation for the whole package system.
 */

const CATEGORY_SLUGS = new Set<string>(PACKAGE_CATEGORIES.map((c) => c.slug));

export function isPackageCategorySlug(slug: string): slug is PackageCategorySlug {
  return CATEGORY_SLUGS.has(slug);
}

export function accommodationHref(accommodation: { accommodationType: keyof typeof ACCOMMODATION_TYPE_SEGMENT; slug: string }): string {
  return `/maldives/${ACCOMMODATION_TYPE_SEGMENT[accommodation.accommodationType]}/${accommodation.slug}/`;
}

export { activityHref };

/** Genuinely universal across every real travel package this platform
 * could ever sell (never claimed to be included by any package's own
 * copy) — the same reasoning the site already applies when explaining
 * how transfers/bookings work. Not package-specific, so not a fabricated
 * claim about any one package. */
export const STANDARD_EXCLUSIONS = ["International flights", "Travel insurance", "Personal expenses", "Optional activities not listed above"];

/** Per site-owner instruction: an N-night package is shown as N-1 days
 * (arrival and departure nights don't each add a full day), not the
 * N+1 "nights+1" convention this used to apply. Floored at 1 so a
 * short package never shows "0 Days". */
export function nightsToDays(nights: number | null): number | null {
  return nights === null ? null : Math.max(nights - 1, 1);
}

/** A single generic-but-true FAQ set, built once and reused per package —
 * answers reference the package's own real fields rather than invented
 * specifics. */
export function buildPackageFaqs(view: Pick<PackageView, "nights" | "transferIncluded" | "activityIncluded" | "mealsIncluded" | "isDemo">): PackageFaq[] {
  const faqs: PackageFaq[] = [];
  if (view.nights !== null) {
    faqs.push({
      question: "How many nights is this package?",
      answer: `This package runs ${view.nights} night${view.nights === 1 ? "" : "s"} (${nightsToDays(view.nights)} days), start to finish.`,
    });
  }
  faqs.push({
    question: "Is airport transfer included?",
    answer:
      view.transferIncluded === true
        ? "Yes — the transfer between Velana International Airport and your accommodation is included in this package."
        : view.transferIncluded === false
          ? "Not in this package — see Maldives Airport Transfers to arrange your own transfer alongside it."
          : "Check the Included section above for this package's exact transfer arrangement.",
  });
  faqs.push({
    question: "Are meals included?",
    answer: view.mealsIncluded ? `This package includes ${view.mealsIncluded.toLowerCase()}.` : "See the Included section above for this package's exact meal plan.",
  });
  faqs.push({
    question: "Can I customize this package?",
    answer: view.isDemo
      ? "This is a demo listing while our real commercial package inventory is being finalized — enquire and we'll help build a real itinerary around what you want."
      : "Enquire below with your preferred dates and any changes — we'll confirm what's possible against real availability before you book.",
  });
  return faqs;
}

/** Converts a real package's own DB itinerary stages (with entities
 * already resolved by getPackageBySlug) into the same normalized shape a
 * demo package's day list uses — one ItineraryList component renders
 * both. */
export function realStagesToItineraryView(stages: PackageItineraryStage[]): PackageItineraryDayView[] {
  return stages.map((stage) => {
    const links: Array<{ label: string; href: string }> = [];
    for (const item of stage.items) {
      if (item.accommodation) links.push({ label: item.accommodation.title, href: accommodationHref(item.accommodation) });
      else if (item.activity) links.push({ label: item.activity.title, href: activityHref(item.activity) });
      else if (item.transferRoute) links.push({ label: item.transferRoute.title, href: `/maldives/transfers/${item.transferRoute.slug}/` });
    }
    return {
      dayLabel: stage.dayStart === stage.dayEnd ? `Day ${stage.dayStart}` : `Days ${stage.dayStart}–${stage.dayEnd}`,
      nightCount: stage.nightCount || null,
      title: stage.title ?? (links[0]?.label ?? "Itinerary stage"),
      description: stage.description,
      links,
    };
  });
}

function deriveHeroImage(stages: PackageItineraryStage[]): MediaAsset | null {
  for (const stage of stages) {
    for (const item of stage.items) {
      if (item.accommodation?.heroImage) return item.accommodation.heroImage;
    }
  }
  return null;
}

/** A package's Gallery section: its hero first, then a few extra genuine
 * photos of whatever accommodation(s) it's anchored to (from
 * ACCOMMODATION_GALLERY_IMAGES — real legacy photos beyond that
 * accommodation's single node_media hero row), deduped by media id and
 * capped so the section stays a gallery, not the whole photo library. */
export function buildGalleryImages(hero: MediaAsset | null, accommodations: Array<{ accommodation: { slug: string; heroImage: MediaAsset | null } }>): MediaAsset[] {
  const seen = new Set<string>();
  const images: MediaAsset[] = [];
  const add = (asset: MediaAsset | null | undefined) => {
    if (!asset || seen.has(asset.id)) return;
    seen.add(asset.id);
    images.push(asset);
  };

  add(hero);
  for (const { accommodation } of accommodations) {
    add(accommodation.heroImage);
    for (const extra of ACCOMMODATION_GALLERY_IMAGES[accommodation.slug] ?? []) add(extra);
  }
  return images.slice(0, 6);
}

function collectLinkedEntities(stages: PackageItineraryStage[]): {
  accommodations: PackageLinkedAccommodation[];
  activities: PackageLinkedActivity[];
} {
  const accommodations: PackageLinkedAccommodation[] = [];
  const activities: PackageLinkedActivity[] = [];
  const seenAcc = new Set<string>();
  const seenAct = new Set<string>();

  for (const stage of stages) {
    for (const item of stage.items) {
      if (item.accommodation && !seenAcc.has(item.accommodation.id)) {
        seenAcc.add(item.accommodation.id);
        accommodations.push({ accommodation: item.accommodation, href: accommodationHref(item.accommodation) });
      }
      if (item.activity && !seenAct.has(item.activity.id)) {
        seenAct.add(item.activity.id);
        activities.push({ activity: item.activity, href: activityHref(item.activity) });
      }
    }
  }
  return { accommodations, activities };
}

function firstTransferLink(stages: PackageItineraryStage[]): { href: string | null; label: string | null; included: boolean | null } {
  for (const stage of stages) {
    for (const item of stage.items) {
      if (item.transferRoute) return { href: `/maldives/transfers/${item.transferRoute.slug}/`, label: item.transferRoute.title, included: true };
      if (item.componentRole === "transfer") return { href: "/maldives/transfers/", label: "Maldives Transfers", included: true };
    }
  }
  return { href: null, label: null, included: null };
}

/** category slugs already on the DB record (traveler-type + theme) that
 * happen to also be one of the 11 owner-defined package categories — no
 * translation table needed since the two new taxonomy rows (Task 21) were
 * deliberately seeded with slugs matching PackageCategorySlug exactly. */
function deriveCategories(titles: Array<{ slug: string }>): PackageCategorySlug[] {
  const slugs = titles.map((t) => t.slug).filter(isPackageCategorySlug);
  return Array.from(new Set(slugs));
}

function deriveHighlights(pkg: PackageDetail, activities: PackageLinkedActivity[], accommodations: PackageLinkedAccommodation[]): string[] {
  const highlights: string[] = [];
  if (accommodations[0]) highlights.push(`Stay at ${accommodations[0].accommodation.title}`);
  for (const a of activities.slice(0, 3)) highlights.push(a.activity.title);
  if (pkg.destinations[0] && highlights.length < 4) highlights.push(`Based in ${pkg.destinations[0].title}`);
  return highlights.slice(0, 4);
}

function deriveIncluded(pkg: PackageDetail, hasTransfer: boolean, hasActivity: boolean): string[] {
  const included: string[] = [];
  for (const inclusion of pkg.inclusions) included.push(inclusion.title);
  if (hasTransfer && !included.some((i) => /transfer/i.test(i))) included.push("Airport transfer");
  if (hasActivity && !included.some((i) => /activit/i.test(i))) included.push("Activities as listed in the itinerary");
  if (included.length === 0) included.push("Accommodation as listed in the itinerary");
  return included;
}

export function realPackageToView(pkg: PackageDetail): PackageView {
  const { accommodations, activities } = collectLinkedEntities(pkg.stages);
  const transfer = firstTransferLink(pkg.stages);
  const heroImage = PACKAGE_HERO_OVERRIDES[pkg.slug] ?? deriveHeroImage(pkg.stages);
  const categories = deriveCategories([...pkg.travelerTypes, ...pkg.styles, ...pkg.themes]);
  const priceType: PackagePriceType | null = pkg.priceFrom !== null ? "per-person" : null;

  const bestFor = pkg.travelerTypes.map((t) => t.title);

  const view: PackageView = {
    id: pkg.id,
    slug: pkg.slug,
    title: pkg.title,
    shortDescription: pkg.summary,
    description: pkg.summary,
    categories,
    destinations: pkg.destinations,
    atoll: null,
    nights: pkg.durationNights,
    days: nightsToDays(pkg.durationNights),
    price: pkg.priceFrom,
    currency: pkg.currency,
    priceType,
    rating: null,
    ratingCount: null,
    heroImage,
    images: buildGalleryImages(heroImage, accommodations),
    youtubeId: null,
    highlights: deriveHighlights(pkg, activities, accommodations),
    bestFor,
    included: deriveIncluded(pkg, transfer.included === true, activities.length > 0),
    excluded: STANDARD_EXCLUSIONS,
    accommodationIncluded: accommodations.length > 0,
    transferIncluded: transfer.included,
    mealsIncluded: pkg.inclusions.find((i) => /board|breakfast|food/i.test(i.slug))?.title ?? null,
    activityIncluded: activities.length > 0,
    flightIncluded: false,
    transferHref: transfer.href,
    transferLabel: transfer.label,
    activities,
    accommodations,
    itinerary: realStagesToItineraryView(pkg.stages),
    faqs: [],
    provider: pkg.provider,
    isMtgCurated: pkg.isMtgCurated,
    isBookable: pkg.isBookable,
    isDemo: false,
    createdAt: null,
  };
  view.faqs = buildPackageFaqs(view);
  return view;
}

/** Resolves this package's real atoll for the location filter — the
 * first destination's own parent atoll, or the destination itself when
 * it already IS an atoll. A pure function over already-fetched data
 * (view-repository.ts does the actual getLocationSummaryById lookup and
 * passes the result in), so this module stays free of Supabase access. */
export function withAtoll(view: PackageView, atoll: LocationSummary | null): PackageView {
  return { ...view, atoll };
}

export type { AccommodationSummary, ActivitySummary };
