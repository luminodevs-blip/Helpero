"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import { updateBookingAddon } from "@/lib/booking";
import { ArrowLeft, Plus, Check, Loader2, ChevronUp, Info } from "lucide-react";

export default function AddonsPage() {
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
          .eq("display_stage", "upsell")
          .order("sort_order", { ascending: true })
          .limit(6);

        if (err) throw new Error(err.message);
        setAddons(data || []);
      } catch (err: any) {
        console.error("Error loading addons:", err);
        setError(err?.message || "Failed to load addons");
      } finally {
        setLoading(false);
      }
    }

    loadAddons();
  }, [activeBookingDraft?.serviceId, router]);

  if (!activeBookingDraft) return null;

  const handleToggleAddon = (addon: any) => {
    const isSelected = getAddonQty(addon.id) > 0;
    const action = isSelected ? "remove" : "add";

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
        
        <h1 className="font-outfit text-[19px] font-bold text-zinc-900 absolute left-1/2 -translate-x-1/2">
          Popular Add-ons
        </h1>
        
        <div className="w-8" /> {/* Spacer */}
      </div>

      <div className="w-full h-[1px] bg-zinc-100" />

      {/* 2. Scrollable Body Content */}
      <div className="flex-1 overflow-y-auto px-5 pt-5 pb-6 bg-white">
        
        {loading ? (
          <div className="flex justify-center items-center py-20">
            <Loader2 className="h-8 w-8 text-[#7B82F4] animate-spin" />
          </div>
        ) : error ? (
          <div className="text-center py-10 text-sm text-red-500 bg-red-50 rounded-xl border border-red-100 p-4">
            {error}
          </div>
        ) : (
          <div className="space-y-5">
            <h2 className="font-outfit text-[17px] font-bold text-zinc-900">
              People also added
            </h2>

            {addons.length > 0 ? (
              <div className="grid grid-cols-3 gap-x-3 gap-y-6">
                {addons.map((addon) => {
                  const isSelected = getAddonQty(addon.id) > 0;
                  // Dummy original price calculation (just for UI design matching)
                  const originalPrice = addon.price ? (addon.price + 10).toFixed(2) : null;

                  return (
                    <div
                      key={addon.id}
                      onClick={() => handleToggleAddon(addon)}
                      className="flex flex-col cursor-pointer transition-opacity hover:opacity-90 active:opacity-70 group"
                    >
                      {/* Image Thumbnail */}
                      <div className="relative w-full aspect-square rounded-xl bg-zinc-100 overflow-hidden mb-2 border border-zinc-100">
                        {addon.image_url ? (
                          <img
                            src={addon.image_url}
                            alt={addon.name}
                            className="w-full h-full object-cover"
                          />
                        ) : (
                          <div className="w-full h-full flex items-center justify-center bg-zinc-100 text-zinc-300 font-outfit text-xs font-bold text-center px-2">
                            {addon.name}
                          </div>
                        )}

                        {/* Plus / Check Button */}
                        <div className="absolute bottom-2 right-2 w-7 h-7 rounded-md bg-[#7B82F4] text-white flex items-center justify-center shadow-sm">
                          {isSelected ? (
                            <Check className="h-4 w-4" strokeWidth={3} />
                          ) : (
                            <Plus className="h-4 w-4" strokeWidth={2.5} />
                          )}
                        </div>
                      </div>

                      {/* Details */}
                      <div className="flex flex-col">
                        <p className="font-outfit text-[14px] font-bold text-zinc-900 leading-tight mb-0.5 line-clamp-1">
                          {addon.name}
                        </p>
                        <button className="text-[12px] font-medium text-[#7B82F4] self-start hover:underline mb-1">
                          Learn more
                        </button>
                        <div className="flex items-center gap-1.5 flex-wrap">
                          <span className="font-sans text-[13px] font-semibold text-zinc-900">
                            ${addon.price?.toFixed(2) || "0.00"}
                          </span>
                          {originalPrice && (
                            <span className="font-sans text-[11px] font-medium text-zinc-300 line-through">
                              ${originalPrice}
                            </span>
                          )}
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            ) : (
              <p className="text-[14px] text-zinc-500">No addons available for this service.</p>
            )}

            {/* Info Box */}
            <div className="bg-zinc-50/80 rounded-xl p-4 flex gap-3 items-start mt-8">
              <Info className="w-4 h-4 text-[#57636C] shrink-0 mt-0.5" strokeWidth={2} />
              <p className="font-sans text-[14px] font-light text-[#57636C] leading-snug">
                Estimated cleaning time adjusts automatically based on your selection.
              </p>
            </div>
          </div>
        )}
      </div>

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
                ${activeBookingDraft.totalPrice?.toFixed(2)}
              </span>
              <ChevronUp className="w-4 h-4 text-zinc-900" />
            </div>
          </div>

          <button
            onClick={() => router.push("/datetime")}
            className="w-[200px] h-[50px] rounded-[10px] bg-[#14181B] text-white font-sans text-[18px] font-semibold hover:bg-zinc-800 focus:outline-none transition-all active:scale-95 shadow-md flex items-center justify-center"
          >
            Next
          </button>
        </div>
      </div>
    </div>
  );
}
