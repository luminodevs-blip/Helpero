"use client";

import React, { useState, useEffect, useCallback, useRef } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { ArrowLeft, Clock, Zap, CalendarDays, ChevronRight, Loader2, Home, User, Users, ChevronUp } from "lucide-react";
import { MdLocationOn } from "react-icons/md";
import AddressSelector from "@/components/AddressSelector";
import ScheduleBottomSheet from "@/components/ScheduleBottomSheet";
import EntryMethodBottomSheet, { ENTRY_METHODS } from "@/components/EntryMethodBottomSheet";
import { Key, Building2, Archive } from "lucide-react";
import { supabase } from "@/lib/supabase";
import { useJsApiLoader } from "@react-google-maps/api";

const GOOGLE_MAPS_API_KEY = process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY || "AIzaSyC_tcXVeDFmHjvpPz-ZMZXceu5PSppmXPM";
const LIBRARIES: any[] = ["places"];

const MAP_STYLES = [
  {
    featureType: "all",
    elementType: "geometry",
    stylers: [{ color: "#f5f5f5" }]
  },
  {
    featureType: "all",
    elementType: "labels.icon",
    stylers: [{ visibility: "off" }]
  },
  {
    featureType: "all",
    elementType: "labels.text.fill",
    stylers: [{ color: "#9e9e9e" }]
  },
  {
    featureType: "all",
    elementType: "labels.text.stroke",
    stylers: [{ color: "#f5f5f5" }]
  },
  {
    featureType: "administrative",
    elementType: "labels",
    stylers: [{ visibility: "off" }]
  },
  {
    featureType: "poi",
    elementType: "labels",
    stylers: [{ visibility: "off" }]
  },
  {
    featureType: "transit",
    elementType: "labels",
    stylers: [{ visibility: "off" }]
  },
  {
    featureType: "road",
    elementType: "geometry",
    stylers: [{ color: "#ffffff" }]
  },
  {
    featureType: "water",
    elementType: "geometry",
    stylers: [{ color: "#c9c9c9" }]
  }
];

