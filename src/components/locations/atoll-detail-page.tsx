import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";

import { AccommodationCard } from "@/components/accommodation/accommodation-card";
import { ActivityCard } from "@/components/activity/activity-card";
import { ArticleCard } from "@/components/articles/article-card";
import { DiveSiteCard } from "@/components/diving/dive-site-card";
import { IslandCard } from "@/components/locations/island-card";
import { PackageCard } from "@/components/packages/package-card";
import { SurfBreakCard } from "@/components/surfing/surf-break-card";
import { TransferRouteCard } from "@/components/transfers/transfer-route-card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { PageHero } from "@/components/ui/page-hero";
import { getAccommodationsByAtoll } from "@/lib/accommodations/repository";
import { getActivitiesByAtoll } from "@/lib/activities/repository";
import { getArticlesRelatedToNodes } from "@/lib/articles/repository";
import { getDiveSitesByAtoll } from "@/lib/diving/repository";
import { applyContextualLinks, escapeHtml } from "@/lib/linking/contextual-links";
import { buildEntityLinkMap } from "@/lib/linking/entity-link-map";
import { getAtollBySlug, getAtollContent, getIslandsByAtoll } from "@/lib/locations/repository";
import { LocationGallerySection } from "@/components/locations/location-gallery-section";
import { getHeroMediaByNodeIds, getMediaForNode } from "@/lib/media/repository";
import { getPackageViewsByAtoll } from "@/lib/packages/view-repository";
import { breadcrumbJsonLd, canonicalUrl } from "@/lib/seo/site";
import { getSurfBreaksByAtoll } from "@/lib/surfing/repository";
import { getTransferRoutesByAtoll } from "@/lib/transfers/repository";

function touristDestinationJsonLd(atoll: NonNullable<Awaited<ReturnType<typeof getAtollBySlug>>>) {
  return {
    "@context": "https://schema.org",
    "@type": "TouristDestination",
    name: atoll.title,
    description: atoll.summary ?? undefined,
    address: { "@type": "PostalAddress", addressCountry: "MV" },
    url: canonicalUrl(`/maldives/atolls/${atoll.slug}`),
  };
}

export async function atollDetailMetadata(slug: string): Promise<Metadata> {
  const atoll = await getAtollBySlug(slug);
  if (!atoll) return {};

  const title = atoll.metaTitle ?? `${atoll.title} | Maldives Atolls | MTG`;
  const description = atoll.metaDescription ?? atoll.summary ?? undefined;
  const url = canonicalUrl(`/maldives/atolls/${atoll.slug}`);

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
  };
}

