import type { Metadata } from "next";

import { SurfingDetailPage, surfingDetailMetadata } from "@/components/surfing/surfing-detail-page";

export const revalidate = 3600;

interface Params {
  activity: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { activity } = await params;
  return surfingDetailMetadata(activity);
}

export default async function SurfingDetailRoute({ params }: { params: Promise<Params> }) {
  const { activity } = await params;
  return <SurfingDetailPage slug={activity} />;
}
