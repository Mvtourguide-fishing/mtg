import type { ReactNode } from "react";

export function EmptyState({
  title,
  description,
  icon,
  className = "",
}: {
  title: string;
  description?: string;
  icon?: ReactNode;
  className?: string;
}) {
  return (
    <div
      className={[
        "mt-8 flex flex-col items-center gap-3 rounded-2xl border border-dashed border-neutral-300 bg-sand-50 px-6 py-12 text-center",
        className,
      ]
        .filter(Boolean)
        .join(" ")}
    >
      {icon && (
        <div aria-hidden className="text-neutral-400">
          {icon}
        </div>
      )}
      <p className="text-sm font-medium text-neutral-700">{title}</p>
      {description && <p className="max-w-sm text-sm text-neutral-500">{description}</p>}
    </div>
  );
}
