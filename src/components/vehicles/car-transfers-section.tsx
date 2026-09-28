import { CARD_CLASS, CARD_IMAGE_BLEED_CLASS } from "@/components/ui/card";
import { MediaImage } from "@/components/ui/media-image";
import { getVehicles } from "@/lib/vehicles/repository";

const VEHICLE_TYPE_LABEL: Record<string, string> = {
  car: "Car",
  minibus: "Minibus",
  bus: "Bus",
};

/**
 * Task 20 §17: "Car Transfers" (not "Hotel Transfers"). No fleet has been
 * entered yet (no legacy or owner-supplied data existed at build time for
 * the described 2x4-seater/2x6-seater/minibus/bus fleet — see the Task 20
 * migration report), so this renders real vehicles once
 * src/lib/vehicles/repository.ts has any, and an honest "coming soon"
 * state until then — never invented vehicles or prices.
 */
export async function CarTransfersSection() {
  const vehicles = await getVehicles();

  return (
    <section className="mt-10">
      <h2 className="text-xl font-semibold text-ocean-900">Car Transfers</h2>
      <p className="mt-1 text-sm text-neutral-600">
        Land transfers by car, minibus, or bus around Malé and the local islands. Pricing will be added once confirmed; hourly and custom
        private hire will be available.
      </p>

      {vehicles.length === 0 ? (
        <p className="mt-4 rounded-2xl border border-dashed border-neutral-300 p-6 text-sm text-neutral-600">
          Our car transfer fleet details are being finalised — check back soon, or contact us directly to arrange a car transfer.
        </p>
      ) : (
        <ul className="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-3">
          {vehicles.map((v) => (
            <li key={v.id} className={CARD_CLASS}>
              {v.heroImage && (
                <div className={CARD_IMAGE_BLEED_CLASS}>
                  <MediaImage asset={v.heroImage} alt={v.title} aspectClassName="aspect-[16/10]" />
                </div>
              )}
              <span className="text-lg font-medium text-ocean-900">{v.title}</span>
              <div className="mt-1.5 flex flex-wrap gap-x-3 gap-y-1 text-sm text-neutral-600">
                <span>{VEHICLE_TYPE_LABEL[v.vehicleType] ?? v.vehicleType}</span>
                <span>{v.capacity} passengers</span>
                {v.luggageCapacity && <span>{v.luggageCapacity}</span>}
              </div>
              {v.facilities.length > 0 && (
                <div className="mt-1.5 flex flex-wrap gap-1.5">
                  {v.facilities.map((f) => (
                    <span key={f} className="rounded-full bg-lagoon-50 px-2 py-0.5 text-xs text-ocean-800">
                      {f}
                    </span>
                  ))}
                </div>
              )}
              <p className="mt-2 text-sm text-neutral-600">Hourly and custom private hire — pricing to be confirmed.</p>
            </li>
          ))}
        </ul>
      )}
    </section>
  );
}
