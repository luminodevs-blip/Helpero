"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import {
  ArrowLeft,
  MapPin,
  Clock,
  Tag,
  ChevronRight,
  BadgeCheck,
  AlertCircle,
  Loader2,
  CreditCard,
  Smartphone,
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

// ─── Promo code section ───────────────────────────────────────────────
function PromoCodeSection({
  onApply,
  appliedCode,
  discountAmount,
}: {
  onApply: (code: string) => void;
  appliedCode: string | null;
  discountAmount: number;
}) {
  const [code, setCode] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!code.trim()) return;
    setLoading(true);
    await onApply(code.trim().toUpperCase());
    setLoading(false);
  };

  return (
    <div className="bg-bg-primary rounded-2xl border border-alternate p-4">
      <div className="flex items-center gap-2 mb-3">
        <Tag className="h-4 w-4 text-primary" />
        <span className="text-sm font-bold text-text-primary">Promo code</span>
      </div>

      {appliedCode ? (
        <div className="flex items-center justify-between bg-primary/10 rounded-xl px-4 py-2.5 border border-primary/30">
          <div className="flex items-center gap-2">
            <BadgeCheck className="h-4 w-4 text-primary" />
            <span className="text-sm font-bold text-primary">{appliedCode}</span>
          </div>
          <span className="text-sm font-extrabold text-primary">
            -${discountAmount.toFixed(2)}
          </span>
        </div>
      ) : (
        <form onSubmit={handleSubmit} className="flex gap-2">
          <input
            type="text"
            value={code}
            onChange={(e) => setCode(e.target.value.toUpperCase())}
            placeholder="Enter code"
            maxLength={20}
            className="flex-1 border border-alternate bg-bg-secondary rounded-xl px-4 py-3 text-sm text-text-primary placeholder-text-secondary focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none uppercase tracking-widest font-semibold"
          />
          <button
            type="submit"
            disabled={loading || !code.trim()}
            className="px-5 rounded-xl bg-primary text-white text-sm font-bold disabled:opacity-40 hover:bg-primary/90 transition-colors flex items-center justify-center"
          >
            {loading ? <Loader2 className="h-4 w-4 animate-spin" /> : "Apply"}
          </button>
        </form>
      )}
    </div>
  );
}

