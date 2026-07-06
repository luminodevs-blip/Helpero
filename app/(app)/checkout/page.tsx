"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import {
  ArrowLeft,
  Tag,
  ChevronRight,
  BadgeCheck,
  AlertCircle,
  Loader2,
  CreditCard,
  Info,
  Sparkles,
} from "lucide-react";
import { supabase } from "@/lib/supabase";

// ─── Countdown timer hook ─────────────────────────────────────────────
function useCountdown(seconds: number) {
  const [timeLeft, setTimeLeft] = useState(seconds);
  useEffect(() => {
    if (timeLeft <= 0) return;
    const timer = setInterval(() => setTimeLeft((t) => t - 1), 1000);
    return () => clearInterval(timer);
  }, [timeLeft]);
  const mm = String(Math.floor(timeLeft / 60)).padStart(2, "0");
  const ss = String(timeLeft % 60).padStart(2, "0");
  return { timeLeft, formatted: `${mm}:${ss}`, expired: timeLeft <= 0 };
}

export default function CheckoutPage() {
  const router = useRouter();
  const { activeBookingDraft, selectedAddress, user, cart, updateCart, setActiveDraft } = useClientAuth();

  const { formatted: countdownTime, expired: slotExpired } = useCountdown(600); // 10 min

  const [promoCode, setPromoCode] = useState<string | null>(null);
  const [promoDiscount, setPromoDiscount] = useState(0);
  const [isPromoExpanded, setIsPromoExpanded] = useState(false);
  const [promoInput, setPromoInput] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!activeBookingDraft) {
      router.replace("/");
    }
  }, [activeBookingDraft, router]);

  // Redirect if slot expired
  useEffect(() => {
    if (slotExpired) {
      router.replace("/datetime");
    }
  }, [slotExpired, router]);

  if (!activeBookingDraft) return null;

  const basePrice = activeBookingDraft.basePrice || 0;
  const addonsTotal = (activeBookingDraft.selectedAddons || []).reduce(
    (sum, a) => sum + a.totalPrice,
    0
  );
  const visitFee = activeBookingDraft.visit?.fee || 0;
  const subtotal = basePrice + addonsTotal + visitFee;
  const taxRate = 0.13; // Ontario HST
  const taxAmount = subtotal * taxRate;
  const totalBeforePromo = subtotal + taxAmount;
  const grandTotal = Math.max(0, totalBeforePromo - promoDiscount);

  const handleApplyPromo = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!promoInput.trim()) return;
    setLoading(true);
    setError(null);
    try {
      const { data, error: promoError } = await supabase
        .from("promo_codes")
        .select("*")
        .eq("code", promoInput.trim().toUpperCase())
        .eq("is_active", true)
        .maybeSingle();

      if (promoError || !data) {
        setError("Invalid or expired promo code");
        setLoading(false);
        return;
      }

      setPromoCode(data.code);
      setPromoDiscount(
        data.discount_type === "percentage"
          ? (subtotal * data.discount_value) / 100
          : data.discount_value
      );
      setIsPromoExpanded(false);
    } catch {
      setError("Failed to validate promo code");
    } finally {
      setLoading(false);
    }
  };

  const handleBookNow = async () => {
    if (!user || !activeBookingDraft || !selectedAddress) return;
    setLoading(true);
    setError(null);

    try {
      // 1. Secure the booking slot in Supabase
      const { error: rpcError } = await supabase.rpc("secure_booking_slot", {
        p_house_id: selectedAddress.id,
        p_duration_min: activeBookingDraft.totalDuration,
        p_mode_slug: activeBookingDraft.visit?.mode,
        p_target_start: activeBookingDraft.visit?.arrivalTimeSlot,
      });

      if (rpcError) {
        throw new Error(rpcError.message);
      }

      // 2. Create order record in the orders table
      const { data: booking, error: bookingError } = await supabase
        .from("orders")
        .insert({
          user_id: user.id,
          house_id: selectedAddress.id,
          scheduled_start_at: activeBookingDraft.visit?.arrivalTimeSlot,
          scheduled_end_at: null,
          arrival_mode_id: activeBookingDraft.visit?.mode,
          total_items_price: subtotal,
          total_tax_amount: taxAmount,
          final_total_price: grandTotal,
          status: "pending_payment",
          payment_status: "pending",
          discount_amount: promoDiscount,
          promo_code: promoCode,
          visit_fee: visitFee,
        })
        .select()
        .single();

      if (bookingError) {
        throw new Error(bookingError.message);
      }

      // 3. Update draft with booking ID and navigate to searching screen
      const updatedDraft = { ...activeBookingDraft, bookingId: booking.id, status: "pending_payment" };
      setActiveDraft(updatedDraft);
      const updatedCart = cart.filter((item) => item.serviceId !== activeBookingDraft.serviceId);
      updateCart(updatedCart);

      router.push(`/searching?bookingId=${booking.id}`);
    } catch (err: any) {
      setError(err?.message || "Booking failed. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-white pb-[140px] relative flex flex-col border-x border-zinc-100 shadow-md font-sans">
      {/* Header */}
      <div className="bg-white px-5 pt-[52px] pb-[16px] flex items-center relative shrink-0">
        <button
          onClick={() => router.back()}
          className="absolute left-5 p-2 -ml-2 rounded-full hover:bg-zinc-100 text-zinc-900 transition-colors"
        >
          <ArrowLeft className="h-5 w-5" />
        </button>
        <div className="flex-1 flex justify-center">
          <h1 className="font-outfit text-[20px] font-semibold text-zinc-900">
            Checkout
          </h1>
        </div>
      </div>

      <div className="w-full h-px bg-zinc-100 shrink-0" />

      {/* Main scrollable body */}
      <div className="flex-1 overflow-y-auto px-5 pt-[20px] pb-10 space-y-8">
        
        {/* ── Slot expired warning ── */}
        {slotExpired && (
          <div className="rounded-2xl bg-red-50 p-4 flex items-start gap-3">
            <AlertCircle className="h-5 w-5 text-red-500 mt-0.5 flex-shrink-0" />
            <div>
              <p className="text-[14px] font-bold text-red-600">Time slot expired</p>
              <p className="text-[13px] text-red-500/80 mt-0.5">
                Your reserved slot has expired. Please go back and select a new time.
              </p>
            </div>
          </div>
        )}

        {/* ── Error ── */}
        {error && (
          <div className="rounded-2xl bg-red-50 border border-red-100 p-4 text-[14px] text-red-600 font-semibold">
            {error}
          </div>
        )}

        {/* ── Payment Method ── */}
        <div className="flex flex-col">
          <h2 className="font-outfit text-[17px] font-medium text-zinc-900 mb-[20px]">
            How would you like to pay?
          </h2>
          
          <div className="flex items-center justify-between h-[66px] px-4 rounded-[10px] border border-zinc-200/80 bg-[#FAFAFA] mb-[16px]">
            <div className="flex items-center gap-3">
              <div className="h-8 w-10 bg-white border border-zinc-200 rounded flex items-center justify-center shadow-sm shrink-0">
                <CreditCard className="h-5 w-5 text-zinc-700" />
              </div>
              <span className="font-sans text-[16px] font-normal text-zinc-900">
                Bank Card
              </span>
            </div>
            <button className="text-[16px] font-normal text-[#7B82F4] hover:opacity-80 transition-opacity">
              Change
            </button>
          </div>

          {/* Promo Banner */}
          <div className="relative overflow-hidden rounded-[12px] bg-gradient-to-r from-[#7B82F4] to-[#A2A6F6] p-4 text-white">
            <div className="relative z-10">
              <h3 className="font-outfit text-[18px] font-semibold leading-tight mb-[10px]">
                Buy Helpero credit<br />
                Get free credit
              </h3>
              <button className="text-[16px] font-normal flex items-center gap-1 hover:opacity-80 transition-opacity">
                Purchase now <ArrowLeft className="h-3.5 w-3.5 rotate-180" />
              </button>
            </div>
            <div className="absolute right-0 top-0 bottom-0 w-32 flex items-center justify-center opacity-30">
              {/* Star graphic placeholder */}
              <Sparkles className="h-32 w-32 fill-current text-white translate-x-4" />
            </div>
          </div>
        </div>

        <div className="w-full h-px bg-zinc-100 !mt-[16px]" />

        {/* ── Order details ── */}
        <div className="space-y-2 !mt-[24px]">
          <h2 className="font-outfit text-[17px] font-medium text-zinc-900">
            Order details
          </h2>
          
          {/* Service Item */}
          <div 
            className="flex items-center justify-between !mt-[20px] !mb-[20px] cursor-pointer hover:opacity-80 transition-opacity"
            onClick={() => router.push(`/service/${activeBookingDraft.serviceId}`)}
          >
            <div className="flex items-center gap-3">
              {activeBookingDraft.serviceImageUrl ? (
                <img
                  src={activeBookingDraft.serviceImageUrl}
                  alt={activeBookingDraft.serviceName}
                  className="h-10 w-10 rounded-lg object-cover"
                />
              ) : (
                <div className="h-10 w-10 rounded-lg bg-zinc-100 flex items-center justify-center">
                  <BadgeCheck className="h-5 w-5 text-zinc-400" />
                </div>
              )}
              <div className="flex flex-col">
                <span className="font-sans text-[16px] font-medium text-zinc-900">
                  {activeBookingDraft.serviceName}
                </span>
                <span className="font-sans text-[14px] font-normal text-[#57636C]">
                  1 position
                </span>
              </div>
            </div>
            <ChevronRight className="h-5 w-5 text-zinc-400" />
          </div>

          <div className="w-full h-px bg-zinc-100 !my-0" />

          {/* Promocode */}
          <div className="!mt-[12px]">
            <div 
              className="flex items-center justify-between py-2 cursor-pointer hover:bg-zinc-50 rounded-lg -mx-2 px-2 transition-colors"
              onClick={() => setIsPromoExpanded(!isPromoExpanded)}
            >
              <div className="flex items-center gap-3">
                <Tag className="h-5 w-5 text-zinc-700" />
                <span className="font-sans text-[14px] font-medium text-zinc-900">
                  {promoCode ? `Promocode applied: ${promoCode}` : "Add promocode"}
                </span>
              </div>
              <ChevronRight className={`h-4 w-4 text-zinc-400 transition-transform ${isPromoExpanded ? 'rotate-90' : ''}`} />
            </div>
            
            {/* Expanded Promo Input */}
            {isPromoExpanded && (
              <div className="mt-3 flex gap-2">
                <input
                  type="text"
                  value={promoInput}
                  onChange={(e) => setPromoInput(e.target.value.toUpperCase())}
                  placeholder="Enter code"
                  className="flex-1 border border-zinc-200 rounded-xl px-4 py-3 text-[14px] text-zinc-900 placeholder:text-zinc-400 focus:border-[#7B82F4] outline-none uppercase font-medium bg-[#FAFAFA]"
                />
                <button
                  onClick={handleApplyPromo}
                  disabled={loading || !promoInput.trim()}
                  className="px-5 rounded-xl bg-zinc-900 text-white text-[14px] font-semibold disabled:opacity-50 hover:bg-zinc-800 transition-colors flex items-center justify-center"
                >
                  {loading ? <Loader2 className="h-4 w-4 animate-spin" /> : "Apply"}
                </button>
              </div>
            )}
          </div>

          <div className="w-full h-px bg-zinc-100 !mt-[12px] !mb-0" />

          {/* Price Breakdown */}
          <div className="!mt-[16px] space-y-2">
            <div className="flex justify-between font-sans text-[15px] font-normal">
              <span className="text-zinc-900">Sub total</span>
              <span className="text-zinc-900">${subtotal.toFixed(2)}</span>
            </div>
            
            {visitFee > 0 && (
              <div className="flex justify-between font-sans text-[15px] font-normal">
                <span className="text-zinc-900">Booking Fee</span>
                <span className="text-zinc-900">${visitFee.toFixed(2)}</span>
              </div>
            )}
            
            <div className="flex justify-between font-sans text-[15px] font-normal items-center">
              <div className="flex items-center gap-1.5 text-zinc-900">
                Taxes & Fees
                <Info className="h-3.5 w-3.5 text-zinc-400" />
              </div>
              <span className="text-zinc-900">${taxAmount.toFixed(2)}</span>
            </div>

            {promoDiscount > 0 && (
              <div className="flex justify-between font-sans text-[15px] font-normal text-[#7B82F4]">
                <span>Discount</span>
                <span>-${promoDiscount.toFixed(2)}</span>
              </div>
            )}

            <div className="flex justify-between font-outfit text-[17px] font-medium text-zinc-900">
              <span>Total</span>
              <span>${grandTotal.toFixed(2)}</span>
            </div>
          </div>

          <div className="w-full h-px bg-zinc-100 !mt-[16px] !mb-0" />

          {/* Legal note */}
          <p className="font-sans text-[13px] leading-relaxed text-zinc-900 !mt-[10px]">
            By confirming booking , I agree to the <a href="#" className="underline">service policy</a> and <a href="#" className="underline">refund policy</a>, I also agree to pay for the full amount of booking
          </p>
        </div>
      </div>

      {/* ── Sticky Bottom CTA ── */}
      <div className="fixed bottom-0 left-0 right-0 z-40 bg-white flex flex-col max-w-md mx-auto border-t border-zinc-100">
        {/* Timer Bar */}
        <div className="w-full h-[28px] bg-[#7B82F4] px-5 flex items-center justify-between text-white">
          <span className="text-[14.5px] font-light font-sans">
            Slot reservation time
          </span>
          <span className="text-[14.5px] font-medium font-sans">
            {countdownTime}
          </span>
        </div>
        
        {/* Pay Button Area */}
        <div className="p-5 pb-[40px] bg-white">
          <button
            onClick={handleBookNow}
            disabled={loading || slotExpired}
            className="w-full h-[50px] rounded-[10px] bg-[#14181B] text-white font-sans text-[18px] font-semibold hover:bg-zinc-800 disabled:opacity-50 transition-colors active:scale-[0.98] shadow-md flex items-center justify-center gap-2"
          >
            {loading ? (
              <Loader2 className="h-5 w-5 animate-spin" />
            ) : (
              <>
                <CreditCard className="h-5 w-5" />
                Pay Now
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
}
