import type { PackageCategorySlug } from "@/lib/packages/view-types";

export interface PackageCategoryContent {
  metaTitle: string;
  metaDescription: string;
  intro: string;
  faqs: Array<{ question: string; answer: string }>;
  relatedLinks: Array<{ href: string; label: string }>;
}

/**
 * Task 21 §25/§26: genuinely different content per category page — not a
 * heading + paragraph + package grid. Every claim here is general,
 * verifiable travel-planning information (how transfers/booking work on
 * this site, real Maldives geography/seasons), never a specific
 * fabricated statistic about any resort or package.
 */
export const PACKAGE_CATEGORY_CONTENT: Record<PackageCategorySlug, PackageCategoryContent> = {
  luxury: {
    metaTitle: "Maldives Luxury Packages | Luxury Maldives Holidays",
    metaDescription: "Real Maldives luxury holiday packages — overwater villas, private-island resorts, and genuine 5-star experiences. Search, compare, and enquire.",
    intro:
      "A luxury Maldives holiday usually means an overwater villa, a private-island resort with its own dive centre and restaurants, and a level of privacy that's hard to find elsewhere. The packages below are built around real resorts already in our catalogue — never an invented property or star rating.",
    faqs: [
      { question: "What makes a Maldives resort 'luxury'?", answer: "Typically an overwater villa, a private island with limited guest numbers, and an all-inclusive or premium dining structure — see each package's own Included section for specifics." },
      { question: "Do luxury packages include transfers?", answer: "Most do — check each package's Included section; longer transfers (domestic flight, seaplane) are common for the more remote luxury resorts." },
      { question: "Are luxury packages good for honeymoons?", answer: "Yes — see our Honeymoon Packages for luxury options specifically curated around couples." },
    ],
    relatedLinks: [
      { href: "/maldives/resorts/", label: "Maldives Resorts" },
      { href: "/maldives/packages/honeymoon/", label: "Honeymoon Packages" },
      { href: "/maldives-speedboats-charter/", label: "Private Speedboat Charter" },
    ],
  },
  family: {
    metaTitle: "Maldives Family Packages | Family Holidays & Vacations",
    metaDescription: "Real Maldives family holiday packages — resorts and local islands with genuine family-friendly activities on record. Search, compare, and enquire.",
    intro:
      "Family trips to the Maldives work best with a resort close to the airport (shorter transfer with kids) and enough real activities on-site to fill the days. Every package below references activities and accommodation actually in our catalogue.",
    faqs: [
      { question: "Which resorts are good for families?", answer: "Look for a shorter airport transfer and a real range of family activities — each package below lists exactly what's included." },
      { question: "Are transfers included for families with children?", answer: "Check each package's own Included section — most resort packages include the transfer as standard." },
      { question: "Can we combine a resort stay with a local island?", answer: "Yes — enquire on any package and mention you'd like to combine destinations; we'll check what's actually possible." },
    ],
    relatedLinks: [
      { href: "/maldives/resort-transfers/", label: "Resort Transfers" },
      { href: "/maldives/activities/", label: "Maldives Activities" },
      { href: "/maldives/travel-guide/", label: "Travel Guide" },
    ],
  },
  "adults-only": {
    metaTitle: "Maldives Adults Only Packages | Quiet, Couples-Focused Holidays",
    metaDescription: "Maldives packages curated for adult travelers wanting a quieter, no-schedule stay. Search, compare, and enquire.",
    intro:
      "Not every trip needs a kids' club. These packages are curated around free time, spa, and quiet — always check a resort's own current policy directly before booking if a formal adults-only rule matters to your trip.",
    faqs: [
      { question: "Do these resorts have a formal adults-only policy?", answer: "Policies can change — always confirm directly with us or the resort before booking if this is a firm requirement." },
      { question: "Are these packages good for honeymoons?", answer: "Yes — many overlap with our Honeymoon Packages; see that category for more romantic-focused options." },
      { question: "Can I add spa treatments?", answer: "Enquire on the specific package — we'll check what's genuinely available at that resort." },
    ],
    relatedLinks: [
      { href: "/maldives/packages/honeymoon/", label: "Honeymoon Packages" },
      { href: "/maldives/packages/luxury/", label: "Luxury Packages" },
      { href: "/maldives/resorts/", label: "Maldives Resorts" },
    ],
  },
  "long-stay": {
    metaTitle: "Maldives Long Stay Packages | Extended Maldives Holidays",
    metaDescription: "Real Maldives long-stay packages — 10+ nights on a resort or local island. Search, compare, and enquire.",
    intro:
      "A longer Maldives stay changes the trip entirely — less checking things off a list, more actually settling in. These packages run 10 nights or more, on either a resort island or a genuinely affordable local island base.",
    faqs: [
      { question: "Is a long stay cheaper per night than a short trip?", answer: "Often, yes, especially on local islands — check each package's own per-night rate against a shorter equivalent." },
      { question: "Can I split a long stay across two islands?", answer: "Enquire and mention it — combining a resort stay with a local island is often possible." },
      { question: "Do long-stay packages include all meals?", answer: "Varies — check each package's own Included section." },
    ],
    relatedLinks: [
      { href: "/maldives/packages/budget/", label: "Budget Packages" },
      { href: "/maldives/islands/", label: "Maldives Islands" },
      { href: "/maldives/travel-guide/", label: "Travel Guide" },
    ],
  },
  budget: {
    metaTitle: "Maldives Budget Packages | Affordable Maldives Holidays",
    metaDescription: "Real Maldives budget holiday packages — local island guesthouses and hotels at a fraction of resort-island prices. Search, compare, and enquire.",
    intro:
      "The Maldives doesn't have to mean an expensive private-island resort. Local, inhabited islands like Maafushi and Ukulhas have real guesthouses and hotels, their own beaches, and genuine local dive/fishing operators — usually at a fraction of resort prices.",
    faqs: [
      { question: "How do I get to a local island?", answer: "Public ferry (cheapest) or a private speedboat — see our Island Transfers page for real routes and schedules." },
      { question: "Is a local island as nice as a resort?", answer: "It's a different experience — a real Maldivian community rather than a private island, with its own beach access (often a designated 'bikini beach' area)." },
      { question: "Can I do activities like diving on a budget trip?", answer: "Yes — local dive and fishing operators run real trips from these islands; see each package's own Included section." },
    ],
    relatedLinks: [
      { href: "/maldives/island-transfers/", label: "Island Transfers" },
      { href: "/maldives/guesthouses/", label: "Maldives Guesthouses" },
      { href: "/maldives-ferry-schedule/", label: "Ferry Schedule" },
    ],
  },
  honeymoon: {
    metaTitle: "Maldives Honeymoon Packages | Romantic Maldives Holidays",
    metaDescription: "Real Maldives honeymoon packages — overwater villas, private dining, and romantic resort experiences. Search, compare, and enquire.",
    intro:
      "Honeymoon packages here center on overwater villas, private dining set-ups, and resorts with a genuinely romantic, adult-focused feel — every one anchored to a real resort already in our catalogue, never an invented property.",
    faqs: [
      { question: "What's typically included in a honeymoon package?", answer: "Check each package's own Included section — many include breakfast, and some offer a private dinner as an add-on you can enquire about." },
      { question: "Are these resorts adults-only?", answer: "See our Adults Only Packages category, or ask us directly for that specific resort's current policy." },
      { question: "Can we add a diving experience?", answer: "Several honeymoon packages already include a Discover Scuba Diving session — check each one's Included list, or enquire to add one." },
    ],
    relatedLinks: [
      { href: "/maldives/packages/luxury/", label: "Luxury Packages" },
      { href: "/maldives/packages/adults-only/", label: "Adults Only Packages" },
      { href: "/maldives/resorts/", label: "Maldives Resorts" },
    ],
  },
  solo: {
    metaTitle: "Maldives Solo Packages | Solo Travel in the Maldives",
    metaDescription: "Real Maldives solo travel packages — local island guesthouses and budget-friendly bases genuinely suited to traveling alone. Search, compare, and enquire.",
    intro:
      "Traveling solo in the Maldives works best on local islands, where guesthouses are genuinely set up for independent travelers rather than couples-only resort packages. These packages are built around real guesthouses already in our catalogue.",
    faqs: [
      { question: "Is the Maldives safe for solo travelers?", answer: "Local islands are genuinely welcoming to solo travelers — guesthouses are used to independent guests, and island communities are small and easy to navigate." },
      { question: "Will I pay a single supplement?", answer: "Check each package's own price basis (per-person vs. per-couple) — local-island guesthouse packages are usually priced per person already." },
      { question: "Can I meet other travelers?", answer: "Local islands like Maafushi and Ukulhas have a real backpacker/traveler community — guesthouse common areas and group activities are a natural way to meet people." },
    ],
    relatedLinks: [
      { href: "/maldives/packages/budget/", label: "Budget Packages" },
      { href: "/maldives/guesthouses/", label: "Maldives Guesthouses" },
      { href: "/maldives/surfing/", label: "Surfing" },
    ],
  },
  diving: {
    metaTitle: "Maldives Diving Packages | Maldives Dive Holidays",
    metaDescription: "Real Maldives diving holiday packages — resort dive centres and local island operators, real courses and guided dives. Search, compare, and enquire.",
    intro:
      "The Maldives is one of the world's best-known diving destinations — real reef drop-offs, channels, and pelagic life across its atolls. These packages reference real diving activities and operators already in our catalogue, from resort dive centres to local-island courses.",
    faqs: [
      { question: "Do I need to be certified to dive here?", answer: "No — Discover Scuba Diving sessions are a supervised introduction for first-timers; several packages include one." },
      { question: "Can I get PADI certified on a package?", answer: "Yes — several packages include a full PADI Open Water or Advanced course; check each package's Included section." },
      { question: "What's the difference between a resort dive package and a liveaboard?", answer: "A resort package dives from a single island base each day; a liveaboard (see our Liveaboard Packages) covers multiple sites across an atoll over one continuous trip." },
    ],
    relatedLinks: [
      { href: "/maldives/diving/", label: "Diving" },
      { href: "/maldives/dive-sites/", label: "Dive Sites" },
      { href: "/maldives/packages/liveaboard/", label: "Liveaboard Packages" },
    ],
  },
  fishing: {
    metaTitle: "Maldives Fishing Holiday Packages | Fishing Holidays in the Maldives",
    metaDescription: "Real Maldives fishing holiday packages — sunset, night and big-game fishing trips with genuine local and resort operators. Search, compare, and enquire.",
    intro:
      "Traditional Maldivian handline fishing and modern sport fishing both have a real place here — sunset reef trips, night fishing, and offshore big-game charters targeting marlin and tuna. Every trip referenced below is a real activity already in our catalogue.",
    faqs: [
      { question: "What kind of fishing trips are available?", answer: "Sunset/night reef fishing (relaxed, beginner-friendly) and big-game/sport fishing charters (offshore, targeting larger species) — see each package's Included section." },
      { question: "Do I need my own gear?", answer: "No — real fishing trips on this site are guided and equipped by the operator." },
      { question: "Can non-anglers come along?", answer: "Often, yes, especially on sunset trips — enquire with the specific package to confirm." },
    ],
    relatedLinks: [
      { href: "/maldives/fishing/", label: "Fishing" },
      { href: "/maldives/islands/", label: "Maldives Islands" },
      { href: "/maldives/packages/budget/", label: "Budget Packages" },
    ],
  },
  surfing: {
    metaTitle: "Maldives Surfing Packages | Maldives Surf Holidays",
    metaDescription: "Real Maldives surfing holiday packages — genuine surf islands like Thulusdhoo with real lessons and boat trips. Search, compare, and enquire.",
    intro:
      "Thulusdhoo and a handful of other islands are genuinely known surf bases in the Maldives, close to well-regarded breaks. These packages reference real surf lessons, boat trips and camps already in our catalogue.",
    faqs: [
      { question: "Do I need surfing experience?", answer: "No — beginner lessons are available; check each package's Included section for what's actually offered." },
      { question: "When is the surf season?", answer: "Generally the Southwest monsoon months (roughly May–October) bring the most consistent swell, though this varies year to year — confirm current conditions when you enquire." },
      { question: "Can I rent a board without a lesson?", answer: "Yes — see the package's Included section; several offer standalone board rental." },
    ],
    relatedLinks: [
      { href: "/maldives/surfing/", label: "Surfing" },
      { href: "/maldives/surf-breaks/", label: "Surf Breaks" },
      { href: "/maldives/packages/solo/", label: "Solo Packages" },
    ],
  },
  liveaboard: {
    metaTitle: "Maldives Liveaboard Packages | Liveaboard Diving Expeditions",
    metaDescription: "Maldives liveaboard diving packages — a multi-day trip aboard a dive vessel covering several atolls' dive sites. Search, compare, and enquire.",
    intro:
      "A liveaboard trades a single-island base for a boat that moves between dive sites across an atoll or more, typically reaching sites a shore-based operator can't. We don't yet have a confirmed real liveaboard operator on record — enquire and we'll help arrange real vessel and schedule details.",
    faqs: [
      { question: "How is a liveaboard different from a resort dive package?", answer: "You live aboard the vessel itself rather than a single island, reaching more dive sites across a wider area in one trip — see our Diving Packages for the resort/local-island alternative." },
      { question: "Do I need to be certified?", answer: "Most liveaboards require at least an Open Water certification — confirm with us when you enquire." },
      { question: "How many dives per day?", answer: "Typically up to 3 on a diving-focused liveaboard, though this depends on the specific vessel and itinerary." },
    ],
    relatedLinks: [
      { href: "/maldives/diving/", label: "Diving" },
      { href: "/maldives/dive-sites/", label: "Dive Sites" },
      { href: "/maldives/atolls/alif-alif/", label: "Alif Alif Atoll" },
    ],
  },
};
