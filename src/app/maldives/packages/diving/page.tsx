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
  return packageCategoryMetadata("diving", searchParams);
}

export default function DivingPackagesPage({
  searchParams,
}: {
  searchParams: Promise<PackageCategoryPageSearchParams>;
}) {
  return <PackageCategoryPage category="diving" searchParams={searchParams} />;
}
