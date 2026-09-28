import type { Metadata } from "next";
import Link from "next/link";

import { TransferRouteCard } from "@/components/transfers/transfer-route-card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import { PageHero } from "@/components/ui/page-hero";
import type { MediaAsset } from "@/lib/media/types";
import { breadcrumbJsonLd, canonicalUrl } from "@/lib/seo/site";
import { getTransferRoutes } from "@/lib/transfers/repository";
import type { TransferType } from "@/lib/transfers/types";

/**
 * Task 20: one shared implementation behind the transfer-category landing
 * pages (airport/resort/hotel/island) plus speedboat-transfers. Each has
 * genuinely distinct copy and a genuinely distinct real subset of route
 * data — never the same content re-skinned. Since Task 20 §22, routes are
 * filtered by the real, non-exclusive transfer-category tags
 * (node_categories, group='transfer-category') rather than a single
 * transferType/isInhabited check, so a route genuinely appears on every
 * category page it qualifies for (e.g. airport AND resort AND island),
 * with no route duplicated in the underlying data. A dedicated "Velana
 * Airport transfers" page was deliberately NOT built as a separate route:
 * nearly every route originates at Velana International Airport, so
 * /maldives/airport-transfers/ already serves that exact search intent.
 */

export interface TransferCategoryConfig {
  slug: string;
  eyebrow: string;
  h1: string;
  intro: string;
  metaTitle: string;
  metaDescription: string;
  faqs: Array<{ question: string; answer: string }>;
  /** transfer-category slug (Task 20 §22): airport / resort-transfer /
   * hotel-transfer / island-transfer. */
  category?: string;
  /** Real transfer_type column filter — used only by speedboat-transfers,
   * which isn't a route-level category (a route can carry a speedboat
   * service alongside other service types). */
  transferType?: TransferType;
  emptyMessage: string;
  /** A real legacy image purpose-named for this category — never a
   * generic stock substitute. */
  heroImage?: MediaAsset;
}

const OTHER_CATEGORIES = [
  { slug: "airport-transfers", label: "Airport Transfers" },
  { slug: "resort-transfers", label: "Resort Transfers" },
  { slug: "hotel-transfers", label: "Hotel Transfers" },
  { slug: "island-transfers", label: "Island Transfers" },
  { slug: "speedboat-transfers", label: "Speedboat Transfers" },
];

export function transferCategoryMetadata(config: TransferCategoryConfig): Metadata {
  const url = canonicalUrl(`/maldives/${config.slug}`);
  return {
    title: config.metaTitle,
    description: config.metaDescription,
    alternates: { canonical: url },
    openGraph: { title: config.metaTitle, description: config.metaDescription, url },
  };
}

function faqJsonLd(faqs: TransferCategoryConfig["faqs"]) {
  if (faqs.length === 0) return null;
  return {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    mainEntity: faqs.map((faq) => ({
      "@type": "Question",
      name: faq.question,
      acceptedAnswer: { "@type": "Answer", text: faq.answer },
    })),
  };
}

export async function TransferCategoryLandingPage({ config }: { config: TransferCategoryConfig }) {
  const fetched = await getTransferRoutes({ category: config.category, transferType: config.transferType, pageSize: 100 });
  const routes = fetched.items;

  const faq = faqJsonLd(config.faqs);

  return (
    <main>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify(
            breadcrumbJsonLd(
              [{ label: "Maldives", href: "/maldives/" }, { label: "Transfers", href: "/maldives/transfers/" }, { label: config.h1 }],
              `/maldives/${config.slug}`,
            ),
          ),
        }}
      />
      {faq && <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(faq) }} />}

      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Transfers", href: "/maldives/transfers/" }, { label: config.h1 }]}
        eyebrow={config.eyebrow}
        title={config.h1}
        description={config.intro}
        image={config.heroImage}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        {routes.length === 0 ? (
          <EmptyState title={config.emptyMessage} />
        ) : (
          <ul className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
            {routes.map((route) => (
              <TransferRouteCard key={route.id} route={route} />
            ))}
          </ul>
        )}

        {config.faqs.length > 0 && (
          <section className="mt-14 border-t border-neutral-200 pt-10">
            <h2 className="text-xl font-semibold text-ocean-900">Common questions</h2>
            <dl className="mt-4 space-y-6">
              {config.faqs.map((faq) => (
                <div key={faq.question}>
                  <dt className="font-medium text-ocean-900">{faq.question}</dt>
                  <dd className="mt-1 text-sm text-neutral-700">{faq.answer}</dd>
                </div>
              ))}
            </dl>
          </section>
        )}

        <div className="mt-10 border-t border-neutral-200 pt-6">
          <p className="text-sm font-medium text-neutral-500">Browse other transfer types</p>
          <nav aria-label="Other transfer categories" className="mt-2 flex flex-wrap gap-2">
            {OTHER_CATEGORIES.filter((c) => c.slug !== config.slug).map((c) => (
              <Link
                key={c.slug}
                href={`/maldives/${c.slug}/`}
                className="rounded-full border border-neutral-300 px-3 py-1.5 text-sm text-neutral-700 hover:border-maldives-500 hover:text-maldives-600"
              >
                {c.label}
              </Link>
            ))}
          </nav>
          <Link href="/maldives/transfers/" className="mt-4 inline-block text-sm font-medium text-maldives-600 hover:underline">
            ← All Maldives transfers
          </Link>
        </div>
      </div>
    </main>
  );
}
