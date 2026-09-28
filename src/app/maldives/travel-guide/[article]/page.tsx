import type { Metadata } from "next";

import { ArticleDetailPage, articleDetailMetadata } from "@/components/articles/article-detail-page";

export const revalidate = 3600;

interface Params {
  article: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { article: slug } = await params;
  return articleDetailMetadata(slug);
}

export default async function ArticleDetailRoute({ params }: { params: Promise<Params> }) {
  const { article: slug } = await params;
  return <ArticleDetailPage slug={slug} />;
}
