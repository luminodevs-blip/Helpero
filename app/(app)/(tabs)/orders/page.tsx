"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import {
  ClipboardList,
  Calendar,
  DollarSign,
  ChevronRight,
  Loader2,
  AlertCircle,
  HelpCircle,
  MapPin,
  BadgeAlert,
  ShoppingCart,
} from "lucide-react";
import CartIcon from "@/components/CartIcon";

interface Order {
  id: number;
  status: string;
  final_total_price: number;
  scheduled_start_at: string;
  house: {
    full_address: string;
    name_label: string;
  } | null;
  visit_fee: number;
  service_name: string;
  service_image_url: string | null;
}

export default function OrdersPage() {
  const router = useRouter();
  const { user, cart } = useClientAuth();

  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [activeTab, setActiveTab] = useState<"active" | "past">("active");

  useEffect(() => {
    if (!user) return;

    const fetchOrders = async () => {
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
              name_label
            ),
            visit_fee,
            order_items (
              service_name,
              service_id,
              services:service_id (
                image_url,
                cat:service_categories (
                  image_url
                )
              )
            )
          `)
          .eq("user_id", user.id)
          .order("created_at", { ascending: false });

        if (fetchErr) throw fetchErr;

        const mapped = (data || []).map((o: any) => {
          const firstItem = o.order_items?.[0];
          return {
            id: o.id,
            status: o.status || "searching",
            final_total_price: Number(o.final_total_price || 0),
            scheduled_start_at: o.scheduled_start_at || "",
            house: o.house ? {
              full_address: o.house.full_address,
              name_label: o.house.name_label || "Home",
            } : null,
            visit_fee: Number(o.visit_fee || 0),
            service_name: firstItem?.service_name || "Service",
            service_image_url: firstItem?.services?.cat?.image_url || firstItem?.services?.image_url || null,
          };
        });

        setOrders(mapped);
      } catch (err: any) {
        setError(err.message || "Failed to load orders");
      } finally {
        setLoading(false);
      }
    };

    fetchOrders();

    // Setup real-time updates for orders
    const channel = supabase
      .channel("orders-list-updates")
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "orders",
          filter: `user_id=eq.${user.id}`,
        },
        () => {
          fetchOrders();
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [user]);

  // Separate active vs past orders
  const activeOrders = orders.filter((o) =>
    ["pending_payment", "searching", "assigned", "in_progress", "en_route", "arrived"].includes(o.status)
  );
  const pastOrders = orders.filter((o) =>
    ["completed", "canceled"].includes(o.status)
  );

  const displayedOrders = activeTab === "active" ? activeOrders : pastOrders;

  const getStatusConfig = (status: string) => {
    switch (status) {
      case "pending_payment":
        return { label: "Pending Payment", bg: "bg-amber-100 text-amber-800 border-amber-200" };
      case "searching":
        return { label: "Searching Pro", bg: "bg-[#7B61FF]/10 text-[#7B61FF] border-[#7B61FF]/20" };
      case "assigned":
        return { label: "Pro Assigned", bg: "bg-emerald-100 text-emerald-800 border-emerald-200" };
      case "en_route":
        return { label: "On the way", bg: "bg-blue-100 text-blue-800 border-blue-200" };
      case "arrived":
        return { label: "Pro Arrived", bg: "bg-emerald-100 text-emerald-800 border-emerald-200" };
      case "in_progress":
        return { label: "In Progress", bg: "bg-blue-100 text-blue-800 border-blue-200" };
      case "completed":
        return { label: "Completed", bg: "bg-zinc-100 text-zinc-600 border-zinc-200" };
      case "canceled":
        return { label: "Cancelled", bg: "bg-red-100 text-red-800 border-red-200" };
      default:
        return { label: status, bg: "bg-zinc-100 text-zinc-700" };
    }
  };

  const formatDate = (isoStr: string) => {
    if (!isoStr) return "Flexible time";
    const date = new Date(isoStr);
    return date.toLocaleDateString("en-US", {
      month: "short",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    });
  };

  // Formatter for "d MMM, yyyy • H:mm"
  const formatDateTime = (isoStr: string) => {
    if (!isoStr) return "Flexible time";
    const date = new Date(isoStr);
    const d = date.getDate();
    const MMM = date.toLocaleString("en-US", { month: "short" });
    const yyyy = date.getFullYear();
    const H = date.getHours();
    const mm = date.getMinutes().toString().padStart(2, "0");
    return `${d} ${MMM}, ${yyyy} • ${H}:${mm}`;
  };

  return (
    <div className="flex flex-col flex-1 bg-white pb-32">
      {/* ── 1. HEADER ── */}
      <div className="bg-[#7b82f4] text-white pt-10 pb-[52px] px-5 relative overflow-hidden flex-shrink-0">
        <div className="absolute inset-0 bg-radial-gradient from-white/10 to-transparent pointer-events-none opacity-40" />

        <div className="relative z-10 flex justify-between items-start">
          <div>
            <h2 className="font-outfit text-[18px] font-bold">Your bookings</h2>
            <p className="font-outfit text-[15px] font-medium text-white/80 mt-1">
              Track, manage and repeat your bookings
            </p>
          </div>

          <CartIcon />
        </div>
      </div>

      {/* ── 2. WHITE CONTAINER & TABS ── */}
      <div className="flex-1 bg-white rounded-t-2xl -mt-6 pt-4 px-5 relative z-10 flex flex-col">
        {/* Sliding Tabs */}
        <div className="flex bg-zinc-100 p-2 rounded-xl mb-4">
          <button
            onClick={() => setActiveTab("active")}
            className={`flex-1 h-[40px] flex items-center justify-center text-[18px] font-semibold rounded-lg transition-all focus:outline-none ${
              activeTab === "active" ? "bg-white text-zinc-900 shadow-sm" : "text-zinc-500 hover:text-zinc-700"
            }`}
          >
            Active
          </button>
          <button
            onClick={() => setActiveTab("past")}
            className={`flex-1 h-[40px] flex items-center justify-center text-[18px] font-semibold rounded-lg transition-all focus:outline-none ${
              activeTab === "past" ? "bg-white text-zinc-900 shadow-sm" : "text-zinc-500 hover:text-zinc-700"
            }`}
          >
            History
          </button>
        </div>

        {/* ── 3. LIST ── */}
        <div className="flex-1">
          {loading ? (
            <div className="space-y-0">
              {[1, 2, 3, 4].map((i) => (
                <div key={i} className="flex justify-between py-4 border-b border-zinc-100 last:border-0">
                  <div className="flex items-center gap-4">
                    <div className="w-[60px] h-[60px] rounded-xl bg-zinc-100 animate-pulse flex-shrink-0" />
                    <div className="space-y-2">
                      <div className="h-[17px] w-36 bg-zinc-100 rounded-lg animate-pulse" />
                      <div className="h-[14px] w-28 bg-zinc-100 rounded-lg animate-pulse" />
                      <div className="h-[14px] w-20 bg-zinc-100 rounded-lg animate-pulse" />
                    </div>
                  </div>
                  <div className="h-[16px] w-14 bg-zinc-100 rounded-lg animate-pulse self-end pb-0.5" />
                </div>
              ))}
            </div>
          ) : error ? (
            <div className="rounded-2xl bg-error/10 border border-error/20 p-4 text-center text-sm font-semibold text-error">
              {error}
            </div>
          ) : displayedOrders.length === 0 ? (
            <div className="flex flex-col items-center justify-center py-20 text-center">
              <div className="w-16 h-16 rounded-full bg-zinc-100 flex items-center justify-center mb-4">
                <ClipboardList className="w-7 h-7 text-zinc-400" />
              </div>
              <p className="font-outfit text-[17px] font-semibold text-zinc-800">
                {activeTab === "active" ? "No active bookings" : "No past bookings"}
              </p>
              <p className="text-[14px] text-zinc-400 mt-1">
                {activeTab === "active" ? "Your upcoming bookings will appear here" : "Completed bookings will appear here"}
              </p>
            </div>
          ) : (
            <div className="space-y-0">
              {displayedOrders.map((ord) => {
                const cfg = getStatusConfig(ord.status);
                return (
                  <div key={ord.id} onClick={() => router.push(`/searching?bookingId=${ord.id}`)} className="flex justify-between py-4 border-b border-zinc-100 last:border-0 cursor-pointer">
                    <div className="flex items-center gap-4">
                      <div className="w-[60px] h-[60px] rounded-xl bg-zinc-50 flex items-center justify-center overflow-hidden flex-shrink-0">
                        {ord.service_image_url ? (
                          <img src={ord.service_image_url} alt={ord.service_name} loading="lazy" className="w-full h-full object-cover mix-blend-multiply opacity-80" />
                        ) : (
                          <div className="w-full h-full bg-zinc-200" />
                        )}
                      </div>
                      
                      <div>
                        <h4 className="font-outfit text-[17px] font-medium text-zinc-900">{ord.service_name}</h4>
                        <p className="text-[14.5px] text-zinc-400 mt-0.5 font-normal">{formatDateTime(ord.scheduled_start_at)}</p>
                        <p className={`text-[14px] mt-0.5 font-medium ${ord.status === 'searching' || ord.status === 'assigned' ? 'text-[#7b82f4]' : 'text-zinc-500'}`}>
                          {cfg.label}
                        </p>
                      </div>
                    </div>
                    
                    <div className="text-[16px] font-semibold text-zinc-900 self-end pb-0.5">
                      ${ord.final_total_price.toFixed(2)}
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
