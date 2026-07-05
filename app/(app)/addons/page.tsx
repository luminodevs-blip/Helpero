"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import { updateBookingAddon } from "@/lib/booking";
import { ArrowLeft, Plus, Minus, Check, Loader2, ChevronUp, Info } from "lucide-react";

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
            <h2 className="font-outfit text-[17px] font-medium text-zinc-900">
              People also added
            </h2>

            {addons.length > 0 ? (
              <div className="grid grid-cols-3 gap-x-4 gap-y-6">
                {addons.map((addon) => {
                  const qty = getAddonQty(addon.id);
                  const originalPrice = addon.price ? (addon.price + 10).toFixed(2) : null;

                  return (
                    <div
                      key={addon.id}
                      className="flex flex-col group"
                    >
                      {/* Image Thumbnail */}
                      <div 
                        className="relative w-full h-[100px] rounded-[8px] bg-zinc-100 overflow-hidden mb-2 border border-zinc-100 cursor-pointer"
                        onClick={() => {
                          if (qty === 0) handleQtyChange(addon, "add");
                        }}
                      >
                        {addon.image_url ? (
                          <img
                            src={addon.image_url}
                            alt={addon.name}
                            className="w-full h-full object-cover transition-opacity hover:opacity-90 active:opacity-70"
                          />
                        ) : (
                          <div className="w-full h-full flex items-center justify-center bg-zinc-100 text-zinc-300 font-outfit text-xs font-bold text-center px-2 transition-opacity hover:opacity-90 active:opacity-70">
                            {addon.name}
                          </div>
                        )}

                        {/* Expanding Counter Button */}
                        <div 
                          className={`absolute bottom-1.5 right-1.5 h-[36px] rounded-[10px] shadow-sm transition-all duration-300 overflow-hidden flex items-center ${
                            qty > 0 ? "w-[94px] bg-[#F5F7FB] p-[3px] justify-between" : "w-[36px] bg-[#7B82F4] justify-center cursor-pointer hover:bg-[#6A70E0]"
                          }`}
                          onClick={(e) => {
                            if (qty === 0) {
                              e.stopPropagation();
                              handleQtyChange(addon, "add");
                            }
                          }}
                        >
                          {qty > 0 ? (
                            <>
                              <button 
                                onClick={(e) => { e.stopPropagation(); handleQtyChange(addon, "remove"); }}
                                className="w-[30px] h-[30px] bg-white rounded-[8px] flex items-center justify-center text-zinc-900 shadow-sm hover:bg-zinc-50 transition-colors shrink-0"
                              >
                                <Minus className="w-[16px] h-[16px]" strokeWidth={2.5} />
                              </button>
                              <span className="font-outfit text-[14px] font-bold text-zinc-900 flex-1 text-center leading-none">{qty}</span>
                              <button 
                                onClick={(e) => { e.stopPropagation(); handleQtyChange(addon, "add"); }}
                                className="w-[30px] h-[30px] bg-[#7B82F4] rounded-[8px] flex items-center justify-center text-white shadow-sm hover:bg-[#6A70E0] transition-colors shrink-0"
                              >
                                <Plus className="w-[16px] h-[16px]" strokeWidth={2.5} />
                              </button>
                            </>
                          ) : (
                            <Plus className="w-[20px] h-[20px] text-white" strokeWidth={2.5} />
                          )}
                        </div>
                      </div>

                      {/* Details */}
                      <div className="flex flex-col px-0.5">
                        <p className="font-outfit text-[14px] font-medium text-zinc-900 leading-tight mb-1 line-clamp-1">
                          {addon.name}
                        </p>
                        <button className="text-[12.5px] font-normal text-[#7B82F4] self-start hover:underline mb-1">
                          Learn more
                        </button>
                        <div className="flex items-center gap-2 flex-wrap">
                          <span className="font-sans text-[14px] font-normal text-zinc-900">
                            ${addon.price?.toFixed(2) || "0.00"}
                          </span>
                          {originalPrice && (
                            <span className="font-sans text-[14px] font-normal text-[#e0e3e7] line-through">
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
