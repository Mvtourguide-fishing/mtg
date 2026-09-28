import type { Metadata } from "next";

import { DiveSiteDetailPage, diveSiteDetailMetadata } from "@/components/diving/dive-site-detail-page";

export const revalidate = 3600;

interface Params {
  site: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { site } = await params;
  return diveSiteDetailMetadata(site);
}

export default async function DiveSiteDetailRoute({ params }: { params: Promise<Params> }) {
  const { site } = await params;
  return <DiveSiteDetailPage slug={site} />;
}
