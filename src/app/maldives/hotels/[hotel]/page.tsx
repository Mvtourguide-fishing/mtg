import type { Metadata } from "next";

import {
  AccommodationDetailPage,
  accommodationDetailMetadata,
} from "@/components/accommodation/accommodation-detail-page";

export const revalidate = 3600;

interface Params {
  hotel: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { hotel } = await params;
  return accommodationDetailMetadata("hotel", hotel);
}

export default async function HotelDetailPage({ params }: { params: Promise<Params> }) {
  const { hotel } = await params;
  return <AccommodationDetailPage type="hotel" slug={hotel} />;
}
