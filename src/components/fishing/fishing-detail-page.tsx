import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";

import { WhereToStaySection } from "@/components/accommodation/where-to-stay-section";
import { NodeInquiryToggle } from "@/components/bookings/node-inquiry-toggle";
import { PackageCard } from "@/components/packages/package-card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { MediaImage } from "@/components/ui/media-image";
import { PageHero } from "@/components/ui/page-hero";
import { getNearbyAccommodations } from "@/lib/accommodations/repository";
import { activityServiceJsonLd } from "@/lib/activities/types";
import { bookingCta } from "@/lib/bookings/copy";
import { getFishingActivitiesByLocation, getFishingActivityBySlug, getFishingTypesForActivity } from "@/lib/fishing/repository";
import { getPackageViewsByActivity } from "@/lib/packages/view-repository";
import { breadcrumbJsonLd, canonicalUrl } from "@/lib/seo/site";

function formatDuration(minutes: number | null): string | null {
  if (!minutes) return null;
  if (minutes < 60) return `${minutes} minutes`;
  const hours = minutes / 60;
  return Number.isInteger(hours) ? `${hours} hour${hours === 1 ? "" : "s"}` : `${hours.toFixed(1)} hours`;
}

export async function fishingDetailMetadata(slug: string): Promise<Metadata> {
  const activity = await getFishingActivityBySlug(slug);
  if (!activity) return {};

  const title = activity.metaTitle ?? `${activity.title} | Maldives Fishing | MTG`;
  const description = activity.metaDescription ?? activity.summary ?? undefined;
  const url = canonicalUrl(`/maldives/fishing/${activity.slug}`);

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
  };
}

export async function FishingDetailPage({ slug }: { slug: string }) {
  const activity = await getFishingActivityBySlug(slug);
  if (!activity) notFound();

  const { primaryLocation, atoll } = activity;
  const duration = formatDuration(activity.durationMinutes);

  const [fishingTypes, sameIslandTrips, packages, nearbyStays] = await Promise.all([
    getFishingTypesForActivity(activity.id),
    primaryLocation ? getFishingActivitiesByLocation(primaryLocation.id) : Promise.resolve([]),
    getPackageViewsByActivity(activity.id),
    getNearbyAccommodations({ islandId: primaryLocation?.id ?? null, atollId: atoll?.id ?? null }),
  ]);
  const relatedTrips = sameIslandTrips.filter((t) => t.id !== activity.id).slice(0, 4);

  return (
    <main>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(
            breadcrumbJsonLd(
              [{ label: "Maldives", href: "/maldives/" }, { label: "Fishing", href: "/maldives/fishing/" }, { label: activity.title }],
              `/maldives/fishing/${activity.slug}`,
            ),
          ),
        }}
      />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(activityServiceJsonLd(activity)) }} />

      <PageHero
        breadcrumbs={[
          { label: "Maldives", href: "/maldives/" },
          { label: "Fishing", href: "/maldives/fishing/" },
          { label: activity.title },
        ]}
        eyebrow="Fishing"
        title={activity.title}
        description={activity.summary ?? undefined}
        image={activity.heroImage}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
      {activity.gallery.length > 0 && (
        <div className="grid grid-cols-2 gap-2 sm:grid-cols-3">
          {activity.gallery.map((asset) => (
            <MediaImage key={asset.id} asset={asset} alt={activity.title} aspectClassName="aspect-[4/3]" />
          ))}
        </div>
      )}
      {fishingTypes.length > 0 && (
        <div className="flex flex-wrap gap-2">
          {fishingTypes.map((type) => (
            <Link
              key={type.id}
              href={`/maldives/fishing/?type=${type.slug}`}
              className="rounded-full border border-neutral-300 px-3 py-1 text-xs text-neutral-700"
            >
              {type.title}
            </Link>
          ))}
        </div>
      )}

      <dl className="mt-6 grid grid-cols-2 gap-4 text-sm sm:grid-cols-3">
        {duration && (
          <div>
            <dt className="text-neutral-500">Duration</dt>
            <dd className="font-medium">{duration}</dd>
          </div>
        )}
        {activity.maxParticipants !== null && (
          <div>
            <dt className="text-neutral-500">Max participants</dt>
            <dd className="font-medium">{activity.maxParticipants}</dd>
          </div>
        )}
        {activity.priceFrom !== null && (
          <div>
            <dt className="text-neutral-500">Price from</dt>
            <dd className="font-medium">
              {activity.currency ?? "USD"} {activity.priceFrom}
            </dd>
          </div>
        )}
        {primaryLocation && (
          <div>
            <dt className="text-neutral-500">Location</dt>
            <dd className="font-medium">
              <Link
                href={
                  primaryLocation.locationType === "island"
                    ? `/maldives/islands/${primaryLocation.slug}/`
                    : `/maldives/atolls/${primaryLocation.slug}/`
                }
                className="hover:underline"
              >
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
        {activity.provider && (
          <div>
            <dt className="text-neutral-500">Operated by</dt>
            <dd className="font-medium">
              <Link href={`/maldives/providers/${activity.provider.slug}/`} className="hover:underline">
                {activity.provider.title}
              </Link>
            </dd>
          </div>
        )}
      </dl>

      {activity.isBookable && (
        <section className="mt-6 rounded-2xl border border-neutral-200 p-6">
          <h2 className="text-xl font-semibold text-ocean-900">{bookingCta("fishing").toggleLabel}</h2>
          <p className="mt-1 text-sm text-neutral-600">Tell us your preferred date and group size and we&rsquo;ll follow up on availability.</p>
          <div className="mt-4">
            <NodeInquiryToggle
              productNodeId={activity.id}
              productTitle={activity.title}
              source="fishing"
              toggleLabel={bookingCta("fishing").toggleLabel}
              submitLabel={bookingCta("fishing").submitLabel}
              showNumberOfDays
            />
          </div>
        </section>
      )}

      {relatedTrips.length > 0 && primaryLocation && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Other fishing trips on {primaryLocation.title}</h2>
          <ul className="mt-4 space-y-2 text-sm">
            {relatedTrips.map((trip) => (
              <li key={trip.id}>
                <Link href={`/maldives/fishing/${trip.slug}/`} className="text-maldives-600 hover:text-ocean-800 hover:underline">
                  {trip.title}
                </Link>
              </li>
            ))}
          </ul>
        </section>
      )}

      {packages.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Packages featuring {activity.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {packages.map((pkg) => (
              <PackageCard key={pkg.id} pkg={pkg} />
            ))}
          </ul>
        </section>
      )}

      <WhereToStaySection nearby={nearbyStays} islandTitle={primaryLocation?.title ?? null} atollTitle={atoll?.title ?? null} />
      </div>
    </main>
  );
}
