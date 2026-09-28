import type { Metadata } from "next";

import {
  TransferCategoryLandingPage,
  transferCategoryMetadata,
  type TransferCategoryConfig,
} from "@/components/transfers/transfer-category-landing-page";
import { TRANSFER_CATEGORY_IMAGES } from "@/lib/transfers/category-images";

const config: TransferCategoryConfig = {
  slug: "airport-transfers",
  eyebrow: "Velana International Airport",
  h1: "Maldives Airport Transfers",
  intro:
    "Every stay in the Maldives starts and ends at Velana International Airport (MLE), on Hulhulé Island next to Malé. From there, real transfer routes and prices — by speedboat, ferry, seaplane, or domestic flight — to resorts, hotels, and local islands across the country.",
  metaTitle: "Maldives Airport Transfers | Velana Airport to Resorts & Islands",
  metaDescription:
    "Real Velana International Airport (MLE) transfer routes and prices to Maldives resorts, hotels, and local islands — speedboat, ferry, seaplane, and domestic flight.",
  faqs: [
    {
      question: "How do I get from Velana International Airport to my resort?",
      answer:
        "Most resorts arrange a shared or private speedboat transfer directly from the airport, typically taking well under an hour for nearby atolls. Resorts further away may use a seaplane or a domestic flight plus a shorter boat transfer — see the specific route below for your destination.",
    },
    {
      question: "How do I reach a local island?",
      answer:
        "Local islands close to Malé, such as Maafushi, are reached by government ferry or a faster private speedboat service. See the Island Transfers page for real, individually priced routes.",
    },
    {
      question: "How long does the journey take?",
      answer: "It depends entirely on the destination — nearby islands can be reached in well under an hour, while remote atolls may take longer or require a seaplane or domestic flight connection.",
    },
    {
      question: "What does the transfer cost?",
      answer: "Prices vary by destination and operator — each route page below shows the real, source-verified price for that specific transfer.",
    },
  ],
  category: "airport",
  emptyMessage: "No airport transfer routes recorded yet.",
  heroImage: TRANSFER_CATEGORY_IMAGES.airportTransfers,
};

export function generateMetadata(): Metadata {
  return transferCategoryMetadata(config);
}

export default function AirportTransfersPage() {
  return <TransferCategoryLandingPage config={config} />;
}