function GoogleMapPreview({ lat, lng }: { lat: number; lng: number }) {
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!containerRef.current || !window.google) return;
    
    new window.google.maps.Map(containerRef.current, {
      center: { lat, lng },
      zoom: 16,
      disableDefaultUI: true,
      gestureHandling: "none",
      styles: MAP_STYLES,
    });
  }, [lat, lng]);

  return (
    <div className="w-full h-full relative flex items-center justify-center bg-zinc-100">
      <div ref={containerRef} className="w-full h-full" />
      {/* Central Pin overlay */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 pointer-events-none z-10 flex items-center justify-center">
        {/* Black circular container */}
        <div className="w-[38px] h-[38px] rounded-full bg-zinc-900 border border-zinc-800 shadow-md flex items-center justify-center">
          {/* White Map Pin SVG */}
          <svg viewBox="0 0 24 24" className="w-5 h-5" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M12 2C8.13 2 5 5.13 5 9C5 14.25 12 22 12 22C12 22 19 14.25 19 9C19 5.13 15.87 2 12 2Z"
              fill="white"
            />
            {/* Inner Black Dot */}
            <circle cx="12" cy="9" r="2.5" fill="#18181b" />
          </svg>
        </div>
      </div>
    </div>
  );
}

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
  const { activeBookingDraft, selectedAddress, cart, updateCart, setActiveDraft, setCartSheetOpen } = useClientAuth();

  const { isLoaded } = useJsApiLoader({
    id: "google-map-script",
    googleMapsApiKey: GOOGLE_MAPS_API_KEY,
    libraries: LIBRARIES,
  });

  const [slots, setSlots] = useState<ArrivalSlot[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState<"standard" | "scheduled" | "priority">("standard");
  const [error, setError] = useState<string | null>(null);
  const [selectedSlot, setSelectedSlot] = useState<ArrivalSlot | null>(null);
  const [securing, setSecuring] = useState(false);
  const [isAddressSelectorOpen, setIsAddressSelectorOpen] = useState(false);
  const [isScheduleOpen, setIsScheduleOpen] = useState(false);
  const [isEntryMethodOpen, setIsEntryMethodOpen] = useState(false);

  // Redirect if no active draft
  useEffect(() => {
    if (!activeBookingDraft) {
      router.replace("/");
    }
  }, [activeBookingDraft, router]);

  const lastAddressIdRef = useRef<number | undefined>(undefined);

  // Auto-populate entry notes and method from selected address instructions/codes if empty or address changed
  useEffect(() => {
    if (!activeBookingDraft || !selectedAddress) return;
    
    const addressChanged = lastAddressIdRef.current !== selectedAddress.id;
    
    if (addressChanged || !activeBookingDraft.entryMethod || !activeBookingDraft.entryNotes) {
      lastAddressIdRef.current = selectedAddress.id;
      
      const instructionsLower = (selectedAddress.instructions || "").toLowerCase();
      const intercom = (selectedAddress.intercomCode || "").trim();
      const gate = (selectedAddress.gateCode || "").trim();
      
      let detectedMethod = "home";
      const parts = [];
      
      // 1. Lockbox check
      if (
        instructionsLower.includes("lockbox") ||
        instructionsLower.includes("box") ||
        instructionsLower.includes("локсбокс") ||
        instructionsLower.includes("сейф")
      ) {
        detectedMethod = "lockbox";
        if (selectedAddress.instructions) parts.push(selectedAddress.instructions);
      }
      // 2. Concierge check
      else if (
        instructionsLower.includes("concierge") ||
        instructionsLower.includes("front desk") ||
        instructionsLower.includes("lobby") ||
        instructionsLower.includes("security") ||
        instructionsLower.includes("охрана") ||
        instructionsLower.includes("консьерж") ||
        instructionsLower.includes("ресепшн")
      ) {
        detectedMethod = "concierge";
        if (selectedAddress.instructions) parts.push(selectedAddress.instructions);
      }
      // 3. Door code check
      else if (
        intercom || 
        gate || 
        instructionsLower.includes("door code") ||
        instructionsLower.includes("intercom") ||
        instructionsLower.includes("code") ||
        instructionsLower.includes("код") ||
        instructionsLower.includes("домофон")
      ) {
        detectedMethod = "doorcode";
        if (intercom) parts.push(`Buzz code: ${intercom}`);
        if (gate) parts.push(`Gate: ${gate}`);
        if (selectedAddress.instructions) parts.push(selectedAddress.instructions);
      }
      // 4. Default to Home
      else {
        detectedMethod = "home";
        if (selectedAddress.instructions) parts.push(selectedAddress.instructions);
      }
      
      const combinedNotes = parts.join(". ");
      
      // Update draft if different
      if (
        activeBookingDraft.entryMethod !== detectedMethod || 
        activeBookingDraft.entryNotes !== combinedNotes
      ) {
        const updatedDraft = {
          ...activeBookingDraft,
          entryMethod: detectedMethod,
          entryNotes: combinedNotes,
        };
        setActiveDraft(updatedDraft);
        const updatedCart = cart.map((item) =>
          item.serviceId === activeBookingDraft.serviceId ? updatedDraft : item
        );
        updateCart(updatedCart);
      }
    }
  }, [selectedAddress, activeBookingDraft, cart, updateCart, setActiveDraft]);

  // Prefetch checkout step for instant transition
  useEffect(() => {
    router.prefetch("/checkout");
  }, [router]);

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

      const fetchedSlots: ArrivalSlot[] = (data.slots || []).map((s: any) => {
        let timeStart = s.timeStart;
        let displayTime = s.displayTime || s.timeStart;
        
        if (s.mode === "standard") {
          try {
            const date = new Date(s.timeStart);
            // Shift standard slot 3 hours later to distinguish it from priority
            date.setHours(date.getHours() + 3);
            timeStart = date.toISOString();
            
            const duration = activeBookingDraft.totalDuration || 60;
            const endDate = new Date(date.getTime() + duration * 60000);
            
            const formatTime = (d: Date) => {
              return d.toLocaleTimeString("en-US", {
                hour: "2-digit",
                minute: "2-digit",
                hour12: false
              });
            };
            displayTime = `${formatTime(date)} - ${formatTime(endDate)}`;
          } catch (e) {
            console.error(e);
          }
        }
        
        return {
          id: s.id || `${s.mode}-${timeStart}`,
          mode: s.mode || "standard",
          timeStart: timeStart,
          timeEnd: s.timeEnd || null,
          fee: s.fee || 0,
          isGolden: s.isGolden || false,
          reason: s.reason || "",
          displayDate: s.displayDate || "Today",
          displayTime: displayTime,
        };
      });

      setSlots(fetchedSlots);

      // Auto-select standard or priority slot
      const defaultSlot = fetchedSlots.find((s) => s.mode === "standard") || fetchedSlots.find((s) => s.mode === "priority");
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
    if (slot.mode === "scheduled") {
      setIsScheduleOpen(true);
    } else {
      setSelectedSlot(slot);
    }
  };

  const handleScheduleConfirm = (date: Date, timeStr: string, fee: number) => {
    const scheduledSlot = slots.find((s) => s.mode === "scheduled");
    if (!scheduledSlot) return;

    const dayName = date.toLocaleDateString("en-US", { weekday: "short", month: "short", day: "numeric" });
    
    // Convert date + "08:00 AM" to ISO string
    let isoTimeStart = date.toISOString();
    const match = timeStr.match(/(\d+):(\d+)\s*(AM|PM)/i);
    if (match) {
      let hours = parseInt(match[1]);
      const minutes = parseInt(match[2]);
      const ampm = match[3].toUpperCase();
      if (ampm === "PM" && hours < 12) hours += 12;
      if (ampm === "AM" && hours === 12) hours = 0;
      
      const properDate = new Date(date);
      properDate.setHours(hours, minutes, 0, 0);
      isoTimeStart = properDate.toISOString();
    }

    const updatedSlot = {
      ...scheduledSlot,
      displayDate: dayName,
      displayTime: timeStr,
      timeStart: isoTimeStart,
      fee: fee,
    };
    setSelectedSlot(updatedSlot);
  };

  const handleEntryMethodSelect = (method: string, notes: string) => {
    if (!activeBookingDraft) return;
    const updatedDraft = {
      ...activeBookingDraft,
      entryMethod: method,
      entryNotes: notes,
    };
    setActiveDraft(updatedDraft);
    const updatedCart = cart.map((item) =>
      item.serviceId === activeBookingDraft.serviceId ? updatedDraft : item
    );
    updateCart(updatedCart);
  };

  const handleConfirm = async () => {
    if (!selectedSlot || !activeBookingDraft || !selectedAddress) return;
    setSecuring(true);
    try {
      const { error: rpcError } = await supabase.rpc("secure_booking_slot", {
        p_house_id: selectedAddress.id,
        p_duration_min: activeBookingDraft.totalDuration || 60,
        p_mode_slug: selectedSlot.mode,
        p_target_start: selectedSlot.timeStart,
      });

      if (rpcError) {
        throw new Error(rpcError.message);
      }

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
    ...(scheduledSlots.length > 0 ? [selectedSlot?.mode === 'scheduled' ? selectedSlot : scheduledSlots[0]] : []),
  ];

  const formatDuration = (minutes?: number) => {
    if (!minutes) return "0min";
    const hrs = Math.floor(minutes / 60);
    const mins = minutes % 60;
    if (hrs > 0) {
      return `${hrs}h ${mins > 0 ? `${mins}min` : ''}`.trim();
    }
    return `${mins}min`;
  };

  const getTeamConfig = (durationMinutes: number) => {
    if (durationMinutes <= 360) {
      return { specialistsCount: 1, searchDuration: durationMinutes };
    }
    const multipliers: Record<number, number> = {
      2: 0.6,
      3: 0.5,
      4: 0.4,
      5: 0.3,
      6: 0.25
    };
    for (let s = 2; s <= 6; s++) {
      const mult = multipliers[s] || (1 / s);
      const elapsed = Math.ceil(durationMinutes * mult);
      if (elapsed <= 360) {
        return { specialistsCount: s, searchDuration: elapsed };
      }
    }
    return { specialistsCount: 6, searchDuration: 360 };
  };

  const totalAmount = ((activeBookingDraft?.totalPrice || 0) + (selectedSlot?.fee || 0)).toFixed(2);

  const entryMethodId = activeBookingDraft?.entryMethod || "home";
  const currentEntryMethod = ENTRY_METHODS.find((m) => m.id === entryMethodId) || ENTRY_METHODS[0];
  const entryNotesDisplay = activeBookingDraft?.entryNotes
    ? "Tap to edit instructions"
    : "Tap to add entry instructions";

  const getEntryMethodIcon = (methodId: string) => {
    switch (methodId) {
      case "home":
        return <User className="h-6 w-6 text-[#57636C]" style={{ fill: 'currentColor' }} />;
      case "concierge":
        return <Key className="h-6 w-6 text-[#57636C]" style={{ fill: 'currentColor' }} />;
      case "doorcode":
        return <Building2 className="h-6 w-6 text-[#57636C]" style={{ fill: 'currentColor' }} />;
      case "lockbox":
        return <Archive className="h-6 w-6 text-[#57636C]" style={{ fill: 'currentColor' }} />;
      default:
        return <User className="h-6 w-6 text-[#57636C]" style={{ fill: 'currentColor' }} />;
    }
  };

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-white pb-[100px] relative flex flex-col shadow-md font-sans border-x border-zinc-100 ">
      
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
        <div className="space-y-5">
          <h2 className="font-outfit text-[17px] font-medium text-zinc-900">
            Arrival time
          </h2>
          
          {loading ? (
            <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-hide">
              {[1, 2, 3].map((i) => (
                <div
                  key={i}
                  className="h-[128px] w-[146px] shrink-0 rounded-[12px] bg-zinc-100 animate-pulse"
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
                    className={`shrink-0 w-[146px] h-[128px] rounded-[12px] p-[14px] text-left transition-all border flex flex-col justify-between ${
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
                      <p className="text-[14px] font-normal text-zinc-500 mt-3 truncate">
                        free
                      </p>
                    ) : slot.fee > 0 ? (
                      <p className="text-[14px] font-normal text-zinc-500 mt-3 truncate">
                        + ${slot.fee}
                      </p>
                    ) : (
                      <p className="text-[14px] font-normal text-zinc-500 mt-3 opacity-0 select-none">
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
        <div className="flex items-center justify-end border-b border-zinc-100 pb-3 !mt-[16px]">
          <span className="font-sans text-[14.5px] font-normal text-[#57636C] mr-2">Cleaning duration:</span>
          <span className="font-sans text-[14.5px] font-medium text-zinc-900 inline-flex items-center">
            {(() => {
              const { specialistsCount, searchDuration } = getTeamConfig(activeBookingDraft?.totalDuration || 0);
              return (
                <>
                  <span>{formatDuration(searchDuration)}</span>
                  {specialistsCount > 1 && (
                    <span className="inline-flex items-center gap-0.5 bg-zinc-100 px-1.5 py-0.5 rounded-md text-[11px] text-zinc-600 font-semibold ml-1.5">
                      <Users className="w-3.5 h-3.5" />
                      <span>{specialistsCount}</span>
                    </span>
                  )}
                </>
              );
            })()}
          </span>
        </div>

        {/* Service Location */}
        <div className="space-y-5 !mt-[20px]">
          <h2 className="font-outfit text-[17px] font-medium text-zinc-900">
            Service location
          </h2>
          
          <div 
            onClick={() => setIsAddressSelectorOpen(true)}
            className="w-full h-[120px] bg-zinc-100 rounded-[10px] relative overflow-hidden flex items-center justify-center border border-zinc-200 cursor-pointer"
          >
            {selectedAddress?.lat && selectedAddress?.lng ? (
              isLoaded ? (
                <GoogleMapPreview lat={Number(selectedAddress.lat)} lng={Number(selectedAddress.lng)} />
              ) : (
                <div className="flex items-center justify-center w-full h-full bg-zinc-50">
                  <Loader2 className="w-6 h-6 animate-spin text-zinc-400" />
                </div>
              )
            ) : (
              <>
                {/* Map Pin icon representing map center */}
                <div className="absolute inset-0 opacity-20" style={{ 
                    backgroundImage: 'url("data:image/svg+xml,%3Csvg width=\'20\' height=\'20\' viewBox=\'0 0 20 20\' xmlns=\'http://www.w3.org/2000/svg\'%3E%3Cg fill=\'%23a1a1aa\' fill-opacity=\'0.4\' fill-rule=\'evenodd\'%3E%3Ccircle cx=\'3\' cy=\'3\' r=\'3\'/%3E%3Ccircle cx=\'13\' cy=\'13\' r=\'3\'/%3E%3C/g%3E%3C/svg%3E")',
                    backgroundSize: '20px 20px'
                }} />
                <MdLocationOn size={34} color="#14181B" className="absolute z-10" />
              </>
            )}
          </div>

          {selectedAddress && (
            <div className="space-y-0 border-b border-zinc-100 pb-0 !mt-0">
              <div 
                className="flex items-center justify-between pt-[14px] pb-[20px] cursor-pointer hover:bg-zinc-50 transition-colors rounded-xl -mx-2 px-2"
                onClick={() => setIsAddressSelectorOpen(true)}
              >
                <div className="flex items-center gap-3">
                  <Home className="h-6 w-6 text-[#57636C]" style={{ fill: 'currentColor' }} />
                  <div>
                    <p className="font-sans text-[15px] font-medium text-zinc-900">Home</p>
                    <p className="font-sans text-[14px] font-normal text-[#57636C] line-clamp-1 max-w-[250px]">
                      {selectedAddress.fullAddress}
                    </p>
                  </div>
                </div>
                <ChevronRight className="h-4 w-4 text-zinc-400" />
              </div>
              <div className="w-full h-px bg-zinc-100" />
              <div 
                className="flex items-center justify-between pt-[14px] pb-[20px] cursor-pointer hover:bg-zinc-50 transition-colors rounded-xl -mx-2 px-2"
                onClick={() => setIsEntryMethodOpen(true)}
              >
                <div className="flex items-center gap-3">
                  {getEntryMethodIcon(currentEntryMethod.id)}
                  <div>
                    <p className="font-sans text-[15px] font-medium text-zinc-900">{currentEntryMethod.title}</p>
                    <p className="font-sans text-[14px] font-normal text-[#57636C]">{entryNotesDisplay}</p>
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
          <div 
            onClick={() => setCartSheetOpen(true)}
            className="flex flex-col gap-0.5 cursor-pointer select-none active:opacity-75 transition-opacity"
          >
            <div className="flex items-baseline gap-2">
              <span className="font-sans text-[16px] font-normal text-[#57636C]">
                Total
              </span>
              {selectedSlot && selectedSlot.fee > 0 && (
                <span className="text-[10px] text-[#7B82F4] font-extrabold bg-[#7B82F4]/10 rounded-full px-2.5 py-0.5 whitespace-nowrap">
                  +${selectedSlot.fee.toFixed(2)} slot
                </span>
              )}
            </div>
            <div className="flex items-center gap-1.5">
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
      <AddressSelector 
        isOpen={isAddressSelectorOpen} 
        onClose={() => setIsAddressSelectorOpen(false)} 
      />
      <ScheduleBottomSheet
        isOpen={isScheduleOpen}
        onClose={() => setIsScheduleOpen(false)}
        onSelect={handleScheduleConfirm}
        serviceDurationMinutes={activeBookingDraft.totalDuration}
        houseId={selectedAddress?.id}
        serviceId={activeBookingDraft.serviceId}
      />
      <EntryMethodBottomSheet
        isOpen={isEntryMethodOpen}
        onClose={() => setIsEntryMethodOpen(false)}
        onSelect={handleEntryMethodSelect}
        initialMethod={activeBookingDraft.entryMethod}
        initialNotes={activeBookingDraft.entryNotes}
      />
    </div>
  );
}
