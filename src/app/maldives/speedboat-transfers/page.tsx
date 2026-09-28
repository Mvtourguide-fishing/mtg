import type { Metadata } from "next";

import {
  TransferCategoryLandingPage,
  transferCategoryMetadata,
  type TransferCategoryConfig,
} from "@/components/transfers/transfer-category-landing-page";
import { TRANSFER_CATEGORY_IMAGES } from "@/lib/transfers/category-images";

const config: TransferCategoryConfig = {
  slug: "speedboat-transfers",
  eyebrow: "By sea",
  h1: "Maldives Speedboat Transfers",
  intro:
    "Speedboat is the most common way to reach a Maldives resort or nearby local island from Velana International Airport — fast, scenic, and typically under an hour for atolls close to Malé. Real speedboat routes and prices below.",
  metaTitle: "Maldives Speedboat Transfers | Airport & Island Transfers",
  metaDescription: "Real Maldives speedboat transfer routes from Velana International Airport — prices and journey times by destination.",
  faqs: [
    {
      question: "Which destinations can be reached by speedboat?",
      answer: "Resorts and local islands in atolls near Malé are typically reached by speedboat — see the real routes below for exact destinations and journey times.",
    },
    {
      question: "How much do speedboat transfers cost?",
      answer: "Prices vary by resort/island and operator, generally in the tens to low hundreds of US dollars per person — each route below shows the actual price on record.",
    },
    {
      question: "How long do speedboat journeys take?",
      answer: "Most speedboat transfers from the airport take well under an hour; the exact duration depends on the destination and is shown on each route below where known.",
    },
    {
      question: "Where do speedboats depart from?",
      answer: "Speedboat transfers depart from the jetty at Velana International Airport, a short walk from the arrivals hall — resort staff or the operator typically meet guests there.",
    },
  ],
  transferType: "speedboat",
  emptyMessage: "No speedboat transfer routes recorded yet.",
  heroImage: TRANSFER_CATEGORY_IMAGES.speedboatTransfers,
};

export function generateMetadata(): Metadata {
  return transferCategoryMetadata(config);
}

export default function SpeedboatTransfersPage() {
  return <TransferCategoryLandingPage config={config} />;
}
