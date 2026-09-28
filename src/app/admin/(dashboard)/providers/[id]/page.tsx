import Link from "next/link";
import { notFound } from "next/navigation";

import { ProviderForm } from "@/components/admin/provider-form";
import { requireStaff } from "@/lib/admin/auth";
import { getProviderByIdAdmin } from "@/lib/admin/providers-repository";

export default async function EditProviderPage({ params }: { params: Promise<{ id: string }> }) {
  // Defense in depth on top of the parent layout's requireStaff() gate —
  // see the identical note in admin/bookings/[id]/page.tsx.
  await requireStaff();
  const { id } = await params;
  const provider = await getProviderByIdAdmin(id);
  if (!provider) notFound();

  return (
    <div>
      <Link href="/admin/providers" className="text-sm text-maldives-600 hover:underline">
        ← All providers
      </Link>
      <h1 className="mt-2 text-2xl font-semibold text-ocean-900">{provider.title}</h1>
      <div className="mt-6">
        <ProviderForm
          initial={{
            id: provider.id,
            core: {
              title: provider.title,
              slug: provider.slug,
              summary: provider.summary,
              status: provider.status,
              metaTitle: provider.metaTitle,
              metaDescription: provider.metaDescription,
            },
            fields: {
              legalName: provider.legalName,
              contactEmail: provider.contactEmail,
              contactPhone: provider.contactPhone,
              websiteUrl: provider.websiteUrl,
              licenseNumber: provider.licenseNumber,
              isVerified: provider.isVerified,
            },
          }}
        />
      </div>
    </div>
  );
}
