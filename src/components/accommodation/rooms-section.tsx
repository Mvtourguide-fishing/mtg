import { MediaImage } from "@/components/ui/media-image";
import type { AccommodationRoom } from "@/lib/accommodations/types";

/**
 * Real room/villa types migrated from the legacy site — deliberately
 * lightweight (see AccommodationRoom's own comment): name, a historical
 * "from" price, bed type, occupancy, and 1-2 real photos. No facilities
 * list is rendered per room, since the source's per-room facilities data
 * was confirmed to be identical boilerplate on every property (see
 * TypicalAmenities for the honestly-labeled general-amenities section
 * this is paired with instead).
 */
export function RoomsSection({ rooms, accommodationTitle }: { rooms: AccommodationRoom[]; accommodationTitle: string }) {
  if (rooms.length === 0) return null;

  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">Rooms &amp; Villas</h2>
      <p className="mt-1 text-sm text-neutral-600">
        Real room/villa types at {accommodationTitle}. Prices shown are historical figures from our own records, not live rates — use
        &ldquo;Request an Offer&rdquo; below for current pricing and availability.
      </p>
      <ul className="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {rooms.map((room) => (
          <li key={room.id} className="overflow-hidden rounded-2xl border border-neutral-200">
            {room.images[0] && (
              <div className="relative aspect-[4/3]">
                <MediaImage asset={room.images[0]} alt={`${room.name} at ${accommodationTitle}`} fillParent />
              </div>
            )}
            <div className="p-4">
              <p className="font-medium text-ocean-900">{room.name}</p>
              <div className="mt-1 flex flex-wrap gap-x-3 gap-y-1 text-sm text-neutral-600">
                {room.bedType && <span>{room.bedType} bed</span>}
                {room.maxOccupancy && <span>Max {room.maxOccupancy}</span>}
              </div>
              {room.priceFrom !== null && (
                <p className="mt-2 text-sm text-neutral-600">
                  From{" "}
                  <span className="font-semibold text-ocean-900">
                    {room.currency === "USD" ? "$" : `${room.currency} `}
                    {room.priceFrom.toLocaleString()}
                  </span>
                </p>
              )}
            </div>
          </li>
        ))}
      </ul>
    </section>
  );
}
