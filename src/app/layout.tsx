import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

import { MobileBottomNav } from "@/components/mobile-bottom-nav";
import { SiteFooter } from "@/components/site-footer";
import { SiteHeader } from "@/components/site-header";
import { getSiteUrl, organizationJsonLd, websiteJsonLd } from "@/lib/seo/site";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  metadataBase: new URL(getSiteUrl()),
  title: {
    default: "Maldives Tour Guide (MTG)",
    template: "%s",
  },
  description:
    "A real, source-verified travel guide to the Maldives — atolls, islands, resorts, hotels, guesthouses, activities, diving, fishing, surfing, transfers and packages.",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="en" className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}>
      <body className="flex min-h-full flex-col bg-white text-ocean-900">
        {/* Task 17 audit: no sitewide Organization/WebSite entity existed
            anywhere — rendered once here, not per-page, since it describes
            the site as a whole. */}
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationJsonLd()) }} />
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(websiteJsonLd()) }} />
        {/* Task 17: Tawk.to live chat. customStyle.visibility must be set
            before the widget script loads (Tawk reads it once, on init) —
            offset it up 76px so the bubble clears <MobileBottomNav>'s
            fixed bar (~60px tall) rather than sitting under it. Applied to
            both breakpoints since the widget renders in a cross-origin
            iframe we can't reach with our own CSS, and the exact viewport
            width where Tawk switches its own "mobile" bucket isn't
            documented, so relying on it to match our lg: breakpoint isn't
            safe. Can't account for env(safe-area-inset-bottom) here since
            customStyle only accepts plain numbers, not CSS expressions —
            on a notched phone the bubble may sit slightly closer to the
            nav than intended; nothing in this codebase can verify that
            without a real device. */}
        <script
          dangerouslySetInnerHTML={{
            __html: `
              var Tawk_API = Tawk_API || {};
              Tawk_API.customStyle = {
                visibility: {
                  desktop: { xOffset: 15, yOffset: 76 },
                  mobile: { xOffset: 15, yOffset: 76 }
                }
              };
              var Tawk_LoadStart = new Date();
              (function () {
                var s1 = document.createElement("script"),
                  s0 = document.getElementsByTagName("script")[0];
                s1.async = true;
                s1.src = "https://embed.tawk.to/5e2c5f46daaca76c6fcfd5ea/default";
                s1.charset = "UTF-8";
                s1.setAttribute("crossorigin", "*");
                s0.parentNode.insertBefore(s1, s0);
              })();
            `,
          }}
        />
        <SiteHeader />
        {/* pb-20 clears the fixed mobile bottom nav (h-16 + safe-area inset)
            on small screens; lg:pb-0 removes it once that nav is hidden. */}
        <div className="flex flex-1 flex-col pb-20 lg:pb-0">{children}</div>
        <SiteFooter />
        <MobileBottomNav />
      </body>
    </html>
  );
}
