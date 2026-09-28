import type { Metadata } from "next";

import {
  ActivityDirectoryPage,
  activityDirectoryMetadata,
  type ActivityDirectorySearchParams,
} from "@/components/activity/activity-directory-page";

export function generateMetadata({
  searchParams,
}: {
  searchParams: Promise<ActivityDirectorySearchParams>;
}): Promise<Metadata> {
  return activityDirectoryMetadata(searchParams);
}

export default function ActivitiesPage({
  searchParams,
}: {
  searchParams: Promise<ActivityDirectorySearchParams>;
}) {
  return <ActivityDirectoryPage searchParams={searchParams} />;
}
