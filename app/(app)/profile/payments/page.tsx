"use client";

import React, { useState, useEffect } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import {
  ArrowLeft,
  CreditCard,
  Plus,
  ChevronRight,
  Loader2,
} from "lucide-react";

export default function PaymentsPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const fromCheckout = searchParams.get("fromCheckout") === "true";
  const { user } = useClientAuth();

  const [balance, setBalance] = useState<{ amount: string; currency_code: string } | null>(null);
  const [loadingBalance, setLoadingBalance] = useState(true);
  const [selectedMethod, setSelectedMethod] = useState<"apple_pay" | "bank_card">("bank_card");

  useEffect(() => {
    // Load preferred payment method from localStorage
    const saved = localStorage.getItem("preferred_payment_method");
    if (saved === "apple_pay" || saved === "bank_card") {
      setSelectedMethod(saved);
    } else {
      // Fallback: Default to bank card as specified
      setSelectedMethod("bank_card");
    }

    if (!user) return;

    // Fetch user balance
    const fetchBalance = async () => {
      try {
        setLoadingBalance(true);
        const { data, error } = await supabase
          .from("user_balance")
          .select("amount, currency_code")
          .eq("user_id", user.id)
          .maybeSingle();

        if (!error && data) {
          setBalance({
            amount: Number(data.amount).toFixed(2),
            currency_code: data.currency_code || "USD",
          });
        } else {
          setBalance({ amount: "0.00", currency_code: "USD" });
        }
      } catch (err) {
        console.error("Error fetching balance:", err);
        setBalance({ amount: "0.00", currency_code: "USD" });
      } finally {
        setLoadingBalance(false);
      }
    };

    fetchBalance();
  }, [user]);

  const handleSelectMethod = (method: "apple_pay" | "bank_card") => {
    setSelectedMethod(method);
    localStorage.setItem("preferred_payment_method", method);
    
    // Save to last order payment method helper
    localStorage.setItem("last_payment_method", method);
  };

  const handleBack = () => {
    if (fromCheckout) {
      router.push("/checkout");
    } else {
      router.push("/profile");
    }
  };

  return (
    <div className="flex flex-col flex-1 bg-white min-h-screen">
      {/* Header */}
      <div className="px-5 pt-8 pb-4 flex flex-col gap-4">
        <button
          onClick={handleBack}
          className="p-2 -ml-2 self-start rounded-full hover:bg-zinc-100 transition-colors"
        >
          <ArrowLeft className="h-6 w-6 text-zinc-900" />
        </button>
        <h1 className="font-outfit text-[28px] font-bold text-zinc-900 leading-tight">
          Payment method
        </h1>
      </div>

      {/* Content */}
      <div className="px-5 space-y-6 flex-1 pb-10">
        {/* Helpero Credits Card */}
        <div className="rounded-[16px] border border-zinc-200 bg-white p-5 shadow-sm">
          <div className="flex flex-col">
            <span className="text-[12px] font-bold text-zinc-500 uppercase tracking-wider">
              Helpero-credits
            </span>
            {loadingBalance ? (
              <div className="h-10 flex items-center mt-1">
                <Loader2 className="h-5 w-5 animate-spin text-zinc-400" />
              </div>
            ) : (
              <span className="font-outfit text-[32px] font-extrabold text-zinc-900 mt-1">
                {balance?.amount} $
              </span>
            )}
          </div>
          
          <div className="h-px bg-zinc-100 my-4" />

          <button
            onClick={() => alert("Transaction history coming soon")}
            className="w-full flex items-center justify-between text-zinc-500 hover:text-zinc-700 transition-colors"
          >
            <span className="text-[13px] font-semibold">View transactions</span>
            <ChevronRight className="h-4 w-4" />
          </button>
        </div>

        {/* Saved Methods */}
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <span className="text-[11px] font-bold text-zinc-400 tracking-wider uppercase">
              Saved Methods
            </span>
            <button
              onClick={() => alert("Edit saved methods coming soon")}
              className="text-[13px] font-bold text-[#7B82F4] hover:opacity-85"
            >
              Change
            </button>
          </div>

          {/* Apple Pay Card */}
          <div
            onClick={() => handleSelectMethod("apple_pay")}
            className={`flex items-center justify-between p-4 rounded-[16px] border cursor-pointer transition-colors bg-[#F8F9FA] ${
              selectedMethod === "apple_pay" ? "border-[#7B82F4]" : "border-zinc-100"
            }`}
          >
            <div className="flex items-center gap-3">
              <div className="h-10 w-[52px] bg-black rounded-[8px] flex items-center justify-center shrink-0 shadow-sm">
                <span className="text-white font-extrabold text-[12px] tracking-tight"> Pay</span>
              </div>
              <div className="flex flex-col">
                <span className="font-outfit text-[15px] font-bold text-zinc-900">
                  Apple Pay
                </span>
                <span className="text-[11px] font-medium text-zinc-500">
                  Fast and secure
                </span>
              </div>
            </div>
            <div
              className={`h-5 w-5 rounded-full border-2 flex items-center justify-center shrink-0 transition-colors ${
                selectedMethod === "apple_pay"
                  ? "border-[#7B82F4] bg-white"
                  : "border-zinc-200"
              }`}
            >
              {selectedMethod === "apple_pay" && (
                <div className="h-2.5 w-2.5 rounded-full bg-[#7B82F4]" />
              )}
            </div>
          </div>

          {/* Bank Card Card */}
          <div
            onClick={() => handleSelectMethod("bank_card")}
            className={`flex items-center justify-between p-4 rounded-[16px] border cursor-pointer transition-colors bg-white ${
              selectedMethod === "bank_card" ? "border-[#7B82F4]" : "border-zinc-200"
            }`}
          >
            <div className="flex items-center gap-3">
              <div className="h-10 w-[52px] border border-zinc-200 rounded-[8px] flex items-center justify-center shrink-0 bg-white">
                <CreditCard className="h-5 w-5 text-zinc-700" />
              </div>
              <div className="flex flex-col">
                <span className="font-outfit text-[15px] font-bold text-zinc-900">
                  Bank Card
                </span>
                <span className="text-[11px] font-medium text-zinc-500">
                  Stripe Connect
                </span>
              </div>
            </div>
            <div
              className={`h-5 w-5 rounded-full border-2 flex items-center justify-center shrink-0 transition-colors ${
                selectedMethod === "bank_card"
                  ? "border-[#7B82F4] bg-white"
                  : "border-zinc-200"
              }`}
            >
              {selectedMethod === "bank_card" && (
                <div className="h-2.5 w-2.5 rounded-full bg-[#7B82F4]" />
              )}
            </div>
          </div>
        </div>

        {/* Separator */}
        <div className="flex items-center justify-center gap-4 text-[12px] font-bold text-zinc-400 tracking-wider">
          <div className="h-px bg-zinc-100 flex-1" />
          <span>OR</span>
          <div className="h-px bg-zinc-100 flex-1" />
        </div>

        {/* Try another way to pay */}
        <div
          onClick={() => alert("Add payment method coming soon")}
          className="flex items-center justify-between p-4 rounded-[16px] border border-zinc-200 bg-white cursor-pointer hover:bg-zinc-50 transition-colors"
        >
          <div className="flex items-center gap-3">
            <div className="h-10 w-[52px] bg-[#7B82F4]/10 rounded-[8px] flex items-center justify-center shrink-0">
              <Plus className="h-5 w-5 text-[#7B82F4]" />
            </div>
            <div className="flex flex-col">
              <span className="font-outfit text-[15px] font-bold text-zinc-900">
                Try another way to pay
              </span>
              <span className="text-[11px] font-medium text-zinc-500">
                Add another way to pay
              </span>
            </div>
          </div>
          <ChevronRight className="h-5 w-5 text-zinc-400" />
        </div>
      </div>
    </div>
  );
}
