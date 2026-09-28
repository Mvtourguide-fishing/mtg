import type { Metadata } from "next";

import { PackageDetailPage, packageDetailMetadata } from "@/components/packages/package-detail-page";

export const revalidate = 3600;

interface Params {
  package: string;
}

export async function generateMetadata({ params }: { params: Promise<Params> }): Promise<Metadata> {
  const { package: slug } = await params;
  return packageDetailMetadata(slug);
}

export default async function PackageDetailRoute({ params }: { params: Promise<Params> }) {
  const { package: slug } = await params;
  return <PackageDetailPage slug={slug} />;
}
