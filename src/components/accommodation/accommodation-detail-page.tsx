import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";

import { NearbyActivitiesSection } from "@/components/activity/nearby-activities-section";
import { GallerySection } from "@/components/accommodation/gallery-section";
import { RoomsSection } from "@/components/accommodation/rooms-section";
import { TypicalAmenitiesSection } from "@/components/accommodation/typical-amenities-section";
import { accommodationVideoJsonLd, VideoSection } from "@/components/accommodation/video-section";
import { ArticleCard } from "@/components/articles/article-card";
import { AttractionCard } from "@/components/attractions/attraction-card";
import { NodeInquiryForm } from "@/components/bookings/node-inquiry-form";
import { PackageCard } from "@/components/packages/package-card";
import { TransferRouteCard } from "@/components/transfers/transfer-route-card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { PageHero } from "@/components/ui/page-hero";
import { getAccommodationBySlug } from "@/lib/accommodations/repository";
import { ACCOMMODATION_TYPE_SEGMENT, type AccommodationType } from "@/lib/accommodations/types";
import { getNearbyActivities } from "@/lib/activities/repository";
import { getArticlesRelatedToNodes } from "@/lib/articles/repository";
import { getNearbyAttractions } from "@/lib/attractions/repository";
import { bookingCta } from "@/lib/bookings/copy";
import { getPackageViewsByAccommodation } from "@/lib/packages/view-repository";
import { breadcrumbJsonLd, canonicalUrl } from "@/lib/seo/site";
import { getTransferRoutesByLocation } from "@/lib/transfers/repository";

const TYPE_LABEL: Record<AccommodationType, string> = {
  hotel: "Hotel",
  resort: "Resort",
  guesthouse: "Guesthouse",
  villa: "Villa",
  liveaboard: "Liveaboard",
  other: "Accommodation",
};

const PRICE_TIER_LABEL: Record<string, string> = {
  budget: "Budget",
  mid: "Mid-range",
  luxury: "Luxury",
  ultra_luxury: "Ultra-luxury",
};

/**
 * Shared by every accommodation type's [slug] route. `type` must match the
 * requested URL segment — a hotel is only reachable at /maldives/hotels/,
 * never at /maldives/resorts/, even though slugs are globally unique
 * across accommodation types. This is what keeps the canonical URL for a
 * given accommodation to exactly one path.
 */
async function loadAndVerify(type: AccommodationType, slug: string) {
  const accommodation = await getAccommodationBySlug(slug);
  if (!accommodation || accommodation.accommodationType !== type) return null;
  return accommodation;
}

export async function accommodationDetailMetadata(type: AccommodationType, slug: string): Promise<Metadata> {
  const accommodation = await loadAndVerify(type, slug);
  if (!accommodation) return {};

  const title = accommodation.metaTitle ?? `${accommodation.title} | Maldives ${TYPE_LABEL[type]}s | MTG`;
  const description = accommodation.metaDescription ?? accommodation.summary ?? undefined;
  const url = canonicalUrl(`/maldives/${ACCOMMODATION_TYPE_SEGMENT[type]}/${accommodation.slug}`);

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
  };
}

