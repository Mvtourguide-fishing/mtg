import type { Metadata } from "next";

import {
  FishingDirectoryPage,
  fishingDirectoryMetadata,
  type FishingDirectorySearchParams,
} from "@/components/fishing/fishing-directory-page";

export function generateMetadata({
  searchParams,
}: {
  searchParams: Promise<FishingDirectorySearchParams>;
}): Promise<Metadata> {
  return fishingDirectoryMetadata(searchParams);
}

export default function FishingPage({
  searchParams,
}: {
  searchParams: Promise<FishingDirectorySearchParams>;
}) {
  return <FishingDirectoryPage searchParams={searchParams} />;
}
