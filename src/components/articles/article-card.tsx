import Link from "next/link";

import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { MediaImage } from "@/components/ui/media-image";
import { articleHref, type ArticleSummary } from "@/lib/articles/types";

export function ArticleCard({ article }: { article: ArticleSummary }) {
  return (
    <li className={CARD_CLASS}>
      {article.heroImage && (
        <div className={CARD_IMAGE_BLEED_CLASS}>
          <MediaImage asset={article.heroImage} alt={article.title} aspectClassName="aspect-[16/10]" />
        </div>
      )}
      <Link href={articleHref(article)} className="text-lg font-medium text-ocean-900 transition-colors hover:text-maldives-600">
        {article.title}
      </Link>
      {article.summary && <p className="mt-1.5 text-sm text-neutral-600">{article.summary}</p>}
      <div className="mt-2 flex flex-wrap gap-x-3 gap-y-1 text-xs text-neutral-500">
        {article.category && <span>{article.category.title}</span>}
        {article.readingTimeMinutes !== null && <span>{article.readingTimeMinutes} min read</span>}
      </div>
    </li>
  );
}
