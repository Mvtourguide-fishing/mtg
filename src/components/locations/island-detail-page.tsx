import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";

import { AccommodationCard } from "@/components/accommodation/accommodation-card";
import { ActivityCard } from "@/components/activity/activity-card";
import { ArticleCard } from "@/components/articles/article-card";
import { AttractionCard } from "@/components/attractions/attraction-card";
import { DiveSiteCard } from "@/components/diving/dive-site-card";
import { IslandCard } from "@/components/locations/island-card";
import { PackageCard } from "@/components/packages/package-card";
import { SurfBreakCard } from "@/components/surfing/surf-break-card";
import { TransferRouteCard } from "@/components/transfers/transfer-route-card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { PageHero } from "@/components/ui/page-hero";
import { LocationMap } from "@/components/locations/location-map";
import { getAccommodationsByLocation } from "@/lib/accommodations/repository";
import { getActivitiesByLocation } from "@/lib/activities/repository";
import { getArticlesRelatedToNodes } from "@/lib/articles/repository";
import { getAttractionsByIsland } from "@/lib/attractions/repository";
import { getDiveSitesByLocation } from "@/lib/diving/repository";
import { applyContextualLinks, escapeHtml } from "@/lib/linking/contextual-links";
import { buildEntityLinkMap } from "@/lib/linking/entity-link-map";
import { LocationGallerySection } from "@/components/locations/location-gallery-section";
import { getChildLocations, getIslandBySlug, getIslandContent } from "@/lib/locations/repository";
import { getNearbyIslands } from "@/lib/locations/nearby-islands";
import { getHeroMediaByNodeIds, getMediaForNode } from "@/lib/media/repository";
import { getPackageViewsByLocation } from "@/lib/packages/view-repository";
import { breadcrumbJsonLd, canonicalUrl } from "@/lib/seo/site";
import { getSurfBreaksByLocation } from "@/lib/surfing/repository";
import { createClient } from "@/lib/supabase/public";
import { getTransferRoutesByLocation } from "@/lib/transfers/repository";

const NEARBY_ISLANDS_LIMIT = 6;

async function getAtollSummary(atollId: string | null) {
  if (!atollId) return null;
  const supabase = await createClient();
  const { data } = await supabase
    .from("nodes")
    .select("slug, title")
    .eq("id", atollId)
    .eq("node_type", "location")
    .maybeSingle<{ slug: string; title: string }>();
  return data;
}

function touristDestinationJsonLd(
  island: NonNullable<Awaited<ReturnType<typeof getIslandBySlug>>>,
  atoll: { slug: string; title: string } | null,
) {
  return {
    "@context": "https://schema.org",
    "@type": "TouristDestination",
    name: island.title,
    description: island.summary ?? undefined,
    address: atoll ? { "@type": "PostalAddress", addressRegion: atoll.title, addressCountry: "MV" } : { "@type": "PostalAddress", addressCountry: "MV" },
    url: canonicalUrl(`/maldives/islands/${island.slug}`),
  };
}

export async function islandDetailMetadata(slug: string): Promise<Metadata> {
  const island = await getIslandBySlug(slug);
  if (!island) return {};

  const title = island.metaTitle ?? `${island.title}, Maldives | Things to Do, Stays & Travel Guide | MTG`;
  const description = island.metaDescription ?? island.summary ?? undefined;
  const url = canonicalUrl(`/maldives/islands/${island.slug}`);

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
  };
}

