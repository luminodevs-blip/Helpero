import React, { useState, useEffect } from "react";
import { createPortal } from "react-dom";
import { X, Users } from "lucide-react";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";

interface ScheduleBottomSheetProps {
  isOpen: boolean;
  onClose: () => void;
  onSelect: (date: Date, timeStr: string, fee: number) => void;
  serviceDurationMinutes?: number;
  houseId?: number;
  serviceId?: number;
}

export default function ScheduleBottomSheet({
  isOpen,
  onClose,
  onSelect,
  serviceDurationMinutes = 60,
  houseId,
  serviceId,
}: ScheduleBottomSheetProps) {
  const { detectedZone } = useClientAuth();
  const [selectedDate, setSelectedDate] = useState<Date>(new Date());
  const [selectedTime, setSelectedTime] = useState<string>("08:00 AM");
  const [isClosing, setIsClosing] = useState(false);
  const [mounted, setMounted] = useState(false);
  const [loading, setLoading] = useState(false);
  const [hasAvailability, setHasAvailability] = useState(true);

  useEffect(() => {
    setMounted(true);
  }, []);

  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = "hidden";
      setIsClosing(false);
    } else {
      document.body.style.overflow = "unset";
    }
    return () => {
      document.body.style.overflow = "unset";
    };
  }, [isOpen]);

  const getSlotSurcharge = (date: Date, timeStr: string): number => {
    const day = date.getDay(); // 0 = Sunday, 6 = Saturday
    const isWeekend = day === 0 || day === 6;
    
    if (isWeekend) {
      return 24; // Weekend surcharge
    }
    
    // Check peak hours (e.g., 08:00 AM, 08:30 AM, 05:00 PM, 05:30 PM, 06:00 PM)
    const isPeakTime = 
      timeStr.startsWith("08:00") || 
      timeStr.startsWith("08:30") || 
      timeStr.startsWith("05:00") || 
      timeStr.startsWith("05:30") || 
      timeStr.startsWith("06:00");
      
    if (isPeakTime) {
      return 15; // Peak hour surcharge
    }
    
    return 0;
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

  const getElapsedDuration = (totalMinutes: number): number => {
    return getTeamConfig(totalMinutes).searchDuration;
  };

  const checkDayAvailability = async (date: Date) => {
    if (!houseId || !serviceId) return;
    try {
      setLoading(true);
      const formattedDate = date.toLocaleDateString('en-CA');
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
            house_id: houseId,
            service_id: serviceId,
            duration_minutes: serviceDurationMinutes,
            target_date: formattedDate
          }),
        }
      );
      const data = await response.json();
      if (data.success) {
        const realSlots = (data.slots || []).filter((s: any) => s.mode !== 'scheduled');
        setHasAvailability(realSlots.length > 0);
      } else {
        setHasAvailability(false);
      }
    } catch (e) {
      console.error("Error checking availability for day:", e);
      setHasAvailability(false);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (isOpen && houseId && serviceId) {
      checkDayAvailability(selectedDate);
    }
  }, [selectedDate, isOpen, serviceDurationMinutes, houseId, serviceId]);

  const handleClose = () => {
    setIsClosing(true);
    setTimeout(() => {
      onClose();
      setIsClosing(false);
    }, 300);
  };

  const handleUpdate = () => {
    const fee = getSlotSurcharge(selectedDate, selectedTime);
    onSelect(selectedDate, selectedTime, fee);
    handleClose();
  };

  // Generate 7 days starting from today
  const generateDays = () => {
    const days = [];
    const today = new Date();
    for (let i = 0; i < 7; i++) {
      const d = new Date(today);
      d.setDate(today.getDate() + i);
      days.push(d);
    }
    return days;
  };

  const days = generateDays();

  // Generate timeslots from 8 AM to 6 PM
  const generateTimeSlots = () => {
    let startHour = 8;
    let startMin = 0;
    let endHour = 21;
    let endMin = 0;

    if (detectedZone) {
      const startParts = (detectedZone.working_hours_start || "08:00:00").split(":");
      const endParts = (detectedZone.working_hours_end || "21:00:00").split(":");
      if (startParts.length >= 2) {
        startHour = parseInt(startParts[0], 10);
        startMin = parseInt(startParts[1], 10);
      }
      if (endParts.length >= 2) {
        endHour = parseInt(endParts[0], 10);
        endMin = parseInt(endParts[1], 10);
      }
    }

    const startTotalMinutes = startHour * 60 + startMin;
    const endTotalMinutes = endHour * 60 + endMin;

    const slots = [];
    const elapsedDuration = getElapsedDuration(serviceDurationMinutes);
    for (let current = startTotalMinutes; current < endTotalMinutes; current += 30) {
      if (current + elapsedDuration <= endTotalMinutes) {
        const h = Math.floor(current / 60);
        const m = current % 60;
        
        const isPM = h >= 12;
        const displayH = h > 12 ? h - 12 : h === 0 ? 12 : h;
        const ampm = isPM ? "PM" : "AM";
        const padH = displayH.toString().padStart(2, "0");
        const padM = m.toString().padStart(2, "0");
        slots.push(`${padH}:${padM} ${ampm}`);
      }
    }
    return slots;
  };

  const timeSlots = generateTimeSlots();

  useEffect(() => {
    const freshSlots = generateTimeSlots();
    if (freshSlots.length > 0 && !freshSlots.includes(selectedTime)) {
      setSelectedTime(freshSlots[0]);
    }
  }, [selectedDate, serviceDurationMinutes, detectedZone]);

  const formatDuration = (minutes: number) => {
    if (!minutes) return "0min";
    const hrs = Math.floor(minutes / 60);
    const mins = minutes % 60;
    if (hrs > 0) return `${hrs}h ${mins > 0 ? `${mins}min` : ''}`.trim();
    return `${mins}min`;
  };

  const isSameDay = (d1: Date, d2: Date) => {
    return d1.getDate() === d2.getDate() && d1.getMonth() === d2.getMonth();
  };

  if ((!isOpen && !isClosing) || !mounted) return null;

  return createPortal(
    <>
      <div
        className={`fixed inset-0 bg-zinc-900/40 z-50 transition-opacity duration-300 ${
          isClosing || !isOpen ? "opacity-0" : "opacity-100"
        }`}
        onClick={handleClose}
      />
      <div
        className={`fixed bottom-0 left-0 right-0 z-50 bg-white rounded-t-[14px] max-w-md mx-auto shadow-2xl transition-transform duration-300 ease-[cubic-bezier(0.32,0.72,0,1)] flex flex-col ${
          isClosing || !isOpen ? "translate-y-full" : "translate-y-0"
        }`}
        style={{ maxHeight: "85vh" }}
      >
        <div className="w-full flex justify-center pt-[16px] shrink-0">
          <div className="w-10 h-1 bg-zinc-200 rounded-full" />
        </div>

        <div className="px-5 pt-[24px] pb-[60px] overflow-y-auto scrollbar-hide flex-1">
          <h2 className="font-outfit text-[18px] font-semibold text-zinc-900 mb-[20px]">
            Choose day
          </h2>

          <div className="flex gap-2.5 overflow-x-auto scrollbar-hide -mx-5 px-5">
            {days.map((date, idx) => {
              const selected = isSameDay(date, selectedDate);
              const dayName = date.toLocaleDateString("en-US", { weekday: "short" });
              const dayNum = date.getDate();
              return (
                <button
                   key={idx}
                  onClick={() => setSelectedDate(date)}
                  className={`shrink-0 w-[60px] h-[70px] rounded-[10px] border flex flex-col items-center justify-center gap-0.5 transition-colors ${
                    selected
                      ? "bg-[#7B82F4] border-[#7B82F4] text-white"
                      : "bg-zinc-50 border-zinc-200 text-zinc-900 hover:bg-zinc-100"
                  }`}
                >
                  <span className={`text-[16px] font-normal ${selected ? "text-white/90" : "text-zinc-500"}`}>
                    {dayName}
                  </span>
                  <span className={`text-[17px] font-medium leading-tight ${selected ? "text-white" : "text-zinc-900"}`}>
                    {dayNum}
                  </span>
                </button>
              );
            })}
          </div>

          <div className="w-full h-px bg-zinc-100 mt-[14px] mb-[20px] -mx-5 px-5 w-[calc(100%+40px)]" />

          <h2 className="font-outfit text-[18px] font-semibold text-zinc-900 mb-[2px]">
            Choose a time
          </h2>
          <p className="text-[15.5px] text-zinc-500 font-normal mb-[20px] flex items-center">
            Service duration — {(() => {
              const { specialistsCount, searchDuration } = getTeamConfig(serviceDurationMinutes);
              return (
                <span className="inline-flex items-center gap-0.5">
                  <span>{formatDuration(searchDuration)}</span>
                  {specialistsCount > 1 && (
                    <span className="inline-flex items-center gap-0.5 bg-zinc-100 px-1.5 py-0.5 rounded-md text-[11px] text-zinc-600 font-semibold ml-1.5">
                      <Users className="w-3 h-3" />
                      <span>{specialistsCount}</span>
                    </span>
                  )}
                </span>
              );
            })()}
          </p>

          {loading ? (
            <div className="flex flex-col items-center justify-center py-[50px]">
              <div className="w-8 h-8 border-2 border-zinc-200 border-t-[#7B82F4] rounded-full animate-spin" />
              <span className="text-[13px] text-zinc-500 font-semibold mt-3">Checking availability...</span>
            </div>
          ) : !hasAvailability ? (
            <div className="flex flex-col items-center justify-center py-[30px] text-center px-4 bg-zinc-50 rounded-2xl border border-zinc-200">
              <Users className="w-10 h-10 text-zinc-400 mb-3" />
              <h3 className="font-outfit text-[15px] font-bold text-zinc-900 mb-1">
                No slots available
              </h3>
              <p className="text-[12px] text-zinc-500 max-w-[260px] font-semibold">
                There are not enough specialists working on this day to cover a {formatDuration(getTeamConfig(serviceDurationMinutes).searchDuration)} service. Please try a different day.
              </p>
            </div>
          ) : (
            <div className="grid grid-cols-3 gap-[12px]">
              {timeSlots.map((time) => {
                const selected = time === selectedTime;
                const surcharge = getSlotSurcharge(selectedDate, time);
                return (
                  <button
                    key={time}
                    onClick={() => setSelectedTime(time)}
                    className={`h-[44px] rounded-[8px] border text-[14px] font-medium transition-colors flex items-center justify-center relative ${
                      selected
                        ? "bg-[#7B82F4]/5 border-[#7B82F4] text-zinc-900"
                        : "bg-white border-zinc-200 text-zinc-700 hover:border-zinc-300"
                    }`}
                  >
                    <span>{time}</span>
                    {surcharge > 0 && (
                      <span className="absolute top-1 right-1.5 text-[8px] font-bold text-amber-600 leading-none">
                        +${surcharge}
                      </span>
                    )}
                  </button>
                );
              })}
            </div>
          )}
        </div>

        <div className="p-5 border-t border-zinc-100 bg-white pb-[40px] shrink-0">
          <button
            onClick={handleUpdate}
            disabled={loading || !hasAvailability}
            className="w-full h-[50px] bg-[#14181B] text-white rounded-[12px] font-sans text-[18px] font-semibold flex items-center justify-center hover:bg-zinc-800 transition-colors active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Update booking
          </button>
        </div>
      </div>
    </>,
    document.body
  );
}