export async function AtollDetailPage({ slug }: { slug: string }) {
  const atoll = await getAtollBySlug(slug);
  if (!atoll) notFound();

  const [heroById, allIslands, content, accommodations, activities, diveSites, surfBreaks, transferRoutes, packages, relatedGuides, entityMap, mediaItems] =
    await Promise.all([
      getHeroMediaByNodeIds([atoll.id]),
      getIslandsByAtoll(slug),
      getAtollContent(atoll.id),
      getAccommodationsByAtoll(atoll.id),
      getActivitiesByAtoll(atoll.id),
      getDiveSitesByAtoll(atoll.id),
      getSurfBreaksByAtoll(atoll.id),
      getTransferRoutesByAtoll(atoll.id),
      getPackageViewsByAtoll(atoll.id),
      getArticlesRelatedToNodes([atoll.id]),
      buildEntityLinkMap(),
      getMediaForNode(atoll.id),
    ]);
  const galleryImages = mediaItems.filter((m) => m.role === "gallery").map((m) => m.asset);

  // Contextual entity linking (Task 23 §67-68) over the atoll's own "About"
  // prose, same engine and rules as article bodies — never links the atoll's
  // own page.
  const aboutHtml =
    content && content.sections.length > 0
      ? applyContextualLinks(
          content.sections
            .map((s) => `<h3>${escapeHtml(s.heading)}</h3>${s.paragraphs.map((p) => `<p>${escapeHtml(p)}</p>`).join("")}`)
            .join(""),
          entityMap,
          { excludeHref: `/maldives/atolls/${atoll.slug}/` },
        )
      : null;
  const heroImage = heroById.get(atoll.id) ?? null;
  // getIslandsByAtoll returns every location_type="island" row under this
  // atoll, which now includes uninhabited resort islands (added in Task 5
  // to give resorts a real location to attach to) alongside the inhabited
  // islands Task 4 seeded — split them rather than mislabel the count.
  const islands = allIslands.filter((island) => island.isInhabited !== false);
  // Visit Maldives' own atoll pages consistently separate local-island
  // guesthouses/hotels from private-island resorts rather than listing
  // every stay together — real, verifiable structural pattern (checked
  // against their site), applied here with our own real accommodationType
  // data, not copied content.
  const resortAccommodations = accommodations.filter((a) => a.accommodationType === "resort");
  const localStayAccommodations = accommodations.filter((a) => a.accommodationType !== "resort");

  // See the identical split on the island page (Task 7, Task 8, Task 9):
  // fishing, diving, and surfing each have their own dedicated
  // vertical/section and canonical URL now.
  const fishingActivities = activities.filter((a) => a.activityCategory === "fishing");
  const divingActivities = activities.filter((a) => a.activityCategory === "diving");
  const surfingActivities = activities.filter((a) => a.activityCategory === "surfing");
  const otherActivities = activities.filter(
    (a) => a.activityCategory !== "fishing" && a.activityCategory !== "diving" && a.activityCategory !== "surfing",
  );

  return (
    <main>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(
            breadcrumbJsonLd(
              [{ label: "Maldives", href: "/maldives/" }, { label: "Atolls", href: "/maldives/atolls/" }, { label: atoll.title }],
              `/maldives/atolls/${atoll.slug}`,
            ),
          ),
        }}
      />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(touristDestinationJsonLd(atoll)) }} />

      <PageHero
        breadcrumbs={[
          { label: "Maldives", href: "/maldives/" },
          { label: "Atolls", href: "/maldives/atolls/" },
          { label: atoll.title },
        ]}
        eyebrow="Atoll"
        title={atoll.title}
        description={atoll.summary ?? undefined}
        image={heroImage}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
      <dl className="grid grid-cols-2 gap-4 text-sm sm:grid-cols-3">
        {atoll.administrativeCode && (
          <div>
            <dt className="text-neutral-500">Administrative code</dt>
            <dd className="font-medium">{atoll.administrativeCode}</dd>
          </div>
        )}
        <div>
          <dt className="text-neutral-500">Inhabited islands</dt>
          <dd className="font-medium">{islands.length}</dd>
        </div>
      </dl>

      {aboutHtml && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">About {atoll.title}</h2>
          <div
            className="[&_h3]:mt-5 [&_h3]:text-base [&_h3]:font-semibold [&_h3]:text-ocean-900 [&_p]:mt-2 [&_p]:text-sm [&_p]:leading-relaxed [&_p]:text-neutral-700 [&_a]:text-maldives-600 [&_a]:underline"
            dangerouslySetInnerHTML={{ __html: aboutHtml }}
          />
        </section>
      )}

      <LocationGallerySection title={atoll.title} images={galleryImages} />

      <section className="mt-10">
        <h2 className="text-xl font-semibold text-ocean-900">Islands in {atoll.title}</h2>
        {islands.length === 0 ? (
          <p className="mt-2 text-sm text-neutral-600">No islands recorded for this atoll yet.</p>
        ) : (
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {islands.map((island) => (
              <IslandCard key={island.id} island={island} />
            ))}
          </ul>
        )}
      </section>

      {resortAccommodations.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Resorts in {atoll.title}</h2>
          <p className="mt-1 text-sm text-neutral-600">Private island resorts, each its own destination.</p>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {resortAccommodations.map((accommodation) => (
              <AccommodationCard key={accommodation.id} accommodation={accommodation} />
            ))}
          </ul>
        </section>
      )}

      {localStayAccommodations.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Guesthouses & Hotels in {atoll.title}</h2>
          <p className="mt-1 text-sm text-neutral-600">Stays on real local islands, inside their communities.</p>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {localStayAccommodations.map((accommodation) => (
              <AccommodationCard key={accommodation.id} accommodation={accommodation} />
            ))}
          </ul>
        </section>
      )}

      {fishingActivities.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Fishing in {atoll.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {fishingActivities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </section>
      )}

      {divingActivities.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Diving in {atoll.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {divingActivities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </section>
      )}

      {diveSites.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Dive sites in {atoll.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {diveSites.map((site) => (
              <DiveSiteCard key={site.id} site={site} />
            ))}
          </ul>
        </section>
      )}

      {surfingActivities.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Surfing in {atoll.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {surfingActivities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </section>
      )}

      {surfBreaks.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Surf breaks in {atoll.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {surfBreaks.map((surfBreak) => (
              <SurfBreakCard key={surfBreak.id} surfBreak={surfBreak} />
            ))}
          </ul>
        </section>
      )}

      {otherActivities.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Activities in {atoll.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {otherActivities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </section>
      )}

      {transferRoutes.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Transfers in {atoll.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {transferRoutes.map((route) => (
              <TransferRouteCard key={route.id} route={route} />
            ))}
          </ul>
        </section>
      )}

      {packages.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Packages featuring {atoll.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {packages.map((pkg) => (
              <PackageCard key={pkg.id} pkg={pkg} />
            ))}
          </ul>
        </section>
      )}

      {relatedGuides.length > 0 && (
        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">{atoll.title} Travel Guides</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {relatedGuides.map((article) => (
              <ArticleCard key={article.id} article={article} />
            ))}
          </ul>
        </section>
      )}

      <p className="mt-10 text-sm text-neutral-600">
        <Link href="/maldives/atolls/" className="font-medium text-maldives-600 hover:underline">
          Explore other Maldives atolls →
        </Link>
      </p>

      {content && (
        <p className="mt-4 text-xs text-neutral-500">
          Destination content on this page is drawn from MTG&rsquo;s own previously published Maldives guide.
        </p>
      )}
      </div>
    </main>
  );
}
