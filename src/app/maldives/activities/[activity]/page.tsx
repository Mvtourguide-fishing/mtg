import type { Metadata } from "next";

import { ActivityDetailPage, activityDetailMetadata } from "@/components/activity/activity-detail-page";

export const revalidate = 3600;

interface Params {
  activity: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { activity } = await params;
  return activityDetailMetadata(activity);
}

export default async function ActivityDetailRoute({ params }: { params: Promise<Params> }) {
  const { activity } = await params;
  return <ActivityDetailPage slug={activity} />;
}
