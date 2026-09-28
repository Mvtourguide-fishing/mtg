import type { Metadata } from "next";
import Link from "next/link";

import { AccommodationCard } from "@/components/accommodation/accommodation-card";
import { ActivityCard } from "@/components/activity/activity-card";
import { ArticleCard } from "@/components/articles/article-card";
import { AttractionCard } from "@/components/attractions/attraction-card";
import { PackageCard } from "@/components/packages/package-card";
import { SearchBox } from "@/components/search/search-box";
import { TransferRouteCard } from "@/components/transfers/transfer-route-card";
import { Button } from "@/components/ui/button";
import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { Container } from "@/components/ui/container";
import { CompassIcon, DivingIcon, FishIcon, MapPinIcon } from "@/components/ui/icons";
import { MediaImage } from "@/components/ui/media-image";
import { SectionHeader } from "@/components/ui/section-header";
import { getAccommodations } from "@/lib/accommodations/repository";
import { getActivities } from "@/lib/activities/repository";
import { getRecentArticles } from "@/lib/articles/repository";
import { getAttractions } from "@/lib/attractions/repository";
import { getAtolls } from "@/lib/locations/repository";
import { getFeaturedPackageViews } from "@/lib/packages/view-repository";
import { canonicalUrl } from "@/lib/seo/site";
import { getTransferRoutes } from "@/lib/transfers/repository";

export const revalidate = 3600;

const WHATSAPP_URL = "https://wa.me/9607794332";

export function generateMetadata(): Metadata {
  const title = "Maldives Tour Guide (MTG)";
  const description =
    "A real, source-verified travel guide to the Maldives — atolls, islands, resorts, hotels, guesthouses, activities, diving, fishing, surfing, transfers and packages.";
  const url = canonicalUrl("/");

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
  };
}

