import type { Metadata } from "next";

import { DivingDetailPage, divingDetailMetadata } from "@/components/diving/diving-detail-page";

export const revalidate = 3600;

interface Params {
  activity: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { activity } = await params;
  return divingDetailMetadata(activity);
}

export default async function DivingDetailRoute({ params }: { params: Promise<Params> }) {
  const { activity } = await params;
  return <DivingDetailPage slug={activity} />;
}
