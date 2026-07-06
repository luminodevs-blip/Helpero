"use client";

import React, { useState, useEffect, useRef } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import { BookingDraft } from "@/lib/types";
import { X, MoreHorizontal, Loader2, Trash2 } from "lucide-react";

export default function CartSheet() {
  const router = useRouter();
  const {
    cart,
    cartSheetOpen,
    setCartSheetOpen,
    updateCart,
    setActiveDraft,
    activeBookingDraft,
  } = useClientAuth();

  const [categories, setCategories] = useState<any[]>([]);
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
    <div className="fixed inset-0 z-[9999] flex items-end justify-center">
      {/* Backdrop */}
      <div
        onClick={() => setCartSheetOpen(false)}
        className="absolute inset-0 bg-black/45 transition-opacity duration-300 animate-fade-in animate-duration-200"
      />

      {/* Sheet Container */}
      <div
        className="relative bg-white w-full max-w-md rounded-none shadow-2xl flex flex-col h-[100dvh] transition-transform duration-300 transform translate-y-0 animate-slide-up pb-safe z-10"
        style={{
          boxShadow: "0 -8px 24px rgba(0, 0, 0, 0.08)",
        }}
      >
        {/* Header */}
        <div className="flex items-center justify-between px-4 pt-[24px] pb-[20px] border-b border-zinc-100 flex-shrink-0 relative">
          <button
            onClick={() => setCartSheetOpen(false)}
            className="p-1 rounded-full hover:bg-zinc-100 text-zinc-800 transition-colors z-10"
          >
            <X size={20} strokeWidth={2.5} />
          </button>
          
          <h2 className="font-outfit text-[20px] font-semibold text-zinc-950 absolute left-1/2 -translate-x-1/2">
            Your cart
          </h2>

          <div className="w-8" /> {/* Spacer */}
        </div>

        {/* Content Area */}
        <div className="flex-1 overflow-y-auto px-4 py-6">
          {cart.length === 0 ? (
            /* EMPTY STATE */
            <div className="flex flex-col items-center justify-center py-10 text-center space-y-5">
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
          ) : (
            /* CART HAS ITEMS */
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
                        <p className="text-[14.5px] text-zinc-500 font-normal mt-1">
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
                    <div className="border-b border-dashed border-zinc-150 pt-2" />

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

        {/* Footer Actions (Only show when cart has items) */}
        {cart.length > 0 && (
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
            className="relative bg-white w-full max-w-md rounded-t-[28px] shadow-2xl flex flex-col p-5 pb-[34px] transition-transform duration-300 transform translate-y-0 animate-slide-up z-10"
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
