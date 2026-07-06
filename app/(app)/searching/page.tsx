"use client";

import React, { useState, useEffect, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import {
  MapPin,
  Clock,
  User,
  Star,
  Phone,
  ShieldCheck,
  X,
  Loader2,
  CheckCircle2,
  AlertCircle,
  MessageSquare,
  Home,
} from "lucide-react";

interface Specialist {
  id: string;
  first_name: string;
  last_name: string;
  avatar_url: string | null;
  rating: number;
  phone_number: string;
}

interface OrderDetails {
  id: number;
  status: string;
  final_total_price: number;
  scheduled_start_at: string;
  service_name?: string;
  service_duration?: number;
  house: {
    full_address: string;
    lat: number;
    lng: number;
    name_label: string;
  } | null;
  specialist: Specialist | null;
}

// Animated progress bar
function ProgressBar() {
  return (
    <div className="w-full h-[5px] bg-zinc-100 rounded-full overflow-hidden">
      <div
        className="h-full bg-[#7B82F4] rounded-full animate-progress-slide"
        style={{ width: "40%" }}
      />
    </div>
  );
}

function SearchingContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const bookingId = searchParams.get("bookingId");
  const { user } = useClientAuth();

  const [order, setOrder] = useState<OrderDetails | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [cancelling, setCancelling] = useState(false);
  const fromPayment = searchParams.get("fromPayment") === "true";
  // Phase: "securing" → (auto) → "map"
  const [phase, setPhase] = useState<"securing" | "map">(fromPayment ? "securing" : "map");

  useEffect(() => {
    if (!bookingId) { router.replace("/"); return; }

    const fetchOrder = async () => {
      try {
        setLoading(true);
        const { data, error: fetchErr } = await supabase
          .from("orders")
          .select(`
            id, status, final_total_price, scheduled_start_at,
            house:houses ( full_address, lat, lng, name_label ),
            specialist:profiles!specialist_id ( id, first_name, last_name, avatar_url, phone_number )
          `)
          .eq("id", bookingId)
          .single();

        if (fetchErr) throw fetchErr;
        const raw = data as any;
        setOrder({
          id: raw.id,
          status: raw.status || "searching",
          final_total_price: raw.final_total_price || 0,
          scheduled_start_at: raw.scheduled_start_at || "",
          house: raw.house ? {
            full_address: raw.house.full_address,
            lat: Number(raw.house.lat),
            lng: Number(raw.house.lng),
            name_label: raw.house.name_label,
          } : null,
          specialist: raw.specialist ? {
            id: raw.specialist.id,
            first_name: raw.specialist.first_name,
            last_name: raw.specialist.last_name,
            avatar_url: raw.specialist.avatar_url,
            rating: raw.specialist.rating || 4.9,
            phone_number: raw.specialist.phone_number || "",
          } : null,
        });
      } catch (err: any) {
        setError(err.message || "Failed to load order");
      } finally {
        setLoading(false);
      }
    };

    fetchOrder();

    // After 3s on "securing" screen, transition to map
    let timer: NodeJS.Timeout;
    if (fromPayment) {
      timer = setTimeout(() => setPhase("map"), 3000);
    }

    // Real-time listener
    const channel = supabase
      .channel(`order-status-${bookingId}`)
      .on("postgres_changes", {
        event: "UPDATE", schema: "public", table: "orders",
        filter: `id=eq.${bookingId}`,
      }, async () => {
        const { data } = await supabase
          .from("orders")
          .select(`
            id, status, final_total_price, scheduled_start_at,
            house:houses ( full_address, lat, lng, name_label ),
            specialist:profiles!specialist_id ( id, first_name, last_name, avatar_url, phone_number )
          `)
          .eq("id", bookingId).single();
        if (data) {
          const raw = data as any;
          setOrder({
            id: raw.id,
            status: raw.status || "searching",
            final_total_price: raw.final_total_price || 0,
            scheduled_start_at: raw.scheduled_start_at || "",
            house: raw.house ? { full_address: raw.house.full_address, lat: Number(raw.house.lat), lng: Number(raw.house.lng), name_label: raw.house.name_label } : null,
            specialist: raw.specialist ? { id: raw.specialist.id, first_name: raw.specialist.first_name, last_name: raw.specialist.last_name, avatar_url: raw.specialist.avatar_url, rating: raw.specialist.rating || 4.9, phone_number: raw.specialist.phone_number || "" } : null,
          });
        }
      })
      .subscribe();

    return () => {
      if (timer) clearTimeout(timer);
      supabase.removeChannel(channel);
    };
  }, [bookingId, router, fromPayment]);

  const handleCancelOrder = async () => {
    if (!bookingId || cancelling) return;
    setCancelling(true);
    try {
      const { error: cancelErr } = await supabase
        .from("orders").update({ status: "cancelled" }).eq("id", bookingId);
      if (cancelErr) throw cancelErr;
      setOrder((prev) => prev ? { ...prev, status: "cancelled" } : null);
    } catch (err: any) {
      alert(err.message || "Failed to cancel order");
    } finally {
      setCancelling(false);
    }
  };

  // ── Loading ──
  if (loading) {
    return (
      <div className="w-full max-w-md mx-auto h-screen bg-[#7B82F4] flex flex-col items-center justify-center text-white px-8 text-center">
        <Loader2 className="h-10 w-10 animate-spin text-white mb-4" />
        <p className="text-lg font-bold font-outfit">Loading...</p>
      </div>
    );
  }

  // ── Error ──
  if (error || !order) {
    return (
      <div className="w-full max-w-md mx-auto h-screen bg-[#F1F4F8] flex flex-col items-center justify-center px-8 text-center">
        <AlertCircle className="h-12 w-12 text-red-500 mb-4" />
        <p className="text-lg font-bold text-zinc-900 font-outfit">Something went wrong</p>
        <p className="text-xs text-zinc-500 mt-1">{error || "Order not found"}</p>
        <button onClick={() => router.push("/")} className="mt-6 px-6 py-3 bg-[#7B82F4] text-white font-bold text-xs rounded-xl">
          Back to Home
        </button>
      </div>
    );
  }

  // ── Phase 1: Securing your booking (purple loading screen) ──
  if (phase === "securing") {
    return (
      <div className="w-full max-w-md mx-auto h-screen bg-[#7B82F4] flex flex-col items-center justify-center text-white px-8 text-center animate-in fade-in duration-300">
        <div className="relative h-28 w-28 flex items-center justify-center mb-8">
          <div className="absolute inset-0 bg-white/10 rounded-full animate-ping" />
          <div className="absolute h-20 w-20 bg-white/10 rounded-full animate-ping" style={{ animationDelay: "0.5s" }} />
          <div className="relative h-16 w-16 rounded-full bg-white/20 border-2 border-white/50 flex items-center justify-center">
            <Loader2 className="h-8 w-8 animate-spin text-white" />
          </div>
        </div>
        <h3 className="font-outfit text-[22px] font-bold leading-tight">Securing your booking...</h3>
        <p className="text-[13px] text-white/70 mt-2 px-4 leading-relaxed">
          Checking payment status with your bank.
        </p>
      </div>
    );
  }

  // ── Cancelled ──
  if (order.status === "cancelled") {
    return (
      <div className="w-full max-w-md mx-auto h-screen bg-[#F1F4F8] flex flex-col items-center justify-center px-8 text-center">
        <div className="h-20 w-20 bg-red-100 rounded-full flex items-center justify-center text-red-500 mb-6">
          <X className="h-10 w-10" />
        </div>
        <h3 className="font-outfit text-2xl font-bold text-zinc-900">Order Cancelled</h3>
        <p className="text-sm text-zinc-500 mt-2 px-6">
          This order has been cancelled. Your authorization hold has been released.
        </p>
        <button onClick={() => router.push("/")} className="mt-8 w-full max-w-[240px] h-12 rounded-xl bg-[#7B82F4] text-white font-bold text-sm shadow-md">
          Back to Home
        </button>
      </div>
    );
  }

  // ── Phase 2: Map + "Finding your specialist" ──
  const lat = order.house?.lat || 43.6532;
  const lng = order.house?.lng || -79.3832;
  const staticMapUrl = `https://maps.googleapis.com/maps/api/staticmap?center=${lat},${lng}&zoom=14&size=450x800&scale=2&style=element:geometry%7Ccolor:0xe8e8e8&style=element:labels%7Cvisibility:off&key=${process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY || ""}`;

  return (
    <div className="w-full max-w-md mx-auto h-screen relative overflow-hidden flex flex-col border-x border-zinc-100 shadow-md bg-[#F1F4F8]">

      {/* ── Map background ── */}
      <div className="absolute inset-0 z-0">
        <div
          className="w-full h-full bg-cover bg-center"
          style={{ backgroundImage: `url(${staticMapUrl})`, backgroundColor: "#d4d4d8" }}
        />
      </div>

      {/* ── Pulsing house marker (center) ── */}
      <div className="absolute inset-0 flex items-center justify-center pointer-events-none z-10" style={{ bottom: "280px", top: "unset", position: "absolute", left: "50%", top: "38%", transform: "translate(-50%, -50%)" }}>
        <div className="relative flex items-center justify-center">
          {/* Outer pulse rings */}
          <div className="absolute h-[120px] w-[120px] rounded-full bg-[#7B82F4]/20 animate-ping" />
          <div className="absolute h-[80px] w-[80px] rounded-full bg-[#7B82F4]/30 animate-ping" style={{ animationDelay: "0.7s" }} />
          {/* House icon circle */}
          <div className="relative h-[52px] w-[52px] rounded-full bg-[#7B82F4] flex items-center justify-center shadow-xl border-4 border-white/30 z-10">
            <Home className="h-6 w-6 text-white" />
          </div>
          {/* Pin stem */}
          <div className="absolute -bottom-[28px] left-1/2 -translate-x-1/2 z-10">
            <div className="w-[14px] h-[14px] rounded-full bg-zinc-900 border-2 border-white shadow" />
          </div>
        </div>
      </div>

      {/* ── Bottom sheet ── */}
      <div className="absolute bottom-0 left-0 right-0 z-20 p-4">
        <div className="bg-white rounded-[24px] p-5 shadow-2xl space-y-4">

          {/* Header */}
          <div>
            <h3 className="font-outfit text-[20px] font-extrabold text-zinc-900">
              {order.status === "assigned" && order.specialist
                ? "Specialist Found! 🎉"
                : "Finding your specialist"}
            </h3>
            <p className="text-[13px] text-zinc-500 mt-0.5">
              {order.status === "assigned" && order.specialist
                ? `${order.specialist.first_name} is on the way to you.`
                : "Matching you with the highest rated pro in Toronto."}
            </p>
          </div>

          {/* Progress bar (only while searching) */}
          {order.status !== "assigned" && <ProgressBar />}

          {/* Specialist row (when assigned) */}
          {order.status === "assigned" && order.specialist && (
            <div className="flex items-center gap-3 pt-1">
              {order.specialist.avatar_url ? (
                <img src={order.specialist.avatar_url} alt="" className="h-12 w-12 rounded-2xl object-cover border border-zinc-100" />
              ) : (
                <div className="h-12 w-12 rounded-2xl bg-[#7B82F4]/10 flex items-center justify-center">
                  <User className="h-5 w-5 text-[#7B82F4]" />
                </div>
              )}
              <div className="flex-1">
                <p className="font-outfit font-bold text-zinc-900 text-[15px]">
                  {order.specialist.first_name} {order.specialist.last_name}
                </p>
                <div className="flex items-center gap-1.5 mt-0.5">
                  <Star className="h-3.5 w-3.5 fill-amber-400 text-amber-400" />
                  <span className="text-xs font-bold text-zinc-700">{order.specialist.rating.toFixed(1)}</span>
                  <ShieldCheck className="h-3.5 w-3.5 text-emerald-500 ml-1" />
                  <span className="text-[11px] text-emerald-600 font-semibold">Verified</span>
                </div>
              </div>
              <a href={`tel:${order.specialist.phone_number}`}
                className="h-10 w-10 rounded-xl bg-[#F1F4F8] flex items-center justify-center">
                <Phone className="h-4 w-4 text-zinc-700" />
              </a>
            </div>
          )}

          {/* Divider */}
          <div className="h-px bg-zinc-100" />

          {/* Service row */}
          <div className="flex items-center gap-3">
            <div className="h-11 w-11 rounded-xl bg-[#F1F4F8] flex items-center justify-center text-xl">
              🧹
            </div>
            <div className="flex-1">
              <p className="font-outfit font-bold text-zinc-900 text-[14px]">Standard Cleaning</p>
              <p className="text-[12px] text-zinc-400">3 hours 45 minutes</p>
            </div>
            <p className="font-outfit font-extrabold text-zinc-900 text-[15px]">
              ${Number(order.final_total_price).toFixed(2)}
            </p>
          </div>

          {/* Cancel button */}
          {order.status !== "assigned" && (
            <button
              onClick={handleCancelOrder}
              disabled={cancelling}
              className="w-full h-12 border border-zinc-200 rounded-xl text-zinc-500 font-semibold text-[13px] flex items-center justify-center gap-2 hover:bg-zinc-50 transition-all"
            >
              {cancelling ? <Loader2 className="h-4 w-4 animate-spin" /> : "Cancel order"}
            </button>
          )}
        </div>
      </div>
    </div>
  );
}

export default function SearchingPage() {
  return (
    <Suspense fallback={
      <div className="w-full max-w-md mx-auto h-screen bg-[#7B82F4] flex items-center justify-center">
        <Loader2 className="h-10 w-10 animate-spin text-white" />
      </div>
    }>
      <SearchingContent />
    </Suspense>
  );
}
