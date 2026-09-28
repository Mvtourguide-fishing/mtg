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
  return accommodationDirectoryMetadata("resort", searchParams);
}

export default function ResortsPage({
  searchParams,
}: {
  searchParams: Promise<AccommodationDirectorySearchParams>;
}) {
  return <AccommodationDirectoryPage type="resort" searchParams={searchParams} />;
}
