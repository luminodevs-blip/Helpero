"use client";

import React, { useState, useEffect } from "react";
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
  house: {
    full_address: string;
    lat: number;
    lng: number;
    name_label: string;
  } | null;
  specialist: Specialist | null;
}

export default function SearchingPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const bookingId = searchParams.get("bookingId");
  const { user } = useClientAuth();

  const [order, setOrder] = useState<OrderDetails | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [cancelling, setCancelling] = useState(false);

  // Fetch initial order details
  useEffect(() => {
    if (!bookingId) {
      router.replace("/");
      return;
    }

    const fetchOrder = async () => {
      try {
        setLoading(true);
        setError(null);

        const { data, error: fetchErr } = await supabase
          .from("orders")
          .select(`
            id,
            status,
            final_total_price,
            scheduled_start_at,
            house:houses (
              full_address,
              lat,
              lng,
              name_label
            ),
            specialist:profiles (
              id,
              first_name,
              last_name,
              avatar_url,
              rating,
              phone_number
            )
          `)
          .eq("id", bookingId)
          .single();

        if (fetchErr) throw fetchErr;

        // Cast nested tables
        const rawOrder = data as any;
        setOrder({
          id: rawOrder.id,
          status: rawOrder.status || "searching",
          final_total_price: rawOrder.final_total_price || 0,
          scheduled_start_at: rawOrder.scheduled_start_at || "",
          house: rawOrder.house ? {
            full_address: rawOrder.house.full_address,
            lat: Number(rawOrder.house.lat),
            lng: Number(rawOrder.house.lng),
            name_label: rawOrder.house.name_label,
          } : null,
          specialist: rawOrder.specialist ? {
            id: rawOrder.specialist.id,
            first_name: rawOrder.specialist.first_name,
            last_name: rawOrder.specialist.last_name,
            avatar_url: rawOrder.specialist.avatar_url,
            rating: rawOrder.specialist.rating || 4.9,
            phone_number: rawOrder.specialist.phone_number || "",
          } : null,
        });
      } catch (err: any) {
        setError(err.message || "Failed to load order");
      } finally {
        setLoading(false);
      }
    };

    fetchOrder();

    // Set up real-time listener for order changes
    const channel = supabase
      .channel(`order-status-${bookingId}`)
      .on(
        "postgres_changes",
        {
          event: "UPDATE",
          schema: "public",
          table: "orders",
          filter: `id=eq.${bookingId}`,
        },
        async (payload) => {
          // Re-fetch full record to get joined specialist profile
          const { data } = await supabase
            .from("orders")
            .select(`
              id,
              status,
              final_total_price,
              scheduled_start_at,
              house:houses (
                full_address,
                lat,
                lng,
                name_label
              ),
              specialist:profiles (
                id,
                first_name,
                last_name,
                avatar_url,
                rating,
                phone_number
              )
            `)
            .eq("id", bookingId)
            .single();

          if (data) {
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
          }
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [bookingId, router]);

  const handleCancelOrder = async () => {
    if (!bookingId || cancelling) return;
    setCancelling(true);
    try {
      const { error: cancelErr } = await supabase
        .from("orders")
        .update({ status: "cancelled" })
        .eq("id", bookingId);

      if (cancelErr) throw cancelErr;

      setOrder((prev) => prev ? { ...prev, status: "cancelled" } : null);
    } catch (err: any) {
      alert(err.message || "Failed to cancel order");
    } finally {
      setCancelling(false);
    }
  };

  if (loading) {
    return (
      <div className="w-full max-w-md mx-auto h-screen bg-[#7B61FF] flex flex-col items-center justify-center text-white px-8">
        <Loader2 className="h-12 w-12 animate-spin text-white mb-4" />
        <p className="text-lg font-bold font-outfit">Loading order details...</p>
      </div>
    );
  }

  if (error || !order) {
    return (
      <div className="w-full max-w-md mx-auto h-screen bg-bg-secondary flex flex-col items-center justify-center px-8 text-center">
        <AlertCircle className="h-12 w-12 text-error mb-4" />
        <p className="text-lg font-bold text-text-primary font-outfit">Something went wrong</p>
        <p className="text-xs text-text-secondary mt-1">{error || "Order not found"}</p>
        <button
          onClick={() => router.push("/")}
          className="mt-6 px-6 py-3 bg-primary text-white font-bold text-xs rounded-xl"
        >
          Back to Home
        </button>
      </div>
    );
  }

  // State 1: pending_payment (Flutter loader.json equivalent)
  if (order.status === "pending_payment") {
    return (
      <div className="w-full max-w-md mx-auto h-screen bg-primary flex flex-col items-center justify-center text-white px-8 text-center animate-fade-in">
        {/* Pulsing Lottie equivalent indicator */}
        <div className="relative h-28 w-28 flex items-center justify-center mb-6">
          <div className="absolute inset-0 bg-white/10 rounded-full animate-ping" />
          <div className="relative h-20 w-20 rounded-full bg-white/20 flex items-center justify-center border-2 border-white/40">
            <Loader2 className="h-10 w-10 animate-spin text-white" />
          </div>
        </div>
        <h3 className="font-outfit text-2xl font-bold">Securing your booking...</h3>
        <p className="text-sm text-white/70 mt-2 px-6">
          Checking payment status with your bank.
        </p>
      </div>
    );
  }

  // State 2: cancelled
  if (order.status === "cancelled") {
    return (
      <div className="w-full max-w-md mx-auto h-screen bg-bg-secondary flex flex-col items-center justify-center px-8 text-center animate-fade-in">
        <div className="h-20 w-20 bg-error/10 border border-error/20 rounded-full flex items-center justify-center text-error mb-6">
          <X className="h-10 w-10" />
        </div>
        <h3 className="font-outfit text-2xl font-bold text-text-primary">Order Cancelled</h3>
        <p className="text-sm text-text-secondary mt-2 px-6">
          This order has been cancelled successfully. Your authorization hold has been released.
        </p>
        <button
          onClick={() => router.push("/")}
          className="mt-8 w-full max-w-[240px] h-12 rounded-xl bg-primary text-white font-bold text-sm shadow-md hover:bg-primary/95 transition-all"
        >
          Back to Home
        </button>
      </div>
    );
  }

  // Dynamic Static Map URL based on Toronto or user coordinates
  const lat = order.house?.lat || 43.6532;
  const lng = order.house?.lng || -79.3832;
  const staticMapUrl = `https://maps.googleapis.com/maps/api/staticmap?center=${lat},${lng}&zoom=14&size=450x800&scale=2&map_id=6cb6a40ecec468b75636393f&key=AIzaSyC_tcXVeDFmHjvpPz-ZMZXceu5PSppmXPM`;

  return (
    <div className="w-full max-w-md mx-auto h-screen relative overflow-hidden flex flex-col border-x border-alternate shadow-md bg-bg-secondary">
      {/* ── 1. Map container ── */}
      <div className="absolute inset-0 z-0">
        <div
          className="w-full h-full bg-cover bg-center relative"
          style={{ backgroundImage: `url(${staticMapUrl})` }}
        >
          {/* Dark map overlay */}
          <div className="absolute inset-0 bg-zinc-900/10 pointer-events-none" />
        </div>
      </div>

      {/* ── 2. Pulsing Radar Animation (centered on user location) ── */}
      {order.status === "searching" && (
        <div className="absolute inset-0 flex items-center justify-center pointer-events-none z-10">
          <div className="relative h-44 w-44 flex items-center justify-center">
            {/* Pulse rings */}
            <div className="absolute h-full w-full rounded-full border border-primary/40 bg-primary/10 animate-ping opacity-60" />
            <div
              className="absolute h-28 w-28 rounded-full border-2 border-primary/60 bg-primary/15 animate-ping opacity-80"
              style={{ animationDelay: "1s" }}
            />
            {/* Inner dot */}
            <div className="relative h-14 w-14 rounded-full bg-primary flex items-center justify-center border-4 border-white shadow-xl">
              <MapPin className="h-6 w-6 text-white" />
            </div>
          </div>
        </div>
      )}

      {/* ── 3. Bottom sliding panel ── */}
      <div className="mt-auto relative z-20 w-full p-5">
        
        {/* Status Card: Searching */}
        {order.status === "searching" && (
          <div className="bg-bg-primary border border-alternate rounded-[24px] p-5 shadow-2xl space-y-4 animate-slide-up">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 bg-primary/10 rounded-xl flex items-center justify-center text-primary flex-shrink-0">
                <Loader2 className="h-5 w-5 animate-spin" />
              </div>
              <div>
                <h4 className="font-outfit text-sm font-extrabold text-text-primary">
                  Looking for a specialist...
                </h4>
                <p className="text-[11px] text-text-secondary mt-0.5">
                  Analyzing coordinates and assigning the best master.
                </p>
              </div>
            </div>

            {/* Cancel Button */}
            <button
              onClick={handleCancelOrder}
              disabled={cancelling}
              className="w-full h-12 border border-error/30 hover:bg-error/5 text-error rounded-xl font-bold text-xs flex items-center justify-center gap-2 transition-all"
            >
              {cancelling ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                <>
                  <X className="h-4 w-4" /> Cancel Booking
                </>
              )}
            </button>
          </div>
        )}

        {/* Status Card: Assigned (MasterAssignedWidget equivalent) */}
        {order.status === "assigned" && order.specialist && (
          <div className="bg-bg-primary border border-alternate rounded-[24px] p-5 shadow-2xl space-y-4 animate-slide-up">
            {/* Header info */}
            <div className="flex items-center justify-between border-b border-alternate pb-3.5">
              <div className="flex items-center gap-2.5">
                <div className="h-2 w-2 rounded-full bg-emerald-500 animate-pulse" />
                <span className="text-[10px] text-emerald-500 font-extrabold uppercase tracking-widest">
                  Specialist Assigned
                </span>
              </div>
              <div className="flex items-center gap-1 text-[11px] text-text-secondary">
                <Clock className="h-3.5 w-3.5" />
                <span>Arriving soon</span>
              </div>
            </div>

            {/* Specialist profile row */}
            <div className="flex items-center gap-3">
              {order.specialist.avatar_url ? (
                <img
                  src={order.specialist.avatar_url}
                  alt={order.specialist.first_name}
                  className="h-14 w-14 rounded-2xl object-cover border border-alternate"
                />
              ) : (
                <div className="h-14 w-14 rounded-2xl bg-primary/10 border border-alternate flex items-center justify-center">
                  <User className="h-6 w-6 text-primary/50" />
                </div>
              )}
              
              <div className="flex-1">
                <p className="font-outfit text-sm font-extrabold text-text-primary">
                  {order.specialist.first_name} {order.specialist.last_name}
                </p>
                <div className="flex items-center gap-1.5 mt-0.5">
                  <div className="flex items-center gap-0.5 text-xs font-bold text-amber-500">
                    <Star className="h-3.5 w-3.5 fill-current" />
                    <span>{order.specialist.rating.toFixed(1)}</span>
                  </div>
                  <span className="text-[10px] text-text-secondary font-medium">·</span>
                  <div className="flex items-center gap-1 text-[10px] text-emerald-500 font-bold">
                    <ShieldCheck className="h-3.5 w-3.5" />
                    <span>Verified Pro</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Contact actions */}
            <div className="grid grid-cols-2 gap-2 pt-1">
              <a
                href={`tel:${order.specialist.phone_number}`}
                className="h-12 border border-alternate rounded-xl font-bold text-xs text-text-primary flex items-center justify-center gap-2 hover:bg-bg-secondary transition-all"
              >
                <Phone className="h-4 w-4" /> Call
              </a>
              <button
                onClick={() => alert("Chat coming soon!")}
                className="h-12 bg-primary hover:bg-primary/95 text-white rounded-xl font-bold text-xs flex items-center justify-center gap-2 transition-all shadow-md"
              >
                <MessageSquare className="h-4 w-4" /> Chat
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
