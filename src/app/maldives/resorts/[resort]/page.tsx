import type { Metadata } from "next";

import {
  AccommodationDetailPage,
  accommodationDetailMetadata,
} from "@/components/accommodation/accommodation-detail-page";

export const revalidate = 3600;

interface Params {
  resort: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { resort } = await params;
  return accommodationDetailMetadata("resort", resort);
}

export default async function ResortDetailPage({ params }: { params: Promise<Params> }) {
  const { resort } = await params;
  return <AccommodationDetailPage type="resort" slug={resort} />;
}
