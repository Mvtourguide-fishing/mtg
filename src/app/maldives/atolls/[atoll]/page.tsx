import type { Metadata } from "next";

import { AtollDetailPage, atollDetailMetadata } from "@/components/locations/atoll-detail-page";

export const revalidate = 3600;

interface Params {
  atoll: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { atoll: slug } = await params;
  return atollDetailMetadata(slug);
}

export default async function AtollPage({ params }: { params: Promise<Params> }) {
  const { atoll: slug } = await params;
  return <AtollDetailPage slug={slug} />;
}