export default function CheckoutPage() {
  const router = useRouter();
  const { activeBookingDraft, selectedAddress, user, cart, updateCart, setActiveDraft } = useClientAuth();

  const { formatted: countdownTime, expired: slotExpired } = useCountdown(600); // 10 min

  const [promoCode, setPromoCode] = useState<string | null>(null);
  const [promoDiscount, setPromoDiscount] = useState(0);
  const [paymentMethod, setPaymentMethod] = useState<"card" | "apple_pay" | "google_pay">("card");
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

  const handleApplyPromo = async (code: string) => {
    setError(null);
    try {
      const { data, error: promoError } = await supabase
        .from("promo_codes")
        .select("*")
        .eq("code", code)
        .eq("is_active", true)
        .maybeSingle();

      if (promoError || !data) {
        setError("Invalid or expired promo code");
        return;
      }

      setPromoCode(data.code);
      setPromoDiscount(
        data.discount_type === "percentage"
          ? (subtotal * data.discount_value) / 100
          : data.discount_value
      );
    } catch {
      setError("Failed to validate promo code");
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
    <div className="w-full max-w-md mx-auto min-h-screen bg-bg-secondary pb-32 relative flex flex-col border-x border-alternate shadow-md">
      {/* Header */}
      <div className="bg-bg-secondary px-5 pt-6 pb-4 border-b border-alternate sticky top-0 z-30">
        <div className="flex items-center justify-between">
          <button
            onClick={() => router.back()}
            className="p-1 rounded-full hover:bg-bg-primary text-text-primary"
          >
            <ArrowLeft className="h-5 w-5" />
          </button>

          <div className="flex flex-col items-center">
            <span className="text-[10px] font-bold text-primary uppercase tracking-widest">
              Step 3 of 3
            </span>
            <span className="text-sm font-bold text-text-primary mt-0.5">
              Review & Pay
            </span>
          </div>

          {/* Countdown timer */}
          <div
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-extrabold ${
              parseInt(countdownTime) < 2
                ? "bg-error/10 text-error"
                : "bg-primary/10 text-primary"
            }`}
          >
            <Clock className="h-3 w-3" />
            {countdownTime}
          </div>
        </div>

        {/* Progress bar */}
        <div className="w-full bg-alternate h-1 rounded-full mt-4 overflow-hidden">
          <div className="bg-primary h-full rounded-full" style={{ width: "100%" }} />
        </div>
      </div>

      {/* Main scrollable body */}
      <div className="flex-1 overflow-y-auto px-5 py-6 space-y-5">
        
        {/* ── Slot expired warning ── */}
        {slotExpired && (
          <div className="rounded-2xl bg-error/10 border border-error/20 p-4 flex items-start gap-3">
            <AlertCircle className="h-5 w-5 text-error mt-0.5 flex-shrink-0" />
            <div>
              <p className="text-sm font-bold text-error">Time slot expired</p>
              <p className="text-xs text-text-secondary mt-0.5">
                Your reserved slot has expired. Please go back and select a new time.
              </p>
            </div>
          </div>
        )}

        {/* ── Error ── */}
        {error && (
          <div className="rounded-2xl bg-error/10 border border-error/20 p-4 text-sm text-error font-semibold">
            {error}
          </div>
        )}

        {/* ── Service card ── */}
        <div className="bg-bg-primary rounded-2xl border border-alternate p-4 space-y-3">
          <div className="flex items-start gap-3">
            {activeBookingDraft.serviceImageUrl ? (
              <img
                src={activeBookingDraft.serviceImageUrl}
                alt={activeBookingDraft.serviceName}
                className="h-14 w-14 rounded-xl object-cover border border-alternate"
              />
            ) : (
              <div className="h-14 w-14 rounded-xl bg-primary/10 border border-alternate flex items-center justify-center">
                <BadgeCheck className="h-6 w-6 text-primary/50" />
              </div>
            )}
            <div className="flex-1">
              <p className="font-outfit text-sm font-extrabold text-text-primary">
                {activeBookingDraft.serviceName}
              </p>
              <p className="text-xs text-text-secondary mt-0.5">
                {activeBookingDraft.totalDuration} min
              </p>
            </div>
            <p className="text-sm font-extrabold text-primary font-outfit">
              ${basePrice.toFixed(2)}
            </p>
          </div>

          {/* Addons list */}
          {(activeBookingDraft.selectedAddons || []).length > 0 && (
            <div className="border-t border-alternate pt-3 space-y-2">
              {activeBookingDraft.selectedAddons.map((addon) => (
                <div key={addon.id} className="flex items-center justify-between">
                  <span className="text-xs text-text-secondary">
                    {addon.name} × {addon.qty}
                  </span>
                  <span className="text-xs font-bold text-text-primary">
                    +${addon.totalPrice.toFixed(2)}
                  </span>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* ── Arrival info ── */}
        {activeBookingDraft.visit && (
          <div className="bg-bg-primary rounded-2xl border border-alternate p-4">
            <div className="flex items-center gap-2 mb-3">
              <Clock className="h-4 w-4 text-primary" />
              <span className="text-sm font-bold text-text-primary">Arrival time</span>
            </div>
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-extrabold text-text-primary">
                  {activeBookingDraft.visit.arrivalDateDisplay}
                </p>
                <p className="text-xs text-text-secondary mt-0.5">
                  {activeBookingDraft.visit.displayTime}
                </p>
              </div>
              <div className="px-3 py-1.5 rounded-full bg-primary/10 text-primary text-xs font-bold capitalize">
                {activeBookingDraft.visit.mode}
              </div>
            </div>
            {visitFee > 0 && (
              <div className="flex items-center justify-between mt-3 border-t border-alternate pt-3">
                <span className="text-xs text-text-secondary">
                  {activeBookingDraft.visit.mode} fee
                </span>
                <span className="text-xs font-bold text-text-primary">
                  +${visitFee.toFixed(2)}
                </span>
              </div>
            )}
          </div>
        )}

        {/* ── Address ── */}
        {selectedAddress && (
          <div className="bg-bg-primary rounded-2xl border border-alternate p-4">
            <div className="flex items-start gap-3">
              <MapPin className="h-4 w-4 text-primary mt-0.5 flex-shrink-0" />
              <div>
                <p className="text-sm font-bold text-text-primary">
                  {selectedAddress.nameLabel}
                </p>
                <p className="text-xs text-text-secondary mt-0.5 leading-relaxed">
                  {selectedAddress.fullAddress}
                </p>
              </div>
            </div>
          </div>
        )}

        {/* ── Promo Code ── */}
        <PromoCodeSection
          onApply={handleApplyPromo}
          appliedCode={promoCode}
          discountAmount={promoDiscount}
        />

        {/* ── Payment Method ── */}
        <div className="bg-bg-primary rounded-2xl border border-alternate p-4">
          <div className="flex items-center gap-2 mb-3">
            <CreditCard className="h-4 w-4 text-primary" />
            <span className="text-sm font-bold text-text-primary">Payment method</span>
          </div>
          <div className="grid grid-cols-3 gap-2">
            {(["card", "apple_pay", "google_pay"] as const).map((method) => {
              const isActive = paymentMethod === method;
              return (
                <button
                  key={method}
                  type="button"
                  onClick={() => setPaymentMethod(method)}
                  className={`flex flex-col items-center justify-center gap-1.5 px-2 py-3 rounded-xl border-2 transition-all text-[10px] font-extrabold uppercase tracking-wider ${
                    isActive
                      ? "border-primary bg-primary/10 text-primary"
                      : "border-alternate bg-bg-secondary text-text-secondary hover:border-primary/30"
                  }`}
                >
                  {method === "card" && <CreditCard className="h-5 w-5" />}
                  {method === "apple_pay" && (
                    <svg className="h-5 w-5 fill-current" viewBox="0 0 24 24">
                      <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M15.97 4.17c.66-.81 1.11-1.93.99-3.06-1 .04-2.2.67-2.92 1.51-.62.73-1.16 1.87-1.01 2.98 1.11.08 2.25-.59 2.94-1.43z" />
                    </svg>
                  )}
                  {method === "google_pay" && <Smartphone className="h-5 w-5" />}
                  <span>{method === "card" ? "Card" : method === "apple_pay" ? "Apple Pay" : "Google Pay"}</span>
                </button>
              );
            })}
          </div>
        </div>

        {/* ── Price Breakdown ── */}
        <div className="bg-bg-primary rounded-2xl border border-alternate p-4 space-y-2.5">
          <h4 className="font-outfit text-sm font-extrabold text-text-primary mb-3">
            Price breakdown
          </h4>
          <div className="flex justify-between text-xs text-text-secondary">
            <span>Service</span>
            <span className="font-bold text-text-primary">${basePrice.toFixed(2)}</span>
          </div>
          {addonsTotal > 0 && (
            <div className="flex justify-between text-xs text-text-secondary">
              <span>Add-ons</span>
              <span className="font-bold text-text-primary">+${addonsTotal.toFixed(2)}</span>
            </div>
          )}
          {visitFee > 0 && (
            <div className="flex justify-between text-xs text-text-secondary">
              <span>{activeBookingDraft.visit?.mode} fee</span>
              <span className="font-bold text-text-primary">+${visitFee.toFixed(2)}</span>
            </div>
          )}
          <div className="flex justify-between text-xs text-text-secondary">
            <span>HST (13%)</span>
            <span className="font-bold text-text-primary">+${taxAmount.toFixed(2)}</span>
          </div>
          {promoDiscount > 0 && (
            <div className="flex justify-between text-xs text-green-500">
              <span>Promo ({promoCode})</span>
              <span className="font-bold">-${promoDiscount.toFixed(2)}</span>
            </div>
          )}
          <div className="border-t border-alternate pt-2.5 flex justify-between text-text-primary font-extrabold">
            <span>Total</span>
            <span className="text-primary text-base font-outfit">${grandTotal.toFixed(2)}</span>
          </div>
        </div>

        {/* Terms note */}
        <p className="text-[10px] text-text-secondary text-center leading-relaxed px-4">
          By completing your order you agree to our{" "}
          <a href="https://helpero.ca/terms" className="text-primary underline">
            Terms of Service
          </a>
          . A specialist will be assigned automatically after payment.
        </p>
      </div>

      {/* ── Sticky Bottom CTA ── */}
      <div className="fixed bottom-0 left-0 right-0 z-40 bg-bg-secondary border-t border-alternate py-4 px-6 flex items-center justify-between max-w-md mx-auto">
        <div className="flex flex-col">
          <span className="text-[10px] text-text-secondary font-semibold uppercase tracking-wide">
            Total due
          </span>
          <span className="font-outfit text-xl font-extrabold text-primary">
            ${grandTotal.toFixed(2)}
          </span>
        </div>

        <button
          onClick={handleBookNow}
          disabled={loading || slotExpired}
          className="px-8 h-14 rounded-full bg-primary text-white font-sans text-sm font-bold hover:bg-primary/95 focus:outline-none disabled:opacity-50 disabled:cursor-not-allowed transition-all active:scale-95 shadow-md flex items-center justify-center gap-2"
        >
          {loading ? (
            <Loader2 className="h-5 w-5 animate-spin" />
          ) : (
            <>
              Book Now
              <ChevronRight className="h-4 w-4" />
            </>
          )}
        </button>
      </div>
    </div>
  );
}
