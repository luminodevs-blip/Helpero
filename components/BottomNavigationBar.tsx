"use client";

import React, { useState, useEffect } from "react";
import { useRouter, usePathname } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import { ChevronUp } from "lucide-react";
import { MdHome, MdManageSearch, MdFactCheck, MdPerson } from "react-icons/md";

interface ActiveOrder {
  id: number;
  status: string;
  scheduled_start_at: string | null;
  visit_fee: number;
  final_total_price: number;
  order_items?: { service_name: string }[];
}

export default function BottomNavigationBar() {
  const router = useRouter();
  const pathname = usePathname();
  const { user } = useClientAuth();

  const [activeOrder, setActiveOrder] = useState<ActiveOrder | null>(null);

  // Monitor active orders in real-time
  useEffect(() => {
    if (!user) {
      setActiveOrder(null);
      return;
    }

    const fetchActiveOrder = async () => {
      try {
        const { data, error } = await supabase
          .from("orders")
          .select("id, status, scheduled_start_at, visit_fee, final_total_price, order_items ( service_name )")
          .eq("user_id", user.id)
          .in("status", ["pending_payment", "searching", "assigned"])
          .order("created_at", { ascending: false })
          .limit(1)
          .maybeSingle();

        if (!error && data) {
          setActiveOrder(data as ActiveOrder);
        } else {
          setActiveOrder(null);
        }
      } catch (err) {
        console.error("Error fetching active order:", err);
      }
    };

    fetchActiveOrder();

    // Set up Realtime listener for status changes
    const channel = supabase
      .channel("nav-active-orders")
      .on(
        "postgres_changes",
        {
          event: "*",
          schema: "public",
          table: "orders",
          filter: `user_id=eq.${user.id}`,
        },
        () => {
          fetchActiveOrder();
        }
      )
      .subscribe();

    return () => {
      supabase.removeChannel(channel);
    };
  }, [user]);

  const handleBannerClick = () => {
    if (activeOrder) {
      router.push(`/searching?bookingId=${activeOrder.id}`);
    }
  };

  const navItems = [
    { label: "Home", icon: MdHome, path: "/", size: 28 },
    { label: "Search", icon: MdManageSearch, path: "/search", size: 36 },
    { label: "Orders", icon: MdFactCheck, path: "/orders", size: 30 },
    { label: "Profile", icon: MdPerson, path: "/profile", size: 28 },
  ];

  // If we are on checkout, searching, or address creation page, hide the bottom navbar entirely
  const hideNavbar = ["/checkout", "/searching", "/address/new", "/login"].some(
    (p) => pathname === p || pathname.startsWith(p + "/")
  );

  if (hideNavbar) return null;

  // Format estimated arrival time (e.g. 17:50-18:20)
  const getEstArrival = () => {
    if (!activeOrder?.scheduled_start_at) return "17:50-18:20";
    const date = new Date(activeOrder.scheduled_start_at);
    
    // Add 15 mins padding before and after for window
    const minDate = new Date(date.getTime() - 15 * 60000);
    const maxDate = new Date(date.getTime() + 15 * 60000);
    
    const pad = (n: number) => String(n).padStart(2, "0");
    return `${pad(minDate.getHours())}:${pad(minDate.getMinutes())}-${pad(maxDate.getHours())}:${pad(maxDate.getMinutes())}`;
  };

  const getStatusText = () => {
    if (activeOrder?.status === "pending_payment") return "Securing Booking...";
    if (activeOrder?.status === "assigned") return "Specialist Assigned!";
    return "Searching for a Pro...";
  };

  return (
    <div className="fixed bottom-[30px] left-0 right-0 z-40 px-4 max-w-md mx-auto pointer-events-none">
      <div className={`pointer-events-auto flex flex-col ${activeOrder ? 'bg-[#7b82f4] rounded-[28px] pt-3 pb-1.5 px-1.5 shadow-xl' : ''}`}>
        
        {/* ── 1. ACTIVE ORDER BANNER ── */}
        {activeOrder && (
          <div
            onClick={handleBannerClick}
            className="flex items-center justify-between px-3 pb-2.5 pt-1 text-white cursor-pointer hover:opacity-95 transition-opacity"
          >
            <div className="flex items-center gap-2">
              <ChevronUp className="h-6 w-6 text-white animate-pulse" />
              <div className="flex flex-col">
                <span className="text-[14.5px] font-bold tracking-wide">
                  {getStatusText()}
                </span>
                <span className="text-[12px] text-white/90 underline font-medium mt-0.5">
                  {activeOrder.order_items && activeOrder.order_items.length > 0
                    ? activeOrder.order_items[0].service_name + (activeOrder.order_items.length > 1 ? ` +${activeOrder.order_items.length - 1}` : "")
                    : "Cleaning Service"}
                </span>
              </div>
            </div>

            <div className="text-right pr-2">
              <span className="text-[11.5px] text-white/90 block font-normal">
                Est. arrival
              </span>
              <span className="text-[14px] font-bold tracking-wide">
                {getEstArrival()}
              </span>
            </div>
          </div>
        )}

        {/* ── 2. WHITE NAVBAR ── */}
        <div className={`flex justify-around items-center bg-white px-4 h-[50px] rounded-full ${activeOrder ? '' : 'shadow-xl border border-[#e0e3e7]'}`}>
          {navItems.map((item) => {
            const Icon = item.icon;
            const isActive = pathname === item.path;

            return (
              <button
                key={item.label}
                onClick={() => router.push(item.path)}
                className="flex items-center justify-center w-14 h-full focus:outline-none transition-colors"
                style={{
                  color: isActive ? "#7b82f4" : "#64748b",
                }}
              >
                <Icon size={item.size} />
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}
