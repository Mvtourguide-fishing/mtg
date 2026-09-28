import type { Metadata } from "next";

import {
  AccommodationDetailPage,
  accommodationDetailMetadata,
} from "@/components/accommodation/accommodation-detail-page";

export const revalidate = 3600;

interface Params {
  guesthouse: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { guesthouse } = await params;
  return accommodationDetailMetadata("guesthouse", guesthouse);
}

export default async function GuesthouseDetailPage({ params }: { params: Promise<Params> }) {
  const { guesthouse } = await params;
  return <AccommodationDetailPage type="guesthouse" slug={guesthouse} />;
}
