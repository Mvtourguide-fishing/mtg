import type { Metadata } from "next";

import {
  AccommodationDirectoryPage,
  accommodationDirectoryMetadata,
  type AccommodationDirectorySearchParams,
} from "@/components/accommodation/accommodation-directory-page";

export function generateMetadata({
  searchParams,
}: {
  searchParams: Promise<AccommodationDirectorySearchParams>;
}): Promise<Metadata> {
  return accommodationDirectoryMetadata("hotel", searchParams);
}

export default function HotelsPage({
  searchParams,
}: {
  searchParams: Promise<AccommodationDirectorySearchParams>;
}) {
  return <AccommodationDirectoryPage type="hotel" searchParams={searchParams} />;
}
