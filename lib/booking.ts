import { BookingDraft, SelectedAddonStruct } from "./types";

export function updateBookingAddon(
  draft: BookingDraft,
  addon: any,
  action: "add" | "remove"
): BookingDraft {
  const updatedAddons = [...draft.selectedAddons];
  const existingIdx = updatedAddons.findIndex((a) => a.id === addon.id);

  if (action === "add") {
    if (existingIdx > -1) {
      const existing = updatedAddons[existingIdx];
      const newQty = existing.qty + 1;
      updatedAddons[existingIdx] = {
        ...existing,
        qty: newQty,
        totalPrice: newQty * existing.unitPrice,
        totalDuration: newQty * existing.unitDuration,
      };
    } else {
      updatedAddons.push({
        id: addon.id,
        name: addon.name,
        qty: 1,
        unitPrice: addon.price || addon.unit_price || 0,
        totalPrice: addon.price || addon.unit_price || 0,
        unitDuration: addon.durationMinutes || addon.duration_minutes || 0,
        totalDuration: addon.durationMinutes || addon.duration_minutes || 0,
      });
    }
  } else if (action === "remove") {
    if (existingIdx > -1) {
      const existing = updatedAddons[existingIdx];
      if (existing.qty > 1) {
        const newQty = existing.qty - 1;
        updatedAddons[existingIdx] = {
          ...existing,
          qty: newQty,
          totalPrice: newQty * existing.unitPrice,
          totalDuration: newQty * existing.unitDuration,
        };
      } else {
        updatedAddons.splice(existingIdx, 1);
      }
    }
  }

  // Recalculate totals
  const basePrice = draft.basePrice || 0;
  const baseDuration = draft.baseDuration || 0;

  const addonsPrice = updatedAddons.reduce((sum, a) => sum + a.totalPrice, 0);
  const addonsDuration = updatedAddons.reduce((sum, a) => sum + a.totalDuration, 0);

  const totalPrice = basePrice + addonsPrice;
  const totalDuration = baseDuration + addonsDuration;

  return {
    ...draft,
    selectedAddons: updatedAddons,
    totalPrice,
    totalDuration,
    itemsPrice: totalPrice,
  };
}
