"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import {
  ArrowLeft,
  ChevronRight,
  Loader2,
  HelpCircle,
  MessageSquare,
  Sparkles,
} from "lucide-react";

interface RecentOrder {
  id: number;
  service_name: string;
  short_description?: string;
  final_total_price: number;
  scheduled_start_at: string;
  service_image_url?: string;
}

export default function SupportPage() {
  const router = useRouter();
  const { user } = useClientAuth();
  const [recentOrder, setRecentOrder] = useState<RecentOrder | null>(null);
  const [loadingOrder, setLoadingOrder] = useState(true);

  useEffect(() => {
    if (!user) return;

    const fetchLatestOrder = async () => {
      try {
        setLoadingOrder(true);
        // Fetch the user's latest order
        const { data, error } = await supabase
          .from("orders")
          .select("id, service_name, final_total_price, scheduled_start_at, service_image_url")
          .eq("user_id", user.id)
          .order("id", { ascending: false })
          .limit(1)
          .maybeSingle();

        if (!error && data) {
          setRecentOrder({
            id: data.id,
            service_name: data.service_name,
            final_total_price: Number(data.final_total_price || 0),
            scheduled_start_at: data.scheduled_start_at,
            service_image_url: data.service_image_url || undefined,
          });
        }
      } catch (err) {
        console.error("Error fetching latest order for support:", err);
      } finally {
        setLoadingOrder(false);
      }
    };

    fetchLatestOrder();
  }, [user]);

  // Date formatter helper: e.g. "Fri. July 3rd"
  const formatOrderDate = (isoStr: string) => {
    if (!isoStr) return "";
    const date = new Date(isoStr);
    const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    
    const dayName = days[date.getDay()];
    const monthName = months[date.getMonth()];
    const dayNum = date.getDate();
    
    // Day suffix: 1st, 2nd, 3rd, 4th...
    let suffix = "th";
    if (dayNum === 1 || dayNum === 21 || dayNum === 31) suffix = "st";
    else if (dayNum === 2 || dayNum === 22) suffix = "nd";
    else if (dayNum === 3 || dayNum === 23) suffix = "rd";

    return `${dayName}. ${monthName} ${dayNum}${suffix}`;
  };

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-white relative flex flex-col border-x border-alternate shadow-md font-sans">
      {/* ── 1. HEADER (Purple banner with technician cartoon) ── */}
      <div className="bg-[#7B82F4] text-white pt-12 pb-[56px] px-5 relative overflow-hidden flex-shrink-0">
        <div className="absolute inset-0 bg-radial-gradient from-white/10 to-transparent pointer-events-none opacity-40" />

        <div className="relative z-10 flex justify-between items-center">
          <div className="space-y-4">
            {/* Circular transparent back button */}
            <button
              onClick={() => router.back()}
              className="w-[42px] h-[42px] rounded-full border border-white/20 bg-white/10 hover:bg-white/20 flex items-center justify-center text-white focus:outline-none transition-colors"
            >
              <ArrowLeft className="w-5 h-5" strokeWidth={2.5} />
            </button>

            <div className="space-y-1">
              <h1 className="font-outfit text-[26px] font-bold tracking-tight">Support</h1>
              <p className="font-outfit text-[15px] font-medium text-white/80">
                How can we assist you today?
              </p>
            </div>
          </div>

          {/* Technician Cartoon Avatar (Custom SVG) */}
          <div className="w-[84px] h-[84px] shrink-0 mr-1 select-none">
            <svg viewBox="0 0 100 100" className="w-full h-full">
              {/* Back Circle */}
              <circle cx="50" cy="50" r="46" fill="#FFFFFF" fillOpacity="0.1" />
              {/* Body in blue shirt */}
              <path d="M22 84 C22 62, 78 62, 78 84 Z" fill="#2C3E50" />
              {/* Neck */}
              <rect x="44" y="52" width="12" height="12" rx="4" fill="#FFC3A0" />
              {/* Face */}
              <circle cx="50" cy="44" r="17" fill="#FFC3A0" />
              {/* Hair under cap */}
              <path d="M33 42 C33 34, 67 34, 67 42 Z" fill="#2C3E50" />
              {/* Blue Cap */}
              <path d="M32 37 C32 23, 68 23, 68 37 Z" fill="#2A4B7C" />
              <path d="M35 32 L65 32 L72 38 L28 38 Z" fill="#1C355E" />
              {/* Wrench (Right Hand Side) */}
              <path d="M14 62 L28 42 L34 46 L20 66 Z" fill="#BDC3C7" />
              <circle cx="15" cy="61" r="5" fill="#95A5A6" />
              <path d="M12 59 L17 64" stroke="#7F8C8D" strokeWidth="2.5" />
              {/* Screwdriver (Left Hand Side) */}
              <path d="M86 62 L72 42 L66 46 L80 66 Z" fill="#E74C3C" />
              <path d="M84 64 L79 59" stroke="#BDC3C7" strokeWidth="3" />
            </svg>
          </div>
        </div>
      </div>

      {/* ── 2. WHITE OVERLAPPING CONTENT CARD ── */}
      <div className="flex-1 bg-white rounded-t-[28px] -mt-6 pt-6 px-5 space-y-6 relative z-10">
        
        {/* Recent orders */}
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <h2 className="font-outfit text-[18px] font-bold text-zinc-900">
              Recent orders
            </h2>
            <button
              onClick={() => router.push("/orders")}
              className="text-[13px] font-bold text-[#7B82F4] flex items-center gap-0.5 hover:opacity-85"
            >
              View all <ChevronRight className="h-3.5 w-3.5" />
            </button>
          </div>

          {loadingOrder ? (
            <div className="h-[120px] rounded-2xl border border-zinc-100 flex items-center justify-center">
              <Loader2 className="h-6 w-6 animate-spin text-[#7B82F4]" />
            </div>
          ) : recentOrder ? (
            /* Real latest order from DB */
            <div
              onClick={() => router.push(`/searching?bookingId=${recentOrder.id}`)}
              className="rounded-2xl border border-zinc-100 bg-[#F8F9FA] p-4 flex items-center justify-between cursor-pointer hover:border-zinc-200 transition-colors"
            >
              <div className="flex items-center gap-4">
                <div className="w-[52px] h-[52px] rounded-xl bg-white border border-zinc-200/60 overflow-hidden flex items-center justify-center shrink-0">
                  {recentOrder.service_image_url ? (
                    <img
                      src={recentOrder.service_image_url}
                      alt={recentOrder.service_name}
                      className="w-full h-full object-cover mix-blend-multiply opacity-80"
                    />
                  ) : (
                    <Sparkles className="h-5 w-5 text-[#7B82F4]" />
                  )}
                </div>
                
                <div className="flex flex-col">
                  <span className="font-outfit text-[15px] font-bold text-zinc-900 leading-tight">
                    {recentOrder.service_name}
                  </span>
                  <span className="text-[12px] font-medium text-zinc-400 mt-1">
                    Order #{recentOrder.id}
                  </span>
                  <span className="text-[12px] font-medium text-zinc-400 mt-0.5">
                    {formatOrderDate(recentOrder.scheduled_start_at)}
                  </span>
                </div>
              </div>

              <span className="font-outfit text-[16px] font-bold text-zinc-900 pr-1">
                ${recentOrder.final_total_price.toFixed(2)}
              </span>
            </div>
          ) : (
            /* Mock painting order card matching screenshot exactly when DB is empty */
            <div
              onClick={() => alert("Mock order selected")}
              className="rounded-2xl border border-zinc-100 bg-[#F8F9FA] p-4 flex items-center justify-between cursor-pointer hover:border-zinc-200 transition-colors"
            >
              <div className="flex items-center gap-4">
                {/* Painting Tools Cartoon Icon */}
                <div className="w-[52px] h-[52px] rounded-xl bg-white border border-zinc-200/60 overflow-hidden flex items-center justify-center shrink-0 p-1">
                  <svg viewBox="0 0 64 64" className="w-full h-full">
                    {/* Bucket */}
                    <path d="M12 28 L52 28 L46 56 L18 56 Z" fill="#3498DB" />
                    <rect x="10" y="24" width="44" height="4" rx="2" fill="#2980B9" />
                    {/* Handle */}
                    <path d="M16 24 C16 10, 48 10, 48 24" stroke="#7F8C8D" strokeWidth="2.5" fill="none" />
                    {/* Sponge / Soap */}
                    <ellipse cx="48" cy="52" rx="8" ry="4" fill="#F1C40F" />
                    {/* Spray Bottle */}
                    <rect x="22" y="16" width="6" height="12" fill="#E67E22" />
                    <path d="M20 16 L30 16 L25 10 Z" fill="#D35400" />
                  </svg>
                </div>
                
                <div className="flex flex-col">
                  <span className="font-outfit text-[15px] font-bold text-zinc-900 leading-tight">
                    Painting - Restaurant
                  </span>
                  <span className="text-[13px] font-medium text-zinc-500 mt-0.5">
                    Full fasad painting
                  </span>
                  <span className="text-[12px] font-medium text-zinc-400 mt-1">
                    Fri. July 3rd
                  </span>
                </div>
              </div>

              <span className="font-outfit text-[16px] font-bold text-zinc-900 pr-1">
                $78.50
              </span>
            </div>
          )}
        </div>

        {/* Other Options */}
        <div className="space-y-4 pt-2">
          <h2 className="font-outfit text-[18px] font-bold text-zinc-900">
            Other
          </h2>

          <div className="space-y-3">
            {/* Contact a consultant */}
            <div
              onClick={() => alert("Consultant chat coming soon")}
              className="flex items-center justify-between p-4 rounded-2xl bg-[#F8F9FA] border border-zinc-100 hover:border-zinc-200 transition-colors cursor-pointer"
            >
              <div className="flex items-center gap-4">
                <div className="h-6 w-6 flex items-center justify-center text-zinc-900">
                  {/* Handshake/Agreement Icon */}
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className="w-5 h-5">
                    <path d="M16 3H1v18h22V7h-7V3zM8 3v4M12 3v4" />
                    <path d="M3 14c2.5-1 4.5 1 7 0s4.5-1 7 0" />
                  </svg>
                </div>
                <span className="font-outfit text-[15px] font-bold text-zinc-900">
                  Contact a consultant
                </span>
              </div>
              <ChevronRight className="h-5 w-5 text-zinc-400" />
            </div>

            {/* Frequently Asked Questions */}
            <div
              onClick={() => alert("FAQ page coming soon")}
              className="flex items-center justify-between p-4 rounded-2xl bg-[#F8F9FA] border border-zinc-100 hover:border-zinc-200 transition-colors cursor-pointer"
            >
              <div className="flex items-center gap-4">
                <HelpCircle className="h-5 w-5 text-zinc-900" />
                <span className="font-outfit text-[15px] font-bold text-zinc-900">
                  Frequently Asked Questions
                </span>
              </div>
              <ChevronRight className="h-5 w-5 text-zinc-400" />
            </div>

            {/* Requests */}
            <div
              onClick={() => alert("Requests tickets coming soon")}
              className="flex items-center justify-between p-4 rounded-2xl bg-[#F8F9FA] border border-zinc-100 hover:border-zinc-200 transition-colors cursor-pointer"
            >
              <div className="flex items-center gap-4">
                <MessageSquare className="h-5 w-5 text-zinc-900" />
                <span className="font-outfit text-[15px] font-bold text-zinc-900">
                  Requests
                </span>
              </div>
              <ChevronRight className="h-5 w-5 text-zinc-400" />
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}
