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
  return packageCategoryMetadata("liveaboard", searchParams);
}

export default function LiveaboardPackagesPage({
  searchParams,
}: {
  searchParams: Promise<PackageCategoryPageSearchParams>;
}) {
  return <PackageCategoryPage category="liveaboard" searchParams={searchParams} />;
}
