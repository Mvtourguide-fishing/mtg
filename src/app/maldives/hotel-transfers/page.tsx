import type { Metadata } from "next";

import {
  TransferCategoryLandingPage,
  transferCategoryMetadata,
  type TransferCategoryConfig,
} from "@/components/transfers/transfer-category-landing-page";
import { TRANSFER_CATEGORY_IMAGES } from "@/lib/transfers/category-images";

const config: TransferCategoryConfig = {
  slug: "hotel-transfers",
  eyebrow: "Budget & mid-range stays",
  h1: "Maldives Hotel Transfers",
  intro:
    "Hotels and guesthouses in the Maldives are located on local, inhabited islands rather than private resort islands — so a hotel transfer is really a local-island transfer. Real routes to the islands with hotel/guesthouse accommodation on record below.",
  metaTitle: "Maldives Hotel Transfers | Airport to Hotels & Islands",
  metaDescription: "Maldives hotel and guesthouse transfers — real airport-to-local-island transfer routes and prices for islands with hotel accommodation.",
  faqs: [
    {
      question: "Is a hotel transfer different from a resort transfer?",
      answer: "Yes — hotels and guesthouses sit on local, inhabited islands (like Maafushi), reached the same way as any local-island transfer: by public ferry or private speedboat, rather than a resort's own dedicated boat.",
    },
    {
      question: "How do I book a transfer to my hotel's island?",
      answer: "Find your hotel's island below — each route shows the real transfer options and prices on record. Your hotel may also arrange pickup directly; check with them first.",
    },
  ],
  category: "hotel-transfer",
  emptyMessage: "No hotel-island transfer routes recorded yet.",
  heroImage: TRANSFER_CATEGORY_IMAGES.hotelTransfers,
};

export function generateMetadata(): Metadata {
  return transferCategoryMetadata(config);
}

export default function HotelTransfersPage() {
  return <TransferCategoryLandingPage config={config} />;
}
