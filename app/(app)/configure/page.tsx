"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import { updateBookingAddon } from "@/lib/booking";
import { ArrowLeft, Plus, Minus, Star, Sparkles, Loader2 } from "lucide-react";

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
  }, [activeBookingDraft, router]);

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

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-bg-secondary pb-32 relative flex flex-col border-x border-alternate shadow-md">
      {/* 1. Header (Wizard: Step 1 of 3) */}
      <div className="bg-bg-secondary px-5 pt-6 pb-4 border-b border-alternate sticky top-0 z-30">
        <div className="flex items-center justify-between">
          <button
            onClick={() => router.back()}
            className="p-1 rounded-full hover:bg-bg-primary text-text-primary focus:outline-none"
          >
            <ArrowLeft className="h-5 w-5" />
          </button>
          
          {/* Progress Indicator */}
          <div className="flex flex-col items-center">
            <span className="text-[10px] font-bold text-primary uppercase tracking-widest">
              Step 1 of 3
            </span>
            <span className="text-xs font-semibold text-text-secondary mt-0.5">
              Customize Service
            </span>
          </div>
          
          {/* Empty spacer for balancing layout */}
          <div className="w-7 h-7" />
        </div>

        {/* Progress Bar Line */}
        <div className="w-full bg-alternate h-1 rounded-full mt-4 overflow-hidden">
          <div className="bg-primary h-full rounded-full transition-all duration-300" style={{ width: "33%" }} />
        </div>
      </div>

      {/* 2. Scrollable Body Content */}
      <div className="flex-1 overflow-y-auto px-5 py-6 space-y-8 bg-bg-secondary">
        
        {loading ? (
          <div className="flex justify-center items-center py-20">
            <Loader2 className="h-8 w-8 text-primary animate-spin" />
          </div>
        ) : error ? (
          <div className="text-center py-10 text-sm text-error bg-error/5 rounded-xl border border-error/20 p-4">
            {error}
          </div>
        ) : (
          <>
            {/* Section A: Customize/Room Size counters */}
            {customizeAddons.length > 0 && (
              <div className="space-y-5">
                <div className="border-b border-alternate pb-2">
                  <h3 className="font-outfit text-base font-extrabold text-text-primary">
                    Choose your home size
                  </h3>
                </div>

                <div className="space-y-4">
                  {customizeAddons.map((addon) => {
                    const qty = getAddonQty(addon.id);
                    return (
                      <div
                        key={addon.id}
                        className="flex items-center justify-between p-4 rounded-2xl border border-alternate bg-bg-primary/30"
                      >
                        <div className="space-y-1 pr-4">
                          <p className="text-sm font-bold text-text-primary">
                            {addon.name}
                          </p>
                          <p className="text-xs text-text-secondary">
                            +${addon.price?.toFixed(2)} (+{addon.duration_minutes || 0}m)
                          </p>
                        </div>

                        {/* Counter Controls */}
                        <div className="flex items-center gap-3 bg-bg-secondary border border-alternate rounded-full p-1 shadow-xs">
                          <button
                            type="button"
                            onClick={() => handleQtyChange(addon, "remove")}
                            disabled={qty === 0}
                            className="h-8 w-8 rounded-full flex items-center justify-center text-text-primary border border-alternate bg-bg-primary hover:bg-bg-primary/80 disabled:opacity-30 disabled:cursor-not-allowed transition-all"
                          >
                            <Minus className="h-4 w-4" />
                          </button>
                          
                          <span className="font-outfit text-base font-bold text-text-primary min-w-[20px] text-center">
                            {qty}
                          </span>
                          
                          <button
                            type="button"
                            onClick={() => handleQtyChange(addon, "add")}
                            className="h-8 w-8 rounded-full flex items-center justify-center text-white bg-primary hover:bg-primary/90 transition-all"
                          >
                            <Plus className="h-4 w-4" />
                          </button>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            )}

            {/* Section B: Extras / Upsell list */}
            {upsellAddons.length > 0 && (
              <div className="space-y-5">
                <div className="border-b border-alternate pb-2">
                  <h3 className="font-outfit text-base font-extrabold text-text-primary">
                    Select additional extras
                  </h3>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  {upsellAddons.map((addon) => {
                    const qty = getAddonQty(addon.id);
                    const isSelected = qty > 0;
                    return (
                      <div
                        key={addon.id}
                        onClick={() => handleQtyChange(addon, isSelected ? "remove" : "add")}
                        className={`flex flex-col rounded-2xl border p-3 cursor-pointer transition-all select-none relative overflow-hidden ${
                          isSelected
                            ? "border-primary bg-primary/5 ring-1 ring-primary"
                            : "border-alternate bg-bg-primary/20 hover:border-primary/30"
                        }`}
                      >
                        {/* Addon Image Thumbnail */}
                        <div className="h-28 w-full rounded-xl bg-bg-primary border border-alternate relative overflow-hidden flex items-center justify-center mb-3">
                          {addon.image_url ? (
                            <img
                              src={addon.image_url}
                              alt={addon.name}
                              className="h-full w-full object-cover"
                            />
                          ) : (
                            <Sparkles className="h-6 w-6 text-primary/30" />
                          )}

                          {/* Check / Quantity Counter badge on top */}
                          {isSelected && (
                            <div className="absolute top-2 right-2 h-6 px-2 rounded-full bg-primary text-white text-[10px] font-extrabold flex items-center justify-center shadow-md">
                              {qty}x
                            </div>
                          )}
                        </div>

                        {/* Text Detail Info */}
                        <div className="flex-1 flex flex-col justify-between">
                          <div>
                            <p className="text-xs font-bold text-text-primary leading-tight line-clamp-1">
                              {addon.name}
                            </p>
                            <p className="text-[10px] text-text-secondary mt-0.5 line-clamp-2 leading-tight">
                              {addon.description || "Deep clean extra option."}
                            </p>
                          </div>

                          <div className="flex items-baseline justify-between mt-3">
                            <span className="text-[10px] text-text-secondary font-semibold">
                              {addon.duration_minutes ? `+${addon.duration_minutes}m` : ""}
                            </span>
                            <span className="text-xs font-extrabold text-primary font-outfit">
                              +${addon.price?.toFixed(2)}
                            </span>
                          </div>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            )}
          </>
        )}
      </div>

      {/* 3. Sticky Bottom Checkout Subtotal Bar */}
      <div className="fixed bottom-0 left-0 right-0 z-40 bg-bg-secondary border-t border-alternate shadow-lg py-4 px-6 flex items-center justify-between max-w-md mx-auto">
        <div className="flex flex-col">
          <span className="text-[10px] font-semibold text-text-secondary uppercase tracking-wider">
            Subtotal Price ({activeBookingDraft.totalDuration}m)
          </span>
          <span className="font-outfit text-xl font-extrabold text-primary mt-0.5">
            ${activeBookingDraft.totalPrice?.toFixed(2)}
          </span>
        </div>

        <button
          onClick={() => router.push("/datetime")}
          className="px-8 h-14 rounded-full bg-primary text-white font-sans text-base font-bold hover:bg-primary/95 focus:outline-none transition-all active:scale-95 shadow-md flex items-center justify-center"
        >
          Select Time & Date
        </button>
      </div>
    </div>
  );
}
