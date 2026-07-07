"use client";

import React, { useState, useEffect, useRef } from "react";
import { useRouter, usePathname } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import { BookingDraft } from "@/lib/types";
import { X, MoreHorizontal, Loader2, Trash2, Plus, Minus } from "lucide-react";
import { updateBookingAddon } from "@/lib/booking";
import { useBodyScrollLock } from "@/lib/useBodyScrollLock";

export default function CartSheet() {
  const router = useRouter();
  const pathname = usePathname();
  const isBookingFlow = pathname === "/configure" || pathname === "/addons" || pathname === "/datetime";
  const {
    cart,
    cartSheetOpen,
    setCartSheetOpen,
    updateCart,
    setActiveDraft,
    activeBookingDraft,
  } = useClientAuth();

  const handleQtyChange = (addon: any, action: "add" | "remove") => {
    const draft = cart.find((item) => item.selectedAddons.some((a) => a.id === addon.id));
    if (!draft) return;
    
    const updatedDraft = updateBookingAddon(draft, addon, action);
    
    if (activeBookingDraft?.serviceId === draft.serviceId) {
      setActiveDraft(updatedDraft);
    }
    
    const updatedCart = cart.map((item) =>
      item.serviceId === draft.serviceId ? updatedDraft : item
    );
    updateCart(updatedCart);
  };

  const [categories, setCategories] = useState<any[]>([]);
  const [allAddons, setAllAddons] = useState<any[]>([]);
  const [deleteConfirmOpen, setDeleteConfirmOpen] = useState(false);
  const [itemToDelete, setItemToDelete] = useState<BookingDraft | null>(null);
  const menuRef = useRef<HTMLDivElement>(null);

  // Close sheet on escape key
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") setCartSheetOpen(false);
    };
    if (cartSheetOpen) {
      window.addEventListener("keydown", handleKeyDown);
    }
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [cartSheetOpen, setCartSheetOpen]);

  // Close item menu on click outside (no longer needed, using bottom sheet)

  // Load categories to display correct image
  useEffect(() => {
    async function loadCategories() {
      try {
        const { data } = await supabase
          .from("service_categories")
          .select("id, name, image_url");
        if (data) setCategories(data);
      } catch (err) {
        console.error("Error loading categories for cart:", err);
      }
    }
    if (cartSheetOpen) {
      loadCategories();
    }
  }, [cartSheetOpen]);

  // Lock body scroll when cart is open
  useBodyScrollLock(cartSheetOpen);

  if (!cartSheetOpen) return null;

  const getCategoryImage = (categoryId?: number) => {
    if (!categoryId) return null;
    const cat = categories.find((c) => c.id === categoryId);
    return cat?.image_url || null;
  };

  const handleCheckoutItem = (item: BookingDraft) => {
    setActiveDraft(item);
    setCartSheetOpen(false);
    
    // Determine where to send the user based on booking status
    if (item.visit?.arrivalTimeSlot) {
      router.push("/checkout");
    } else if (item.date) {
      router.push("/datetime");
    } else {
      router.push("/configure");
    }
  };

  const handleEditItem = (item: BookingDraft) => {
    setActiveDraft(item);
    setCartSheetOpen(false);
    router.push("/configure");
  };

  const handleDeleteItem = (item: BookingDraft) => {
    const updatedCart = cart.filter((i) => i.currentCartId !== item.currentCartId);
    updateCart(updatedCart);
    if (activeBookingDraft?.currentCartId === item.currentCartId) {
      setActiveDraft(null);
    }
    setDeleteConfirmOpen(false);
    setItemToDelete(null);
  };

  // Helper to format duration
  const formatDuration = (mins?: number) => {
    if (!mins) return "0 min";
    const h = Math.floor(mins / 60);
    const m = mins % 60;
    return `${h > 0 ? `${h} hr ` : ""}${m > 0 ? `${m} min` : ""}`.trim();
  };

  return (
    <div className="fixed inset-0 z-[9999] flex items-end justify-center bg-black/40 backdrop-blur-[2px]">
      {/* Backdrop */}
      <div
        onClick={() => setCartSheetOpen(false)}
        className="absolute inset-0 z-0 cursor-pointer"
      />

      {/* Sheet Container */}
      <div
        className="relative bg-white w-full max-w-md rounded-t-[14px] shadow-2xl flex flex-col h-[90vh] transition-transform duration-300 transform translate-y-0 animate-slide-up z-10 overflow-hidden"
      >
        {/* Handle Bar */}
        {isBookingFlow && (
          <div className="flex justify-center pt-[8px] pb-[16px] shrink-0">
            <div className="w-10 h-1 rounded-full bg-zinc-200" />
          </div>
        )}

        {/* Header */}
        <div className={`flex items-center justify-between px-5 pb-[24px] border-b border-zinc-100 flex-shrink-0 relative ${
          !isBookingFlow ? "pt-[24px]" : ""
        }`}>
          {isBookingFlow ? (
            <>
              <h3 className="font-outfit text-[20px] font-semibold text-zinc-900 mx-auto">
                Summary
              </h3>
              <button
                onClick={() => setCartSheetOpen(false)}
                className="absolute right-5 p-1.5 rounded-full hover:bg-zinc-100 text-zinc-500 focus:outline-none transition-colors"
              >
                <X className="h-5 w-5" />
              </button>
            </>
          ) : (
            <>
              <button
                onClick={() => setCartSheetOpen(false)}
                className="absolute left-5 p-1.5 rounded-full hover:bg-zinc-100 text-zinc-500 focus:outline-none transition-colors"
              >
                <X className="h-5 w-5" />
              </button>
              <h3 className="font-outfit text-[20px] font-semibold text-zinc-900 mx-auto">
                Your cart
              </h3>
            </>
          )}
        </div>

        {/* Content Area */}
        <div className="flex-1 overflow-y-auto px-5 pt-[24px] pb-[20px] flex flex-col">
          {cart.length === 0 ? (
            /* EMPTY STATE */
            <div className="flex-1 flex flex-col items-center justify-center py-10 text-center space-y-5">
              {isBookingFlow && (
                <div className="w-16 h-16 bg-zinc-50 rounded-full flex items-center justify-center">
                  <svg
                    className="w-8 h-8 text-zinc-400"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    strokeWidth={2}
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"
                    />
                  </svg>
                </div>
              )}

              <div className="space-y-2 max-w-[280px]">
                <h3 className="font-outfit text-[17px] font-semibold text-zinc-900 leading-snug">
                  Your cart is empty
                </h3>
                <p className="text-[14.5px] text-zinc-500 font-normal leading-relaxed">
                  Looks like you haven't added any services yet. Explore our catalog to find what you need.
                </p>
              </div>

              <button
                onClick={() => setCartSheetOpen(false)}
                className="bg-zinc-950 text-white font-normal text-[14.5px] px-6 py-3 rounded-xl hover:bg-zinc-900 active:scale-95 transition-all shadow-sm"
              >
                Browse Services
              </button>
            </div>
          ) : isBookingFlow ? (
            /* BOOKING FLOW CART CONTENT */
            <div className="space-y-6">
              {cart.map((item) => {
                const img = getCategoryImage(item.categoryId);
                
                // Find rooms and bathrooms config
                const roomsAddon = item.selectedAddons.find((a) => a.name === "Rooms" || a.name.includes("Bedroom"));
                const bathroomsAddon = item.selectedAddons.find((a) => a.name === "Bathrooms");
                const roomsQty = roomsAddon ? roomsAddon.qty : 0;
                const bathroomsQty = bathroomsAddon ? bathroomsAddon.qty : 0;
                
                const subtitle = roomsQty || bathroomsQty
                  ? `${roomsQty} Rooms · ${bathroomsQty} Bathrooms`
                  : formatDuration(item.baseDuration);
                  
                const mainServicePrice = item.basePrice || item.totalPrice;
                
                // Extras: all addons except Rooms and Bathrooms
                const extraAddons = item.selectedAddons.filter(
                  (a) => a.name !== "Rooms" && a.name !== "Bathrooms"
                );

                return (
                  <div key={item.currentCartId} className="space-y-[20px]">
                    {/* Main service row card */}
                    <div className="flex items-center justify-between gap-4 bg-[#F5F7FB] p-4 rounded-2xl">
                      {/* Left: Thumbnail */}
                      <div className="w-[90px] h-[100px] rounded-xl overflow-hidden bg-white border border-zinc-100 flex-shrink-0 flex items-center justify-center">
                        {img ? (
                          <img
                            src={img}
                            alt={item.serviceName || "Service"}
                            className="w-full h-full object-contain p-2"
                          />
                        ) : (
                          <div className="w-10 h-10 bg-primary/10 rounded-full" />
                        )}
                      </div>

                      {/* Middle: Details */}
                      <div className="flex-1 min-w-0">
                        <h4 className="font-outfit text-[15px] font-bold text-zinc-900 truncate leading-tight">
                          {item.serviceName}
                        </h4>
                        <p className="text-[13px] text-zinc-500 font-semibold mt-1">
                          {subtitle}
                        </p>
                        <p className="font-outfit text-[15px] font-bold text-zinc-900 mt-1">
                          ${mainServicePrice.toFixed(2)}
                        </p>
                      </div>

                      {/* Right: Actions menu */}
                      <div className="relative">
                        <button
                          onClick={() => {
                            setItemToDelete(item);
                            setDeleteConfirmOpen(true);
                          }}
                          className="h-8 w-8 rounded-full bg-white hover:bg-zinc-50 shadow-sm flex items-center justify-center text-zinc-700 transition-colors"
                        >
                          <MoreHorizontal size={18} />
                        </button>
                      </div>
                    </div>

                    {extraAddons.length > 0 ? (
                      <>
                        {/* Divider line under item */}
                        <div className="border-b border-dashed border-zinc-200 my-[20px]" />

                        {/* Extras list */}
                        <div className="space-y-4">
                          {extraAddons.map((addon) => {
                            const currentPrice = addon.unitPrice;
                            const comparePrice = addon.compareAtPrice;
                            
                            return (
                              <div
                                key={addon.id}
                                className="flex justify-between items-center py-1"
                              >
                                <div>
                                  <span className="text-sm font-bold text-zinc-900 block leading-tight">
                                    {addon.name}
                                  </span>
                                  <div className="flex items-center gap-1.5 mt-0.5">
                                    <span className="text-xs font-bold text-zinc-900">
                                      ${currentPrice.toFixed(2)}
                                    </span>
                                    {comparePrice && comparePrice > currentPrice && (
                                      <span className="text-xs font-semibold text-zinc-400 line-through">
                                        ${comparePrice.toFixed(2)}
                                      </span>
                                    )}
                                  </div>
                                </div>

                                {/* Counter widget */}
                                <div className="flex items-center justify-between bg-[#F1F4F8] rounded-[10px] p-[4px] shrink-0 w-[100px]">
                                  <button
                                    type="button"
                                    onClick={() => handleQtyChange(addon, "remove")}
                                    className="h-7 w-7 rounded-[8px] flex items-center justify-center text-zinc-950 bg-white shadow-sm hover:bg-zinc-50 transition-colors"
                                  >
                                    <Minus className="h-4 w-4" strokeWidth={2.5} />
                                  </button>
                                  <span className="font-sans text-sm font-bold text-zinc-900">
                                    {addon.qty}
                                  </span>
                                  <button
                                    type="button"
                                    onClick={() => handleQtyChange(addon, "add")}
                                    className="h-7 w-7 rounded-[8px] flex items-center justify-center text-[#7B82F4] bg-white shadow-sm hover:bg-zinc-50 transition-colors"
                                  >
                                    <Plus className="h-4 w-4" strokeWidth={2.5} />
                                  </button>
                                </div>
                              </div>
                            );
                          })}
                        </div>
                      </>
                    ) : (
                      <>
                        {/* Divider line under item */}
                        <div className="border-b border-dashed border-zinc-200 my-[20px]" />
                        
                        {/* Empty extras list widget */}
                        <div className="border border-dashed border-zinc-200 rounded-2xl p-5 flex flex-col items-center justify-center text-center select-none bg-white">
                          <Plus className="w-5 h-5 text-zinc-400 mb-1.5" strokeWidth={1.5} />
                          <span className="text-sm font-bold text-zinc-900">No extras added yet</span>
                          <span className="text-[11px] text-zinc-500 font-semibold mt-1 max-w-[220px]">
                            Customize your cleaning by adding popular extras from the configuration page.
                          </span>
                        </div>
                      </>
                    )}
                  </div>
                );
              })}
            </div>
          ) : (
            /* GENERAL APP CART CONTENT */
            <div className="space-y-6">
              {cart.map((item) => {
                const img = getCategoryImage(item.categoryId);
                const hasExtras = item.selectedAddons && item.selectedAddons.length > 0;
                
                return (
                  <div key={item.currentCartId} className="space-y-4">
                    {/* Main service row */}
                    <div className="flex items-center justify-between gap-4">
                      {/* Left: Thumbnail */}
                      <div className="w-[90px] h-[100px] rounded-xl overflow-hidden bg-zinc-50 border border-zinc-100 flex-shrink-0 flex items-center justify-center">
                        {img ? (
                          <img
                            src={img}
                            alt={item.serviceName || "Service"}
                            className="w-full h-full object-contain p-2"
                          />
                        ) : (
                          <div className="w-10 h-10 bg-primary/10 rounded-full" />
                        )}
                      </div>

                      {/* Middle: Details */}
                      <div className="flex-1 min-w-0">
                        <h4 className="font-outfit text-[15px] font-bold text-zinc-900 truncate">
                          {item.serviceName}
                        </h4>
                        <p className="text-[14.5px] text-zinc-500 font-semibold mt-1">
                          {formatDuration(item.totalDuration)} · ${item.totalPrice.toFixed(2)}
                        </p>
                      </div>

                      {/* Right: Actions menu */}
                      <div className="relative">
                        <button
                          onClick={() => {
                            setItemToDelete(item);
                            setDeleteConfirmOpen(true);
                          }}
                          className="h-8 w-8 rounded-full bg-zinc-100 hover:bg-zinc-200 flex items-center justify-center text-zinc-700 transition-colors"
                        >
                          <MoreHorizontal size={18} />
                        </button>
                      </div>
                    </div>

                    {/* Divider line under item */}
                    <div className="border-b border-dashed border-zinc-200 my-[20px]" />

                    {/* Extras section */}
                    <div className="bg-zinc-50 rounded-2xl p-4">
                      {!hasExtras ? (
                        <p className="text-[12px] text-zinc-500 text-center font-medium">
                          You haven't added any extras
                        </p>
                      ) : (
                        <div className="space-y-2">
                          <p className="text-[11px] font-bold text-zinc-400 uppercase tracking-wider">
                            Selected Extras
                          </p>
                          {item.selectedAddons.map((addon) => (
                            <div
                              key={addon.id}
                              className="flex justify-between items-center text-[13px] text-zinc-700 font-semibold"
                            >
                              <span className="truncate max-w-[240px]">
                                {addon.name} <span className="text-zinc-400">x{addon.qty}</span>
                              </span>
                              <span className="flex-shrink-0 text-zinc-900">
                                +${addon.totalPrice.toFixed(2)}
                              </span>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>

        {/* Promo savings banner */}
        {cart.length > 0 && (() => {
          const cartTotal = cart.reduce((sum, item) => sum + item.totalPrice, 0);
          const savings = Math.round(cartTotal * 0.15);
          if (savings <= 0) return null;
          return (
            <div className="bg-[#7B82F4] text-white h-[32px] flex items-center justify-center gap-2 text-[14px] font-normal select-none flex-shrink-0">
              <svg className="w-[16px] h-[16px] text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M9.568 3H5.25A2.25 2.25 0 003 5.25v4.318c0 .597.237 1.17.659 1.591l9.581 9.581a1.5 1.5 0 002.122 0l4.318-4.318a1.5 1.5 0 000-2.122L11.16 3.659a2.25 2.25 0 00-1.591-.659z" />
                <path strokeLinecap="round" strokeLinejoin="round" d="M6 6h.008v.008H6V6z" />
              </svg>
              <span>You saved ${savings} with promos</span>
            </div>
          );
        })()}

        {/* Footer Actions (Only show when cart has items) */}
        {cart.length > 0 && (
          isBookingFlow ? (() => {
            const cartTotal = cart.reduce((sum, item) => sum + item.totalPrice, 0);
            const slotFee = activeBookingDraft?.visit?.fee || 0;
            const displayTotal = (cartTotal + slotFee).toFixed(2);
            
            return (
              <div className="pt-[20px] pb-[40px] px-5 border-t border-zinc-100 bg-white flex items-center justify-between flex-shrink-0">
                <div 
                  onClick={() => setCartSheetOpen(false)}
                  className="flex flex-col gap-0.5 cursor-pointer select-none active:opacity-75 transition-opacity"
                >
                  <div className="flex items-baseline gap-2">
                    <span className="font-sans text-[16px] font-normal text-[#57636C]">
                      Total
                    </span>
                    {activeBookingDraft?.visit?.fee && activeBookingDraft.visit.fee > 0 ? (
                      <span className="text-[10px] text-[#7B82F4] font-extrabold bg-[#7B82F4]/10 rounded-full px-2.5 py-0.5 whitespace-nowrap">
                        +${activeBookingDraft.visit.fee.toFixed(2)} slot
                      </span>
                    ) : null}
                  </div>
                  <div className="flex items-center gap-1.5">
                    <span className="font-outfit text-[18px] font-semibold text-zinc-900">
                      ${displayTotal}
                    </span>
                    <svg
                      className="w-4 h-4 text-zinc-900"
                      fill="none"
                      stroke="currentColor"
                      viewBox="0 0 24 24"
                      strokeWidth={3}
                    >
                      <path strokeLinecap="round" strokeLinejoin="round" d="M19 9l-7 7-7-7" />
                    </svg>
                  </div>
                </div>

                <button
                  onClick={() => handleCheckoutItem(cart[0])}
                  className="w-[200px] h-[50px] rounded-xl bg-[#14181B] text-white font-sans text-[18px] font-semibold flex items-center justify-center hover:bg-zinc-800 transition-colors active:scale-[0.98] shadow-md"
                >
                  {pathname === "/configure" || pathname === "/addons" ? "Next" : "Checkout"}
                </button>
              </div>
            );
          })() : (
            <div className="p-4 border-t border-zinc-100 bg-white flex gap-3 flex-shrink-0">
              <button
                onClick={() => setCartSheetOpen(false)}
                className="flex-1 py-3 px-4 rounded-xl border border-zinc-300 text-zinc-950 font-semibold text-[15px] bg-white hover:bg-zinc-50 active:scale-98 transition-all text-center"
              >
                Add Services
              </button>
              <button
                onClick={() => handleCheckoutItem(cart[0])}
                className="flex-1 py-3 px-4 rounded-xl bg-zinc-950 text-white font-semibold text-[15px] hover:bg-zinc-900 active:scale-98 transition-all text-center shadow-sm"
              >
                Checkout
              </button>
            </div>
          )
        )}
      </div>

      {/* Delete Confirmation Bottom Sheet */}
      {deleteConfirmOpen && (
        <div className="fixed inset-0 z-[10000] flex items-end justify-center">
          {/* Backdrop */}
          <div
            onClick={() => {
              setDeleteConfirmOpen(false);
              setItemToDelete(null);
            }}
            className="absolute inset-0 bg-black/55 transition-opacity duration-300 animate-fade-in"
          />

          {/* Sheet */}
          <div
            className="relative bg-white w-full max-w-md rounded-t-[14px] shadow-2xl flex flex-col p-5 pb-[34px] transition-transform duration-300 transform translate-y-0 animate-slide-up z-10"
            style={{
              boxShadow: "0 -8px 32px rgba(0, 0, 0, 0.12)",
            }}
          >
            <button
              onClick={() => {
                if (itemToDelete) handleDeleteItem(itemToDelete);
              }}
              className="w-full py-3 flex items-center gap-3.5 text-[#f43f5e] hover:bg-rose-50/50 rounded-xl px-2 transition-colors text-left"
            >
              <Trash2 size={20} strokeWidth={2} />
              <span className="text-[16px] font-semibold font-sans">Clear cart</span>
            </button>
          </div>
        </div>
      )}

      <style dangerouslySetInnerHTML={{
        __html: `
        @keyframes fadeIn {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes slideUp {
          from { transform: translateY(100%); }
          to { transform: translateY(0); }
        }
        .animate-fade-in {
          animation: fadeIn 0.2s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }
        .animate-slide-up {
          animation: slideUp 0.25s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }
      `,
      }} />
    </div>
  );
}
