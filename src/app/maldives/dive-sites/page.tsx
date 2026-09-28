import type { Metadata } from "next";

import {
  DiveSiteDirectoryPage,
  diveSiteDirectoryMetadata,
  type DiveSiteDirectorySearchParams,
} from "@/components/diving/dive-site-directory-page";

export function generateMetadata({
  searchParams,
}: {
  searchParams: Promise<DiveSiteDirectorySearchParams>;
}): Promise<Metadata> {
  return diveSiteDirectoryMetadata(searchParams);
}

export default function DiveSitesPage({
  searchParams,
}: {
  searchParams: Promise<DiveSiteDirectorySearchParams>;
}) {
  return <DiveSiteDirectoryPage searchParams={searchParams} />;
}