export async function AccommodationDetailPage({ type, slug }: { type: AccommodationType; slug: string }) {
  const accommodation = await loadAndVerify(type, slug);
  if (!accommodation) notFound();

  const segment = ACCOMMODATION_TYPE_SEGMENT[type];
  const { primaryLocation, atoll } = accommodation;
  const locationFilter = { islandId: primaryLocation?.id ?? null, atollId: atoll?.id ?? null };
  const [packages, nearbyActivities, nearbyAttractions, transferRoutes, relatedGuides] = await Promise.all([
    getPackageViewsByAccommodation(accommodation.id),
    getNearbyActivities(locationFilter),
    getNearbyAttractions(locationFilter),
    primaryLocation ? getTransferRoutesByLocation(primaryLocation.id) : Promise.resolve([]),
    getArticlesRelatedToNodes([accommodation.id, primaryLocation?.id, atoll?.id].filter((id): id is string => Boolean(id))),
  ]);

  const videoJsonLd = accommodationVideoJsonLd(accommodation.videoYoutubeId, accommodation.title, accommodation.summary);
  const breadcrumbs = [
    { label: "Maldives", href: "/maldives/" },
    { label: `${TYPE_LABEL[type]}s`, href: `/maldives/${segment}/` },
    { label: accommodation.title },
  ];

  return (
    <main>
      {/* Task 17 audit: every other detail-page type already emits this;
          accommodation had the visual breadcrumb via PageHero below but no
          matching structured data. */}
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbJsonLd(breadcrumbs, `/maldives/${segment}/${accommodation.slug}`)) }}
      />
      {videoJsonLd && (
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(videoJsonLd) }} />
      )}
      <PageHero
        breadcrumbs={breadcrumbs}
        eyebrow={TYPE_LABEL[type]}
        title={accommodation.title}
        description={accommodation.summary ?? undefined}
        image={accommodation.heroImage}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
      {accommodation.overviewParagraphs.length > 0 && (
        <section className="max-w-3xl space-y-4 text-neutral-700">
          {accommodation.overviewParagraphs.map((paragraph, i) => (
            <p key={i}>{paragraph}</p>
          ))}
        </section>
      )}

      <dl className="mt-8 grid grid-cols-2 gap-4 text-sm sm:grid-cols-3">
        <div>
          <dt className="text-neutral-500">Type</dt>
          <dd className="font-medium">{TYPE_LABEL[type]}</dd>
        </div>
        {accommodation.starRating && (
          <div>
            <dt className="text-neutral-500">Star rating</dt>
            <dd className="font-medium">{accommodation.starRating}★</dd>
          </div>
        )}
        {accommodation.priceTier && (
          <div>
            <dt className="text-neutral-500">Price tier</dt>
            <dd className="font-medium">{PRICE_TIER_LABEL[accommodation.priceTier] ?? accommodation.priceTier}</dd>
          </div>
        )}
        {accommodation.roomCount && (
          <div>
            <dt className="text-neutral-500">Rooms</dt>
            <dd className="font-medium">{accommodation.roomCount}</dd>
          </div>
        )}
        {accommodation.allInclusive !== null && (
          <div>
            <dt className="text-neutral-500">All-inclusive</dt>
            <dd className="font-medium">{accommodation.allInclusive ? "Yes" : "No"}</dd>
          </div>
        )}
        {accommodation.overwaterVillas !== null && (
          <div>
            <dt className="text-neutral-500">Overwater villas</dt>
            <dd className="font-medium">{accommodation.overwaterVillas ? "Yes" : "No"}</dd>
          </div>
        )}
        {primaryLocation && (
          <div>
            <dt className="text-neutral-500">Island</dt>
            <dd className="font-medium">
              <Link href={`/maldives/islands/${primaryLocation.slug}/`} className="hover:underline">
                {primaryLocation.title}
              </Link>
            </dd>
          </div>
        )}
        {atoll && (
          <div>
            <dt className="text-neutral-500">Atoll</dt>
            <dd className="font-medium">
              <Link href={`/maldives/atolls/${atoll.slug}/`} className="hover:underline">
                {atoll.title}
              </Link>
            </dd>
          </div>
        )}
        {accommodation.provider && (
          <div>
            <dt className="text-neutral-500">Operated by</dt>
            <dd className="font-medium">
              <Link href={`/maldives/providers/${accommodation.provider.slug}/`} className="hover:underline">
                {accommodation.provider.title}
              </Link>
            </dd>
          </div>
        )}
      </dl>

      <RoomsSection rooms={accommodation.rooms} accommodationTitle={accommodation.title} />

      <TypicalAmenitiesSection accommodationType={accommodation.accommodationType} />

      <NearbyActivitiesSection
        nearby={nearbyActivities}
        heading={`Things to Do Near ${accommodation.title}`}
        islandTitle={primaryLocation?.title ?? null}
        atollTitle={atoll?.title ?? null}
        viewAllHref="/maldives/activities/"
      />

      {(nearbyAttractions.islandAttractions.length > 0 || nearbyAttractions.atollAttractions.length > 0) && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Nearby Attractions</h2>
          <p className="mt-1 text-sm text-neutral-600">Real places to visit in the area — not bookable, just worth knowing about during your stay.</p>
          {nearbyAttractions.islandAttractions.length > 0 && (
            <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {nearbyAttractions.islandAttractions.map((attraction) => (
                <AttractionCard key={attraction.id} attraction={attraction} />
              ))}
            </ul>
          )}
          {nearbyAttractions.atollAttractions.length > 0 && (
            <div className="mt-6">
              <h3 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">More Attractions in {atoll?.title ?? "the Area"}</h3>
              <ul className="mt-3 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
                {nearbyAttractions.atollAttractions.map((attraction) => (
                  <AttractionCard key={attraction.id} attraction={attraction} />
                ))}
              </ul>
            </div>
          )}
          <Link href="/maldives/attractions/" className="mt-4 inline-block text-sm font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
            View all attractions →
          </Link>
        </section>
      )}

      {packages.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Packages featuring {accommodation.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {packages.map((pkg) => (
              <PackageCard key={pkg.id} pkg={pkg} />
            ))}
          </ul>
        </section>
      )}

      {transferRoutes.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Getting Here</h2>
          <p className="mt-1 text-sm text-neutral-600">Real, source-verified transfer routes to and from {primaryLocation?.title ?? accommodation.title}.</p>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {transferRoutes.slice(0, 6).map((route) => (
              <TransferRouteCard key={route.id} route={route} />
            ))}
          </ul>
          <Link href="/maldives/transfers/" className="mt-4 inline-block text-sm font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
            View all transfers →
          </Link>
        </section>
      )}

      {relatedGuides.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">{accommodation.title} Travel Guides</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {relatedGuides.map((article) => (
              <ArticleCard key={article.id} article={article} />
            ))}
          </ul>
        </section>
      )}

      <GallerySection images={accommodation.galleryImages} accommodationTitle={accommodation.title} />

      <VideoSection youtubeId={accommodation.videoYoutubeId} accommodationTitle={accommodation.title} />

      {accommodation.isBookable && (
        <section className="mt-10 rounded-2xl border border-neutral-200 p-6">
          <h2 className="text-xl font-semibold text-ocean-900">Request an Offer</h2>
          <p className="mt-1 text-sm text-neutral-600">
            Prices change with season and availability — tell us your dates and we&rsquo;ll send current rates for {accommodation.title}.
          </p>
          <div className="mt-4">
            <NodeInquiryForm
              productNodeId={accommodation.id}
              productTitle={accommodation.title}
              source="accommodation"
              submitLabel={bookingCta("accommodation").submitLabel}
            />
          </div>
        </section>
      )}
      </div>
    </main>
  );
}
