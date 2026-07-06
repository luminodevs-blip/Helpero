"use client";

import React, { useState, useEffect, useRef } from "react";
import { X, Info } from "lucide-react";
import ServiceTermsBottomSheet from "./ServiceTermsBottomSheet";

interface EntryMethodBottomSheetProps {
  isOpen: boolean;
  onClose: () => void;
  onSelect: (method: string, notes: string) => void;
  initialMethod?: string;
  initialNotes?: string;
}

export const ENTRY_METHODS = [
  { id: "home", title: "I'll be home", subtitle: "Cleaner will arrive while I'm there.", emoji: "🏡" },
  { id: "concierge", title: "Leave keys with concierge", subtitle: "Front desk will provide access.", emoji: "🔑" },
  { id: "doorcode", title: "Door code", subtitle: "I'll share an entry code.", emoji: "🏢" },
  { id: "lockbox", title: "Key in lockbox", subtitle: "Key is stored in a secure box.", emoji: "🗄️" },
];

export default function EntryMethodBottomSheet({
  isOpen,
  onClose,
  onSelect,
  initialMethod = "home",
  initialNotes = "",
}: EntryMethodBottomSheetProps) {
  const [selectedMethod, setSelectedMethod] = useState(initialMethod);
  const [notes, setNotes] = useState(initialNotes);
  const [isClosing, setIsClosing] = useState(false);
  const [isServiceTermsOpen, setIsServiceTermsOpen] = useState(false);

  // Swipe-to-close refs
  const touchStartY = useRef<number | null>(null);
  const scrollRef = useRef<HTMLDivElement>(null);
  const sheetRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (isOpen) {
      document.body.style.overflow = "hidden";
      setIsClosing(false);
      setSelectedMethod(initialMethod);
      setNotes(initialNotes);
    } else {
      document.body.style.overflow = "unset";
    }
    return () => {
      document.body.style.overflow = "unset";
    };
  }, [isOpen, initialMethod, initialNotes]);

  if (!isOpen && !isClosing) return null;

  const handleClose = () => {
    setIsClosing(true);
    setTimeout(() => {
      onClose();
      setIsClosing(false);
    }, 300);
  };

  const handleUpdate = () => {
    onSelect(selectedMethod, notes);
    handleClose();
  };

  const handleTouchStart = (e: React.TouchEvent) => {
    touchStartY.current = e.touches[0].clientY;
    if (sheetRef.current) {
      sheetRef.current.style.transition = "none";
    }
  };

  const handleTouchMove = (e: React.TouchEvent) => {
    if (touchStartY.current === null) return;
    if (scrollRef.current && scrollRef.current.scrollTop > 0) return;

    const currentY = e.touches[0].clientY;
    const diff = currentY - touchStartY.current;

    if (diff > 0 && sheetRef.current) {
      sheetRef.current.style.transform = `translateY(${diff}px)`;
    }
  };

  const handleTouchEnd = (e: React.TouchEvent) => {
    if (touchStartY.current === null) return;
    
    const currentY = e.changedTouches[0].clientY;
    const diff = currentY - touchStartY.current;
    
    if (sheetRef.current) {
      sheetRef.current.style.transition = "transform 0.3s ease-out";
    }

    if (diff > 100) {
      if (sheetRef.current) {
        sheetRef.current.style.transform = `translateY(100%)`;
      }
      setTimeout(() => handleClose(), 300);
    } else {
      if (sheetRef.current) {
        sheetRef.current.style.transform = `translateY(0)`;
      }
    }
    touchStartY.current = null;
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
        ref={sheetRef}
        className={`fixed bottom-0 left-0 right-0 z-50 bg-white rounded-t-[20px] max-w-md mx-auto shadow-2xl transition-transform duration-300 ease-[cubic-bezier(0.32,0.72,0,1)] flex flex-col ${
          isClosing || !isOpen ? "translate-y-full" : "translate-y-0"
        }`}
        style={{ maxHeight: "90vh" }}
        onTouchStart={handleTouchStart}
        onTouchMove={handleTouchMove}
        onTouchEnd={handleTouchEnd}
      >
        <div className="px-5 pt-[24px] shrink-0">
          <div className="flex items-center justify-between mb-4">
            <button
              onClick={handleClose}
              className="p-1 -ml-1 rounded-full hover:bg-zinc-100 text-zinc-900 focus:outline-none transition-colors"
            >
              <X className="w-6 h-6" strokeWidth={2} />
            </button>
            <button 
              onClick={() => setIsServiceTermsOpen(true)}
              className="p-1 -mr-1 rounded-full text-zinc-900 hover:bg-zinc-100 transition-colors"
            >
              <Info className="w-5 h-5" strokeWidth={2} />
            </button>
          </div>
          <div className="flex flex-col items-center">
            <h2 className="font-outfit text-[20px] font-semibold text-zinc-900 mb-[4px]">
              How will we enter?
            </h2>
            <p className="text-[14.5px] font-sans font-normal text-zinc-500 text-center mb-[24px]">
              Choose how the cleaner can enter your home.
            </p>
          </div>
        </div>

        <div ref={scrollRef} className="px-5 overflow-y-auto scrollbar-hide flex-1 space-y-3 pb-[140px]">
          {ENTRY_METHODS.map((method) => {
            const isSelected = selectedMethod === method.id;
            return (
              <div
                key={method.id}
                onClick={() => setSelectedMethod(method.id)}
                className={`flex items-center p-4 rounded-[12px] border cursor-pointer transition-all ${
                  isSelected
                    ? "border-[#7B82F4] bg-[#7B82F4]/5"
                    : "border-zinc-200 bg-white hover:border-zinc-300"
                }`}
              >
                <div className="w-[38px] h-[38px] bg-white border border-zinc-100 rounded-[10px] flex items-center justify-center shadow-sm text-lg mr-4 shrink-0">
                  {method.emoji}
                </div>
                <div className="flex-1">
                  <h3 className="font-outfit text-[16px] font-medium text-zinc-900 leading-tight">
                    {method.title}
                  </h3>
                  <p className="font-sans text-[14px] font-normal text-zinc-500 mt-0.5">
                    {method.subtitle}
                  </p>
                </div>
                <div
                  className={`w-5 h-5 rounded-full border-2 flex items-center justify-center shrink-0 ml-3 transition-colors ${
                    isSelected
                      ? "border-[#7B82F4]"
                      : "border-zinc-300"
                  }`}
                >
                  {isSelected && (
                    <div className="w-2.5 h-2.5 rounded-full bg-[#7B82F4]" />
                  )}
                </div>
              </div>
            );
          })}

          <div className="mt-8">
            <h4 className="font-outfit text-[14.5px] font-medium text-zinc-900 mb-[14px]">
              Access notes (optional)
            </h4>
            <textarea
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              placeholder="Example: gate code, parking instructions, call upon arrival..."
              className="w-full bg-[#F5F7FB] border border-transparent focus:border-[#7B82F4] rounded-[14px] p-4 font-sans text-[14px] font-normal text-zinc-900 placeholder:text-zinc-400 outline-none resize-none transition-colors"
              rows={4}
            />
          </div>
        </div>

        <div className="absolute bottom-0 left-0 right-0 p-5 bg-white border-t border-zinc-100 pb-[40px] shrink-0">
          <button
            onClick={handleUpdate}
            className="w-full h-[50px] bg-[#14181B] text-white rounded-[8px] font-sans text-[16px] font-semibold flex items-center justify-center hover:bg-zinc-800 transition-colors active:scale-[0.98] shadow-md"
          >
            Update Booking
          </button>
        </div>
      </div>
      
      <ServiceTermsBottomSheet 
        isOpen={isServiceTermsOpen} 
        onClose={() => setIsServiceTermsOpen(false)} 
      />
    </>
  );
}
