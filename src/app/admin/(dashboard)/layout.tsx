import type { Metadata } from "next";
import Link from "next/link";
import type { ReactNode } from "react";

import { AdminNav } from "@/components/admin/admin-nav";
import { SignOutButton } from "@/components/admin/sign-out-button";
import { CONTAINER_CLASS } from "@/components/ui/container";
import { requireStaff } from "@/lib/admin/auth";

export const metadata: Metadata = {
  title: "Admin | MTG",
  robots: { index: false, follow: false },
};

/**
 * Every route under this group (`src/app/admin/(dashboard)/*`) renders
 * behind requireStaff() — a Server Component check that runs before any
 * child page's own code, for every request, including a direct URL hit
 * with no JavaScript. `/admin/login` deliberately sits OUTSIDE this route
 * group (a sibling, not a child) so it isn't itself gated by the check that
 * would otherwise redirect an unauthenticated visitor straight back to it.
 */
export default async function AdminDashboardLayout({ children }: { children: ReactNode }) {
  const { email, isAdmin } = await requireStaff();

  return (
    <div className="min-h-screen bg-sand-50">
      <header className="border-b border-neutral-200 bg-white">
        <div className={`${CONTAINER_CLASS} flex h-16 items-center justify-between gap-4`}>
          <div className="flex items-center gap-6">
            <Link href="/admin" className="font-semibold text-ocean-900">
              MTG Admin
            </Link>
            <AdminNav isAdmin={isAdmin} />
          </div>
          <div className="flex items-center gap-4">
            <Link href="/" target="_blank" className="text-sm text-neutral-600 hover:text-ocean-900">
              View site
            </Link>
            <span className="hidden text-sm text-neutral-500 sm:inline">{email}</span>
            <SignOutButton />
          </div>
        </div>
      </header>

      <main className={`${CONTAINER_CLASS} py-8`}>{children}</main>
    </div>
  );
}
