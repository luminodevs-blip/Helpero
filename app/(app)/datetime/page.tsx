"use client";

import React, { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { ArrowLeft, Clock, Zap, CalendarDays, ChevronRight, Loader2, MapPin, Home, User, ChevronUp } from "lucide-react";

// ─── Types ───────────────────────────────────────────────────────────
interface ArrivalSlot {
  id: string;
  mode: "priority" | "standard" | "scheduled";
  timeStart: string;
  timeEnd: string | null;
  fee: number;
  isGolden: boolean;
  reason: string;
  displayDate: string;
  displayTime: string;
}

const MODE_CONFIG = {
  priority: {
    icon: Zap,
    label: "Priority",
    color: "text-primary",
  },
  standard: {
    icon: null,
    label: "Standard",
    color: "text-zinc-400",
  },
  scheduled: {
    icon: null,
    label: "Scheduled",
    color: "text-zinc-400",
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

      // Auto-select priority or standard slot
      const defaultSlot = fetchedSlots.find((s) => s.mode === "priority") || fetchedSlots.find((s) => s.mode === "standard");
      if (defaultSlot && !selectedSlot) {
        setSelectedSlot(defaultSlot);
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

  const prioritySlots = slots.filter((s) => s.mode === "priority");
  const standardSlots = slots.filter((s) => s.mode === "standard");
  const scheduledSlots = slots.filter((s) => s.mode === "scheduled");

  const slotsByMode = [
    ...(prioritySlots.length > 0 ? [prioritySlots[0]] : []),
    ...(standardSlots.length > 0 ? [standardSlots[0]] : []),
    ...(scheduledSlots.length > 0 ? [scheduledSlots[0]] : []),
  ];

  const formatDuration = (minutes?: number) => {
    if (!minutes) return "0m";
    const hrs = Math.floor(minutes / 60);
    const mins = minutes % 60;
    if (hrs > 0) {
      return `${hrs}h ${mins}m`;
    }
    return `${mins}m`;
  };

  const totalAmount = ((activeBookingDraft?.totalPrice || 0) + (selectedSlot?.fee || 0)).toFixed(2);

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-white pb-[100px] relative flex flex-col shadow-md font-sans border-x border-zinc-100">
      
      {/* 1. Header */}
      <div className="bg-white px-5 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30">
        <button
          onClick={() => router.back()}
          className="p-1 -ml-1 flex items-center justify-center rounded-full hover:bg-zinc-100 text-zinc-900 focus:outline-none transition-colors"
        >
          <ArrowLeft className="w-[24px] h-[24px]" strokeWidth={2} />
        </button>
        
        <h1 className="font-outfit text-[20px] font-semibold text-zinc-900 absolute left-1/2 -translate-x-1/2">
          Service details
        </h1>
        
        <div className="w-8" /> {/* Spacer */}
      </div>

      <div className="w-full h-[1px] bg-zinc-100" />

      {/* 2. Scrollable Body Content */}
      <div className="flex-1 overflow-y-auto px-5 pt-5 pb-6 bg-white space-y-6">
        
        {/* Arrival Time */}
        <div className="space-y-4">
          <h2 className="font-outfit text-[17px] font-bold text-zinc-900">
            Arrival time
          </h2>
          
          {loading ? (
            <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-hide">
              {[1, 2, 3].map((i) => (
                <div
                  key={i}
                  className="h-[110px] w-[140px] shrink-0 rounded-[14px] bg-zinc-100 animate-pulse"
                />
              ))}
            </div>
          ) : error ? (
            <div className="text-center py-6 bg-red-50 rounded-[14px] border border-red-100 p-4">
              <p className="text-sm text-red-600 font-medium">{error}</p>
              <button
                onClick={fetchSlots}
                className="mt-2 text-xs text-primary font-bold underline"
              >
                Try again
              </button>
            </div>
          ) : slotsByMode.length === 0 ? (
            <div className="text-center py-6 text-sm text-zinc-500 bg-zinc-50 rounded-[14px]">
              No slots available. Please try a different time.
            </div>
          ) : (
            <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-hide -mx-5 px-5">
              {slotsByMode.map((slot) => {
                const isSelected = selectedSlot?.id === slot.id && selectedSlot?.mode === slot.mode;
                const cfg = MODE_CONFIG[slot.mode] || MODE_CONFIG.standard;
                const ModeIcon = cfg.icon;

                return (
                  <button
                    key={`${slot.id}-${slot.mode}`}
                    onClick={() => handleSelectSlot(slot)}
                    className={`shrink-0 w-[130px] rounded-[14px] p-3 text-left transition-all border flex flex-col justify-between min-h-[110px] ${
                      isSelected
                        ? "border-primary bg-primary/5 ring-1 ring-primary/20"
                        : "border-zinc-200 bg-white hover:border-zinc-300"
                    }`}
                  >
                    <div>
                      <div className="flex items-center gap-1.5 mb-2">
                        <span className={`text-[14px] font-medium text-zinc-900`}>
                          {cfg.label}
                        </span>
                        {ModeIcon && <ModeIcon className={`h-3.5 w-3.5 text-primary`} style={{ fill: 'currentColor' }} />}
                      </div>
                      <p className="text-[13px] text-zinc-500 font-medium leading-tight">
                        {slot.displayDate}
                      </p>
                      <p className="text-[13px] text-zinc-500 font-medium mt-0.5 leading-tight">
                        {slot.displayTime}
                      </p>
                    </div>
                    
                    {slot.mode === "standard" ? (
                      <p className="text-[12px] text-zinc-500 font-medium mt-3 truncate">
                        free
                      </p>
                    ) : slot.fee > 0 ? (
                      <p className="text-[12px] text-zinc-500 font-medium mt-3 truncate">
                        + ${slot.fee}
                      </p>
                    ) : (
                      <p className="text-[12px] text-zinc-400 font-medium mt-3 opacity-0">
                        Placeholder
                      </p>
                    )}
                  </button>
                );
              })}
            </div>
          )}
        </div>

        {/* Cleaning Duration */}
        <div className="flex items-center justify-end border-b border-zinc-100 pb-6 pt-2">
          <span className="text-sm text-zinc-500 font-medium mr-2">Cleaning duration:</span>
          <span className="text-sm font-bold text-zinc-900">
            {formatDuration(activeBookingDraft?.totalDuration)}
          </span>
        </div>

        {/* Service Location */}
        <div className="space-y-4 pt-2">
          <h2 className="font-outfit text-[17px] font-bold text-zinc-900">
            Service location
          </h2>
          
          <div className="w-full h-[120px] bg-zinc-100 rounded-[14px] relative overflow-hidden flex items-center justify-center border border-zinc-200">
            {/* Map Pin icon representing map center */}
            <div className="absolute inset-0 opacity-20" style={{ 
                backgroundImage: 'url("data:image/svg+xml,%3Csvg width=\'20\' height=\'20\' viewBox=\'0 0 20 20\' xmlns=\'http://www.w3.org/2000/svg\'%3E%3Cg fill=\'%23a1a1aa\' fill-opacity=\'0.4\' fill-rule=\'evenodd\'%3E%3Ccircle cx=\'3\' cy=\'3\' r=\'3\'/%3E%3Ccircle cx=\'13\' cy=\'13\' r=\'3\'/%3E%3C/g%3E%3C/svg%3E")',
                backgroundSize: '20px 20px'
            }} />
            <MapPin className="h-8 w-8 text-zinc-900 absolute z-10" style={{ fill: 'currentColor', color: '#18181b' }} />
          </div>

          {selectedAddress && (
            <div className="space-y-0 border-b border-zinc-100 pb-2">
              <div className="flex items-center justify-between py-3">
                <div className="flex items-center gap-3">
                  <Home className="h-5 w-5 text-zinc-600" style={{ fill: 'currentColor' }} />
                  <div>
                    <p className="text-[14px] font-semibold text-zinc-900">Home</p>
                    <p className="text-[12px] text-zinc-500 line-clamp-1 max-w-[250px]">
                      {selectedAddress.fullAddress}
                    </p>
                  </div>
                </div>
                <ChevronRight className="h-4 w-4 text-zinc-400" />
              </div>
              <div className="w-full h-px bg-zinc-100" />
              <div className="flex items-center justify-between py-3">
                <div className="flex items-center gap-3">
                  <User className="h-5 w-5 text-zinc-600" style={{ fill: 'currentColor' }} />
                  <div>
                    <p className="text-[14px] font-semibold text-zinc-900">I'll be home (Meet at door)</p>
                    <p className="text-[12px] text-zinc-500">Tap to add entry instructions</p>
                  </div>
                </div>
                <ChevronRight className="h-4 w-4 text-zinc-400" />
              </div>
            </div>
          )}
        </div>

      </div> {/* End Scrollable Body Content */}

      {/* Progress Bar & Footer Sticky Container */}
      <div className="fixed bottom-0 left-0 right-0 z-40 bg-white max-w-md mx-auto">
        {/* Progress Bar */}
        <div className="w-full bg-zinc-100 h-[6px]">
          <div className="bg-[#7B82F4] h-full transition-all duration-300" style={{ width: "66%" }} />
        </div>
        
        {/* Footer */}
        <div className="pt-4 pb-[40px] px-5 flex items-center justify-between">
          <div className="flex flex-col gap-0.5">
            <span className="font-sans text-[16px] font-normal text-[#57636C]">
              Total
            </span>
            <div className="flex items-center gap-1.5 cursor-pointer">
              <span className="font-outfit text-[18px] font-semibold text-zinc-900">
                ${totalAmount}
              </span>
              <ChevronUp className="w-4 h-4 text-zinc-900" />
            </div>
          </div>

          <button
            onClick={handleConfirm}
            disabled={!selectedSlot || securing}
            className="w-[200px] h-[50px] rounded-[10px] bg-[#14181B] text-white font-sans text-[18px] font-semibold hover:bg-zinc-800 focus:outline-none transition-all active:scale-95 shadow-md flex items-center justify-center"
          >
            {securing ? (
              <Loader2 className="w-5 h-5 animate-spin" />
            ) : (
              "Checkout"
            )}
          </button>
        </div>
      </div>
    </div>
  );
}
