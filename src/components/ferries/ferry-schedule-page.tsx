import type { Metadata } from "next";
import Link from "next/link";

import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import { MediaImage } from "@/components/ui/media-image";
import { PageHero } from "@/components/ui/page-hero";
import { getFerryRoutes } from "@/lib/ferries/repository";
import type { FerryRoute } from "@/lib/ferries/types";
import { breadcrumbJsonLd, canonicalUrl } from "@/lib/seo/site";
import { TRANSFER_CATEGORY_IMAGES } from "@/lib/transfers/category-images";

const FAQS = [
  {
    question: "Can I book a ferry through Maldives Tour Guide?",
    answer:
      "No — this page is public province ferry schedule information only. Tickets for these government-operated ferries are bought locally; we don't take ferry bookings.",
  },
  {
    question: "Do ferries run every day?",
    answer: "No — public ferries don't operate on Fridays, and most routes run on specific days of the week shown against each schedule below.",
  },
  {
    question: "Is this the same as a resort speedboat transfer?",
    answer:
      "No — these are public transport ferries between inhabited local islands, run independently of any resort. For a resort or airport transfer, see the main Transfers page instead.",
  },
];

export function ferryScheduleMetadata(): Metadata {
  const title = "Maldives Ferry Schedule | Island & Province Ferry Timetables";
  const description = "Real public province ferry schedules in the Maldives — routes, operating days, and departure/arrival times, transcribed from the original timetable. Information only, no booking.";
  const url = canonicalUrl("/maldives-ferry-schedule");
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

function RouteCard({ route }: { route: FerryRoute }) {
  return (
    <li className={CARD_CLASS}>
      {route.heroImage && (
        <div className={CARD_IMAGE_BLEED_CLASS}>
          <MediaImage asset={route.heroImage} alt={route.title} aspectClassName="aspect-[16/9]" />
        </div>
      )}
      <div className="flex flex-wrap items-baseline justify-between gap-2">
        <span className="text-lg font-medium text-ocean-900">{route.title}</span>
        <span className="text-xs font-medium uppercase tracking-wide text-neutral-500">Route {route.routeNumber}</span>
      </div>
      <p className="mt-1 text-sm text-neutral-600">
        {route.province}
        {route.variantLabel ? ` · ${route.variantLabel}` : ""}
      </p>
      <p className="mt-1 text-sm font-medium text-ocean-800">{route.operatingDays}</p>

      {(route.origin || route.destination) && (
        <p className="mt-1 text-sm text-neutral-600">
          {route.origin && (
            <Link href={`/maldives/islands/${route.origin.slug}/`} className="text-maldives-600 hover:underline">
              {route.origin.title}
            </Link>
          )}
          {route.origin && route.destination && " → "}
          {route.destination && (
            <Link href={`/maldives/islands/${route.destination.slug}/`} className="text-maldives-600 hover:underline">
              {route.destination.title}
            </Link>
          )}
        </p>
      )}

      <div className="mt-3 overflow-x-auto">
        <table className="w-full min-w-[280px] text-left text-sm">
          <thead>
            <tr className="text-xs uppercase tracking-wide text-neutral-500">
              <th className="pb-1 pr-2 font-medium">Island</th>
              <th className="pb-1 pr-2 font-medium">Arrival</th>
              <th className="pb-1 font-medium">Departure</th>
            </tr>
          </thead>
          <tbody>
            {route.stops.map((stop, i) => (
              <tr key={`${stop.island}-${i}`} className="border-t border-neutral-100">
                <td className="py-1 pr-2 text-neutral-800">{stop.island}</td>
                <td className="py-1 pr-2 text-neutral-600">{stop.arrival ?? "—"}</td>
                <td className="py-1 text-neutral-600">{stop.departure ?? "—"}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </li>
  );
}

export async function FerryScheduleDirectoryPage() {
  const routes = await getFerryRoutes();
  const groups = new Map<string, FerryRoute[]>();
  for (const r of routes) {
    const list = groups.get(r.province) ?? [];
    list.push(r);
    groups.set(r.province, list);
  }

  return (
    <main>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(breadcrumbJsonLd([{ label: "Maldives", href: "/maldives/" }, { label: "Ferry Schedule" }], "/maldives-ferry-schedule")),
        }}
      />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faqJsonLd()) }} />

      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Ferry Schedule" }]}
        eyebrow="Public transport · information only"
        title="Maldives Ferry Schedule"
        description="Real province ferry timetables between local Maldivian islands — route, operating days, and stop-by-stop times. Information only; these government ferries aren't booked through us."
        image={TRANSFER_CATEGORY_IMAGES.ferryScheduleHub}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        {routes.length === 0 ? (
          <EmptyState title="No ferry schedules published yet." />
        ) : (
          Array.from(groups.entries()).map(([province, provinceRoutes]) => (
            <section key={province} className="mt-8 first:mt-0">
              <h2 className="text-xl font-semibold text-ocean-900">{province}</h2>
              <ul className="mt-4 space-y-4">
                {provinceRoutes.map((route) => (
                  <RouteCard key={route.id} route={route} />
                ))}
              </ul>
            </section>
          ))
        )}

        <section className="mt-14 border-t border-neutral-200 pt-10">
          <h2 className="text-xl font-semibold text-ocean-900">Common questions</h2>
          <dl className="mt-4 space-y-6">
            {FAQS.map((faq) => (
              <div key={faq.question}>
                <dt className="font-medium text-ocean-900">{faq.question}</dt>
                <dd className="mt-1 text-sm text-neutral-700">{faq.answer}</dd>
              </div>
            ))}
          </dl>
        </section>

        <div className="mt-10 border-t border-neutral-200 pt-6">
          <Link href="/maldives/transfers/" className="text-sm font-medium text-maldives-600 hover:underline">
            ← All Maldives transfers
          </Link>
        </div>
      </div>
    </main>
  );
}
