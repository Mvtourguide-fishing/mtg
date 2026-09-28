import type { Metadata } from "next";

import { SurfBreakDetailPage, surfBreakDetailMetadata } from "@/components/surfing/surf-break-detail-page";

export const revalidate = 3600;

interface Params {
  surfBreak: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { surfBreak } = await params;
  return surfBreakDetailMetadata(surfBreak);
}

export default async function SurfBreakDetailRoute({ params }: { params: Promise<Params> }) {
  const { surfBreak } = await params;
  return <SurfBreakDetailPage slug={surfBreak} />;
}
