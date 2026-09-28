import type { Metadata } from "next";

import { AttractionDetailPage, attractionDetailMetadata } from "@/components/attractions/attraction-detail-page";

export const revalidate = 3600;

interface Params {
  attraction: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { attraction } = await params;
  return attractionDetailMetadata(attraction);
}

export default async function AttractionDetailRoute({ params }: { params: Promise<Params> }) {
  const { attraction } = await params;
  return <AttractionDetailPage slug={attraction} />;
}
