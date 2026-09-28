import type { Metadata } from "next";

import { TransferRouteDetailPage, transferRouteDetailMetadata } from "@/components/transfers/transfer-route-detail-page";

export const revalidate = 3600;

interface Params {
  route: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { route } = await params;
  return transferRouteDetailMetadata(route);
}

export default async function TransferRouteDetailRoute({ params }: { params: Promise<Params> }) {
  const { route } = await params;
  return <TransferRouteDetailPage slug={route} />;
}