export default async function Home() {
  const [atolls, accommodations, activities, attractions, transferRoutes, packages, articles] = await Promise.all([
    getAtolls(),
    getAccommodations({ type: "resort", pageSize: 6 }),
    getActivities({ pageSize: 6 }),
    getAttractions({ pageSize: 6 }),
    getTransferRoutes({ pageSize: 4 }),
    getFeaturedPackageViews(6),
    getRecentArticles(3),
  ]);

  const islandCount = atolls.reduce((sum, atoll) => sum + atoll.islandCount, 0);
  const featuredAtolls = atolls.slice(0, 6);

  return (
    <main className="flex-1">
      {/* Hero — no stock imagery is used (none is available in this
          dataset yet); the ocean gradient + real counts carry the section
          instead of a placeholder photo. */}
      <section className="bg-gradient-to-br from-ocean-950 via-ocean-800 to-maldives-600 text-white">
        <Container className="py-16 sm:py-24">
          <p className="text-xs font-semibold uppercase tracking-wide text-lagoon-200">Maldives Tour Guide</p>
          <h1 className="mt-3 max-w-2xl text-4xl font-semibold tracking-tight sm:text-5xl">
            A real, source-verified guide to the Maldives
          </h1>
          <p className="mt-4 max-w-xl text-lg text-lagoon-100">
            Atolls, islands, resorts, hotels and guesthouses, activities, diving, fishing, surfing, transfers and
            travel packages — researched and kept up to date, not generated.
          </p>
          <div className="mt-6 max-w-xl">
            <SearchBox variant="inline" placeholder="Search islands, resorts, activities…" />
          </div>
          <div className="mt-6 flex flex-wrap gap-3">
            <Button href="/maldives/" variant="inverted" size="md">
              Explore the Maldives
            </Button>
            <Button href="/maldives/packages/" variant="secondary" size="md" className="border-white/30 bg-white/10 text-white hover:bg-white/20">
              See travel packages
            </Button>
          </div>
          <dl className="mt-10 flex flex-wrap gap-x-8 gap-y-3 text-sm text-lagoon-100">
            <div>
              <dt className="sr-only">Administrative atolls</dt>
              <dd>
                <span className="text-lg font-semibold text-white">{atolls.length}</span> atolls
              </dd>
            </div>
            <div>
              <dt className="sr-only">Inhabited islands</dt>
              <dd>
                <span className="text-lg font-semibold text-white">{islandCount}</span> inhabited islands
              </dd>
            </div>
            <div>
              <dt className="sr-only">Places to stay</dt>
              <dd>
                <span className="text-lg font-semibold text-white">{accommodations.total}+</span> resorts listed
              </dd>
            </div>
          </dl>
        </Container>
      </section>

      {/* Explore Maldives */}
      {featuredAtolls.length > 0 && (
        <section className="py-14 sm:py-20">
          <Container>
            <SectionHeader
              eyebrow="Destinations"
              title="Explore the Maldives"
              description="26 natural atolls, grouped into administrative atolls — each with its own inhabited islands."
              action={{ label: "View all atolls", href: "/maldives/atolls/" }}
            />
            <ul className="mt-8 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-6">
              {featuredAtolls.map((atoll) => (
                <li key={atoll.id} className={CARD_CLASS}>
                  <Link href={`/maldives/atolls/${atoll.slug}/`} className="group flex h-full flex-col justify-between">
                    {atoll.heroImage ? (
                      <div className={CARD_IMAGE_BLEED_CLASS}>
                        <MediaImage asset={atoll.heroImage} alt={atoll.title} aspectClassName="aspect-square" />
                      </div>
                    ) : (
                      <MapPinIcon className="h-5 w-5 text-maldives-600" />
                    )}
                    <div className="mt-3">
                      <p className="font-medium text-ocean-900 group-hover:text-maldives-600">{atoll.title}</p>
                      <p className="mt-0.5 text-xs text-neutral-500">
                        {atoll.islandCount} island{atoll.islandCount === 1 ? "" : "s"}
                      </p>
                    </div>
                  </Link>
                </li>
              ))}
            </ul>
          </Container>
        </section>
      )}

      {/* Places to Stay */}
      {accommodations.items.length > 0 && (
        <section className="bg-sand-50 py-14 sm:py-20">
          <Container>
            <SectionHeader
              eyebrow="Places to stay"
              title="Resorts, hotels and guesthouses"
              description="Real, individually verified accommodation across the Maldives."
              action={{ label: "Browse all resorts", href: "/maldives/resorts/" }}
            />
            <ul className="mt-8 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {accommodations.items.map((accommodation) => (
                <AccommodationCard key={accommodation.id} accommodation={accommodation} />
              ))}
            </ul>
            <div className="mt-6 flex flex-wrap gap-3 text-sm">
              <Link href="/maldives/hotels/" className="font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
                Hotels →
              </Link>
              <Link href="/maldives/guesthouses/" className="font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
                Guesthouses →
              </Link>
            </div>
          </Container>
        </section>
      )}

      {/* Things to Do */}
      {activities.items.length > 0 && (
        <section className="py-14 sm:py-20">
          <Container>
            <SectionHeader
              eyebrow="Things to do"
              title="Activities, diving, fishing and surfing"
              description="Real operators and activities, sourced island by island."
              action={{ label: "View all activities", href: "/maldives/activities/" }}
            />
            <ul className="mt-8 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {activities.items.map((activity) => (
                <ActivityCard key={activity.id} activity={activity} />
              ))}
            </ul>
            <div className="mt-6 flex flex-wrap gap-x-5 gap-y-2 text-sm">
              <Link href="/maldives/diving/" className="inline-flex items-center gap-1.5 font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
                <DivingIcon className="h-4 w-4" /> Diving
              </Link>
              <Link href="/maldives/fishing/" className="inline-flex items-center gap-1.5 font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
                <FishIcon className="h-4 w-4" /> Fishing
              </Link>
              <Link href="/maldives/surfing/" className="inline-flex items-center gap-1.5 font-medium text-maldives-600 hover:text-ocean-800 hover:underline">
                <CompassIcon className="h-4 w-4" /> Surfing
              </Link>
            </div>
          </Container>
        </section>
      )}

      {/* Attractions — deliberately its own section, not folded into
          Things to Do: an attraction is a place to see, not a bookable
          activity (Task 15 §21). */}
      {attractions.items.length > 0 && (
        <section className="py-14 sm:py-20">
          <Container>
            <SectionHeader
              eyebrow="Places to visit"
              title="Maldives Attractions"
              description="Real, individually documented landmarks, museums, monuments and public beaches — not bookable, but part of any Maldives trip."
              action={{ label: "Explore Maldives attractions", href: "/maldives/attractions/" }}
            />
            <ul className="mt-8 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {attractions.items.map((attraction) => (
                <AttractionCard key={attraction.id} attraction={attraction} />
              ))}
            </ul>
          </Container>
        </section>
      )}

      {/* Getting Around */}
      {transferRoutes.items.length > 0 && (
        <section className="bg-sand-50 py-14 sm:py-20">
          <Container>
            <SectionHeader
              eyebrow="Getting around"
              title="Maldives Transfers"
              description="Real airport, speedboat, resort and island transfer routes from Velana International Airport, with source-verified prices."
              action={{ label: "Find your transfer", href: "/maldives/transfers/" }}
            />
            <nav aria-label="Transfer categories" className="mt-4 flex flex-wrap gap-2">
              {[
                { href: "/maldives/airport-transfers/", label: "Airport Transfers" },
                { href: "/maldives-speedboats-charter/", label: "Private Speedboats" },
                { href: "/maldives/island-transfers/", label: "Island Transfers" },
              ].map((link) => (
                <Link key={link.href} href={link.href} className="rounded-full border border-neutral-300 bg-white px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
                  {link.label}
                </Link>
              ))}
            </nav>
            <ul className="mt-8 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-4">
              {transferRoutes.items.map((route) => (
                <TransferRouteCard key={route.id} route={route} />
              ))}
            </ul>
          </Container>
        </section>
      )}

      {/* Packages — a curated mix of the real, verified packages plus a
          diverse spread of demo listings (Task 21) while commercial
          inventory grows; never all 20-plus at once (Task 21 §44). */}
      {packages.length > 0 && (
        <section className="py-14 sm:py-20">
          <Container>
            <SectionHeader
              eyebrow="Packages"
              title="Maldives holiday packages"
              description="Multi-day itineraries built from real accommodation, activities and transfers — honeymoon, family, diving, fishing, surfing, luxury and budget."
              action={{ label: "View all packages", href: "/maldives/packages/" }}
            />
            <ul className="mt-8 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
              {packages.map((pkg) => (
                <PackageCard key={pkg.id} pkg={pkg} />
              ))}
            </ul>
          </Container>
        </section>
      )}

      {/* Travel Guide — real migrated articles (Task 14) only; nothing
          renders here when there are none. */}
      {articles.length > 0 && (
        <section className="bg-sand-50 py-14 sm:py-20">
          <Container>
            <SectionHeader
              eyebrow="Travel Guide"
              title="In-depth Maldives travel guides"
              description="Real, researched guides to islands, atolls, diving, weather and culture."
              action={{ label: "View all guides", href: "/maldives/travel-guide/" }}
            />
            <ul className="mt-8 grid grid-cols-1 gap-4 sm:grid-cols-3">
              {articles.map((article) => (
                <ArticleCard key={article.id} article={article} />
              ))}
            </ul>
          </Container>
        </section>
      )}

      {/* Final CTA */}
      <section className="bg-gradient-to-br from-ocean-900 to-maldives-600 py-14 text-white sm:py-20">
        <Container className="flex flex-col items-start gap-4 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <h2 className="text-2xl font-semibold sm:text-3xl">Planning a trip to the Maldives?</h2>
            <p className="mt-2 max-w-xl text-lagoon-100">
              Browse real atolls, islands, resorts and activities, or message us directly on WhatsApp for help
              planning your trip.
            </p>
          </div>
          <div className="flex shrink-0 flex-wrap gap-3">
            <Button href="/maldives/" variant="inverted">
              Start exploring
            </Button>
            <Button href={WHATSAPP_URL} variant="secondary" className="border-white/30 bg-white/10 text-white hover:bg-white/20" target="_blank" rel="noopener noreferrer">
              WhatsApp us
            </Button>
          </div>
        </Container>
      </section>
    </main>
  );
}
