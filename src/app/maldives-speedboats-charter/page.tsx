import type { Metadata } from "next";

import { speedboatDirectoryMetadata, SpeedboatDirectoryPage } from "@/components/speedboats/speedboat-directory-page";

export function generateMetadata(): Metadata {
  return speedboatDirectoryMetadata();
}

export default function Page() {
  return <SpeedboatDirectoryPage />;
}
