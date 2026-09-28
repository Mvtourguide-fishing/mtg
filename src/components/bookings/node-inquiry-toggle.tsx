"use client";

import { useState } from "react";

import { NodeInquiryForm, type NodeInquiryFormProps } from "@/components/bookings/node-inquiry-form";
import { Button } from "@/components/ui/button";

export function NodeInquiryToggle({ toggleLabel, ...formProps }: NodeInquiryFormProps & { toggleLabel: string }) {
  const [open, setOpen] = useState(false);

  if (open) {
    return (
      <div className="mt-4 border-t border-neutral-200 pt-4">
        <NodeInquiryForm {...formProps} />
      </div>
    );
  }

  return (
    <Button className="mt-4" onClick={() => setOpen(true)}>
      {toggleLabel}
    </Button>
  );
}
