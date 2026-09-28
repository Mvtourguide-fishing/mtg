import "server-only";

import { getAccommodationBySlug } from "@/lib/accommodations/repository";
import { getActivityBySlug } from "@/lib/activities/repository";
import { activityHref } from "@/lib/activities/types";
import { getAtollBySlug } from "@/lib/locations/repository";
import type { LocationSummary } from "@/lib/locations/types";
import type { MediaAsset } from "@/lib/media/types";
import { PACKAGE_CATEGORY_FALLBACK_IMAGES } from "@/lib/packages/category-images";
import { DEMO_PACKAGES, type DemoItineraryDay, type DemoPackageInput } from "@/lib/packages/demo-packages";
import { PACKAGE_HERO_OVERRIDES } from "@/lib/packages/package-images";
import { accommodationHref, buildGalleryImages, buildPackageFaqs, nightsToDays, STANDARD_EXCLUSIONS } from "@/lib/packages/view";
import type { PackageItineraryDayView, PackageLinkedAccommodation, PackageLinkedActivity, PackageView } from "@/lib/packages/view-types";

/**
 * Task 21: resolves the static DEMO_PACKAGES input data against the REAL
 * accommodations/activities/locations repositories, so every demo
 * package's destination, image, and internal links are genuine even
 * though the package itself (price/rating/existence as a product) is
 * demo content. Server-only (real repository calls), unlike view.ts
 * which stays a pure mapper.
 */

function itineraryDayToView(day: DemoItineraryDay, activityLinksByDay: Map<number, Array<{ label: string; href: string }>>): PackageItineraryDayView {
  return {
    dayLabel: `Day ${day.day}`,
    nightCount: null,
    title: day.title,
    description: day.description,
    links: activityLinksByDay.get(day.day) ?? [],
  };
}

function categoryFallbackImage(input: DemoPackageInput): MediaAsset {
  if (input.categories.includes("liveaboard")) return PACKAGE_CATEGORY_FALLBACK_IMAGES.liveaboard;
  if (input.categories.includes("diving")) return PACKAGE_CATEGORY_FALLBACK_IMAGES.diving;
  if (input.categories.includes("fishing")) return PACKAGE_CATEGORY_FALLBACK_IMAGES.fishing;
  if (input.categories.includes("surfing")) return PACKAGE_CATEGORY_FALLBACK_IMAGES.surfing;
  if (input.categories.includes("honeymoon")) return PACKAGE_CATEGORY_FALLBACK_IMAGES.honeymoon;
  if (input.categories.includes("adults-only")) return PACKAGE_CATEGORY_FALLBACK_IMAGES.adultsOnly;
  if (input.categories.includes("family")) return PACKAGE_CATEGORY_FALLBACK_IMAGES.family;
  if (input.categories.includes("luxury")) return PACKAGE_CATEGORY_FALLBACK_IMAGES.luxury;
  return PACKAGE_CATEGORY_FALLBACK_IMAGES.budget;
}

async function resolveOneDemoPackage(input: DemoPackageInput): Promise<PackageView> {
  const [accommodation, atoll, ...activities] = await Promise.all([
    input.accommodationSlug ? getAccommodationBySlug(input.accommodationSlug) : Promise.resolve(null),
    input.atollSlug ? getAtollBySlug(input.atollSlug) : Promise.resolve(null),
    ...(input.activitySlugs ?? []).map((slug) => getActivityBySlug(slug)),
  ]);

  const accommodations: PackageLinkedAccommodation[] = accommodation
    ? [{ accommodation, href: accommodationHref(accommodation) }]
    : [];
  const linkedActivities: PackageLinkedActivity[] = activities
    .filter((a): a is NonNullable<typeof a> => a !== null)
    .map((activity) => ({ activity, href: activityHref(activity) }));

  const activityHrefBySlug = new Map(linkedActivities.map((a) => [a.activity.slug, { label: a.activity.title, href: a.href }]));
  const activityLinksByDay = new Map<number, Array<{ label: string; href: string }>>();
  for (const day of input.itinerary) {
    const links = (day.activitySlugs ?? []).map((slug) => activityHrefBySlug.get(slug)).filter((l): l is { label: string; href: string } => Boolean(l));
    if (links.length > 0) activityLinksByDay.set(day.day, links);
  }

  const destinations: LocationSummary[] = [];
  if (accommodation?.primaryLocation) destinations.push(accommodation.primaryLocation);
  else if (atoll) destinations.push(atoll);

  const resolvedAtoll: LocationSummary | null = atoll ?? null;

  const heroImage = PACKAGE_HERO_OVERRIDES[input.slug] ?? accommodation?.heroImage ?? categoryFallbackImage(input);

  const view: PackageView = {
    id: `demo-${input.slug}`,
    slug: input.slug,
    title: input.title,
    shortDescription: input.shortDescription,
    description: input.description,
    categories: input.categories,
    destinations,
    atoll: resolvedAtoll,
    nights: input.nights,
    days: nightsToDays(input.nights),
    price: input.price,
    currency: input.currency,
    priceType: input.priceType,
    rating: input.rating,
    ratingCount: input.ratingCount,
    heroImage,
    images: buildGalleryImages(heroImage, accommodations),
    youtubeId: null,
    highlights: input.highlights,
    bestFor: input.bestFor,
    included: input.included,
    excluded: STANDARD_EXCLUSIONS,
    accommodationIncluded: accommodations.length > 0,
    transferIncluded: input.transferIncluded,
    mealsIncluded: input.mealsIncluded,
    activityIncluded: linkedActivities.length > 0,
    flightIncluded: input.flightIncluded,
    transferHref: input.transferIncluded ? "/maldives/transfers/" : null,
    transferLabel: input.transferLabel ?? null,
    activities: linkedActivities,
    accommodations,
    itinerary: input.itinerary.map((day) => itineraryDayToView(day, activityLinksByDay)),
    faqs: [],
    provider: null,
    isMtgCurated: true,
    isBookable: false,
    isDemo: true,
    createdAt: input.createdAt,
  };
  view.faqs = buildPackageFaqs(view);
  return view;
}

let cachedDemoViews: Promise<PackageView[]> | null = null;

/** Resolves every demo package once per request lifetime (Next.js
 * request-scoped module cache) — cheap given there are only ~24, but no
 * reason to re-resolve them per call within one render. */
export function getDemoPackageViews(): Promise<PackageView[]> {
  if (!cachedDemoViews) {
    cachedDemoViews = Promise.all(DEMO_PACKAGES.map(resolveOneDemoPackage));
  }
  return cachedDemoViews;
}

export async function getDemoPackageViewBySlug(slug: string): Promise<PackageView | null> {
  const all = await getDemoPackageViews();
  return all.find((p) => p.slug === slug) ?? null;
}

/** Demo packages whose real accommodation OR any real activity matches
 * `nodeId` — powers the reverse "Featured in packages" links on
 * accommodation/activity detail pages alongside real DB packages. */
export async function getDemoPackagesReferencingNode(nodeId: string): Promise<PackageView[]> {
  const all = await getDemoPackageViews();
  return all.filter((p) => p.accommodations.some((a) => a.accommodation.id === nodeId) || p.activities.some((a) => a.activity.id === nodeId));
}
