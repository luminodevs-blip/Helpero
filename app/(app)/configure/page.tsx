"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import { updateBookingAddon } from "@/lib/booking";
import { ArrowLeft, Plus, Minus, Star, Sparkles, Loader2, ChevronUp, Info } from "lucide-react";

export default function ConfigurePage() {
  const router = useRouter();
  const { activeBookingDraft, cart, updateCart, setActiveDraft } = useClientAuth();

  const [addons, setAddons] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!activeBookingDraft) {
      router.replace("/");
      return;
    }

    async function loadAddons() {
      if (!activeBookingDraft) return;
      try {
        setLoading(true);
        const { data, error: err } = await supabase
          .from("service_addons")
          .select("*")
          .eq("service_id", activeBookingDraft.serviceId)
          .order("sort_order", { ascending: true });

        if (err) throw new Error(err.message);
        setAddons(data || []);
      } catch (err: any) {
        console.error("Error loading addons:", err);
        setError(err?.message || "Failed to load options");
      } finally {
        setLoading(false);
      }
    }

    loadAddons();
  }, [activeBookingDraft?.serviceId, router]);

  if (!activeBookingDraft) return null;

  // Group addons by display stage
  const customizeAddons = addons.filter((a) => a.display_stage === "customize");
  const upsellAddons = addons.filter((a) => a.display_stage === "upsell");

  const handleQtyChange = (addon: any, action: "add" | "remove") => {
    // 1. Calculate updated draft using the booking utility
    const updatedDraft = updateBookingAddon(activeBookingDraft, addon, action);

    // 2. Update local state
    setActiveDraft(updatedDraft);

    // 3. Update item in GeneralCart list
    const updatedCart = cart.map((item) =>
      item.serviceId === activeBookingDraft.serviceId ? updatedDraft : item
    );
    updateCart(updatedCart);
  };

  const getAddonQty = (addonId: string) => {
    const found = activeBookingDraft.selectedAddons.find((a) => a.id === addonId);
    return found ? found.qty : 0;
  };

  const hasSelectedSomething = 
    customizeAddons.length === 0 || 
    customizeAddons.some((addon) => getAddonQty(addon.id) > 0);

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-white pb-[100px] relative flex flex-col shadow-md font-sans">
      {/* 1. Header */}
      <div className="bg-white px-5 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30">
        <button
          onClick={() => router.back()}
          className="p-1 -ml-1 flex items-center justify-center rounded-full hover:bg-zinc-100 text-zinc-900 focus:outline-none transition-colors"
        >
          <ArrowLeft className="w-[24px] h-[24px]" strokeWidth={2} />
        </button>
        
        <h1 className="font-outfit text-[20px] font-semibold text-zinc-900 absolute left-1/2 -translate-x-1/2">
          Set up your service
        </h1>
        
        <div className="w-8" /> {/* Spacer */}
      </div>

      <div className="w-full h-[1px] bg-zinc-100" />

      {/* 2. Scrollable Body Content */}
      <div className="flex-1 overflow-y-auto px-5 pt-5 pb-6 bg-white">
        
        {loading ? (
          <div className="flex justify-center items-center py-20">
            <Loader2 className="h-8 w-8 text-primary animate-spin" />
          </div>
        ) : error ? (
          <div className="text-center py-10 text-sm text-red-500 bg-red-50 rounded-xl border border-red-100 p-4">
            {error}
          </div>
        ) : (
          <div className="space-y-5">
            <h2 className="font-outfit text-[17px] font-medium text-zinc-900">
              Set up your service
            </h2>

            {/* Section A: Customize/Room Size counters */}
            {customizeAddons.length > 0 && (
              <div className="flex flex-col">
                {customizeAddons.map((addon, index) => {
                  const qty = getAddonQty(addon.id);
                  return (
                    <div
                      key={addon.id}
                      className={`flex items-center justify-between py-5 ${index !== customizeAddons.length - 1 ? 'border-b border-zinc-100' : ''}`}
                    >
                      <div className="flex items-center gap-4">
                        {/* Image Thumbnail */}
                        <div className="w-[60px] h-[60px] rounded-[6px] overflow-hidden bg-zinc-50 border border-zinc-100 shrink-0 flex items-center justify-center">
                          {addon.image_url ? (
                            <img src={addon.image_url} alt={addon.name} className="w-full h-full object-cover" />
                          ) : (
                            <Sparkles className="w-6 h-6 text-zinc-300" />
                          )}
                        </div>

                        {/* Details */}
                        <div className="flex flex-col gap-0.5">
                          <p className="font-outfit text-[16px] font-medium text-zinc-900">
                            {addon.name}
                          </p>
                          <p className="font-sans text-[14px] font-normal text-zinc-900">
                            ${addon.price?.toFixed(2)} / {addon.name.toLowerCase().replace(/s$/, '')}
                          </p>
                          {(addon.description || addon.name === "Rooms" || addon.name === "Bathrooms") && (
                            <p className="font-sans text-[14px] font-light text-zinc-500">
                              {addon.description || (addon.name === "Rooms" ? "(living & sleeping areas)" : "Hygiene zone")}
                            </p>
                          )}
                        </div>
                      </div>

                      {/* Counter Controls */}
                      <div className="flex items-center justify-between bg-[#F5F7FB] rounded-[10px] p-[5px] shrink-0 w-[110px]">
                        <button
                          type="button"
                          onClick={() => handleQtyChange(addon, "remove")}
                          disabled={qty === 0}
                          className="h-[30px] w-[30px] rounded-[8px] flex items-center justify-center text-zinc-900 bg-white shadow-sm disabled:opacity-50 disabled:cursor-not-allowed hover:bg-zinc-50 transition-colors"
                        >
                          <Minus className="w-[18px] h-[18px]" strokeWidth={2} />
                        </button>
                        
                        <span className="font-sans text-[20px] font-medium text-zinc-900 text-center">
                          {qty}
                        </span>
                        
                        <button
                          type="button"
                          onClick={() => handleQtyChange(addon, "add")}
                          disabled={qty >= 6}
                          className="h-[30px] w-[30px] rounded-[8px] flex items-center justify-center text-white bg-[#7B82F4] shadow-sm hover:bg-[#6A70E0] disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                        >
                          <Plus className="w-[18px] h-[18px]" strokeWidth={2} />
                        </button>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}

            <div className="w-full h-[1px] bg-zinc-100 mb-6" />

            {/* Info Box */}
            <div className="bg-zinc-50/80 rounded-xl p-4 flex gap-3 items-start">
              <Info className="w-4 h-4 text-[#57636C] shrink-0 mt-0.5" strokeWidth={2} />
              <p className="font-sans text-[14px] font-light text-[#57636C] leading-snug">
                Estimated cleaning time adjusts automatically based on your selection.
              </p>
            </div>

            {/* Section B removed as it now belongs to its own addons page */}
          </div>
        )}
      </div>

      {/* Progress Bar & Footer Sticky Container */}
      <div className="fixed bottom-0 left-0 right-0 z-40 bg-white max-w-md mx-auto">
        {/* Progress Bar */}
        <div className="w-full bg-zinc-100 h-[6px]">
          <div className="bg-[#7B82F4] h-full transition-all duration-300" style={{ width: "33%" }} />
        </div>
        
        {/* Footer */}
        <div className="pt-4 pb-[40px] px-5 flex items-center justify-between">
          <div className="flex flex-col gap-0.5">
            <span className="font-sans text-[16px] font-normal text-[#57636C]">
              Total
            </span>
            <div className="flex items-center gap-1.5 cursor-pointer">
              <span className="font-outfit text-[18px] font-semibold text-zinc-900">
                ${activeBookingDraft.totalPrice?.toFixed(2)}
              </span>
              <ChevronUp className="w-4 h-4 text-zinc-900" />
            </div>
          </div>

          <button
            onClick={() => router.push("/addons")}
            disabled={!hasSelectedSomething}
            className={`w-[200px] h-[50px] rounded-[10px] font-sans text-[18px] font-semibold flex items-center justify-center transition-all ${
              hasSelectedSomething 
                ? "bg-[#14181B] text-white hover:bg-zinc-800 active:scale-95 shadow-md" 
                : "bg-zinc-200 text-zinc-400 cursor-not-allowed"
            }`}
          >
            Next
          </button>
        </div>
      </div>
    </div>
  );
}
