import Link from "next/link";
import type { ReactNode } from "react";

export function SectionHeader({
  eyebrow,
  title,
  description,
  action,
  className = "",
}: {
  eyebrow?: string;
  title: ReactNode;
  description?: string;
  action?: { label: string; href: string };
  className?: string;
}) {
  return (
    <div className={["flex flex-wrap items-end justify-between gap-4", className].filter(Boolean).join(" ")}>
      <div>
        {eyebrow && <p className="text-xs font-semibold uppercase tracking-wide text-maldives-600">{eyebrow}</p>}
        <h2 className="mt-1 text-xl font-semibold text-ocean-900 sm:text-2xl">{title}</h2>
        {description && <p className="mt-1 max-w-2xl text-sm text-neutral-600">{description}</p>}
      </div>
      {action && (
        <Link
          href={action.href}
          className="shrink-0 text-sm font-medium text-maldives-600 hover:text-ocean-800 hover:underline"
        >
          {action.label} →
        </Link>
      )}
    </div>
  );
}