export async function IslandDetailPage({ slug }: { slug: string }) {
  const island = await getIslandBySlug(slug);
  if (!island) notFound();

  const [atoll, children, accommodations, activities, attractions, diveSites, surfBreaks, transferRoutes, packages, heroById, content] =
    await Promise.all([
      getAtollSummary(island.parentId),
      getChildLocations(island.id),
      getAccommodationsByLocation(island.id),
      getActivitiesByLocation(island.id),
      getAttractionsByIsland(island.id),
      getDiveSitesByLocation(island.id),
      getSurfBreaksByLocation(island.id),
      getTransferRoutesByLocation(island.id),
      getPackageViewsByLocation(island.id),
      getHeroMediaByNodeIds([island.id]),
      getIslandContent(island.id),
    ]);
  const heroImage = heroById.get(island.id) ?? null;

  const [nearbyIslands, relatedGuides, entityMap, mediaItems] = await Promise.all([
    getNearbyIslands({ id: island.id, parentId: island.parentId }, content?.nearbyIslandSlugs ?? [], NEARBY_ISLANDS_LIMIT),
    getArticlesRelatedToNodes([island.id, island.parentId].filter((id): id is string => Boolean(id))),
    buildEntityLinkMap(),
    getMediaForNode(island.id),
  ]);
  const galleryImages = mediaItems.filter((m) => m.role === "gallery").map((m) => m.asset);

  // Contextual entity linking (Task 23 §67-68) over the island's own "About"
  // prose — same engine as travel-guide articles, applied once across all
  // overview + section paragraphs together so an entity mentioned in one
  // paragraph isn't re-linked in the next. Never links the island's own page.
  const aboutHtml =
    content && (content.overview.length > 0 || content.sections.length > 0)
      ? applyContextualLinks(
          [
            ...content.overview.map((p) => `<p>${escapeHtml(p)}</p>`),
            ...content.sections.map(
              (s) => `<h3>${escapeHtml(s.heading)}</h3>${s.paragraphs.map((p) => `<p>${escapeHtml(p)}</p>`).join("")}`,
            ),
          ].join(""),
          entityMap,
          { excludeHref: `/maldives/islands/${island.slug}/` },
        )
      : null;

  // Fishing, diving, and surfing each have their own dedicated
  // vertical/section (Task 7, Task 8, Task 9) and, per
  // ACTIVITY_CATEGORY_SEGMENT, their own canonical URL — split them out of
  // the generic activity list rather than showing them twice.
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
              [
                { label: "Maldives", href: "/maldives/" },
                { label: "Islands", href: "/maldives/islands/" },
                ...(atoll ? [{ label: atoll.title, href: `/maldives/atolls/${atoll.slug}/` }] : []),
                { label: island.title },
              ],
              `/maldives/islands/${island.slug}`,
            ),
          ),
        }}
      />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(touristDestinationJsonLd(island, atoll)) }} />

      <PageHero
        breadcrumbs={[
          { label: "Maldives", href: "/maldives/" },
          { label: "Islands", href: "/maldives/islands/" },
          ...(atoll ? [{ label: atoll.title, href: `/maldives/atolls/${atoll.slug}/` }] : []),
          { label: island.title },
        ]}
        eyebrow="Island"
        title={island.title}
        description={island.summary ?? undefined}
        image={heroImage}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
      <dl className="grid grid-cols-2 gap-4 text-sm sm:grid-cols-3">
        <div>
          <dt className="text-neutral-500">Location type</dt>
          <dd className="font-medium capitalize">{island.locationType}</dd>
        </div>
        {island.isInhabited !== null && (
          <div>
            <dt className="text-neutral-500">Inhabited</dt>
            <dd className="font-medium">{island.isInhabited ? "Yes" : "No"}</dd>
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
      </dl>

      <LocationMap title={island.title} lat={island.lat} lng={island.lng} />

      {content && content.quickFacts.length > 0 && (
        <section className="mt-8 rounded-2xl border border-neutral-200 bg-sand-50 p-6">
          <h2 className="text-lg font-semibold text-ocean-900">Quick Facts</h2>
          <dl className="mt-4 grid grid-cols-1 gap-4 text-sm sm:grid-cols-2">
            {content.quickFacts.map((fact) => (
              <div key={fact.label}>
                <dt className="text-neutral-500">{fact.label}</dt>
                <dd className="font-medium">{fact.value}</dd>
              </div>
            ))}
          </dl>
        </section>
      )}

      {aboutHtml && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">About {island.title}</h2>
          <div
            className="[&_h3]:mt-5 [&_h3]:text-base [&_h3]:font-semibold [&_h3]:text-ocean-900 [&_p]:mt-3 [&_p]:text-sm [&_p]:leading-relaxed [&_p]:text-neutral-700 [&_a]:text-maldives-600 [&_a]:underline"
            dangerouslySetInnerHTML={{ __html: aboutHtml }}
          />
        </section>
      )}

      <LocationGallerySection title={island.title} images={galleryImages} />

      {children.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">On this island</h2>
          <ul className="mt-4 grid grid-cols-2 gap-x-6 gap-y-2 sm:grid-cols-3">
            {children.map((child) => (
              <li key={child.id} className="capitalize">
                {child.title}
                <span className="ml-1 text-xs text-neutral-500">({child.locationType.replace("_", " ")})</span>
              </li>
            ))}
          </ul>
        </section>
      )}

      {accommodations.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Where to Stay on {island.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {accommodations.map((accommodation) => (
              <AccommodationCard key={accommodation.id} accommodation={accommodation} />
            ))}
          </ul>
        </section>
      )}

      {attractions.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Attractions on {island.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {attractions.map((attraction) => (
              <AttractionCard key={attraction.id} attraction={attraction} />
            ))}
          </ul>
        </section>
      )}

      {fishingActivities.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Fishing on {island.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {fishingActivities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </section>
      )}

      {divingActivities.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Diving on {island.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {divingActivities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </section>
      )}

      {diveSites.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Dive sites near {island.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {diveSites.map((site) => (
              <DiveSiteCard key={site.id} site={site} />
            ))}
          </ul>
        </section>
      )}

      {surfingActivities.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Surfing on {island.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {surfingActivities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </section>
      )}

      {surfBreaks.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Surf breaks near {island.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {surfBreaks.map((surfBreak) => (
              <SurfBreakCard key={surfBreak.id} surfBreak={surfBreak} />
            ))}
          </ul>
        </section>
      )}

      {otherActivities.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Activities on {island.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {otherActivities.map((activity) => (
              <ActivityCard key={activity.id} activity={activity} />
            ))}
          </ul>
        </section>
      )}

      {transferRoutes.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Getting to {island.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {transferRoutes.map((route) => (
              <TransferRouteCard key={route.id} route={route} />
            ))}
          </ul>
        </section>
      )}

      {packages.length > 0 && (
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Packages featuring {island.title}</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {packages.map((pkg) => (
              <PackageCard key={pkg.id} pkg={pkg} />
            ))}
          </ul>
        </section>
      )}

      {content && content.faqs.length > 0 && (
        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Frequently Asked Questions</h2>
          <dl className="mt-4 space-y-6">
            {content.faqs.map((faq) => (
              <div key={faq.question}>
                <dt className="font-medium text-ocean-900">{faq.question}</dt>
                <dd className="mt-1 text-sm text-neutral-700">{faq.answer}</dd>
              </div>
            ))}
          </dl>
        </section>
      )}

      {nearbyIslands.length > 0 && (
        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Nearby Islands</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {nearbyIslands.map((nearby) => (
              <IslandCard key={nearby.id} island={nearby} />
            ))}
          </ul>
        </section>
      )}

      {relatedGuides.length > 0 && (
        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">{island.title} Travel Guides</h2>
          <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {relatedGuides.map((article) => (
              <ArticleCard key={article.id} article={article} />
            ))}
          </ul>
        </section>
      )}

      {atoll && (
        <p className="mt-10 text-sm text-neutral-600">
          <Link href={`/maldives/atolls/${atoll.slug}/`} className="font-medium text-maldives-600 hover:underline">
            Explore all of {atoll.title} →
          </Link>
        </p>
      )}

      {content && (
        <p className="mt-4 text-xs text-neutral-500">
          Destination content on this page is drawn from MTG&rsquo;s own previously published Maldives guide.
        </p>
      )}
      </div>
    </main>
  );
}
