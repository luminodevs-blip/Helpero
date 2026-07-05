"use client";

import React, { useState, useEffect, useRef } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { ChevronDown, ShoppingCart, Search, Sparkles } from "lucide-react";
import AddressSelector from "@/components/AddressSelector";
import CartIcon from "@/components/CartIcon";

interface HomeAppBarProps {
  categories?: any[];
  categoriesPinned?: boolean;
}

export default function HomeAppBar({ categories = [], categoriesPinned = false }: HomeAppBarProps) {
  const router = useRouter();
  const { selectedAddress, cart } = useClientAuth();
  const [selectorOpen, setSelectorOpen] = useState(false);
  const [pinned, setPinned] = useState(false);

  // Watch the address row — when it exits viewport, show pinned search bar
  const addressRowRef = useRef<HTMLDivElement>(null);
  useEffect(() => {
    const el = addressRowRef.current;
    if (!el) return;
    const observer = new IntersectionObserver(
      ([entry]) => setPinned(!entry.isIntersecting),
      { threshold: 0, rootMargin: "0px" }
    );
    observer.observe(el);
    return () => observer.disconnect();
  }, []);

  const searchBar = (
    <div
      onClick={() => router.push("/search")}
      className="flex items-center bg-white/20 hover:bg-white/25 border border-white/5 transition-all rounded-[10px] h-11 px-4 cursor-pointer"
    >
      <Search className="h-4.5 w-4.5 text-white/80 mr-2.5 flex-shrink-0" />
      <span className="text-[16px] font-medium text-white/70">
        Search for services
      </span>
    </div>
  );

  return (
    <>
      {/* ── PINNED BAR: appears instantly when address row exits viewport ── */}
      {pinned && (
        <div className="fixed top-0 left-1/2 -translate-x-1/2 w-full max-w-md z-50 bg-primary px-5 pt-3 pb-4 shadow-sm transition-all duration-300">
          {searchBar}
          
          {/* Mini Categories Row - smoothly appears when categories are scrolled past */}
          <div 
            className={`flex items-center gap-2 overflow-x-auto -mx-5 px-5 [&::-webkit-scrollbar]:hidden [-ms-overflow-style:none] [scrollbar-width:none] transition-all duration-300 ease-in-out ${
              categoriesPinned ? "max-h-12 opacity-100 mt-3" : "max-h-0 opacity-0 mt-0"
            }`}
          >
            {categories.map((cat) => (
              <div
                key={cat.id}
                onClick={() => router.push(`/category/${cat.id}`)}
                className="flex items-center gap-1.5 px-3 py-1.5 bg-white/20 hover:bg-white/30 rounded-full border border-white/10 cursor-pointer flex-shrink-0 transition-colors"
              >
                {cat.image_url ? (
                  <img src={cat.image_url} alt={cat.name} className="w-4 h-4 object-contain" />
                ) : (
                  <Sparkles className="w-4 h-4 text-white/80" />
                )}
                <span className="text-[13px] font-medium text-white">{cat.name}</span>
              </div>
            ))}
          </div>
        </div>
      )}

      <div className="bg-primary pt-10 pb-[40px] px-5 relative overflow-hidden flex-shrink-0 z-20">
        {/* Subtle Radial Glow */}
        <div className="absolute inset-0 bg-radial-gradient from-white/10 to-transparent pointer-events-none opacity-40" />

        <div className="relative z-10 space-y-[12px]">

          {/* Address row — observed */}
          <div ref={addressRowRef} className="flex items-start justify-between">
            <div
              onClick={() => setSelectorOpen(true)}
              className="flex flex-col cursor-pointer max-w-[280px]"
            >
              <span className="text-[15px] font-normal text-white/70">
                Selected address
              </span>
              <div className="flex items-center gap-1.5 mt-[4px]">
                <span className="font-outfit text-[18px] font-medium truncate max-w-[210px]">
                  {selectedAddress?.fullAddress || "Select Address"}
                </span>
                <ChevronDown className="h-4.5 w-4.5 text-white/80" />
              </div>
            </div>

            <CartIcon />
          </div>

          {/* Search bar */}
          <div className="relative">
            {searchBar}
          </div>

        </div>
      </div>

      <AddressSelector isOpen={selectorOpen} onClose={() => setSelectorOpen(false)} />
    </>
  );
}
