import type { Metadata } from "next";
import Link from "next/link";

import { ComingSoonSection } from "@/components/transfers/coming-soon-section";
import { RouteVideo, routeVideoJsonLd } from "@/components/transfers/route-video";
import { TransferFinder } from "@/components/transfers/transfer-finder";
import { TransferRouteCard } from "@/components/transfers/transfer-route-card";
import { CarTransfersSection } from "@/components/vehicles/car-transfers-section";
import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { MediaImage } from "@/components/ui/media-image";
import { PageHero } from "@/components/ui/page-hero";
import { getFerryRoutes } from "@/lib/ferries/repository";
import { getLocationBySlug } from "@/lib/locations/repository";
import { breadcrumbJsonLd, canonicalUrl } from "@/lib/seo/site";
import { getSpeedboats } from "@/lib/speedboats/repository";
import { TRANSFER_CATEGORY_IMAGES } from "@/lib/transfers/category-images";
import { getTransferRoutes } from "@/lib/transfers/repository";

/**
 * Task 20: the main Maldives transportation hub. Rebuilt as a full
 * search engine + directory + booking/inquiry funnel, not a page of
 * generic card sections — see the section order in the task brief
 * (§11): hero, finder, airport, speedboat charter, car, resort, island,
 * seaplane/domestic-flight (coming soon), ferry, why-us, how-it-works,
 * FAQ, related links. (The catch-all "browse every route" directory that
 * used to sit beneath all of this was removed on request — the category
 * pages linked from each section's "See all" already cover that.)
 */

const HOW_IT_WORKS = [
  {
    title: "After you land",
    body: "Once you clear immigration and collect luggage at Velana International Airport, resort and hotel transfer desks are typically just outside arrivals — most shared and private speedboat transfers depart from the jetty a short walk away.",
  },
  {
    title: "Shared vs. private speedboats",
    body: "A shared transfer runs on a schedule with other travellers heading the same way, usually at a lower fixed price. A private transfer or full charter is your own boat on your own timing — see Private Speedboat Charter below.",
  },
  {
    title: "Resort transfers",
    body: "Most resorts occupy their own private island and run their own speedboat or seaplane transfer, timed around your flight — the resort's own route page shows its real price and typical journey time where on record.",
  },
  {
    title: "Local island transfers",
    body: "Local islands such as Maafushi are reached by public ferry (cheapest, runs on a fixed schedule) or a faster private speedboat operator.",
  },
  {
    title: "Seaplanes and domestic flights",
    body: "Used for resorts too far for a speedboat — currently marked Coming Soon on this platform while we confirm real operator and schedule data.",
  },
  {
    title: "Booking ahead",
    body: "Arrange your transfer as soon as your accommodation is confirmed — many resorts times transfers to specific flight schedules, so having your flight details ready speeds things up.",
  },
];

const FAQS = [
  {
    question: "How do Maldives airport transfers work?",
    answer: "You land at Velana International Airport, then continue by speedboat, ferry, seaplane, or domestic flight depending on your destination — see How Transfers Work above.",
  },
  {
    question: "How do I get from Velana Airport to my island?",
    answer: "Use the transfer finder above — search your destination and we'll show the real route if one exists, or offer a private charter if it doesn't.",
  },
  {
    question: "Are Maldives speedboat transfers shared?",
    answer: "Both — most resorts offer a scheduled shared transfer, and a private transfer or full charter is also usually available. Each route page shows what's actually on offer.",
  },
  {
    question: "Can I book a private speedboat?",
    answer: "Yes — see Private Speedboat Charter below for our own fleet, available for hourly, destination-based, or custom private hire.",
  },
  {
    question: "How early should I arrange my transfer?",
    answer: "As soon as your accommodation is confirmed, especially for resorts that time transfers to specific flights.",
  },
  {
    question: "Are ferry schedules the same every day?",
    answer: "No — public ferries don't run on Fridays, and most routes only run on specific days of the week. See the Ferry Schedule page for exact days.",
  },
  {
    question: "What's the difference between a resort transfer and an island transfer?",
    answer: "A resort transfer goes to a private resort island; an island transfer goes to a local, inhabited Maldivian island (like Malé or Maafushi) with hotels or guesthouses rather than a resort.",
  },
  {
    question: "Are seaplane and domestic flight transfers available?",
    answer: "Not yet listed on this platform — marked Coming Soon while we confirm real operator, route, and schedule data rather than publish anything unverified.",
  },
];

