import type { Metadata } from "next";

import {
  AttractionDirectoryPage,
  attractionDirectoryMetadata,
  type AttractionDirectorySearchParams,
} from "@/components/attractions/attraction-directory-page";

export function generateMetadata({
  searchParams,
}: {
  searchParams: Promise<AttractionDirectorySearchParams>;
}): Promise<Metadata> {
  return attractionDirectoryMetadata(searchParams);
}

export default function AttractionsPage({
  searchParams,
}: {
  searchParams: Promise<AttractionDirectorySearchParams>;
}) {
  return <AttractionDirectoryPage searchParams={searchParams} />;
}
