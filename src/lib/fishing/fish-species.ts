import { asset } from "@/lib/packages/category-images";
import type { MediaAsset } from "@/lib/media/types";

/**
 * Real content recovered from the legacy site
 * (release/public_html/fishing/fish-species-maldives.html) — 20 species
 * across the same 4 categories that page used, each with its own real
 * legacy photo (every id below verified against
 * data/maldives/migration/full-legacy-image-library-manifest.json before
 * being hardcoded here, same rule as every other Task 14+ script/file).
 *
 * The Manta Ray entry uses a different real legacy photo than the one the
 * old page linked (images/diving/mantarays.webp doesn't exist in the
 * migrated library) — images/activities/New folder/Manta-Ray-Snorkeling-in-the-Maldives.webp
 * is a genuine manta ray photo from the same legacy site, confirmed present.
 *
 * Static, hand-authored data (not DB-driven) — same convention as
 * category-images.ts and package-images.ts, appropriate for a small, fixed,
 * real content set that never needs a CMS-style edit flow.
 */

export type FishSpeciesCategorySlug = "reef-fish" | "pelagic-fish" | "bottom-dwellers" | "sharks-rays";

export interface FishSpeciesCategory {
  slug: FishSpeciesCategorySlug;
  title: string;
  intro: string;
}

export interface FishSpecies {
  slug: string;
  name: string;
  scientificName: string;
  category: FishSpeciesCategorySlug;
  size: string;
  habitat: string;
  /** Diet for most species; a few (pelagic species, per the source page)
   * use this same field for their best fishing season instead. */
  dietOrSeason: string;
  dietOrSeasonLabel: "Diet" | "Best Season" | "Status";
  description: string;
  image: MediaAsset;
}

export const FISH_SPECIES_CATEGORIES: FishSpeciesCategory[] = [
  {
    slug: "reef-fish",
    title: "Reef Fish",
    intro:
      "The vibrant coral reefs of the Maldives support an incredible diversity of reef-dwelling fish species — the backbone of the reef ecosystem and a delight for snorkelers and divers.",
  },
  {
    slug: "pelagic-fish",
    title: "Pelagic Fish",
    intro:
      "The open waters surrounding the Maldives' atolls are home to powerful pelagic species that roam the Indian Ocean, prized by anglers and crucial to the marine ecosystem.",
  },
  {
    slug: "bottom-dwellers",
    title: "Bottom Dwellers",
    intro:
      "The sandy bottoms, reef bases, and rocky areas of the Maldives are home to a variety of bottom-dwelling species, both ecologically important and prized by anglers.",
  },
  {
    slug: "sharks-rays",
    title: "Sharks & Rays",
    intro:
      "The Maldives is a sanctuary for various shark and ray species, which play crucial roles in maintaining healthy marine ecosystems. Many are protected under Maldivian law.",
  },
];

