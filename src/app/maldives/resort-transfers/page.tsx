import type { Metadata } from "next";

import {
  TransferCategoryLandingPage,
  transferCategoryMetadata,
  type TransferCategoryConfig,
} from "@/components/transfers/transfer-category-landing-page";
import { TRANSFER_CATEGORY_IMAGES } from "@/lib/transfers/category-images";

const config: TransferCategoryConfig = {
  slug: "resort-transfers",
  eyebrow: "Private resort islands",
  h1: "Maldives Resort Transfers",
  intro:
    "Nearly every Maldives resort occupies its own private island, reached from Velana International Airport by speedboat or seaplane. Real, resort-specific transfer routes and prices below.",
  metaTitle: "Maldives Resort Transfers | Airport to Resort Transfers",
  metaDescription: "Real Maldives resort transfer routes from Velana International Airport, by resort island — speedboat and seaplane prices.",
  faqs: [
    {
      question: "How do I get from the airport to my resort?",
      answer: "Most resorts run their own speedboat or seaplane transfer from Velana International Airport, timed around your flight — see the resort's own route below for its real price and typical journey time.",
    },
    {
      question: "Is the resort transfer included in my stay?",
      answer: "This varies by resort and rate — the price shown on each route is the transfer's own price as recorded, separate from any accommodation booking.",
    },
  ],
  category: "resort-transfer",
  emptyMessage: "No resort transfer routes recorded yet.",
  heroImage: TRANSFER_CATEGORY_IMAGES.resortTransfers,
};

export function generateMetadata(): Metadata {
  return transferCategoryMetadata(config);
}

export default function ResortTransfersPage() {
  return <TransferCategoryLandingPage config={config} />;
}
