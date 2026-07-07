"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import {
  ArrowLeft,
  Loader2,
  Tag,
  CheckCircle,
  AlertCircle,
  HelpCircle,
} from "lucide-react";

interface Voucher {
  id: number;
  code: string;
  title: string;
  description: string;
  expires_at: string | null;
  target_audience: string;
}

export default function VouchersPage() {
  const router = useRouter();
  const { user } = useClientAuth();

  const [promoCode, setPromoCode] = useState("");
  const [loadingClaim, setLoadingClaim] = useState(false);
  const [claimStatus, setClaimStatus] = useState<{
    type: "success" | "error";
    message: string;
  } | null>(null);

  const [vouchers, setVouchers] = useState<Voucher[]>([]);
  const [loadingList, setLoadingList] = useState(true);
  const [activeTab, setActiveTab] = useState<"global" | "personal">("global");

  const fetchVouchers = async () => {
    if (!user) return;
    try {
      setLoadingList(true);
      const { data, error } = await supabase
        .from("user_vouchers")
        .select(`
          id,
          status,
          voucher:vouchers (
            id,
            code,
            title,
            description,
            expires_at,
            target_audience
          )
        `)
        .eq("user_id", user.id)
        .eq("status", "active");

      if (!error && data) {
        // Map and cast results
        const mapped = (data || [])
          .map((row: any) => row.voucher)
          .filter(Boolean) as Voucher[];
        setVouchers(mapped);
      }
    } catch (err) {
      console.error("Error fetching vouchers:", err);
    } finally {
      setLoadingList(false);
    }
  };

  useEffect(() => {
    fetchVouchers();
  }, [user]);

  const handleApplyPromo = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!promoCode.trim() || !user) return;

    setLoadingClaim(true);
    setClaimStatus(null);

    const codeUpper = promoCode.trim().toUpperCase();

    try {
      // 1. Try claiming via Edge Function
      try {
        const { data: claimData, error: claimErr } = await supabase.functions.invoke(
          "claim_voucher",
          {
            body: { code: codeUpper },
          }
        );

        if (!claimErr && claimData?.success) {
          setClaimStatus({
            type: "success",
            message: `Promocode ${codeUpper} applied successfully!`,
          });
          setPromoCode("");
          fetchVouchers();
          setLoadingClaim(false);
          return;
        }
      } catch (fnErr) {
        console.warn("Edge Function claim_voucher failed/missing, trying direct DB fallback:", fnErr);
      }

      // 2. Direct DB Fallback
      // Search for the active voucher by code
      const { data: voucher, error: vError } = await supabase
        .from("vouchers")
        .select("*")
        .eq("code", codeUpper)
        .eq("is_active", true)
        .single();

      if (vError || !voucher) {
        setClaimStatus({
          type: "error",
          message: "Invalid or inactive promo code.",
        });
        setLoadingClaim(false);
        return;
      }

      // Check if already claimed
      const { data: existing } = await supabase
        .from("user_vouchers")
        .select("id")
        .eq("user_id", user.id)
        .eq("voucher_id", voucher.id)
        .maybeSingle();

      if (existing) {
        setClaimStatus({
          type: "error",
          message: "You have already claimed this promo code.",
        });
        setLoadingClaim(false);
        return;
      }

      // Claim the voucher by inserting into user_vouchers
      const { error: claimErr } = await supabase
        .from("user_vouchers")
        .insert({
          user_id: user.id,
          voucher_id: voucher.id,
          status: "active",
        });

      if (claimErr) throw claimErr;

      setClaimStatus({
        type: "success",
        message: `Promocode ${codeUpper} applied successfully!`,
      });
      setPromoCode("");
      fetchVouchers();
    } catch (err: any) {
      console.error(err);
      setClaimStatus({
        type: "error",
        message: err?.message || "Failed to apply promo code.",
      });
    } finally {
      setLoadingClaim(false);
    }
  };

  // Filter vouchers based on target_audience
  const globalVouchers = vouchers.filter(
    (v) => v.target_audience !== "specific_user"
  );
  const personalVouchers = vouchers.filter(
    (v) => v.target_audience === "specific_user"
  );

  const displayedVouchers =
    activeTab === "global" ? globalVouchers : personalVouchers;

  const formatDate = (isoStr: string | null) => {
    if (!isoStr) return "No Expiry";
    const date = new Date(isoStr);
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return `Expires ${months[date.getMonth()]} ${date.getDate()}, ${date.getFullYear()}`;
  };

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-white relative flex flex-col border-x border-alternate shadow-md animate-page-fade-in font-sans">
      {/* Header */}
      <div className="px-5 pt-12 pb-5 flex items-center justify-between border-b border-zinc-100 sticky top-0 bg-white z-20">
        <button
          onClick={() => router.back()}
          className="p-1 -ml-1 flex items-center justify-center rounded-full hover:bg-zinc-100 text-zinc-900 focus:outline-none transition-colors"
        >
          <ArrowLeft className="w-[24px] h-[24px]" strokeWidth={2} />
        </button>
        
        <h1 className="font-outfit text-[20px] font-bold text-zinc-900 absolute left-1/2 -translate-x-1/2">
          Promocodes
        </h1>
        
        <div className="w-8" />
      </div>

      {/* Main Content */}
      <div className="px-5 pt-6 space-y-6 flex-1 pb-10">
        
        {/* Promocode Input Form */}
        <form onSubmit={handleApplyPromo} className="space-y-3">
          <div className="flex items-center gap-3">
            <div className="flex-1 h-12 px-4 rounded-xl border border-zinc-200 bg-[#F1F4F8]/50 flex items-center">
              <input
                type="text"
                value={promoCode}
                onChange={(e) => setPromoCode(e.target.value)}
                placeholder="Enter code"
                className="w-full bg-transparent font-sans font-semibold text-[15px] text-zinc-900 placeholder-zinc-400 focus:outline-none"
              />
            </div>
            
            <button
              type="submit"
              disabled={loadingClaim || !promoCode.trim()}
              className="h-12 px-6 bg-[#7B82F4] text-white font-sans font-semibold text-[15px] rounded-xl active:scale-[0.98] transition-all hover:bg-[#6c73e3] disabled:opacity-50 disabled:active:scale-100 flex items-center justify-center shrink-0 shadow-sm"
            >
              {loadingClaim ? (
                <Loader2 className="h-5 w-5 animate-spin text-white" />
              ) : (
                "Apply"
              )}
            </button>
          </div>

          {claimStatus && (
            <div
              className={`p-3 rounded-xl border flex items-start gap-2 text-[13px] font-semibold ${
                claimStatus.type === "success"
                  ? "bg-green-50 border-green-100 text-green-700"
                  : "bg-red-50 border-red-100 text-red-600"
              }`}
            >
              {claimStatus.type === "success" ? (
                <CheckCircle className="h-4.5 w-4.5 shrink-0 mt-0.5" />
              ) : (
                <AlertCircle className="h-4.5 w-4.5 shrink-0 mt-0.5" />
              )}
              <span>{claimStatus.message}</span>
            </div>
          )}
        </form>

        {/* Tab Switcher exactly matching screenshot */}
        <div className="flex items-center gap-2.5">
          <button
            onClick={() => setActiveTab("global")}
            className={`h-9 px-4 rounded-full font-sans font-bold text-[13px] transition-all focus:outline-none ${
              activeTab === "global"
                ? "bg-zinc-900 text-white"
                : "bg-white text-zinc-500 border border-zinc-200/80"
            }`}
          >
            Global {globalVouchers.length}
          </button>
          
          <button
            onClick={() => setActiveTab("personal")}
            className={`h-9 px-4 rounded-full font-sans font-bold text-[13px] transition-all focus:outline-none ${
              activeTab === "personal"
                ? "bg-zinc-900 text-white"
                : "bg-white text-zinc-500 border border-zinc-200/80"
            }`}
          >
            Personal {personalVouchers.length}
          </button>
        </div>

        {/* Vouchers List */}
        {loadingList ? (
          <div className="flex items-center justify-center py-12">
            <Loader2 className="h-6 w-6 animate-spin text-[#7B82F4]" />
          </div>
        ) : displayedVouchers.length === 0 ? (
          <div className="p-8 border border-dashed border-zinc-200 rounded-2xl text-center">
            <Tag className="h-10 w-10 text-zinc-300 mx-auto mb-2" />
            <p className="font-outfit text-[16px] font-bold text-zinc-800">
              No active promocodes
            </p>
            <p className="text-[12px] text-zinc-400 mt-1 max-w-[240px] mx-auto leading-relaxed">
              Vouchers listed here will automatically apply discount during checkout.
            </p>
          </div>
        ) : (
          <div className="space-y-4">
            {displayedVouchers.map((voucher) => (
              <div
                key={voucher.id}
                className="relative rounded-2xl border border-zinc-200 bg-white overflow-hidden shadow-sm flex flex-col"
              >
                {/* Purple Left Accent Border */}
                <div className="absolute left-0 top-0 bottom-0 w-1 bg-[#7B82F4]" />

                {/* Card Top Info */}
                <div className="p-5 flex flex-col pl-6">
                  <h3 className="font-outfit text-[16px] font-bold text-zinc-900">
                    {voucher.title}
                  </h3>
                  <p className="text-[13px] font-medium text-zinc-500 mt-1">
                    {voucher.description}
                  </p>
                </div>

                {/* Divider */}
                <div className="h-px bg-zinc-100 mx-5" />

                {/* Card Bottom Row */}
                <div className="px-5 py-3.5 flex items-center justify-between pl-6">
                  <button
                    onClick={() => alert(`Promo code: ${voucher.code}`)}
                    className="text-[12.5px] font-bold text-[#7B82F4] hover:opacity-85"
                  >
                    Learn more
                  </button>
                  <span className="text-[12px] font-medium text-zinc-400">
                    {formatDate(voucher.expires_at)}
                  </span>
                </div>
              </div>
            ))}
          </div>
        )}

      </div>
    </div>
  );
}
