import type { Metadata } from "next";
import { notFound } from "next/navigation";

import Link from "next/link";

import { AccommodationCard } from "@/components/accommodation/accommodation-card";
import { ActivityCard } from "@/components/activity/activity-card";
import { CARD_CLASS } from "@/components/ui/card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import { PageHero } from "@/components/ui/page-hero";
import { getAccommodationsByProvider } from "@/lib/accommodations/repository";
import { getActivitiesByProvider } from "@/lib/activities/repository";
import { getProviderBySlug } from "@/lib/providers/repository";
import { canonicalUrl } from "@/lib/seo/site";
import { getTransferServicesByProvider } from "@/lib/transfers/repository";

const TRANSFER_TYPE_LABEL: Record<string, string> = {
  speedboat: "Speedboat",
  seaplane: "Seaplane",
  domestic_flight: "Domestic Flight",
  ferry: "Ferry",
  private_yacht: "Private Yacht",
  land_transfer: "Land Transfer",
};

export const revalidate = 3600;

interface Params {
  provider: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { provider: slug } = await params;
  const provider = await getProviderBySlug(slug);
  if (!provider) return {};

  const title = provider.metaTitle ?? `${provider.title} | Maldives Providers | MTG`;
  const description = provider.metaDescription ?? provider.summary ?? undefined;
  const url = canonicalUrl(`/maldives/providers/${provider.slug}`);

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
  };
}

export default async function ProviderDetailPage({ params }: { params: Promise<Params> }) {
  const { provider: slug } = await params;
  const provider = await getProviderBySlug(slug);
  if (!provider) notFound();

  const [accommodations, activities, transferServices] = await Promise.all([
    getAccommodationsByProvider(provider.id),
    getActivitiesByProvider(provider.id),
    getTransferServicesByProvider(provider.id),
  ]);
  // See the identical split on the island/atoll pages (Task 7, Task 8, Task 9).
  const fishingActivities = activities.filter((a) => a.activityCategory === "fishing");
  const divingActivities = activities.filter((a) => a.activityCategory === "diving");
  const surfingActivities = activities.filter((a) => a.activityCategory === "surfing");
  const otherActivities = activities.filter(
    (a) => a.activityCategory !== "fishing" && a.activityCategory !== "diving" && a.activityCategory !== "surfing",
  );
  const hasAnyContent = accommodations.length > 0 || activities.length > 0 || transferServices.length > 0;

  return (
    <main>
      <PageHero
        breadcrumbs={[
          { label: "Maldives", href: "/maldives/" },
          { label: "Providers", href: "/maldives/providers/" },
          { label: provider.title },
        ]}
        eyebrow="Provider"
        title={provider.title}
        description={provider.summary ?? undefined}
        meta={
          provider.websiteUrl ? (
            <a href={provider.websiteUrl} target="_blank" rel="noopener noreferrer" className="text-maldives-600 underline">
              {provider.websiteUrl}
            </a>
          ) : undefined
        }
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
      {/* Task 17 audit: a newly created provider with nothing linked yet
          (reachable via the admin "new provider" flow) previously rendered
          only the PageHero with a blank content area below it. */}
      {!hasAnyContent && (
        <EmptyState
          title={`No listings linked to ${provider.title} yet`}
          description="Check back soon — accommodation, activities, and transfer services operated by this provider will appear here once added."
        />
      )}
      {accommodations.length > 0 && (
        <section>
          <h2 className="text-xl font-semibold text-ocean-900">Accommodation operated by {provider.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2">
            {accommodations.map((accommodation) => (
              <AccommodationCard key={accommodation.id} accommodation={accommodation} />
            ))}
          </ul>
        </section>
      )}

      {fishingActivities.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Fishing operated by {provider.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2">
            {fishingActivities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </section>
      )}

      {divingActivities.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Diving operated by {provider.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2">
            {divingActivities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </section>
      )}

      {surfingActivities.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Surfing operated by {provider.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2">
            {surfingActivities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </section>
      )}

      {otherActivities.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Activities operated by {provider.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2">
            {otherActivities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </section>
      )}

      {transferServices.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Transfer services operated by {provider.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2">
            {transferServices.map((service) => (
              <li key={service.id} className={CARD_CLASS}>
                <Link href={`/maldives/transfers/${service.route.slug}/`} className="text-lg font-medium text-ocean-900 transition-colors hover:text-maldives-600">
                  {service.route.title}
                </Link>
                <div className="mt-1 flex flex-wrap gap-x-3 gap-y-1 text-sm text-neutral-600">
                  <span>{TRANSFER_TYPE_LABEL[service.transferType] ?? service.transferType}</span>
                  <span className="capitalize">{service.sharedOrPrivate}</span>
                  <span>
                    {service.currency} {service.price}
                  </span>
                </div>
              </li>
            ))}
          </ul>
        </section>
      )}
      </div>
    </main>
  );
}
