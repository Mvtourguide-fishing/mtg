import type { Metadata } from "next";

import {
  DivingDirectoryPage,
  divingDirectoryMetadata,
  type DivingDirectorySearchParams,
} from "@/components/diving/diving-directory-page";

export function generateMetadata({
  searchParams,
}: {
  searchParams: Promise<DivingDirectorySearchParams>;
}): Promise<Metadata> {
  return divingDirectoryMetadata(searchParams);
}

export default function DivingPage({
  searchParams,
}: {
  searchParams: Promise<DivingDirectorySearchParams>;
}) {
  return <DivingDirectoryPage searchParams={searchParams} />;
}
