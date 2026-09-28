import type { Metadata } from "next";

import {
  SurfBreakDirectoryPage,
  surfBreakDirectoryMetadata,
  type SurfBreakDirectorySearchParams,
} from "@/components/surfing/surf-break-directory-page";

export function generateMetadata({
  searchParams,
}: {
  searchParams: Promise<SurfBreakDirectorySearchParams>;
}): Promise<Metadata> {
  return surfBreakDirectoryMetadata(searchParams);
}

export default function SurfBreaksPage({
  searchParams,
}: {
  searchParams: Promise<SurfBreakDirectorySearchParams>;
}) {
  return <SurfBreakDirectoryPage searchParams={searchParams} />;
}
