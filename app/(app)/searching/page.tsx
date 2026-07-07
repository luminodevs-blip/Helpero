"use client";

import React, { useState, useEffect, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import { GoogleMap, useJsApiLoader } from "@react-google-maps/api";
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

const GOOGLE_MAPS_API_KEY = process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY || "AIzaSyC_tcXVeDFmHjvpPz-ZMZXceu5PSppmXPM";
const LIBRARIES: any[] = ["places"];

interface Specialist {
  id: string;
  first_name: string;
  last_name: string;
  avatar_url: string | null;
  rating: number;
  reviews_count?: number;
  phone_number: string;
}

interface OrderDetails {
  id: number;
  status: string;
  final_total_price: number;
  scheduled_start_at: string;
  service_name?: string;
  service_duration?: number;
  service_icon_url?: string;
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

  const { isLoaded } = useJsApiLoader({
    id: 'google-map-script',
    googleMapsApiKey: GOOGLE_MAPS_API_KEY,
    libraries: LIBRARIES,
  });

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
            specialist:profiles!specialist_id ( id, first_name, last_name, avatar_url, phone_number ),
            order_items ( service_name, service:services ( image_url, duration_minutes, cat:service_categories ( image_url ) ) )
          `)
          .eq("id", bookingId)
          .single();

        if (fetchErr) throw fetchErr;
        const raw = data as any;
        let specialistData = null;
        if (raw.specialist) {
          const { data: specDetails } = await supabase
            .from("specialists")
            .select("rating, reviews_count")
            .eq("id", raw.specialist.id)
            .maybeSingle();

          specialistData = {
            id: raw.specialist.id,
            first_name: raw.specialist.first_name,
            last_name: raw.specialist.last_name,
            avatar_url: raw.specialist.avatar_url,
            rating: specDetails ? Number(specDetails.rating) : 5.0,
            reviews_count: specDetails ? Number(specDetails.reviews_count) : 0,
            phone_number: raw.specialist.phone_number || "",
          };
        }

        setOrder({
          id: raw.id,
          status: raw.status || "searching",
          final_total_price: raw.final_total_price || 0,
          scheduled_start_at: raw.scheduled_start_at || "",
          service_name: raw.order_items?.[0]?.service_name,
          service_icon_url: raw.order_items?.[0]?.service?.cat?.image_url || raw.order_items?.[0]?.service?.image_url,
          service_duration: raw.order_items?.[0]?.service?.duration_minutes,
          house: raw.house ? {
            full_address: raw.house.full_address,
            lat: Number(raw.house.lat),
            lng: Number(raw.house.lng),
            name_label: raw.house.name_label,
          } : null,
          specialist: specialistData,
        });

        // Trigger Next.js simulated auto-assignment API as a fallback in case webhook failed
        if (raw.status === "pending_payment" || raw.status === "searching") {
          supabase.auth.getSession().then(({ data: { session } }) => {
            fetch("/api/assign-specialist", {
              method: "POST",
              headers: { 
                "Content-Type": "application/json",
                "Authorization": `Bearer ${session?.access_token || ""}`
              },
              body: JSON.stringify({ bookingId: raw.id })
            }).catch(err => console.error("Error triggering auto-assignment:", err));
          });
        }
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
            specialist:profiles!specialist_id ( id, first_name, last_name, avatar_url, phone_number ),
            order_items ( service_name, service:services ( image_url, duration_minutes, cat:service_categories ( image_url ) ) )
          `)
          .eq("id", bookingId).single();
        if (data) {
          const raw = data as any;
          setOrder(prev => ({
            id: raw.id,
            status: raw.status || "searching",
            final_total_price: raw.final_total_price || 0,
            scheduled_start_at: raw.scheduled_start_at || "",
            service_name: raw.order_items?.[0]?.service_name || prev?.service_name,
            service_icon_url: raw.order_items?.[0]?.service?.cat?.image_url || raw.order_items?.[0]?.service?.image_url || prev?.service_icon_url,
            service_duration: raw.order_items?.[0]?.service?.duration_minutes || prev?.service_duration,
            house: raw.house ? { full_address: raw.house.full_address, lat: Number(raw.house.lat), lng: Number(raw.house.lng), name_label: raw.house.name_label } : null,
            specialist: raw.specialist ? { id: raw.specialist.id, first_name: raw.specialist.first_name, last_name: raw.specialist.last_name, avatar_url: raw.specialist.avatar_url, rating: raw.specialist.rating || 4.9, phone_number: raw.specialist.phone_number || "" } : null,
          }));
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
        .from("orders").update({ status: "canceled" }).eq("id", bookingId);
      if (cancelErr) throw cancelErr;
      setOrder((prev) => prev ? { ...prev, status: "canceled" } : null);
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
  if (order.status === "canceled") {
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

  return (
    <div className="w-full max-w-md mx-auto h-screen relative overflow-hidden flex flex-col border-x border-zinc-100 shadow-md bg-[#F1F4F8]">
      <style dangerouslySetInnerHTML={{ __html: `
        @keyframes radar-pulse {
          0% {
            transform: scale(0.8);
            opacity: 0.8;
          }
          100% {
            transform: scale(2.6);
            opacity: 0;
          }
        }
        .radar-wave {
          animation: radar-pulse 3s cubic-bezier(0.1, 0.8, 0.3, 1) infinite;
        }
        .radar-wave-delayed {
          animation: radar-pulse 3s cubic-bezier(0.1, 0.8, 0.3, 1) infinite;
          animation-delay: 1.5s;
        }
      `}} />

      {/* ── Map background ── */}
      <div className="absolute inset-0 z-0 bg-[#E8E8E8]">
        {isLoaded && (
          <GoogleMap
            mapContainerStyle={{ width: "100%", height: "100%" }}
            center={{ lat, lng }}
            zoom={14}
            options={{
              mapId: "51e65d1a42c6dcc2d42df44f",
              disableDefaultUI: true,
              keyboardShortcuts: false,
              gestureHandling: 'none',
              styles: [
                {
                  featureType: "all",
                  elementType: "labels",
                  stylers: [{ visibility: "off" }]
                },
                {
                  featureType: "water",
                  elementType: "geometry",
                  stylers: [{ color: "#d4d4d8" }]
                }
              ]
            }}
          />
        )}
      </div>

      {/* ── Pulsing house marker (center) ── */}
      <div className="absolute inset-0 flex flex-col items-center justify-center pointer-events-none z-10" style={{ bottom: "280px", position: "absolute", left: "50%", top: "38%", transform: "translate(-50%, -50%)" }}>
        
        <div className="relative flex items-center justify-center mb-3">
          <div className="absolute h-[60px] w-[60px] rounded-full bg-[#7B82F4]/25 radar-wave" />
          <div className="absolute h-[60px] w-[60px] rounded-full bg-[#7B82F4]/25 radar-wave-delayed" />
          {/* House icon circle */}
          <div className="relative h-[60px] w-[60px] rounded-full bg-[#7B82F4] flex items-center justify-center shadow-lg z-10">
            <Home className="h-[32px] w-[32px] text-white" strokeWidth={2} />
          </div>
        </div>

      </div>

      {/* ── Bottom sheet ── */}
      <div className="absolute bottom-0 left-0 right-0 z-20 p-4 pb-8">
        <div className="bg-white rounded-[30px] pt-[32px] pb-[24px] overflow-hidden shadow-2xl">
          
          {order.status === "assigned" && order.specialist ? (
            <div className="space-y-6">
              {/* Specialist Header */}
              <div className="px-6 flex items-center gap-4">
                {order.specialist.avatar_url ? (
                  <img src={order.specialist.avatar_url} alt="" className="h-16 w-16 rounded-[14px] object-cover border-2 border-[#7B82F4]" />
                ) : (
                  <div className="h-16 w-16 rounded-[14px] bg-[#9198F7] border border-[#7B82F4] flex items-end justify-center overflow-hidden shrink-0">
                    <User className="h-12 w-12 text-white/90 translate-y-2" />
                  </div>
                )}
                <div>
                  <p className="text-[10px] font-bold text-[#7B82F4] uppercase tracking-wider mb-0.5">
                    Specialist Assigned
                  </p>
                  <h3 className="font-outfit text-[22px] font-bold text-zinc-900 leading-tight">
                    {order.specialist.first_name} {order.specialist.last_name}
                  </h3>
                  <div className="flex items-center gap-1 mt-1 text-xs text-zinc-500 font-medium">
                    <Star className="h-3.5 w-3.5 fill-[#7B82F4] text-[#7B82F4]" />
                     <span className="font-semibold text-zinc-700">{order.specialist.rating.toFixed(1)}</span>
                     <span>({order.specialist.reviews_count ?? 0})</span>
                    <span className="mx-0.5">·</span>
                    <span>Helpero Pro</span>
                  </div>
                </div>
              </div>

              {/* Divider */}
              <div className="mx-6 h-px bg-zinc-100" />

              {/* Details */}
              <div className="px-6 space-y-3">
                <div className="flex items-start justify-between">
                  <span className="text-[14px] font-bold text-zinc-900 w-24">Arrival:</span>
                  <span className="text-[14px] font-medium text-zinc-700 text-right">
                    {order.scheduled_start_at ? new Date(order.scheduled_start_at).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' }) : "24 Apr, 14:45"}
                  </span>
                </div>
                <div className="flex items-start justify-between">
                  <span className="text-[14px] font-bold text-zinc-900 w-24">To:</span>
                  <span className="text-[14px] font-medium text-zinc-700 text-right flex-1 truncate text-ellipsis">
                    {order.house?.full_address || "123 Maple St, North York"}
                  </span>
                </div>
              </div>

              {/* Service & Price Box */}
              <div className="px-6 py-5 bg-[#F4F5F7] border-y border-zinc-100 flex items-center gap-3">
                <div className="h-10 w-10 shrink-0 flex items-center justify-center">
                  {order.service_icon_url ? (
                    <img src={order.service_icon_url} alt={order.service_name} className="h-10 w-10 object-contain drop-shadow-sm" />
                  ) : (
                    <span className="text-2xl">🧹</span>
                  )}
                </div>
                <div className="flex-1">
                  <p className="font-outfit font-medium text-zinc-900 text-[15px]">{order.service_name || "Standard Cleaning"}</p>
                  <p className="text-[13px] font-medium text-zinc-500">
                    {order.service_duration ? `${Math.floor(order.service_duration / 60)} hours ${order.service_duration % 60} minutes` : "3 hours 55 minutes"}
                  </p>
                </div>
                <p className="font-outfit font-bold text-zinc-900 text-[16px]">
                  ${Number(order.final_total_price).toFixed(2)}
                </p>
              </div>

              {/* Order History Button */}
              <div className="px-6">
                <button
                  onClick={() => router.push("/orders")}
                  className="w-full h-[52px] bg-zinc-900 rounded-[14px] text-white font-bold text-[16px] flex items-center justify-center transition-transform active:scale-[0.98]"
                >
                  Order History
                </button>
              </div>
            </div>
          ) : (
            <div className="px-6 space-y-6">
              {/* Header */}
              <div className="text-center">
                <h3 className="font-outfit text-[28px] font-bold text-zinc-900 leading-tight">
                  Finding your specialist
                </h3>
                <p className="text-[16px] font-normal text-zinc-500 mt-2 leading-snug">
                  Matching you with the highest rated pro in Toronto.
                </p>
              </div>

              {/* Progress bar */}
              <ProgressBar />

              {/* Divider */}
              <div className="h-px bg-zinc-100" />

              {/* Service row */}
              <div className="flex items-center gap-3">
                <div className="h-11 w-11 rounded-xl bg-[#F1F4F8] flex items-center justify-center shrink-0 overflow-hidden">
                  {order.service_icon_url ? (
                    <img src={order.service_icon_url} alt={order.service_name} className="h-8 w-8 object-contain" />
                  ) : (
                    <span className="text-xl">🧹</span>
                  )}
                </div>
                <div className="flex-1">
                  <p className="font-outfit font-medium text-zinc-900 text-[18px]">{order.service_name || "Standard Cleaning"}</p>
                  <p className="text-[15px] font-normal text-zinc-400">
                    {order.service_duration ? `${Math.floor(order.service_duration / 60)} hours ${order.service_duration % 60} minutes` : "3 hours 45 minutes"}
                  </p>
                </div>
                <p className="font-outfit font-semibold text-zinc-900 text-[17px]">
                  ${Number(order.final_total_price).toFixed(2)}
                </p>
              </div>

              {/* Cancel button */}
              <button
                onClick={handleCancelOrder}
                disabled={cancelling}
                className="w-full h-12 border border-zinc-200 rounded-xl text-zinc-500 font-normal text-[18px] flex items-center justify-center gap-2 hover:bg-zinc-50 transition-all"
              >
                {cancelling ? <Loader2 className="h-4 w-4 animate-spin" /> : "Cancel order"}
              </button>
            </div>
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
