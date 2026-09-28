import type { Metadata } from "next";
import Link from "next/link";

import { CARD_CLASS } from "@/components/ui/card";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { EmptyState } from "@/components/ui/empty-state";
import { PageHero } from "@/components/ui/page-hero";
import { getProviders } from "@/lib/providers/repository";
import { canonicalUrl } from "@/lib/seo/site";

export function generateMetadata(): Metadata {
  const title = "Maldives Accommodation Providers | MTG";
  const description = "Operators and companies running accommodation in the Maldives.";
  return {
    title,
    description,
    alternates: { canonical: canonicalUrl("/maldives/providers") },
    openGraph: { title, description, url: canonicalUrl("/maldives/providers") },
  };
}

export default async function ProvidersPage() {
  const { items: providers } = await getProviders({ pageSize: 100 });

  return (
    <main>
      <PageHero
        breadcrumbs={[{ label: "Maldives", href: "/maldives/" }, { label: "Providers" }]}
        eyebrow="Operators"
        title="Providers"
        description="Companies operating accommodation in the Maldives."
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        {providers.length === 0 ? (
          <EmptyState title="No providers recorded yet" />
        ) : (
          <ul className="grid grid-cols-1 gap-3 sm:grid-cols-2">
            {providers.map((provider) => (
              <li key={provider.id}>
                <Link href={`/maldives/providers/${provider.slug}/`} className={`${CARD_CLASS} block text-lg font-medium text-ocean-900 hover:text-maldives-600`}>
                  {provider.title}
                </Link>
              </li>
            ))}
          </ul>
        )}
      </div>
    </main>
  );
}
