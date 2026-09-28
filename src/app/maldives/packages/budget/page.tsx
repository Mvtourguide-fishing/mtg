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
  return packageCategoryMetadata("budget", searchParams);
}

export default function BudgetPackagesPage({
  searchParams,
}: {
  searchParams: Promise<PackageCategoryPageSearchParams>;
}) {
  return <PackageCategoryPage category="budget" searchParams={searchParams} />;
}