export const FISH_SPECIES: FishSpecies[] = [
  // Reef Fish
  {
    slug: "butterflyfish",
    name: "Butterflyfish",
    scientificName: "Chaetodontidae family",
    category: "reef-fish",
    size: "12-22 cm",
    habitat: "Coral reefs",
    dietOrSeason: "Coral polyps, invertebrates",
    dietOrSeasonLabel: "Diet",
    description:
      "With their distinctive disk-shaped bodies and vibrant patterns, butterflyfish are among the most recognizable reef fish in the Maldives. The archipelago is home to over 40 species, including the iconic Threadfin Butterflyfish and the Raccoon Butterflyfish. They're often seen in pairs, meticulously picking at coral polyps with their specialized snouts.",
    image: asset("5952e704-4f3e-7b97-3c86-719cf879e437", "legacy/fishing/images/butterfly-fish.webp", "Butterflyfish in the Maldives"),
  },
  {
    slug: "angelfish",
    name: "Angelfish",
    scientificName: "Pomacanthidae family",
    category: "reef-fish",
    size: "15-45 cm",
    habitat: "Reef slopes, lagoons",
    dietOrSeason: "Sponges, algae, invertebrates",
    dietOrSeasonLabel: "Diet",
    description:
      "Angelfish are among the most beautiful fish in Maldivian waters, with their vibrant colors and elegant fins. The Emperor Angelfish undergoes a remarkable transformation from its juvenile \"blue ring\" pattern to the striking yellow and blue adult form. Other common species include the Regal Angelfish and the Semicircle Angelfish.",
    image: asset("8f209f81-bd00-a318-68ea-c7841aedbb3a", "legacy/fishing/images/angel-fish.webp", "Emperor Angelfish in the Maldives"),
  },
  {
    slug: "parrotfish",
    name: "Parrotfish",
    scientificName: "Scaridae family",
    category: "reef-fish",
    size: "30-120 cm",
    habitat: "Coral reefs, lagoons",
    dietOrSeason: "Coral, algae",
    dietOrSeasonLabel: "Diet",
    description:
      "Named for their fused teeth that resemble a parrot's beak, these colorful fish play a crucial role in reef health by cleaning algae and creating sand. The Maldives hosts numerous species, including the Steephead Parrotfish and the Bullethead Parrotfish. Many parrotfish species change color and even gender as they mature.",
    image: asset("900cd205-4d09-fc07-d87b-cc79a3ed2bb9", "legacy/fishing/images/parrot-fish.webp", "Parrotfish in the Maldives"),
  },
  {
    slug: "wrasse",
    name: "Wrasse",
    scientificName: "Labridae family",
    category: "reef-fish",
    size: "10-230 cm",
    habitat: "Varied reef environments",
    dietOrSeason: "Crustaceans, mollusks, fish",
    dietOrSeasonLabel: "Diet",
    description:
      "The wrasse family includes some of the most diverse and colorful fish in the Maldives. From the tiny Cleaner Wrasse that sets up \"cleaning stations\" for larger fish to the massive Napoleon Wrasse (which can grow to over 2 meters), these fish are fascinating to observe. The Napoleon Wrasse is protected in the Maldives due to its vulnerable conservation status.",
    image: asset("7f9725e7-fd00-b7e2-dd37-608d3de55985", "legacy/fishing/images/napoleon-wrasse.jpg", "Napoleon Wrasse in the Maldives"),
  },
  {
    slug: "triggerfish",
    name: "Triggerfish",
    scientificName: "Balistidae family",
    category: "reef-fish",
    size: "30-75 cm",
    habitat: "Reef flats, lagoons",
    dietOrSeason: "Crustaceans, coral, sea urchins",
    dietOrSeasonLabel: "Diet",
    description:
      "Known for their oval-shaped bodies and powerful jaws, triggerfish are common throughout Maldivian reefs. The Titan Triggerfish is the largest species and can be territorial, especially during nesting season. The Clown Triggerfish, with its polka-dot pattern, is one of the most visually striking fish in the ocean.",
    image: asset("a0f822d5-ef1d-096a-7733-9c491dbebe6e", "legacy/fishing/images/trigger-fish.webp", "Titan Triggerfish in the Maldives"),
  },
  {
    slug: "anemonefish",
    name: "Anemonefish (Clownfish)",
    scientificName: "Amphiprioninae subfamily",
    category: "reef-fish",
    size: "7-15 cm",
    habitat: "Sea anemones on reefs",
    dietOrSeason: "Algae, zooplankton",
    dietOrSeasonLabel: "Diet",
    description:
      "Made famous by the movie \"Finding Nemo,\" clownfish or anemonefish are beloved for their bright orange coloration and symbiotic relationship with sea anemones. The Maldives is home to several species, including the Clark's Anemonefish and the Maldives Anemonefish, which is endemic to the region.",
    image: asset("ed076800-70ea-de89-765c-9052120f3f95", "legacy/fishing/images/clownfish-maldives.webp", "Clownfish in the Maldives"),
  },

  // Pelagic Fish
  {
    slug: "yellowfin-tuna",
    name: "Yellowfin Tuna",
    scientificName: "Thunnus albacares",
    category: "pelagic-fish",
    size: "Up to 200 cm / 200 kg",
    habitat: "Open ocean, atoll edges",
    dietOrSeason: "December - March",
    dietOrSeasonLabel: "Best Season",
    description:
      "Yellowfin tuna are powerful, fast-swimming predators identified by their bright yellow fins and streamlined bodies. They're a primary target for sport fishermen in the Maldives and are also commercially important. These fish can be found around the edges of atolls and in open water, often hunting in schools and capable of impressive speeds.",
    image: asset("572c610a-06c9-2ce3-7a45-a3e102138d7c", "uploads/assets/uploads/fishing/images/gallery/yellowfin-tuna.webp", "Yellowfin Tuna in the Maldives"),
  },
  {
    slug: "skipjack-tuna",
    name: "Skipjack Tuna",
    scientificName: "Katsuwonus pelamis",
    category: "pelagic-fish",
    size: "Up to 100 cm / 20 kg",
    habitat: "Surface waters, near atolls",
    dietOrSeason: "Year-round",
    dietOrSeasonLabel: "Best Season",
    description:
      "Skipjack tuna are the most abundant tuna species in Maldivian waters and form the backbone of the traditional pole-and-line fishing industry. They're identified by their distinctive dark stripes on the lower body. These fast-growing fish travel in large schools and are often found feeding near the surface, making them accessible to traditional fishing methods.",
    image: asset("b01af010-f4a9-7461-9134-cfa8377a9e49", "legacy/images/fishing/tuna-fish-in-maldives.webp", "Skipjack Tuna in the Maldives"),
  },
  {
    slug: "giant-trevally",
    name: "Giant Trevally (GT)",
    scientificName: "Caranx ignobilis",
    category: "pelagic-fish",
    size: "Up to 170 cm / 80 kg",
    habitat: "Reef edges, channels, open water",
    dietOrSeason: "April - October",
    dietOrSeasonLabel: "Best Season",
    description:
      "The Giant Trevally or GT is the ultimate sport fishing challenge in the Maldives. These powerful predators are known for their explosive strikes and incredible fighting strength. Silver-gray in color, they patrol reef edges and channels, hunting smaller fish with remarkable aggression. The Maldives is one of the best destinations worldwide for targeting trophy-sized GTs.",
    image: asset("9caab764-5e7b-5cf3-dc39-30bb3b9a98d8", "legacy/images/fishing/giant-trevally-fish.webp", "Giant Trevally in the Maldives"),
  },
  {
    slug: "dogtooth-tuna",
    name: "Dogtooth Tuna",
    scientificName: "Gymnosarda unicolor",
    category: "pelagic-fish",
    size: "Up to 130 cm / 70 kg",
    habitat: "Deep reef slopes, drop-offs",
    dietOrSeason: "November - April",
    dietOrSeasonLabel: "Best Season",
    description:
      "Named for their prominent, dog-like teeth, Dogtooth Tuna are powerful predators that inhabit the deeper reef slopes and drop-offs around Maldivian atolls. They're known for their incredible fighting ability and tendency to dive deep when hooked. These solitary hunters are prized catches for experienced anglers using jigging techniques.",
    image: asset("390aad4e-f870-8e2c-0869-bbb6906dba92", "legacy/fishing/images/dogtooth-tuna-in-maldives.webp", "Dogtooth Tuna in the Maldives"),
  },
  {
    slug: "wahoo",
    name: "Wahoo",
    scientificName: "Acanthocybium solandri",
    category: "pelagic-fish",
    size: "Up to 250 cm / 80 kg",
    habitat: "Open ocean, atoll edges",
    dietOrSeason: "December - March",
    dietOrSeasonLabel: "Best Season",
    description:
      "Wahoo are among the fastest fish in the ocean, capable of speeds up to 80 km/h. Their streamlined, torpedo-shaped bodies and razor-sharp teeth make them formidable predators. In the Maldives, they're often found near the edges of atolls and are prized for both their fighting ability and excellent taste. Trolling is the most effective method for targeting wahoo.",
    image: asset("e5ffdf3e-f374-906a-92b3-61c4c7190d3c", "uploads/assets/uploads/fishing/images/gallery/wahoo-in-maldives.webp", "Wahoo in the Maldives"),
  },
  {
    slug: "mahi-mahi",
    name: "Mahi-Mahi (Dolphinfish)",
    scientificName: "Coryphaena hippurus",
    category: "pelagic-fish",
    size: "Up to 210 cm / 40 kg",
    habitat: "Open ocean, floating debris",
    dietOrSeason: "December - April",
    dietOrSeasonLabel: "Best Season",
    description:
      "With their vibrant colors and distinctive blunt head, Mahi-Mahi are among the most beautiful pelagic fish. Males develop a prominent forehead as they mature. These fast-growing fish are often found near floating debris or FADs (Fish Aggregating Devices) and are known for their acrobatic jumps when hooked. They're excellent table fare and a popular target for sport fishermen.",
    image: asset("080f091e-1114-7565-3709-c85533388ec2", "uploads/assets/uploads/fishing/images/gallery/mahi-mahi-fish.webp", "Mahi-Mahi in the Maldives"),
  },

  // Bottom Dwellers
  {
    slug: "groupers",
    name: "Groupers",
    scientificName: "Epinephelinae subfamily",
    category: "bottom-dwellers",
    size: "30-250 cm (species dependent)",
    habitat: "Reef caves, drop-offs",
    dietOrSeason: "Fish, crustaceans",
    dietOrSeasonLabel: "Diet",
    description:
      "The Maldives is home to numerous grouper species, from the colorful Coral Grouper to the massive Goliath Grouper. These ambush predators typically hide in reef crevices and caves, darting out to capture prey. Many grouper species change sex from female to male as they grow larger. They're highly prized for their firm, white flesh but are vulnerable to overfishing.",
    image: asset("9470f23c-f113-241a-49ae-eb70b72218dd", "legacy/images/fishing/groupers-maldives.webp", "Coral Grouper in the Maldives"),
  },
  {
    slug: "snappers",
    name: "Snappers",
    scientificName: "Lutjanidae family",
    category: "bottom-dwellers",
    size: "30-100 cm (species dependent)",
    habitat: "Reef edges, sandy bottoms",
    dietOrSeason: "Fish, crustaceans, mollusks",
    dietOrSeasonLabel: "Diet",
    description:
      "Snappers are common throughout Maldivian waters, with species like the Red Snapper and Humpback Snapper being particularly abundant. These fish are characterized by their strong teeth and are often found in schools around reef edges and drop-offs. They're popular targets for bottom fishing and provide excellent eating.",
    image: asset("6a568121-cf94-c905-4b2d-bba7ceff1137", "uploads/assets/uploads/fishing/images/gallery/redsnappers-in-maldives.webp", "Red Snapper in the Maldives"),
  },
  {
    slug: "emperor-fish",
    name: "Emperor Fish",
    scientificName: "Lethrinidae family",
    category: "bottom-dwellers",
    size: "30-100 cm (species dependent)",
    habitat: "Sandy areas, lagoons, reef flats",
    dietOrSeason: "Crustaceans, mollusks, small fish",
    dietOrSeasonLabel: "Diet",
    description:
      "Emperor fish, including the popular Spangled Emperor, are common in the sandy areas and reef flats of the Maldives. They have powerful jaws designed for crushing shells and crustaceans. These fish are easily identified by their slightly elongated snouts and bright coloration. They're excellent table fish and a common target for both traditional and modern fishing methods.",
    image: asset("5a37ef28-6eb2-9443-dc66-ca56a994189d", "legacy/fishing/images/emperor-fish-maldives.webp", "Spangled Emperor in the Maldives"),
  },
  {
    slug: "sweetlips",
    name: "Sweetlips",
    scientificName: "Haemulidae family",
    category: "bottom-dwellers",
    size: "30-60 cm",
    habitat: "Reef slopes, caves",
    dietOrSeason: "Crustaceans, worms",
    dietOrSeasonLabel: "Diet",
    description:
      "Named for their thick, fleshy lips, sweetlips are striking fish with distinctive spotted or striped patterns. The Oriental Sweetlips and Harlequin Sweetlips are common in Maldivian waters. Juveniles have even more dramatic patterns and perform a unique \"dancing\" swimming style. These fish are typically found in small groups around reef slopes and caves.",
    image: asset("adc042af-2741-3a01-1fac-a989b1175d0c", "legacy/fishing/images/sweetlips-maldives.webp", "Oriental Sweetlips in the Maldives"),
  },

  // Sharks & Rays
  {
    slug: "reef-sharks",
    name: "Reef Sharks",
    scientificName: "Carcharhinidae family",
    category: "sharks-rays",
    size: "1.5-2.5 meters",
    habitat: "Reef edges, lagoons",
    dietOrSeason: "Protected in Maldives",
    dietOrSeasonLabel: "Status",
    description:
      "Blacktip and Whitetip Reef Sharks are common sights in the Maldives, patrolling the edges of reefs and lagoons. These elegant predators are generally shy around humans and play a vital role in maintaining reef health by removing weak or sick fish. All shark species are protected in the Maldives, with shark fishing banned since 2010.",
    image: asset("1a23939d-3a9c-ff67-6ef1-88f5a29f2166", "legacy/images/fishing/reef-sharks-maldives.webp", "Blacktip Reef Shark in the Maldives"),
  },
  {
    slug: "whale-shark",
    name: "Whale Shark",
    scientificName: "Rhincodon typus",
    category: "sharks-rays",
    size: "Up to 12 meters",
    habitat: "Open ocean, feeding aggregations",
    dietOrSeason: "Endangered, fully protected",
    dietOrSeasonLabel: "Status",
    description:
      "The gentle giants of the ocean, Whale Sharks are the world's largest fish and a highlight for many visitors to the Maldives. Despite their enormous size, they feed primarily on plankton and small fish. South Ari Atoll is famous for year-round whale shark sightings, while Hanifaru Bay in Baa Atoll hosts seasonal feeding aggregations.",
    image: asset("263ea34e-c78a-4ed0-e7d6-45fd4c436f41", "legacy/images/fishing/whale-shark-in-maldives.webp", "Whale Shark in the Maldives"),
  },
  {
    slug: "manta-ray",
    name: "Manta Ray",
    scientificName: "Mobula alfredi (Reef Manta)",
    category: "sharks-rays",
    size: "3-5 meters wingspan",
    habitat: "Cleaning stations, feeding areas",
    dietOrSeason: "Vulnerable, protected",
    dietOrSeasonLabel: "Status",
    description:
      "The Maldives is home to the world's largest known population of reef manta rays, with over 5,000 individuals identified. These graceful creatures are frequently spotted at cleaning stations where smaller fish remove parasites from their bodies. Hanifaru Bay in Baa Atoll is famous for its spectacular manta feeding aggregations during the southwest monsoon.",
    image: asset("bd3b41a5-79b7-dd34-d52e-f6efd963ee14", "legacy/images/activities/new-folder/manta-ray-snorkeling-in-the-maldives.webp", "Manta Ray in the Maldives"),
  },
  {
    slug: "stingrays",
    name: "Stingrays",
    scientificName: "Dasyatidae family",
    category: "sharks-rays",
    size: "0.5-2 meters disc width",
    habitat: "Sandy bottoms, lagoons",
    dietOrSeason: "Protected in Maldives",
    dietOrSeasonLabel: "Status",
    description:
      "Various species of stingrays inhabit the sandy bottoms and lagoons of the Maldives. These flat, disc-shaped fish are often partially buried in sand with only their eyes visible. The Bluespotted Stingray, with its distinctive blue spots on a sandy-colored body, is a common sight in shallow lagoons.",
    image: asset("cd389a5a-9ae2-3acd-f094-db9e5f925fbd", "legacy/images/stingray-snorkeling-male-atoll.webp", "Stingray in the Maldives"),
  },
];

export function fishSpeciesByCategory(): Array<{ category: FishSpeciesCategory; species: FishSpecies[] }> {
  return FISH_SPECIES_CATEGORIES.map((category) => ({
    category,
    species: FISH_SPECIES.filter((s) => s.category === category.slug),
  }));
}
