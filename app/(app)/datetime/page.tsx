"use client";

import React, { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { ArrowLeft, MapPin, Clock, Zap, CalendarDays, Star, ChevronRight, Loader2 } from "lucide-react";

// ─── Types ───────────────────────────────────────────────────────────
interface ArrivalSlot {
  id: string;
  mode: "express" | "standard" | "scheduled";
  timeStart: string;      // ISO datetime
  timeEnd: string | null; // ISO datetime or null
  fee: number;
  isGolden: boolean;
  reason: string;
  displayDate: string;    // "Today" / "Tomorrow" / "Jun 28"
  displayTime: string;    // "10:00 – 11:00"
}

const MODE_CONFIG = {
  express: {
    icon: Zap,
    label: "Express",
    tagline: "Fastest arrival",
    color: "text-[#f59e0b]",
    bg: "bg-[#fef3c7]",
    border: "border-[#f59e0b]",
    selectedBg: "bg-[#f59e0b]",
  },
  standard: {
    icon: Clock,
    label: "Standard",
    tagline: "Best match",
    color: "text-primary",
    bg: "bg-primary/10",
    border: "border-primary",
    selectedBg: "bg-primary",
  },
  scheduled: {
    icon: CalendarDays,
    label: "Scheduled",
    tagline: "Pick a time",
    color: "text-secondary",
    bg: "bg-secondary/10",
    border: "border-secondary",
    selectedBg: "bg-secondary",
  },
};

export default function DateTimePage() {
  const router = useRouter();
  const { activeBookingDraft, selectedAddress, cart, updateCart, setActiveDraft } = useClientAuth();

  const [slots, setSlots] = useState<ArrivalSlot[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedSlot, setSelectedSlot] = useState<ArrivalSlot | null>(null);
  const [securing, setSecuring] = useState(false);

  // Redirect if no active draft
  useEffect(() => {
    if (!activeBookingDraft) {
      router.replace("/");
    }
  }, [activeBookingDraft, router]);

  // Fetch availability from the Edge Function
  const fetchSlots = useCallback(async () => {
    if (!activeBookingDraft || !selectedAddress) return;
    try {
      setLoading(true);
      setError(null);

      const response = await fetch(
        "https://hwgmjlsoeebgounmthmr.supabase.co/functions/v1/check_availability",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization:
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MjExMzUsImV4cCI6MjA4MjA5NzEzNX0.SOn3uvZKOZvy0xmg46oXIhGHiOVpPjRXG7cTfXcqqR4",
          },
          body: JSON.stringify({
            house_id: selectedAddress.id,
            service_id: activeBookingDraft.serviceId,
            duration_minutes: activeBookingDraft.totalDuration,
          }),
        }
      );

      const data = await response.json();

      if (!response.ok || !data.success) {
        throw new Error(data.error || "Failed to fetch availability");
      }

      const fetchedSlots: ArrivalSlot[] = (data.slots || []).map((s: any) => ({
        id: s.id || `${s.mode}-${s.timeStart}`,
        mode: s.mode || "standard",
        timeStart: s.timeStart,
        timeEnd: s.timeEnd || null,
        fee: s.fee || 0,
        isGolden: s.isGolden || false,
        reason: s.reason || "",
        displayDate: s.displayDate || "Today",
        displayTime: s.displayTime || s.timeStart,
      }));

      setSlots(fetchedSlots);

      // Auto-select standard slot
      const standardSlot = fetchedSlots.find((s) => s.mode === "standard");
      if (standardSlot && !selectedSlot) {
        setSelectedSlot(standardSlot);
      }
    } catch (err: any) {
      setError(err?.message || "Couldn't load availability");
    } finally {
      setLoading(false);
    }
  }, [activeBookingDraft, selectedAddress]);

  useEffect(() => {
    fetchSlots();
  }, [fetchSlots]);

  if (!activeBookingDraft) return null;

  const handleSelectSlot = (slot: ArrivalSlot) => {
    setSelectedSlot(slot);
  };

  const handleConfirm = async () => {
    if (!selectedSlot || !activeBookingDraft) return;
    setSecuring(true);
    try {
      // Update draft with visit details
      const updatedDraft = {
        ...activeBookingDraft,
        visit: {
          mode: selectedSlot.mode,
          arrivalTimeSlot: selectedSlot.timeStart,
          arrivalDateDisplay: selectedSlot.displayDate,
          displayTime: selectedSlot.displayTime,
          fee: selectedSlot.fee,
          slotId: selectedSlot.id,
        },
        totalPrice: activeBookingDraft.totalPrice + (selectedSlot.fee || 0),
      };
      setActiveDraft(updatedDraft);
      const updatedCart = cart.map((item) =>
        item.serviceId === activeBookingDraft.serviceId ? updatedDraft : item
      );
      updateCart(updatedCart);
      router.push("/checkout");
    } catch (err: any) {
      setError(err?.message || "Failed to secure slot");
    } finally {
      setSecuring(false);
    }
  };

  // Group slots by mode for the 3-column card grid
  const expressSlots = slots.filter((s) => s.mode === "express");
  const standardSlots = slots.filter((s) => s.mode === "standard");
  const scheduledSlots = slots.filter((s) => s.mode === "scheduled");

  const slotsByMode = [
    ...(expressSlots.length > 0 ? [expressSlots[0]] : []),
    ...(standardSlots.length > 0 ? [standardSlots[0]] : []),
    ...(scheduledSlots.length > 0 ? [scheduledSlots[0]] : []),
  ];

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-bg-secondary pb-32 relative flex flex-col border-x border-alternate shadow-md">
      {/* Purple Header – matches Flutter background color: primary */}
      <div className="bg-primary px-5 pt-12 pb-20 relative overflow-hidden">
        {/* Radial glow */}
        <div className="absolute inset-0 bg-radial-gradient from-white/10 to-transparent opacity-50 pointer-events-none" />

        <div className="flex items-center justify-between mb-6 relative z-10">
          <button
            onClick={() => router.back()}
            className="p-2 rounded-full border-2 border-white/30 text-white hover:bg-white/10 transition-all"
          >
            <ArrowLeft className="h-5 w-5" />
          </button>

          <div className="text-center">
            <span className="text-[10px] font-bold text-white/60 uppercase tracking-widest">
              Step 2 of 3
            </span>
            <p className="text-base font-bold text-white font-outfit">
              Service details
            </p>
          </div>

          {/* Transparent spacer for layout balance */}
          <div className="w-9 h-9 opacity-0" />
        </div>

        {/* Address Row */}
        {selectedAddress && (
          <div className="flex items-center gap-2 bg-white/15 rounded-2xl px-4 py-3 relative z-10">
            <MapPin className="h-4 w-4 text-white/80 flex-shrink-0" />
            <p className="text-xs text-white/90 font-semibold line-clamp-1 flex-1">
              {selectedAddress.fullAddress}
            </p>
          </div>
        )}
      </div>

      {/* White Card pulls up over purple section */}
      <div className="flex-1 bg-bg-secondary rounded-t-[28px] -mt-10 z-20 relative shadow-md">
        
        {/* Content Scroll area */}
        <div className="overflow-y-auto px-5 pt-6 pb-4 space-y-8">
          
          {/* Progress bar */}
          <div className="w-full bg-alternate h-1 rounded-full overflow-hidden">
            <div className="bg-primary h-full rounded-full" style={{ width: "66%" }} />
          </div>

          {/* Arrival Time Header */}
          <div className="flex items-center justify-between">
            <h3 className="font-outfit text-lg font-extrabold text-text-primary">
              Arrival time
            </h3>
            {!loading && slots.length > 0 && (
              <button
                onClick={fetchSlots}
                className="text-[10px] text-primary font-semibold underline"
              >
                Refresh
              </button>
            )}
          </div>

          {/* Slot Cards 3-column grid */}
          {loading ? (
            <div className="grid grid-cols-3 gap-3">
              {[1, 2, 3].map((i) => (
                <div
                  key={i}
                  className="h-36 rounded-2xl bg-bg-primary border border-alternate animate-pulse"
                />
              ))}
            </div>
          ) : error ? (
            <div className="text-center py-8 bg-error/5 rounded-2xl border border-error/20 p-4">
              <p className="text-sm text-error font-semibold">{error}</p>
              <button
                onClick={fetchSlots}
                className="mt-3 text-xs text-primary font-bold underline"
              >
                Try again
              </button>
            </div>
          ) : slotsByMode.length === 0 ? (
            <div className="text-center py-8 text-sm text-text-secondary">
              No slots available for today. Please try a different time.
            </div>
          ) : (
            <div className="grid grid-cols-3 gap-3">
              {slotsByMode.map((slot) => {
                const cfg = MODE_CONFIG[slot.mode] || MODE_CONFIG.standard;
                const ModeIcon = cfg.icon;
                const isSelected = selectedSlot?.id === slot.id;
                return (
                  <button
                    key={slot.id}
                    type="button"
                    onClick={() => handleSelectSlot(slot)}
                    className={`relative flex flex-col items-start rounded-2xl border-2 p-3 text-left transition-all focus:outline-none ${
                      isSelected
                        ? `${cfg.selectedBg} border-transparent text-white shadow-lg scale-[1.02]`
                        : `bg-bg-primary ${cfg.border} hover:scale-[1.01]`
                    }`}
                  >
                    {/* Icon */}
                    <div
                      className={`h-8 w-8 rounded-xl flex items-center justify-center mb-2 ${
                        isSelected ? "bg-white/20" : cfg.bg
                      }`}
                    >
                      <ModeIcon
                        className={`h-4 w-4 ${isSelected ? "text-white" : cfg.color}`}
                      />
                    </div>

                    {/* Mode label */}
                    <p
                      className={`text-[11px] font-extrabold leading-tight ${
                        isSelected ? "text-white" : "text-text-primary"
                      }`}
                    >
                      {cfg.label}
                    </p>

                    {/* Date/Tagline */}
                    <p
                      className={`text-[10px] mt-0.5 leading-tight ${
                        isSelected ? "text-white/80" : "text-text-secondary"
                      }`}
                    >
                      {slot.displayDate}
                    </p>

                    {/* Time display */}
                    <p
                      className={`text-[10px] font-semibold mt-1 leading-tight ${
                        isSelected ? "text-white" : cfg.color
                      }`}
                    >
                      {slot.displayTime}
                    </p>

                    {/* Fee badge */}
                    {slot.fee > 0 && (
                      <div
                        className={`mt-2 px-2 py-0.5 rounded-full text-[9px] font-bold ${
                          isSelected
                            ? "bg-white/25 text-white"
                            : `${cfg.bg} ${cfg.color}`
                        }`}
                      >
                        +${slot.fee}
                      </div>
                    )}

                    {/* Golden badge */}
                    {slot.isGolden && (
                      <Star
                        className="absolute top-2 right-2 h-3 w-3 text-yellow-400 fill-yellow-400"
                      />
                    )}
                  </button>
                );
              })}
            </div>
          )}

          {/* All Scheduled Slots (if "scheduled" selected, show time picker expansion) */}
          {selectedSlot?.mode === "scheduled" && scheduledSlots.length > 1 && (
            <div className="space-y-3">
              <h4 className="font-outfit text-sm font-bold text-text-primary">
                Choose a time
              </h4>
              <div className="space-y-2">
                {scheduledSlots.map((slot) => {
                  const isActive = selectedSlot?.id === slot.id;
                  return (
                    <button
                      key={slot.id}
                      onClick={() => handleSelectSlot(slot)}
                      className={`w-full flex items-center justify-between px-4 py-3 rounded-2xl border-2 transition-all ${
                        isActive
                          ? "border-secondary bg-secondary text-white"
                          : "border-alternate bg-bg-primary hover:border-secondary/40"
                      }`}
                    >
                      <div className="flex items-center gap-3">
                        <CalendarDays
                          className={`h-4 w-4 ${isActive ? "text-white" : "text-secondary"}`}
                        />
                        <div className="text-left">
                          <p className={`text-xs font-bold ${isActive ? "text-white" : "text-text-primary"}`}>
                            {slot.displayDate}
                          </p>
                          <p className={`text-[10px] ${isActive ? "text-white/80" : "text-text-secondary"}`}>
                            {slot.displayTime}
                          </p>
                        </div>
                      </div>
                      {slot.fee > 0 && (
                        <span className={`text-xs font-extrabold ${isActive ? "text-white" : "text-secondary"}`}>
                          +${slot.fee}
                        </span>
                      )}
                    </button>
                  );
                })}
              </div>
            </div>
          )}

          {/* Order Summary section */}
          {selectedSlot && (
            <div className="bg-bg-primary rounded-2xl border border-alternate p-4 space-y-3">
              <h4 className="font-outfit text-sm font-bold text-text-primary">
                Order Summary
              </h4>
              <div className="space-y-2 text-xs">
                <div className="flex justify-between text-text-secondary">
                  <span>{activeBookingDraft?.serviceName}</span>
                  <span className="font-bold text-text-primary">
                    ${activeBookingDraft?.basePrice?.toFixed(2)}
                  </span>
                </div>
                {(activeBookingDraft?.selectedAddons || []).map((addon) => (
                  <div key={addon.id} className="flex justify-between text-text-secondary">
                    <span>
                      {addon.name} × {addon.qty}
                    </span>
                    <span className="font-bold text-text-primary">
                      +${addon.totalPrice.toFixed(2)}
                    </span>
                  </div>
                ))}
                {selectedSlot.fee > 0 && (
                  <div className="flex justify-between text-text-secondary">
                    <span>{MODE_CONFIG[selectedSlot.mode]?.label} fee</span>
                    <span className="font-bold text-text-primary">
                      +${selectedSlot.fee.toFixed(2)}
                    </span>
                  </div>
                )}
                <div className="border-t border-alternate pt-2 flex justify-between font-extrabold text-text-primary text-sm">
                  <span>Total</span>
                  <span className="text-primary">
                    ${((activeBookingDraft?.totalPrice || 0) + (selectedSlot.fee || 0)).toFixed(2)}
                  </span>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* Sticky Bottom CTA */}
      <div className="fixed bottom-0 left-0 right-0 z-40 bg-bg-secondary border-t border-alternate py-4 px-6 flex items-center justify-between max-w-md mx-auto">
        <div className="flex flex-col">
          {selectedSlot ? (
            <>
              <span className="text-[10px] text-text-secondary font-semibold uppercase tracking-wide">
                {selectedSlot.displayDate} · {selectedSlot.displayTime}
              </span>
              <span className="font-outfit text-lg font-extrabold text-primary">
                ${((activeBookingDraft?.totalPrice || 0) + (selectedSlot.fee || 0)).toFixed(2)}
              </span>
            </>
          ) : (
            <span className="text-sm text-text-secondary">Select a time slot</span>
          )}
        </div>

        <button
          onClick={handleConfirm}
          disabled={!selectedSlot || securing}
          className="px-7 h-14 rounded-full bg-primary text-white font-sans text-sm font-bold hover:bg-primary/95 focus:outline-none disabled:opacity-40 disabled:cursor-not-allowed transition-all active:scale-95 shadow-md flex items-center justify-center gap-2"
        >
          {securing ? (
            <Loader2 className="h-5 w-5 animate-spin" />
          ) : (
            <>
              Confirm <ChevronRight className="h-4 w-4" />
            </>
          )}
        </button>
      </div>
    </div>
  );
}
