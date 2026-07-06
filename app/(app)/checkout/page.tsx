"use client";

import React, { useState, useEffect, useMemo } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import StripePaymentModal from "@/components/StripePaymentModal";
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
function useCountdown(initialSeconds: number | null, onExpire: () => void) {
  const [timeLeft, setTimeLeft] = useState<number | null>(null);

  useEffect(() => {
    if (initialSeconds !== null) {
      setTimeLeft(initialSeconds);
    }
  }, [initialSeconds]);

  useEffect(() => {
    if (timeLeft === null) return;
    if (timeLeft <= 0) {
      onExpire();
      return;
    }
    const timer = setInterval(() => setTimeLeft((t) => (t !== null ? t - 1 : null)), 1000);
    return () => clearInterval(timer);
  }, [timeLeft, onExpire]);

  const displayTime = useMemo(() => {
    if (timeLeft === null) return "10:00";
    const mm = String(Math.floor(timeLeft / 60)).padStart(2, "0");
    const ss = String(timeLeft % 60).padStart(2, "0");
    return `${mm}:${ss}`;
  }, [timeLeft]);

  return { timeLeft, formatted: displayTime, expired: timeLeft !== null && timeLeft <= 0 };
}
export default function CheckoutPage() {
  const router = useRouter();
  const { activeBookingDraft, selectedAddress, user, cart, updateCart, setActiveDraft } = useClientAuth();

  const [isTimerExpired, setIsTimerExpired] = useState(false);
  const [initialSeconds, setInitialSeconds] = useState<number | null>(null);
  const { formatted: countdownTime, expired: slotExpired } = useCountdown(initialSeconds, () => {
    setIsTimerExpired(true);
  });

  useEffect(() => {
    if (!user || !activeBookingDraft?.visit?.arrivalTimeSlot) return;

    const fetchIntent = async () => {
      const { data, error } = await supabase
        .from("booking_intents")
        .select("expires_at")
        .eq("user_id", user.id)
        .gt("expires_at", new Date().toISOString())
        .order("created_at", { ascending: false })
        .limit(1)
        .maybeSingle();

      if (data?.expires_at) {
        const expiresTime = new Date(data.expires_at).getTime();
        const nowTime = new Date().getTime();
        const diffSeconds = Math.max(0, Math.floor((expiresTime - nowTime) / 1000));
        setInitialSeconds(diffSeconds);
      } else {
        setIsTimerExpired(true);
      }
    };

    fetchIntent();
  }, [user, activeBookingDraft, router]);

  const [promoCode, setPromoCode] = useState<string | null>(null);
  const [promoDiscount, setPromoDiscount] = useState(0);
  const [isPromoExpanded, setIsPromoExpanded] = useState(false);
  const [promoInput, setPromoInput] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [isServiceDetailsExpanded, setIsServiceDetailsExpanded] = useState(false);
  const [isFeeModalOpen, setIsFeeModalOpen] = useState(false);

  // Stripe Modal state
  const [isStripeModalOpen, setIsStripeModalOpen] = useState(false);
  const [stripeClientSecret, setStripeClientSecret] = useState<string | null>(null);
  const [createdBookingId, setCreatedBookingId] = useState<number | null>(null);

  // Payment Method state
  const [selectedPaymentMethod, setSelectedPaymentMethod] = useState<"apple_pay" | "bank_card">("bank_card");

  useEffect(() => {
    const saved = localStorage.getItem("preferred_payment_method");
    if (saved === "apple_pay" || saved === "bank_card") {
      setSelectedPaymentMethod(saved);
    } else {
      setSelectedPaymentMethod("bank_card");
    }
  }, []);

  // Compute actual time range
  const displayTimeRange = useMemo(() => {
    if (!activeBookingDraft?.visit) return "8:00 - 8:15";
    const { mode, displayTime, arrivalTimeSlot } = activeBookingDraft.visit;
    if (mode === "scheduled" && arrivalTimeSlot && activeBookingDraft.totalDuration) {
      const start = new Date(arrivalTimeSlot);
      const end = new Date(start.getTime() + activeBookingDraft.totalDuration * 60000);
      const formatTime = (d: Date) => {
        let h = d.getHours().toString().padStart(2, '0');
        let m = d.getMinutes().toString().padStart(2, '0');
        return `${h}:${m}`;
      };
      return `${formatTime(start)} - ${formatTime(end)}`;
    }
    return displayTime || "8:00 - 8:15";
  }, [activeBookingDraft]);

  useEffect(() => {
    if (!activeBookingDraft && !createdBookingId) {
      router.replace("/");
    }
  }, [activeBookingDraft, createdBookingId, router]);

  if (isTimerExpired) {
    return (
      <div className="w-full max-w-md mx-auto h-screen bg-[#F1F4F8] flex flex-col items-center justify-center px-6 text-center">
        <div className="bg-white p-6 rounded-[28px] shadow-lg flex flex-col items-center space-y-6 w-full">
          <div className="h-16 w-16 bg-[#7B82F4]/10 rounded-full flex items-center justify-center">
            <AlertCircle className="h-8 w-8 text-[#7B82F4]" />
          </div>
          
          <div className="space-y-2">
            <h3 className="font-outfit text-xl font-extrabold text-zinc-900">
              Slot Reservation Expired
            </h3>
            <p className="font-sans text-sm font-semibold text-zinc-500 leading-relaxed">
              The reservation time for the selected slot has expired. Please select a new time for your order.
            </p>
          </div>

          <button
            onClick={() => router.push("/datetime")}
            className="w-full h-[50px] rounded-xl bg-[#7B82F4] text-white font-sans text-base font-semibold hover:bg-[#6c73e0] transition-colors active:scale-[0.98]"
          >
            Select New Time
          </button>
        </div>
      </div>
    );
  }

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
    try {
      // 1. Secure the booking slot in Supabase
      const { error: rpcError } = await supabase.rpc("secure_booking_slot", {
        p_house_id: selectedAddress!.id,
        p_duration_min: activeBookingDraft.totalDuration,
        p_mode_slug: activeBookingDraft.visit?.mode,
        p_target_start: activeBookingDraft.visit?.arrivalTimeSlot,
      });

      if (rpcError) {
        throw new Error(rpcError.message);
      }

      // 2. Create order — prices are calculated SERVER-SIDE (SECURITY DEFINER)
      //    We NEVER send prices from the frontend to prevent price manipulation.
      const addonIds = (activeBookingDraft.selectedAddons || []).map((a) => a.id);

      const { data: orderId, error: orderError } = await supabase.rpc("client_create_order", {
        p_house_id: selectedAddress.id,
        p_service_id: activeBookingDraft.serviceId,
        p_addon_ids: addonIds,
        p_arrival_mode_slug: activeBookingDraft.visit?.mode ?? "standard",
        p_scheduled_start_at: activeBookingDraft.visit?.arrivalTimeSlot,
        p_promo_code: promoCode || null,
      });

      if (orderError) {
        throw new Error(orderError.message);
      }

      // 4. Update draft with booking ID
      const updatedDraft = { ...activeBookingDraft, bookingId: orderId, status: "pending_payment" };
      setActiveDraft(updatedDraft);
      setCreatedBookingId(orderId);

      // 5. Initialize Stripe — server reads price from DB using our JWT
      //    We send ONLY orderId. Amount comes entirely from the database.
      const { data: { session } } = await supabase.auth.getSession();
      const res = await fetch("/api/process-payment", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${session?.access_token}`,
        },
        body: JSON.stringify({
          orderId,
          currency: "cad",
        }),
      });

      if (!res.ok) {
        const errBody = await res.json().catch(() => ({}));
        throw new Error(errBody.error || "Failed to initialize payment");
      }

      const { clientSecret } = await res.json();
      setStripeClientSecret(clientSecret);
      setIsStripeModalOpen(true);

    } catch (err: any) {
      setError(err?.message || "Booking failed. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-white pb-[140px] relative flex flex-col border-x border-zinc-100 shadow-md font-sans animate-page-fade-in">
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
                {selectedPaymentMethod === "apple_pay" ? (
                  <span className="font-sans font-extrabold text-[12px] bg-black text-white px-1.5 py-0.5 rounded-[4px]"> Pay</span>
                ) : (
                  <CreditCard className="h-5 w-5 text-zinc-700" />
                )}
              </div>
              <span className="font-sans text-[16px] font-normal text-zinc-900">
                {selectedPaymentMethod === "apple_pay" ? "Apple Pay" : "Bank Card"}
              </span>
            </div>
            <button
              onClick={() => router.push("/profile/payments?fromCheckout=true")}
              className="text-[16px] font-normal text-[#7B82F4] hover:opacity-80 transition-opacity"
            >
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
            className={`flex flex-col transition-colors ${isServiceDetailsExpanded ? "bg-[#F8F9FA] -mx-5 px-5 py-[20px]" : "!mt-[20px] !mb-[20px]"}`}
          >
            <div 
              className="flex items-center justify-between cursor-pointer hover:opacity-80 transition-opacity"
              onClick={() => setIsServiceDetailsExpanded(!isServiceDetailsExpanded)}
            >
              <div className="flex items-center gap-3">
                {(!isServiceDetailsExpanded && activeBookingDraft.serviceImageUrl) ? (
                  <img
                    src={activeBookingDraft.serviceImageUrl}
                    alt={activeBookingDraft.serviceName}
                    className="h-10 w-10 rounded-lg object-cover"
                  />
                ) : (!isServiceDetailsExpanded ? (
                  <div className="h-10 w-10 rounded-lg bg-zinc-100 flex items-center justify-center">
                    <BadgeCheck className="h-5 w-5 text-zinc-400" />
                  </div>
                ) : null)}
                <div className="flex flex-col">
                  <span className={`font-sans ${isServiceDetailsExpanded ? "text-[15px] font-semibold" : "text-[16px] font-medium"} text-zinc-900`}>
                    {activeBookingDraft.serviceName}
                  </span>
                  <span className={`font-sans ${isServiceDetailsExpanded ? "text-[13px]" : "text-[14px]"} font-normal text-[#57636C]`}>
                    1 position
                  </span>
                </div>
              </div>
              <ChevronRight className={`h-5 w-5 text-zinc-400 transition-transform ${isServiceDetailsExpanded ? "rotate-90" : ""}`} />
            </div>

            {isServiceDetailsExpanded && (
              <div className="flex flex-col mt-4">
                <div className="w-full h-px bg-zinc-200/60 mb-4" />
                
                <div className="flex">
                  <div className="flex-1 flex flex-col">
                    <span className="font-sans text-[12px] text-zinc-500 mb-1">Date</span>
                    <span className="font-sans text-[13px] font-medium text-zinc-900">
                      {activeBookingDraft.visit?.arrivalDateDisplay || "Today"}
                    </span>
                  </div>
                  <div className="flex-1 flex flex-col">
                    <span className="font-sans text-[12px] text-zinc-500 mb-1">Arrival time</span>
                    <span className="font-sans text-[13px] font-medium text-zinc-900">
                      {displayTimeRange}
                    </span>
                  </div>
                </div>

                <div className="w-full h-px bg-zinc-200/60 my-4" />

                <div className="flex flex-col">
                  <span className="font-sans text-[12px] text-zinc-500 mb-1.5">You selected</span>
                  <span className="font-sans text-[13px] font-medium text-zinc-900 mb-[2px]">
                    {activeBookingDraft.serviceName}
                  </span>
                  {activeBookingDraft.selectedAddons?.map((addon, idx) => (
                    <span key={idx} className="font-sans text-[13px] text-zinc-500">
                      + {addon.name} x{addon.qty}
                    </span>
                  ))}
                </div>

                <div className="w-full h-px bg-zinc-200/60 my-4" />

                <div className="flex flex-col">
                  <span className="font-sans text-[12px] text-zinc-500 mb-1.5">Location</span>
                  <span className="font-sans text-[13px] font-medium text-zinc-900">
                    {selectedAddress?.nameLabel || "Home"}
                  </span>
                  <span className="font-sans text-[13px] text-zinc-900 mt-0.5 leading-[1.4]">
                    {selectedAddress?.fullAddress || "1 Bloor St E, Toronto, ON M4W 1A8, Canada"}
                  </span>
                </div>
              </div>
            )}
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
                <button 
                  type="button" 
                  className="p-1 -m-1 hover:opacity-80 transition-opacity"
                  onClick={() => setIsFeeModalOpen(true)}
                >
                  <Info className="h-3.5 w-3.5 text-zinc-400" />
                </button>
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
          <p className="font-sans text-[14px] font-normal leading-relaxed text-zinc-900 !mt-[10px]">
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

      {/* ── Fee Modal ── */}
      {isFeeModalOpen && (
        <div className="fixed inset-0 z-50 flex items-end justify-center sm:items-center">
          {/* Backdrop */}
          <div 
            className="absolute inset-0 bg-black/40 transition-opacity" 
            onClick={() => setIsFeeModalOpen(false)}
          />
          {/* Modal */}
          <div className="relative w-full max-w-md bg-white rounded-t-[10px] sm:rounded-[10px] flex flex-col transform transition-transform duration-300">
            <div className="pt-[24px] px-5 pb-5 flex justify-center">
              <h3 className="font-outfit text-[18px] font-semibold text-zinc-900">
                How's this fee calculated?
              </h3>
            </div>
            
            <div className="w-full h-px bg-zinc-100" />

            <div className="pt-[20px] px-5 pb-5">
              <p className="font-sans text-[14.5px] font-normal leading-[1.6] text-zinc-800 mb-[34px]">
                Your total is based on the size of your home, the services you select, and any extras you add. No hidden fees — you always see the final price before booking.
              </p>

              <button 
                onClick={() => setIsFeeModalOpen(false)}
                className="w-full h-[50px] bg-[#14181B] text-white rounded-[10px] font-semibold text-[16px] hover:bg-zinc-800 transition-colors mb-[40px]"
              >
                Agree and close
              </button>
            </div>
          </div>
        </div>
      )}

      <StripePaymentModal
        isOpen={isStripeModalOpen}
        onClose={() => setIsStripeModalOpen(false)}
        clientSecret={stripeClientSecret || ""}
        bookingId={Number(activeBookingDraft?.bookingId || createdBookingId || 0)}
        onSuccess={() => {
          // Capture bookingId before any state resets
          const targetId = activeBookingDraft?.bookingId || createdBookingId;
          const updatedCart = cart.filter((item) => item.serviceId !== activeBookingDraft?.serviceId);
          updateCart(updatedCart);
          setActiveDraft(null);
          if (targetId) {
            router.push(`/searching?bookingId=${targetId}&fromPayment=true`);
          } else {
            router.push("/orders");
          }
        }}
      />
    </div>
  );
}
