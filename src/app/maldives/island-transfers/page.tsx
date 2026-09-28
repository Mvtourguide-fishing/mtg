import type { Metadata } from "next";

import {
  TransferCategoryLandingPage,
  transferCategoryMetadata,
  type TransferCategoryConfig,
} from "@/components/transfers/transfer-category-landing-page";
import { TRANSFER_CATEGORY_IMAGES } from "@/lib/transfers/category-images";

const config: TransferCategoryConfig = {
  slug: "island-transfers",
  eyebrow: "Local islands",
  h1: "Maldives Island Transfers",
  intro:
    "Local Maldivian islands such as Malé and Maafushi are reached from Velana International Airport by public ferry or a faster private speedboat — a budget-friendly way to experience the Maldives outside a private resort.",
  metaTitle: "Maldives Island Transfers | Airport to Local Islands",
  metaDescription: "Real Maldives local-island transfer routes from Velana International Airport — public ferry and speedboat options and prices.",
  faqs: [
    {
      question: "How do I get from the airport to a local island?",
      answer: "Local islands near Malé are reached by government ferry (the cheapest option) or a private speedboat operator — see the real routes and prices below for each island.",
    },
    {
      question: "Are local-island transfers cheaper than resort transfers?",
      answer: "Generally yes — public ferry fares to nearby local islands are typically far lower than a resort's private speedboat transfer, though the journey usually takes longer.",
    },
  ],
  category: "island-transfer",
  emptyMessage: "No local-island transfer routes recorded yet.",
  heroImage: TRANSFER_CATEGORY_IMAGES.islandTransfers,
};

export function generateMetadata(): Metadata {
  return transferCategoryMetadata(config);
}

export default function IslandTransfersPage() {
  return <TransferCategoryLandingPage config={config} />;
}
