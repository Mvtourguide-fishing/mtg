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
  return packageCategoryMetadata("honeymoon", searchParams);
}

export default function HoneymoonPackagesPage({
  searchParams,
}: {
  searchParams: Promise<PackageCategoryPageSearchParams>;
}) {
  return <PackageCategoryPage category="honeymoon" searchParams={searchParams} />;
}