export function transferDirectoryMetadata(): Metadata {
  const title = "Maldives Transfers | Airport, Resort, Island & Speedboat Transfers";
  const description =
    "The complete Maldives transportation platform: real airport, resort, island, ferry, and private speedboat transfer routes and prices — search, compare, and book or enquire.";
  const url = canonicalUrl("/maldives/transfers");

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: { title, description, url },
  };
}

function faqJsonLd() {
  return {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: FAQS.map((faq) => ({ "@type": "Question", name: faq.question, acceptedAnswer: { "@type": "Answer", text: faq.answer } })),
  };
}

function SeeAllLink({ href, total, label }: { href: string; total: number; label: string }) {
  return (
    <Link href={href} className="text-sm font-medium text-maldives-600 hover:underline">
      {label} ({total}) →
    </Link>
  );
}

export async function TransferDirectoryPage() {
  const [velanaAirport, airportResult, resortResult, islandResult, boats, ferryRoutes] = await Promise.all([
    getLocationBySlug("velana-international-airport"),
    getTransferRoutes({ category: "airport", pageSize: 6 }),
    getTransferRoutes({ category: "resort-transfer", pageSize: 6 }),
    getTransferRoutes({ category: "island-transfer", pageSize: 6 }),
    getSpeedboats(),
    getFerryRoutes(),
  ]);
  // getTransferRoutes() already runs count: "exact" alongside its
  // .range() page — .total above is the real total, not just this page's
  // item count, so a second (pageSize: 1) query per category to re-fetch
  // the same number was pure duplicate work. Task 17 production audit.
  const airportTotal = airportResult.total;
  const resortTotal = resortResult.total;
  const islandTotal = islandResult.total;

  return (
    <main>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbJsonLd([{ label: "Maldives", href: "/maldives/" }, { label: "Transfers" }], "/maldives/transfers")) }}
      />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd()) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(routeVideoJsonLd()) }} />

      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Transfers" }]}
        eyebrow="Maldives transportation"
        title="Maldives Transfers"
        description="Airport, resort, island, private speedboat, and other transportation options across the Maldives — real routes and prices, search by destination, or request a private charter."
        image={TRANSFER_CATEGORY_IMAGES.mainHub}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        {/* 2. Transfer search */}
        <TransferFinder defaultFromSlug={velanaAirport?.slug} defaultFromLabel={velanaAirport?.title} />

        {/* 3. Airport transfers */}
        {airportResult.items.length > 0 && (
          <section className="mt-10">
            <div className="flex items-baseline justify-between">
              <h2 className="text-xl font-semibold text-ocean-900">Maldives Airport Transfers</h2>
              <SeeAllLink href="/maldives/airport-transfers/" total={airportTotal} label="See all" />
            </div>
            <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {airportResult.items.map((r) => (
                <TransferRouteCard key={r.id} route={r} />
              ))}
            </ul>
          </section>
        )}

        {/* 4. Private speedboat charters */}
        {boats.length > 0 && (
          <section className="mt-10">
            <div className="flex items-baseline justify-between">
              <h2 className="text-xl font-semibold text-ocean-900">Private Speedboat Charters</h2>
              <SeeAllLink href="/maldives-speedboats-charter/" total={boats.length} label="See all speedboats" />
            </div>
            <p className="mt-1 text-sm text-neutral-600">Our own fleet, available for private hire — hourly, destination-based, or custom trip. No fixed public price.</p>
            <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {boats.slice(0, 6).map((boat) => (
                <li key={boat.id} className={CARD_CLASS}>
                  {boat.heroImage && (
                    <div className={CARD_IMAGE_BLEED_CLASS}>
                      <MediaImage asset={boat.heroImage} alt={boat.title} aspectClassName="aspect-[4/3]" />
                    </div>
                  )}
                  <Link href={`/maldives-speedboats-charter/${boat.slug}/`} className="font-medium text-ocean-900 hover:text-maldives-600">
                    {boat.title}
                  </Link>
                  <p className="mt-1 text-sm text-neutral-600">{boat.capacity} seats{boat.lengthFeet ? ` · ${boat.lengthFeet} ft` : ""}</p>
                </li>
              ))}
            </ul>
          </section>
        )}

        {/* 5. Car transfers */}
        <CarTransfersSection />

        {/* 6. Resort transfers */}
        {resortResult.items.length > 0 && (
          <section className="mt-10">
            <div className="flex items-baseline justify-between">
              <h2 className="text-xl font-semibold text-ocean-900">Resort Transfers</h2>
              <SeeAllLink href="/maldives/resort-transfers/" total={resortTotal} label="See all" />
            </div>
            <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {resortResult.items.map((r) => (
                <TransferRouteCard key={r.id} route={r} />
              ))}
            </ul>
          </section>
        )}

        {/* 7. Island transfers */}
        {islandResult.items.length > 0 && (
          <section className="mt-10">
            <div className="flex items-baseline justify-between">
              <h2 className="text-xl font-semibold text-ocean-900">Island Transfers</h2>
              <SeeAllLink href="/maldives/island-transfers/" total={islandTotal} label="See all" />
            </div>
            <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {islandResult.items.map((r) => (
                <TransferRouteCard key={r.id} route={r} />
              ))}
            </ul>
          </section>
        )}

        {/* 8-9. Seaplane / domestic flight — coming soon */}
        <ComingSoonSection
          title="Seaplane Transfers"
          description="We're working on confirming real seaplane operator, route, and pricing data before listing it here — no fabricated schedules or availability in the meantime."
          image={TRANSFER_CATEGORY_IMAGES.seaplaneComingSoon}
        />
        <ComingSoonSection
          title="Domestic Flight Transfers"
          description="Domestic flight transfer routes will be added once real operator and schedule data is confirmed."
          image={TRANSFER_CATEGORY_IMAGES.domesticFlightComingSoon}
        />

        {/* 10. Ferry schedule */}
        {ferryRoutes.length > 0 && (
          <section className="mt-10">
            <div className="flex items-baseline justify-between">
              <h2 className="text-xl font-semibold text-ocean-900">Maldives Ferry Schedule</h2>
              <SeeAllLink href="/maldives-ferry-schedule/" total={ferryRoutes.length} label="See all schedules" />
            </div>
            <p className="mt-1 text-sm text-neutral-600">Public province ferries between local islands — information only, no booking through us.</p>
            <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {ferryRoutes.slice(0, 6).map((route) => (
                <li key={route.id} className="rounded-2xl border border-neutral-200 p-4">
                  <span className="font-medium text-ocean-900">{route.title}</span>
                  <p className="mt-1 text-sm text-neutral-600">
                    {route.province} · {route.operatingDays}
                  </p>
                </li>
              ))}
            </ul>
          </section>
        )}

        {/* Getting-around explainer video */}
        <RouteVideo />

        {/* 11. Why use MTG */}
        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Why Use Maldives Tour Guide for Transfers</h2>
          <p className="mt-2 max-w-2xl text-sm text-neutral-700">
            Every route on this page is a real, individually verified transfer — not a generic estimate. We list the actual price where one
            exists, we&rsquo;re honest when a route isn&rsquo;t on record instead of inventing one, and every enquiry connects to a real
            booking or charter request, not a dead-end contact form.
          </p>
        </section>

        {/* 12. How transfers work */}
        <section className="mt-10">
          <h2 className="text-xl font-semibold text-ocean-900">How Maldives Transfers Work</h2>
          <dl className="mt-4 grid grid-cols-1 gap-6 sm:grid-cols-2">
            {HOW_IT_WORKS.map((item) => (
              <div key={item.title}>
                <dt className="font-medium text-ocean-900">{item.title}</dt>
                <dd className="mt-1 text-sm text-neutral-700">{item.body}</dd>
              </div>
            ))}
          </dl>
        </section>

        {/* 13. FAQs */}
        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Frequently Asked Questions</h2>
          <dl className="mt-4 space-y-6">
            {FAQS.map((faq) => (
              <div key={faq.question}>
                <dt className="font-medium text-ocean-900">{faq.question}</dt>
                <dd className="mt-1 text-sm text-neutral-700">{faq.answer}</dd>
              </div>
            ))}
          </dl>
        </section>

        {/* 14. Related Maldives travel links */}
        <section className="mt-12 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Related Maldives Travel Links</h2>
          <nav aria-label="Related Maldives travel links" className="mt-4 flex flex-wrap gap-2">
            {[
              { href: "/maldives/islands/", label: "Maldives Islands" },
              { href: "/maldives/atolls/", label: "Maldives Atolls" },
              { href: "/maldives/resorts/", label: "Maldives Resorts" },
              { href: "/maldives/hotels/", label: "Maldives Hotels" },
              { href: "/maldives/packages/", label: "Maldives Packages" },
              { href: "/maldives/travel-guide/", label: "Travel Guide" },
            ].map((link) => (
              <Link key={link.href} href={link.href} className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600">
                {link.label}
              </Link>
            ))}
          </nav>
        </section>
      </div>
    </main>
  );
}
