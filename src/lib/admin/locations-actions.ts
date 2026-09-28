"use server";

import { revalidatePath } from "next/cache";

import { requireStaff } from "@/lib/admin/auth";
import { updateNodeCore, type NodeCoreInput } from "@/lib/admin/node-actions";
import { createClient } from "@/lib/supabase/server";

export interface AdminActionResult {
  ok: boolean;
  error?: string;
}

export interface LocationFieldsInput {
  lat: number | null;
  lng: number | null;
  isInhabited: boolean | null;
  administrativeCode: string | null;
}

/**
 * Deliberately does NOT accept `locationType` or `parentId` — reassigning
 * either is validated by `enforce_location_hierarchy()` (parent/child type
 * rules, cycle detection) and cascades an ltree `path` recompute across
 * every descendant. Exposing that safely in a form is real work belonging
 * to its own round, not something to bolt on here; editing it stays a
 * migration-script operation for now, same as it already was.
 */
export async function updateLocation(id: string, core: NodeCoreInput, fields: LocationFieldsInput): Promise<AdminActionResult> {
  await requireStaff();

  const coreResult = await updateNodeCore(id, core);
  if (!coreResult.ok) return coreResult;

  const supabase = await createClient();
  const { error } = await supabase
    .from("locations")
    .update({
      lat: fields.lat,
      lng: fields.lng,
      is_inhabited: fields.isInhabited,
      administrative_code: fields.administrativeCode?.trim() || null,
    } as unknown as never)
    .eq("id", id);
  if (error) return { ok: false, error: error.message };

  revalidatePath("/admin/locations");
  revalidatePath(`/admin/locations/${id}`);
  revalidatePath("/admin");
  return { ok: true };
}
