import React, { useState, useEffect } from "react";
import { X } from "lucide-react";

interface ScheduleBottomSheetProps {
  isOpen: boolean;
  onClose: () => void;
  onSelect: (date: Date, timeStr: string) => void;
  serviceDurationMinutes?: number;
}

export default function ScheduleBottomSheet({
  isOpen,
  onClose,
  onSelect,
  serviceDurationMinutes = 60,
}: ScheduleBottomSheetProps) {
  const [selectedDate, setSelectedDate] = useState<Date>(new Date());
  const [selectedTime, setSelectedTime] = useState<string>("08:00 AM");
  const [isClosing, setIsClosing] = useState(false);

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

  if (!isOpen && !isClosing) return null;

  const handleClose = () => {
    setIsClosing(true);
    setTimeout(() => {
      onClose();
      setIsClosing(false);
    }, 300);
  };

  const handleUpdate = () => {
    onSelect(selectedDate, selectedTime);
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
    const slots = [];
    for (let h = 8; h <= 18; h++) {
      const isPM = h >= 12;
      const displayH = h > 12 ? h - 12 : h;
      const ampm = isPM ? "PM" : "AM";
      const padH = displayH.toString().padStart(2, "0");
      slots.push(`${padH}:00 ${ampm}`);
      if (h !== 18) {
        slots.push(`${padH}:30 ${ampm}`);
      }
    }
    return slots;
  };

  const timeSlots = generateTimeSlots();

  const formatDuration = (minutes: number) => {
    const hrs = Math.floor(minutes / 60);
    const mins = minutes % 60;
    if (hrs > 0) return `${hrs}h ${mins > 0 ? `${mins}m` : ''}`;
    return `${mins}m`;
  };

  const isSameDay = (d1: Date, d2: Date) => {
    return d1.getDate() === d2.getDate() && d1.getMonth() === d2.getMonth();
  };

  return (
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
        <div className="w-full flex justify-center pt-3 pb-2 shrink-0">
          <div className="w-10 h-1 bg-zinc-200 rounded-full" />
        </div>

        <div className="px-5 pb-4 overflow-y-auto scrollbar-hide flex-1">
          <h2 className="font-outfit text-[17px] font-bold text-zinc-900 mb-3">
            Choose day
          </h2>

          <div className="flex gap-2.5 overflow-x-auto pb-2 scrollbar-hide -mx-5 px-5">
            {days.map((date, idx) => {
              const selected = isSameDay(date, selectedDate);
              const dayName = date.toLocaleDateString("en-US", { weekday: "short" });
              const dayNum = date.getDate();
              return (
                <button
                  key={idx}
                  onClick={() => setSelectedDate(date)}
                  className={`shrink-0 w-[64px] h-[72px] rounded-[10px] border flex flex-col items-center justify-center gap-0.5 transition-colors ${
                    selected
                      ? "bg-[#7B82F4] border-[#7B82F4] text-white"
                      : "bg-zinc-50 border-zinc-200 text-zinc-900 hover:bg-zinc-100"
                  }`}
                >
                  <span className={`text-[14px] font-medium ${selected ? "text-white/90" : "text-zinc-500"}`}>
                    {dayName}
                  </span>
                  <span className={`text-[18px] font-bold leading-tight ${selected ? "text-white" : "text-zinc-900"}`}>
                    {dayNum}
                  </span>
                </button>
              );
            })}
          </div>

          <div className="w-full h-px bg-zinc-100 my-5 -mx-5 px-5 w-[calc(100%+40px)]" />

          <h2 className="font-outfit text-[17px] font-bold text-zinc-900 mb-1">
            Choose a time
          </h2>
          <p className="text-[14px] text-zinc-500 font-medium mb-4">
            Service duration — {formatDuration(serviceDurationMinutes)}
          </p>

          <div className="grid grid-cols-3 gap-3 mb-6">
            {timeSlots.map((time) => {
              const selected = time === selectedTime;
              return (
                <button
                  key={time}
                  onClick={() => setSelectedTime(time)}
                  className={`h-[44px] rounded-[10px] border text-[13px] font-semibold transition-colors flex items-center justify-center ${
                    selected
                      ? "bg-[#7B82F4]/5 border-[#7B82F4] text-zinc-900"
                      : "bg-white border-zinc-200 text-zinc-700 hover:border-zinc-300"
                  }`}
                >
                  {time}
                </button>
              );
            })}
          </div>
        </div>

        <div className="p-5 border-t border-zinc-100 bg-white pb-8 shrink-0">
          <button
            onClick={handleUpdate}
            className="w-full h-[52px] bg-[#14181B] text-white rounded-[12px] font-sans text-[16px] font-bold flex items-center justify-center hover:bg-zinc-800 transition-colors active:scale-[0.98]"
          >
            Update booking
          </button>
        </div>
      </div>
    </>
  );
}
