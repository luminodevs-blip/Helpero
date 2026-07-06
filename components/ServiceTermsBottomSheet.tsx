"use client";

import React, { useState, useEffect, useRef } from "react";

interface ServiceTermsBottomSheetProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function ServiceTermsBottomSheet({
  isOpen,
  onClose,
}: ServiceTermsBottomSheetProps) {
  const [isClosing, setIsClosing] = useState(false);

  // Swipe-to-close refs
  const touchStartY = useRef<number | null>(null);
  const scrollRef = useRef<HTMLDivElement>(null);
  const sheetRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (isOpen) {
      setIsClosing(false);
    }
  }, [isOpen]);

  if (!isOpen && !isClosing) return null;

  const handleClose = () => {
    setIsClosing(true);
    setTimeout(() => {
      onClose();
      setIsClosing(false);
    }, 300);
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
        className={`fixed inset-0 bg-zinc-900/40 z-[60] transition-opacity duration-300 ${
          isClosing || !isOpen ? "opacity-0" : "opacity-100"
        }`}
        onClick={handleClose}
      />
      <div
        ref={sheetRef}
        className={`fixed bottom-0 left-0 right-0 z-[60] bg-white rounded-t-[20px] max-w-md mx-auto shadow-2xl transition-transform duration-300 ease-[cubic-bezier(0.32,0.72,0,1)] flex flex-col ${
          isClosing || !isOpen ? "translate-y-full" : "translate-y-0"
        }`}
        style={{ maxHeight: "90vh" }}
        onTouchStart={handleTouchStart}
        onTouchMove={handleTouchMove}
        onTouchEnd={handleTouchEnd}
      >
        <div className="flex items-center justify-center pt-[24px] pb-[20px] shrink-0 border-b border-zinc-100">
          <h2 className="font-outfit text-[18px] font-bold text-zinc-900">
            Service Terms
          </h2>
        </div>

        <div ref={scrollRef} className="px-5 pt-6 overflow-y-auto scrollbar-hide flex-1 pb-[100px]">
          <div className="space-y-4 font-sans text-[14.5px] font-normal text-[#57636C] leading-relaxed">
            <p>
              If our cleaner is unable to access the premises at the scheduled time, the service will be considered incomplete.
            </p>
            <p>
              By placing an order, you confirm that you will provide access to the property and ensure safe working conditions.
            </p>
            <p>
              If access is not provided, the booking is cancelled upon arrival, or the service is refused on-site, a call-out fee may apply.
            </p>
            <p>
              If there are any access restrictions (building entry system, concierge, security, access codes), please provide instructions in advance.
            </p>
          </div>
        </div>

        <div className="absolute bottom-0 left-0 right-0 p-5 bg-white border-t border-zinc-100 pb-[40px] shrink-0">
          <button
            onClick={handleClose}
            className="w-full h-[50px] bg-[#14181B] text-white rounded-[8px] font-sans text-[16px] font-semibold flex items-center justify-center hover:bg-zinc-800 transition-colors active:scale-[0.98] shadow-md"
          >
            Got it
          </button>
        </div>
      </div>
    </>
  );
}
