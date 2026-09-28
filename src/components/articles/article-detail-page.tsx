import type { Metadata } from "next";
import Link from "next/link";
import { notFound } from "next/navigation";

import { CONTAINER_CLASS } from "@/components/ui/container";
import { PageHero } from "@/components/ui/page-hero";
import { getArticleBySlug } from "@/lib/articles/repository";
import { articleHref } from "@/lib/articles/types";
import { applyContextualLinks } from "@/lib/linking/contextual-links";
import { buildEntityLinkMap } from "@/lib/linking/entity-link-map";
import { publicStorageUrl } from "@/lib/media/types";
import { canonicalUrl, getSiteUrl } from "@/lib/seo/site";

export async function articleDetailMetadata(slug: string): Promise<Metadata> {
  const article = await getArticleBySlug(slug);
  if (!article) return {};

  const title = article.metaTitle ?? `${article.title} | Maldives Travel Guide | MTG`;
  const description = article.metaDescription ?? article.summary ?? undefined;
  const url = canonicalUrl(`/maldives/travel-guide/${article.slug}`);
  const ogImage = article.heroImage?.storagePath ? publicStorageUrl(article.heroImage.storagePath) : null;

  return {
    title,
    description,
    alternates: { canonical: url },
    openGraph: {
      title,
      description,
      url,
      type: "article",
      publishedTime: article.publishedAt ?? undefined,
      images: ogImage ? [{ url: ogImage }] : undefined,
    },
  };
}

/**
 * Article structured data (schema.org Article) — the first JSON-LD block
 * in this codebase. Only real, already-verified fields go in: no
 * fabricated author/organization details beyond the site name itself.
 */
function articleJsonLd(article: NonNullable<Awaited<ReturnType<typeof getArticleBySlug>>>) {
  const url = canonicalUrl(`/maldives/travel-guide/${article.slug}`);
  const imageUrl = article.heroImage?.storagePath ? publicStorageUrl(article.heroImage.storagePath) : undefined;

  return {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: article.title,
    description: article.metaDescription ?? article.summary ?? undefined,
    image: imageUrl ? [imageUrl] : undefined,
    datePublished: article.publishedAt ?? undefined,
    mainEntityOfPage: url,
    publisher: {
      "@type": "Organization",
      name: "Maldives Tour Guide",
      url: getSiteUrl(),
    },
  };
}

export async function ArticleDetailPage({ slug }: { slug: string }) {
  const article = await getArticleBySlug(slug);
  if (!article) notFound();

  const entityMap = await buildEntityLinkMap();
  const bodyHtml = applyContextualLinks(article.bodyHtml, entityMap, { excludeHref: articleHref(article) });

  return (
    <main>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(articleJsonLd(article)) }} />

      <PageHero
        breadcrumbs={[
          { label: "Maldives", href: "/maldives/" },
          { label: "Travel Guide", href: "/maldives/travel-guide/" },
          { label: article.title },
        ]}
        eyebrow={article.category?.title ?? "Travel Guide"}
        title={article.title}
        description={article.summary ?? undefined}
        image={article.heroImage}
        meta={article.readingTimeMinutes !== null ? <span>{article.readingTimeMinutes} min read</span> : undefined}
      />

      <div className={`${CONTAINER_CLASS} py-10 sm:py-14`}>
        <div className="grid grid-cols-1 gap-10 lg:grid-cols-[1fr_280px]">
          <article
            className="
              max-w-none text-neutral-800
              [&_h2]:mt-8 [&_h2]:text-2xl [&_h2]:font-semibold [&_h2]:text-ocean-900
              [&_h3]:mt-6 [&_h3]:text-xl [&_h3]:font-semibold [&_h3]:text-ocean-900
              [&_h4]:mt-4 [&_h4]:text-lg [&_h4]:font-semibold [&_h4]:text-ocean-900
              [&_p]:mt-4 [&_p]:leading-relaxed
              [&_ul]:mt-4 [&_ul]:list-disc [&_ul]:space-y-1 [&_ul]:pl-6
              [&_ol]:mt-4 [&_ol]:list-decimal [&_ol]:space-y-1 [&_ol]:pl-6
              [&_blockquote]:mt-4 [&_blockquote]:border-l-4 [&_blockquote]:border-maldives-300 [&_blockquote]:pl-4 [&_blockquote]:italic [&_blockquote]:text-neutral-600
              [&_figure]:mt-6 [&_figure]:overflow-hidden [&_figure]:rounded-2xl
              [&_img]:h-auto [&_img]:w-full
              [&_table]:mt-4 [&_table]:w-full [&_table]:border-collapse [&_table]:text-sm
              [&_td]:border [&_td]:border-neutral-200 [&_td]:p-2
              [&_a]:text-maldives-600 [&_a]:underline
              [&_[data-youtube-id]]:relative [&_[data-youtube-id]]:mt-6 [&_[data-youtube-id]]:aspect-video [&_[data-youtube-id]]:overflow-hidden [&_[data-youtube-id]]:rounded-2xl [&_[data-youtube-id]]:bg-neutral-100
            "
            dangerouslySetInnerHTML={{ __html: bodyHtml }}
          />

          <aside className="space-y-8">
            {article.relatedLocations.length > 0 && (
              <div>
                <h2 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">Related places</h2>
                <ul className="mt-3 space-y-2 text-sm">
                  {article.relatedLocations.map((location) => (
                    <li key={location.id}>
                      <Link
                        href={location.locationType === "atoll" ? `/maldives/atolls/${location.slug}/` : `/maldives/islands/${location.slug}/`}
                        className="text-maldives-600 hover:underline"
                      >
                        {location.title}
                      </Link>
                    </li>
                  ))}
                </ul>
              </div>
            )}

            {article.relatedEntities.length > 0 && (
              <div>
                <h2 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">You might also book</h2>
                <ul className="mt-3 space-y-2 text-sm">
                  {article.relatedEntities.map((entity) => (
                    <li key={entity.id}>
                      <Link href={entity.href} className="text-maldives-600 hover:underline">
                        {entity.title}
                      </Link>
                    </li>
                  ))}
                </ul>
              </div>
            )}

            {article.category && (
              <div>
                <h2 className="text-sm font-semibold uppercase tracking-wide text-neutral-500">Topic</h2>
                <Link
                  href={`/maldives/travel-guide/?category=${article.category.slug}`}
                  className="mt-3 inline-block rounded-full border border-neutral-300 px-3 py-1 text-sm text-neutral-700 hover:border-maldives-600 hover:text-maldives-600"
                >
                  {article.category.title}
                </Link>
              </div>
            )}
          </aside>
        </div>

        {article.relatedArticles.length > 0 && (
          <div className="mt-14 border-t border-neutral-200 pt-10">
            <h2 className="text-xl font-semibold text-ocean-900">Related Travel Guide articles</h2>
            <ul className="mt-5 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
              {article.relatedArticles.map((related) => (
                <li key={related.id}>
                  <Link
                    href={`/maldives/travel-guide/${related.slug}/`}
                    className="block rounded-xl border border-neutral-200 p-4 text-sm font-medium text-ocean-900 transition-colors hover:border-maldives-600 hover:text-maldives-600"
                  >
                    {related.title}
                  </Link>
                </li>
              ))}
            </ul>
          </div>
        )}

        <div className="mt-10 border-t border-neutral-200 pt-6">
          <Link href="/maldives/travel-guide/" className="text-sm font-medium text-maldives-600 hover:underline">
            ← Back to Travel Guide
          </Link>
        </div>
      </div>
    </main>
  );
}
