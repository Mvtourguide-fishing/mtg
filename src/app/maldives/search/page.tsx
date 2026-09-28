import type { Metadata } from "next";

import { SearchResultsPage, searchPageMetadata, type SearchPageSearchParams } from "@/components/search/search-page";

export function generateMetadata({
  searchParams,
}: {
  searchParams: Promise<SearchPageSearchParams>;
}): Promise<Metadata> {
  return searchPageMetadata(searchParams);
}

export default function SearchPage({
  searchParams,
}: {
  searchParams: Promise<SearchPageSearchParams>;
}) {
  return <SearchResultsPage searchParams={searchParams} />;
}
