"use client";

import React, { useState } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import {
  User,
  CreditCard,
  Tag,
  MapPin,
  Headphones,
  Settings,
  ChevronRight,
  Search,
  ShoppingCart,
  Pencil,
  LogOut,
  Loader2,
} from "lucide-react";
import CartIcon from "@/components/CartIcon";

export default function ProfilePage() {
  const router = useRouter();
  const { user, profile, cart, signOut } = useClientAuth();
  const [loggingOut, setLoggingOut] = useState(false);

  const handleSignOut = async () => {
    try {
      setLoggingOut(true);
      await signOut();
      router.push("/login");
    } catch (err) {
      console.error("Failed to sign out:", err);
    } finally {
      setLoggingOut(false);
    }
  };

  const displayName = profile?.firstName
    ? `${profile.firstName} ${profile.lastName || ""}`.trim()
    : "Helpero User";

  const displaySub = profile?.phoneNumber || user?.email || "";

  const displaySubMasked = (() => {
    const phone = profile?.phoneNumber;
    if (!phone) return user?.email || "";
    // +44XXXXXXXXXX → +44 XXXX XXX-XXX
    if (phone.startsWith("+44") && phone.length >= 12) {
      const n = phone.slice(3); // remove +44
      return `+44 ${n.slice(0, 4)} ${n.slice(4, 7)}-${n.slice(7)}`;
    }
    return phone;
  })();

  const menuItems = [
    {
      label: "Payments",
      icon: CreditCard,
      subtitle: "Manage your payment methods",
      action: () => router.push("/profile/payments"),
    },
    {
      label: "Vouchers",
      icon: Tag,
      subtitle: "Redeem promo codes & vouchers",
      action: () => router.push("/vouchers"),
    },
    {
      label: "Addresses",
      icon: MapPin,
      subtitle: "Manage your saved addresses",
      action: () => router.push("/address"),
    },
    {
      label: "Support Center",
      icon: Headphones,
      subtitle: "Get help from our team",
      action: () => router.push("/support"),
    },
    {
      label: "Settings",
      icon: Settings,
      subtitle: "App preferences & account",
      action: () => router.push("/settings"),
    },
  ];

  return (
    <div className="flex flex-col flex-1 bg-white animate-page-fade-in">
      {/* ── 1. HEADER ── */}
      <div className="bg-primary text-white pt-10 pb-[40px] px-5 relative overflow-hidden flex-shrink-0">
        <div className="absolute inset-0 bg-radial-gradient from-white/10 to-transparent pointer-events-none opacity-40" />

        <div className="relative z-10 space-y-[12px]">
          {/* Top row */}
          <div className="flex justify-between items-start">
            <div>
              <h2 className="font-outfit text-[18px] font-bold">Account settings</h2>
              <p className="font-outfit text-[15px] font-medium text-white/80 mt-1">
                Control your account in one place
              </p>
            </div>
            <CartIcon />
          </div>

          {/* Search bar */}
          <div
            className="relative flex items-center bg-white/20 rounded-xl h-[44px] px-4 shadow-sm border border-white/10 cursor-pointer"
            onClick={() => router.push("/search")}
          >
            <Search className="h-5 w-5 text-white/80 mr-2.5 flex-shrink-0" />
            <span className="font-outfit text-[16px] font-normal text-white/80">
              Search for services
            </span>
          </div>
        </div>
      </div>

      {/* ── 2. WHITE CARD (overlapping) ── */}
      <div className="flex-1 bg-white rounded-t-[16px] -mt-[24px] pt-5 pb-28 px-5 relative z-10 overflow-y-auto">

        {/* Profile row */}
        <div className="flex items-center gap-3 mb-6">
          <div className="h-[52px] w-[52px] rounded-full bg-zinc-100 border border-zinc-200 flex items-center justify-center flex-shrink-0 overflow-hidden">
            {profile?.avatarUrl ? (
              <img src={profile.avatarUrl} alt="Avatar" className="h-full w-full object-cover" />
            ) : (
              <User className="h-6 w-6 text-zinc-400" />
            )}
          </div>
          <div className="flex-1 min-w-0">
            <p className="font-outfit text-[18px] font-semibold text-zinc-900 truncate">{displayName}</p>
            <p className="text-[15px] font-medium text-zinc-500 truncate">{displaySubMasked}</p>
          </div>
          <button
            onClick={() => router.push("/profile/edit")}
            className="h-9 w-9 rounded-full bg-zinc-50 border border-zinc-200 flex items-center justify-center flex-shrink-0 hover:bg-zinc-100 transition-colors"
          >
            <Pencil className="h-4 w-4 text-zinc-500" />
          </button>
        </div>

        {/* Menu list */}
        <div className="space-y-2">
          {menuItems.map((item, idx) => {
            const Icon = item.icon;
            return (
              <div
                key={idx}
                onClick={item.action}
                className="flex items-center justify-between px-4 py-3.5 rounded-2xl border border-zinc-100 bg-white hover:bg-zinc-50 transition-colors cursor-pointer"
              >
                <div className="flex items-center gap-3">
                  <div className="h-9 w-9 bg-primary/10 rounded-xl flex items-center justify-center flex-shrink-0">
                    <Icon className="h-[18px] w-[18px] text-primary" />
                  </div>
                  <span className="font-outfit text-[16px] font-medium text-zinc-900">{item.label}</span>
                </div>
                <ChevronRight className="h-4 w-4 text-zinc-400" />
              </div>
            );
          })}
        </div>

        {/* Log Out */}
        <div className="mt-6">
          <button
            onClick={handleSignOut}
            disabled={loggingOut}
            className="w-full h-[52px] rounded-2xl border border-zinc-200 bg-white hover:bg-zinc-50 flex items-center justify-center gap-2 text-[15px] font-semibold text-zinc-700 transition-colors"
          >
            {loggingOut ? (
              <Loader2 className="h-5 w-5 animate-spin text-zinc-400" />
            ) : (
              <>
                <LogOut className="h-[18px] w-[18px] text-zinc-400" />
                <span>Log Out</span>
              </>
            )}
          </button>
        </div>

        {/* Version */}
        <p className="text-center text-[12px] text-zinc-400 mt-6">Helpero v.1.0.1</p>
      </div>
    </div>
  );
}
