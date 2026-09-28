import type { Metadata } from "next";

import { IslandDetailPage, islandDetailMetadata } from "@/components/locations/island-detail-page";

export const revalidate = 3600;

interface Params {
  island: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { island: slug } = await params;
  return islandDetailMetadata(slug);
}

export default async function IslandPage({ params }: { params: Promise<Params> }) {
  const { island: slug } = await params;
  return <IslandDetailPage slug={slug} />;
}
