import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";

import { IslandCard } from "@/components/locations/island-card";
import { MapPinIcon } from "@/components/ui/icons";
import { CARD_CLASS } from "@/components/ui/card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { MediaImage } from "@/components/ui/media-image";
import { PageHero } from "@/components/ui/page-hero";
import { SectionHeader } from "@/components/ui/section-header";
import { getAtolls, getCountry, getIslandBySlug } from "@/lib/locations/repository";
import { breadcrumbJsonLd, canonicalUrl, itemListJsonLd } from "@/lib/seo/site";

export async function generateMetadata(): Promise<Metadata> {
  const country = await getCountry();
  if (!country) return {};

  const title = country.metaTitle ?? `${country.title} Travel Guide | MTG`;
  const description = country.metaDescription ?? country.summary ?? undefined;

  return {
    title,
    description,
    alternates: { canonical: canonicalUrl("/maldives") },
    openGraph: { title, description, url: canonicalUrl("/maldives") },
  };
}

// A cross-section of real, well-known local islands (not an arbitrary
// pick) — each one only renders if it actually exists as a published
// island node, so this list can never surface a broken card.
const FEATURED_ISLAND_SLUGS = ["thulusdhoo", "maafushi", "dhigurah", "ukulhas", "fuvahmulah", "gan"];

export default async function MaldivesPage() {
  const country = await getCountry();
  if (!country) notFound();

  const [atolls, featuredIslandResults] = await Promise.all([
    getAtolls(),
    Promise.all(FEATURED_ISLAND_SLUGS.map((slug) => getIslandBySlug(slug))),
  ]);
  const totalIslands = atolls.reduce((sum, atoll) => sum + atoll.islandCount, 0);
  const featuredIslands = featuredIslandResults.filter((i): i is NonNullable<typeof i> => i !== null);

  return (
    <main>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbJsonLd([{ label: "Maldives" }], "/maldives")) }}
      />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(itemListJsonLd(atolls.map((a) => ({ title: a.title, href: `/maldives/atolls/${a.slug}/`, summary: a.summary })), "Place")),
        }}
      />

      <PageHero
        variant="ocean"
        eyebrow="Maldives Tour Guide"
        title={country.title}
        description={country.summary ?? undefined}
        meta={
          <>
            <span>
              <strong className="font-semibold text-white">{atolls.length}</strong> administrative atolls
            </span>
            <span>
              <strong className="font-semibold text-white">{totalIslands}</strong> inhabited islands
            </span>
          </>
        }
      />

      <div className={`${CONTAINER_CLASS} py-12 sm:py-16`}>
        <section className="prose-sm max-w-none text-sm text-neutral-700">
          <p>
            The Maldives is a nation of coral atolls in the Indian Ocean, made up of the capital Malé, a scattering of
            resort islands, and {totalIslands} inhabited local islands spread across {atolls.length} administrative
            atolls. Most travellers stay in one of two very different ways: a private resort island — one island, one
            property, all-inclusive — or a local island, where guesthouses sit inside a real Maldivian community
            alongside its mosque, school and harbour. Both give access to the same reefs, lagoons and marine life;
            what differs is the kind of trip. Everything below — atolls, islands, stays, activities, transfers,
            packages and travel guides — links back to the same real MTG catalogue, so wherever you start, you can
            get to everything else.
          </p>
        </section>

        <div className="mt-10">
          <SectionHeader
            eyebrow="Destinations"
            title="Browse by atoll"
            description="The Maldives is organized into administrative atolls, each made up of inhabited islands."
            action={{ label: "View all atolls", href: "/maldives/atolls/" }}
          />
          <ul className="mt-6 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
            {atolls.map((atoll) => (
              <li key={atoll.id} className={CARD_CLASS}>
                <Link href={`/maldives/atolls/${atoll.slug}/`} className="flex items-center gap-3">
                  {atoll.heroImage ? (
                    <div className="w-14 shrink-0 overflow-hidden rounded-lg">
                      <MediaImage asset={atoll.heroImage} alt={atoll.title} aspectClassName="aspect-square" />
                    </div>
                  ) : (
                    <MapPinIcon className="h-5 w-5 shrink-0 text-maldives-600" />
                  )}
                  <span>
                    <span className="block font-medium text-ocean-900">{atoll.title}</span>
                    <span className="text-xs text-neutral-500">
                      {atoll.islandCount} island{atoll.islandCount === 1 ? "" : "s"}
                    </span>
                  </span>
                </Link>
              </li>
            ))}
          </ul>
        </div>

        {featuredIslands.length > 0 && (
          <div className="mt-12">
            <SectionHeader
              title="Featured local islands"
              description="A starting point, not the whole list — every inhabited island has its own page."
              action={{ label: "View all islands", href: "/maldives/islands/" }}
            />
            <ul className="mt-6 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {featuredIslands.map((island) => (
                <IslandCard key={island.id} island={island} />
              ))}
            </ul>
          </div>
        )}

        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Maldives Local Islands</h2>
          <div className="mt-4 grid grid-cols-1 gap-6 text-sm text-neutral-700 sm:grid-cols-2">
            <p>
              A &ldquo;local island&rdquo; is simply an inhabited Maldivian island that welcomes overnight guests —
              usually in small, independently run guesthouses rather than a single resort operator. You&rsquo;ll be
              staying inside a real community: shops, a mosque, a school, a working harbour, and neighbours going
              about daily life around you.
            </p>
            <p>
              It&rsquo;s generally the more affordable way to experience the Maldives, since you pay for a room and
              meals rather than an entire private island. Local dress and behaviour norms are more conservative than
              on a resort island — swimwear is for designated &ldquo;bikini beaches&rdquo; only, for example — and
              in exchange you get easier access to real Maldivian food, culture and everyday life.
            </p>
          </div>
          <p className="mt-4 text-sm text-neutral-600">
            <Link href="/maldives/islands/" className="font-medium text-maldives-600 hover:underline">
              Browse every local island →
            </Link>{" "}
            or see{" "}
            <Link href="/maldives/guesthouses/" className="font-medium text-maldives-600 hover:underline">
              guesthouses
            </Link>{" "}
            for places to stay on them.
          </p>
        </section>

        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Explore More Maldives</h2>
          <nav aria-label="Related Maldives links" className="mt-4 flex flex-wrap gap-2">
            {[
              { href: "/maldives/activities/", label: "Things to Do" },
              { href: "/maldives/diving/", label: "Diving" },
              { href: "/maldives/fishing/", label: "Fishing" },
              { href: "/maldives/surfing/", label: "Surfing" },
              { href: "/maldives/attractions/", label: "Attractions" },
              { href: "/maldives/resorts/", label: "Resorts" },
              { href: "/maldives/guesthouses/", label: "Guesthouses" },
              { href: "/maldives/transfers/", label: "Transfers" },
              { href: "/maldives/packages/", label: "Packages" },
              { href: "/maldives/travel-guide/", label: "Travel Guide" },
            ].map((link) => (
              <Link
                key={link.href}
                href={link.href}
                className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600"
              >
                {link.label}
              </Link>
            ))}
          </nav>
        </section>
      </div>
    </main>
  );
}
