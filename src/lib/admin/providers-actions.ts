"use server";

import { revalidatePath } from "next/cache";

import { requireStaff } from "@/lib/admin/auth";
import { createNode, deleteOrphanedNode, updateNodeCore, type NodeCoreInput } from "@/lib/admin/node-actions";
import { createClient } from "@/lib/supabase/server";

export interface AdminActionResult {
  ok: boolean;
  error?: string;
}

export interface ProviderFieldsInput {
  legalName: string | null;
  contactEmail: string | null;
  contactPhone: string | null;
  websiteUrl: string | null;
  licenseNumber: string | null;
  isVerified: boolean;
}

function providerRow(input: ProviderFieldsInput) {
  return {
    legal_name: input.legalName?.trim() || null,
    contact_email: input.contactEmail?.trim() || null,
    contact_phone: input.contactPhone?.trim() || null,
    website_url: input.websiteUrl?.trim() || null,
    license_number: input.licenseNumber?.trim() || null,
    is_verified: input.isVerified,
  };
}

export async function createProvider(core: NodeCoreInput, fields: ProviderFieldsInput): Promise<AdminActionResult & { id?: string }> {
  await requireStaff();

  const created = await createNode({ ...core, nodeType: "provider" });
  if (!created.ok) return created;

  const supabase = await createClient();
  const { error } = await supabase.from("providers").insert({ id: created.id, ...providerRow(fields) } as unknown as never);
  if (error) {
    await deleteOrphanedNode(created.id);
    return { ok: false, error: error.message };
  }

  revalidatePath("/admin/providers");
  revalidatePath("/admin");
  return { ok: true, id: created.id };
}

export async function updateProvider(id: string, core: NodeCoreInput, fields: ProviderFieldsInput): Promise<AdminActionResult> {
  await requireStaff();

  const coreResult = await updateNodeCore(id, core);
  if (!coreResult.ok) return coreResult;

  const supabase = await createClient();
  const { error } = await supabase
    .from("providers")
    .update(providerRow(fields) as unknown as never)
    .eq("id", id);
  if (error) return { ok: false, error: error.message };

  revalidatePath("/admin/providers");
  revalidatePath(`/admin/providers/${id}`);
  revalidatePath("/admin");
  return { ok: true };
}
