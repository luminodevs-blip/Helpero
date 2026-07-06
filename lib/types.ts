export interface AddressStruct {
  id?: number;
  fullAddress: string;
  lat: number;
  lng: number;
  zipCode?: string;
  city?: string;
  isDefault: boolean;
  nameLabel: string; // "Home", "Office", etc.
  propertyType: string; // "Apartment", "House"
}

export interface SelectedAddonStruct {
  id: string;
  name: string;
  qty: number;
  unitPrice: number;
  totalPrice: number;
  unitDuration: number;
  totalDuration: number;
}

// ─── Visit/slot details (Step 2: Arrival time) ───────────────────────
export interface VisitDetails {
  mode: "priority" | "standard" | "scheduled";
  arrivalTimeSlot: string;       // ISO datetime sent to API
  arrivalDateDisplay: string;    // "Today", "Tomorrow", "Jun 28"
  displayTime: string;           // "10:00 – 11:00"
  fee: number;                   // Slot surcharge
  slotId: string;                // specialist/slot ID
}

export interface BookingDraft {
  currentCartId?: string;
  serviceId?: number;
  categoryId?: number;
  serviceName?: string;
  serviceImageUrl?: string;
  basePrice?: number;
  baseDuration?: number;
  totalPrice: number;
  totalDuration: number;
  itemsPrice?: number;
  selectedAddons: SelectedAddonStruct[];
  address?: AddressStruct | null;
  date?: string; // ISO String
  // Phase 4: Visit / Slot selection
  visit?: VisitDetails | null;
  // Phase 4: After booking created
  bookingId?: number | string;
  status?: string;
  // Legacy fields
  arrivalType?: "priority" | "standard" | "scheduled";
  priorityFee?: number;
  slotPriceAdjustment?: number;
  selectedVoucherId?: string;
  entryMethod?: string;
  entryNotes?: string;
}

export interface UserProfile {
  id: string;
  firstName?: string;
  lastName?: string;
  phoneNumber?: string;
  avatarUrl?: string;
  currentHouseId?: number | null;
  savedAddresses: AddressStruct[];
}
