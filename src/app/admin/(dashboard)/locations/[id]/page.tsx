import Link from "next/link";
import { notFound } from "next/navigation";

import { LocationForm } from "@/components/admin/location-form";
import { requireStaff } from "@/lib/admin/auth";
import { getLocationByIdAdmin } from "@/lib/admin/locations-repository";

export default async function EditLocationPage({ params }: { params: Promise<{ id: string }> }) {
  // Defense in depth on top of the parent layout's requireStaff() gate —
  // see the identical note in admin/bookings/[id]/page.tsx.
  await requireStaff();
  const { id } = await params;
  const location = await getLocationByIdAdmin(id);
  if (!location) notFound();

  return (
    <div>
      <Link href="/admin/locations" className="text-sm text-maldives-600 hover:underline">
        ← All locations
      </Link>
      <h1 className="mt-2 text-2xl font-semibold text-ocean-900">{location.title}</h1>
      <div className="mt-6">
        <LocationForm
          initial={{
            id: location.id,
            core: {
              title: location.title,
              slug: location.slug,
              summary: location.summary,
              status: location.status,
              metaTitle: location.metaTitle,
              metaDescription: location.metaDescription,
            },
            fields: {
              lat: location.lat,
              lng: location.lng,
              isInhabited: location.isInhabited,
              administrativeCode: location.administrativeCode,
            },
            locationType: location.locationType,
            parentTitle: location.parentTitle,
          }}
        />
      </div>
    </div>
  );
}
