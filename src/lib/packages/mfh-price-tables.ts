// Full 1-5 guest pricing table per MFH fishing package (Task 22).
// GENERATED FILE — do not hand-edit. Source of truth:
//   data/maldives/fishing/mfh-packages.json
// Regenerate with: node scripts/generate-mfh-seed.mjs
//
// packages.price_from (the DB column) only holds one number, so it's set
// to the lowest verified per-person rate (the 5-guest "best value" tier —
// see generate-mfh-seed.mjs's header comment). This file carries the FULL
// 1-5 guest table from the same source JSON, so the package detail page
// can render the real pricing table without a schema change, and can never
// drift from price_from since both come from the same run of this script.

export interface MfhGuestPrice {
  guests: number;
  sourcePrice: number;
  websitePrice: number;
  isBestValue: boolean;
}

export const MFH_PRICE_TABLES: Record<string, MfhGuestPrice[]> = {
  "2-night-maldives-fishing-package-full-day-fishing": [
    { guests: 1, sourcePrice: 1785, websitePrice: 1765, isBestValue: false },
    { guests: 2, sourcePrice: 1185, websitePrice: 1165, isBestValue: false },
    { guests: 3, sourcePrice: 1002, websitePrice: 982, isBestValue: false },
    { guests: 4, sourcePrice: 885, websitePrice: 865, isBestValue: false },
    { guests: 5, sourcePrice: 845, websitePrice: 825, isBestValue: true },
  ],
  "3-night-maldives-fishing-package-full-day-fishing": [
    { guests: 1, sourcePrice: 3135, websitePrice: 3115, isBestValue: false },
    { guests: 2, sourcePrice: 1910, websitePrice: 1890, isBestValue: false },
    { guests: 3, sourcePrice: 1568, websitePrice: 1548, isBestValue: false },
    { guests: 4, sourcePrice: 1535, websitePrice: 1515, isBestValue: false },
    { guests: 5, sourcePrice: 1255, websitePrice: 1235, isBestValue: true },
  ],
  "4-night-maldives-fishing-package-full-day-fishing": [
    { guests: 1, sourcePrice: 4460, websitePrice: 4440, isBestValue: false },
    { guests: 2, sourcePrice: 2610, websitePrice: 2590, isBestValue: false },
    { guests: 3, sourcePrice: 2110, websitePrice: 2090, isBestValue: false },
    { guests: 4, sourcePrice: 2060, websitePrice: 2040, isBestValue: false },
    { guests: 5, sourcePrice: 1640, websitePrice: 1620, isBestValue: true },
  ],
  "5-night-maldives-fishing-package-full-day-fishing": [
    { guests: 1, sourcePrice: 5785, websitePrice: 5765, isBestValue: false },
    { guests: 2, sourcePrice: 3310, websitePrice: 3290, isBestValue: false },
    { guests: 3, sourcePrice: 2652, websitePrice: 2632, isBestValue: false },
    { guests: 4, sourcePrice: 2585, websitePrice: 2565, isBestValue: false },
    { guests: 5, sourcePrice: 2025, websitePrice: 2005, isBestValue: true },
  ],
  "6-night-maldives-fishing-package-full-day-fishing": [
    { guests: 1, sourcePrice: 7110, websitePrice: 7090, isBestValue: false },
    { guests: 2, sourcePrice: 4010, websitePrice: 3990, isBestValue: false },
    { guests: 3, sourcePrice: 3193, websitePrice: 3173, isBestValue: false },
    { guests: 4, sourcePrice: 3110, websitePrice: 3090, isBestValue: false },
    { guests: 5, sourcePrice: 2410, websitePrice: 2390, isBestValue: true },
  ],
  "7-night-maldives-fishing-package-full-day-fishing": [
    { guests: 1, sourcePrice: 8410, websitePrice: 8390, isBestValue: false },
    { guests: 2, sourcePrice: 4685, websitePrice: 4665, isBestValue: false },
    { guests: 3, sourcePrice: 3710, websitePrice: 3690, isBestValue: false },
    { guests: 4, sourcePrice: 3610, websitePrice: 3590, isBestValue: false },
    { guests: 5, sourcePrice: 2770, websitePrice: 2750, isBestValue: true },
  ],
  "8-night-maldives-fishing-package-full-day-fishing": [
    { guests: 1, sourcePrice: 9710, websitePrice: 9690, isBestValue: false },
    { guests: 2, sourcePrice: 5360, websitePrice: 5340, isBestValue: false },
    { guests: 3, sourcePrice: 4227, websitePrice: 4207, isBestValue: false },
    { guests: 4, sourcePrice: 4110, websitePrice: 4090, isBestValue: false },
    { guests: 5, sourcePrice: 3130, websitePrice: 3110, isBestValue: true },
  ],
  "2-night-maldives-fishing-package-half-day-fishing": [
    { guests: 1, sourcePrice: 1485, websitePrice: 1465, isBestValue: false },
    { guests: 2, sourcePrice: 1010, websitePrice: 990, isBestValue: false },
    { guests: 3, sourcePrice: 902, websitePrice: 882, isBestValue: false },
    { guests: 4, sourcePrice: 810, websitePrice: 790, isBestValue: false },
    { guests: 5, sourcePrice: 785, websitePrice: 765, isBestValue: true },
  ],
  "3-night-maldives-fishing-package-half-day-fishing": [
    { guests: 1, sourcePrice: 2535, websitePrice: 2515, isBestValue: false },
    { guests: 2, sourcePrice: 1510, websitePrice: 1490, isBestValue: false },
    { guests: 3, sourcePrice: 1268, websitePrice: 1248, isBestValue: false },
    { guests: 4, sourcePrice: 1110, websitePrice: 1090, isBestValue: false },
    { guests: 5, sourcePrice: 1045, websitePrice: 1025, isBestValue: true },
  ],
  "4-night-maldives-fishing-package-half-day-fishing": [
    { guests: 1, sourcePrice: 3560, websitePrice: 3540, isBestValue: false },
    { guests: 2, sourcePrice: 1985, websitePrice: 1965, isBestValue: false },
    { guests: 3, sourcePrice: 1610, websitePrice: 1590, isBestValue: false },
    { guests: 4, sourcePrice: 1385, websitePrice: 1365, isBestValue: false },
    { guests: 5, sourcePrice: 1280, websitePrice: 1260, isBestValue: true },
  ],
  "5-night-maldives-fishing-package-half-day-fishing": [
    { guests: 1, sourcePrice: 4585, websitePrice: 4565, isBestValue: false },
    { guests: 2, sourcePrice: 2460, websitePrice: 2440, isBestValue: false },
    { guests: 3, sourcePrice: 2218, websitePrice: 2198, isBestValue: false },
    { guests: 4, sourcePrice: 1660, websitePrice: 1640, isBestValue: false },
    { guests: 5, sourcePrice: 1515, websitePrice: 1495, isBestValue: true },
  ],
  "6-night-maldives-fishing-package-half-day-fishing": [
    { guests: 1, sourcePrice: 5610, websitePrice: 5590, isBestValue: false },
    { guests: 2, sourcePrice: 2935, websitePrice: 2915, isBestValue: false },
    { guests: 3, sourcePrice: 2293, websitePrice: 2273, isBestValue: false },
    { guests: 4, sourcePrice: 1935, websitePrice: 1915, isBestValue: false },
    { guests: 5, sourcePrice: 1750, websitePrice: 1730, isBestValue: true },
  ],
  "7-night-maldives-fishing-package-half-day-fishing": [
    { guests: 1, sourcePrice: 6610, websitePrice: 6590, isBestValue: false },
    { guests: 2, sourcePrice: 3385, websitePrice: 3365, isBestValue: false },
    { guests: 3, sourcePrice: 2610, websitePrice: 2590, isBestValue: false },
    { guests: 4, sourcePrice: 2185, websitePrice: 2165, isBestValue: false },
    { guests: 5, sourcePrice: 1960, websitePrice: 1940, isBestValue: true },
  ],
  "8-night-maldives-fishing-package-half-day-fishing": [
    { guests: 1, sourcePrice: 7610, websitePrice: 7590, isBestValue: false },
    { guests: 2, sourcePrice: 3835, websitePrice: 3815, isBestValue: false },
    { guests: 3, sourcePrice: 2910, websitePrice: 2890, isBestValue: false },
    { guests: 4, sourcePrice: 2435, websitePrice: 2415, isBestValue: false },
    { guests: 5, sourcePrice: 2170, websitePrice: 2150, isBestValue: true },
  ],
};
