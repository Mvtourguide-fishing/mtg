import type { Metadata } from "next";

import { ferryScheduleMetadata, FerryScheduleDirectoryPage } from "@/components/ferries/ferry-schedule-page";

export function generateMetadata(): Metadata {
  return ferryScheduleMetadata();
}

export default function Page() {
  return <FerryScheduleDirectoryPage />;
}
