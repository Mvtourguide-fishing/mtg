import type { Metadata } from "next";

import { FishingDetailPage, fishingDetailMetadata } from "@/components/fishing/fishing-detail-page";

export const revalidate = 3600;

interface Params {
  activity: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { activity } = await params;
  return fishingDetailMetadata(activity);
}

export default async function FishingDetailRoute({ params }: { params: Promise<Params> }) {
  const { activity } = await params;
  return <FishingDetailPage slug={activity} />;
}
