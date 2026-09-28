import Link from "next/link";

import { ProviderForm } from "@/components/admin/provider-form";

export default function NewProviderPage() {
  return (
    <div>
      <Link href="/admin/providers" className="text-sm text-maldives-600 hover:underline">
        ← All providers
      </Link>
      <h1 className="mt-2 text-2xl font-semibold text-ocean-900">New provider</h1>
      <div className="mt-6">
        <ProviderForm />
      </div>
    </div>
  );
}
