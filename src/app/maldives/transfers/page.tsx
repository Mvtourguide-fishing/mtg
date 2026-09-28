import type { Metadata } from "next";

import { TransferDirectoryPage, transferDirectoryMetadata } from "@/components/transfers/transfer-directory-page";

export function generateMetadata(): Metadata {
  return transferDirectoryMetadata();
}

export default function TransfersPage() {
  return <TransferDirectoryPage />;
}
