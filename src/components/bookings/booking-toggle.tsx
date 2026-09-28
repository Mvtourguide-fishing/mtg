"use client";

import { useState } from "react";

import { Button } from "@/components/ui/button";
import { RequestBookingForm, type RequestBookingFormProps } from "@/components/bookings/request-booking-form";

/** Keeps the (server-rendered) service card lightweight by default — the
 * booking form only mounts once a visitor actually wants to book this
 * specific service, not for every service on the page up front. */
export function BookingToggle(props: RequestBookingFormProps) {
  const [open, setOpen] = useState(false);

  if (open) {
    return (
      <div className="mt-4 border-t border-neutral-200 pt-4">
        <RequestBookingForm {...props} />
      </div>
    );
  }

  return (
    <Button size="sm" className="mt-4" onClick={() => setOpen(true)}>
      Request Transfer
    </Button>
  );
}
