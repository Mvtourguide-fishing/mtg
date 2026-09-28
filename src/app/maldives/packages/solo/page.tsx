import type { Metadata } from "next";

import {
  PackageCategoryPage,
  packageCategoryMetadata,
  type PackageCategoryPageSearchParams,
} from "@/components/packages/package-category-page";

export function generateMetadata({
  searchParams,
}: {
  searchParams: Promise<PackageCategoryPageSearchParams>;
}): Promise<Metadata> {
  return packageCategoryMetadata("solo", searchParams);
}

export default function SoloPackagesPage({
  searchParams,
}: {
  searchParams: Promise<PackageCategoryPageSearchParams>;
}) {
  return <PackageCategoryPage category="solo" searchParams={searchParams} />;
}
