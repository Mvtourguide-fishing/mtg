import Link from "next/link";

import { ChevronRightIcon } from "@/components/ui/icons";

export interface BreadcrumbItem {
  label: string;
  href?: string;
}

const TONE_CLASS = {
  default: {
    nav: "text-neutral-500",
    link: "hover:text-ocean-900",
    current: "text-ocean-900",
    separator: "text-neutral-300",
  },
  inverted: {
    nav: "text-lagoon-100/80",
    link: "hover:text-white",
    current: "text-white",
    separator: "text-white/30",
  },
} as const;

/** Accessible breadcrumb nav. The last item is treated as the current page.
 * `tone="inverted"` is for use on a dark hero background (e.g. PageHero's
 * ocean-gradient variant); the default tone suits a light background. */
export function Breadcrumbs({ items, tone = "default" }: { items: BreadcrumbItem[]; tone?: "default" | "inverted" }) {
  const classes = TONE_CLASS[tone];

  return (
    <nav aria-label="Breadcrumb" className={`text-sm ${classes.nav}`}>
      <ol className="flex flex-wrap items-center gap-1">
        {items.map((item, index) => {
          const isLast = index === items.length - 1;
          return (
            <li key={`${item.label}-${index}`} className="flex items-center gap-1">
              {item.href && !isLast ? (
                <Link href={item.href} className={`transition-colors ${classes.link}`}>
                  {item.label}
                </Link>
              ) : (
                <span aria-current={isLast ? "page" : undefined} className={classes.current}>
                  {item.label}
                </span>
              )}
              {!isLast && <ChevronRightIcon className={`h-3.5 w-3.5 ${classes.separator}`} />}
            </li>
          );
        })}
      </ol>
    </nav>
  );
}
