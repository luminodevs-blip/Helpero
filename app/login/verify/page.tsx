"use client";

import React, { useState, useEffect, useRef } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { supabase } from "@/lib/supabase";
import { ArrowLeft } from "lucide-react";

export default function VerifyOtpPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const phone = searchParams.get("phone") || "";

  const [otp, setOtp] = useState<string[]>(Array(6).fill(""));
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [resendTimer, setResendTimer] = useState(60);
  const [canResend, setCanResend] = useState(false);

  const inputRefs = useRef<(HTMLInputElement | null)[]>([]);

  useEffect(() => {
    if (!phone) {
      router.replace("/login");
    }
  }, [phone, router]);

  // Resend Timer Countdown
  useEffect(() => {
    if (resendTimer > 0) {
      const timer = setTimeout(() => {
        setResendTimer(resendTimer - 1);
      }, 1000);
      return () => clearTimeout(timer);
    } else {
      setCanResend(true);
    }
  }, [resendTimer]);

  const handleInputChange = (value: string, index: number) => {
    // Keep only numbers
    const cleanValue = value.replace(/\D/g, "");
    if (!cleanValue) return;

    const newOtp = [...otp];
    // Take only the last character if multiple are entered
    newOtp[index] = cleanValue.slice(-1);
    setOtp(newOtp);

    // Auto-focus next input
    if (index < 5 && cleanValue) {
      inputRefs.current[index + 1]?.focus();
    }
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>, index: number) => {
    if (e.key === "Backspace") {
      if (!otp[index] && index > 0) {
        // Clear previous cell and focus it
        const newOtp = [...otp];
        newOtp[index - 1] = "";
        setOtp(newOtp);
        inputRefs.current[index - 1]?.focus();
      } else {
        // Clear current cell
        const newOtp = [...otp];
        newOtp[index] = "";
        setOtp(newOtp);
      }
    }
  };

  const handlePaste = (e: React.ClipboardEvent<HTMLInputElement>) => {
    e.preventDefault();
    const pastedData = e.clipboardData.getData("text").replace(/\D/g, "").slice(0, 6);
    
    if (pastedData.length === 6) {
      const newOtp = pastedData.split("");
      setOtp(newOtp);
      inputRefs.current[5]?.focus();
    }
  };

  const handleVerify = async (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    setError(null);

    const otpCode = otp.join("");
    if (otpCode.length < 6) {
      setError("Please enter the 6-digit confirmation code");
      return;
    }

    try {
      setLoading(true);
      const { error: verifyError, data } = await supabase.auth.verifyOtp({
        phone,
        token: otpCode,
        type: "sms",
      });

      if (verifyError) {
        setError(verifyError.message);
      } else if (data?.user) {
        // Route Guard Checks
        // 1. Check Profile
        const { data: profile } = await supabase
          .from("profiles")
          .select("id")
          .eq("id", data.user.id)
          .maybeSingle();

        if (!profile) {
          router.push(`/register?phone=${encodeURIComponent(phone)}`);
          return;
        }

        // 2. Check Houses
        const { data: houses } = await supabase
          .from("houses")
          .select("id")
          .eq("user_id", data.user.id)
          .limit(1);

        if (!houses || houses.length === 0) {
          router.push("/address/new");
        } else {
          router.push("/");
        }
      }
    } catch (err: any) {
      setError(err?.message || "Verification failed");
    } finally {
      setLoading(false);
    }
  };

  // Auto-submit when all 6 digits are entered
  useEffect(() => {
    if (otp.join("").length === 6) {
      handleVerify();
    }
  }, [otp]);

  const handleResend = async () => {
    if (!canResend) return;
    setError(null);
    setCanResend(false);
    setResendTimer(60);
    
    try {
      const { error: resendError } = await supabase.auth.signInWithOtp({
        phone,
      });
      if (resendError) {
        setError(resendError.message);
        setCanResend(true);
        setResendTimer(0);
      }
    } catch (err: any) {
      setError(err?.message || "Resend failed");
      setCanResend(true);
      setResendTimer(0);
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-[#1a1a2e] sm:p-4">
      <div className="w-full h-screen sm:h-auto sm:max-h-[95vh] overflow-y-auto bg-white flex flex-col justify-center px-6 py-8 sm:p-8 sm:rounded-[28px] sm:shadow-2xl max-w-[430px] border border-zinc-100 sm:border-zinc-200">
        {/* Back Button */}
        <div>
          <button
            onClick={() => router.push("/login")}
            className="flex items-center text-sm font-medium text-zinc-500 hover:text-zinc-800 transition-colors focus:outline-none"
          >
            <ArrowLeft className="mr-2 h-4 w-4" />
            Back to login
          </button>
        </div>

        {/* Title & Subtitle */}
        <div className="text-center">
          <h2 className="font-outfit text-3xl font-bold tracking-tight text-zinc-900">
            Confirm phone
          </h2>
          <p className="mt-2 text-sm text-zinc-500">
            A confirmation code has been sent to:
          </p>
          <p className="mt-1 text-base font-bold text-primary tracking-wide">
            {phone}
          </p>
        </div>

        {/* Error Alert */}
        {error && (
          <div className="rounded-lg bg-error/10 p-3 text-sm text-error border border-error/20">
            {error}
          </div>
        )}

        {/* OTP Pin Grid Form */}
        <form onSubmit={handleVerify} className="mt-8 space-y-6">
          <div className="flex justify-between gap-2">
            {otp.map((digit, idx) => (
              <input
                key={idx}
                type="text"
                maxLength={1}
                value={digit}
                ref={(el) => {
                  inputRefs.current[idx] = el;
                }}
                onChange={(e) => handleInputChange(e.target.value, idx)}
                onKeyDown={(e) => handleKeyDown(e, idx)}
                onPaste={idx === 0 ? handlePaste : undefined}
                className="w-12 h-14 text-center text-xl font-bold text-zinc-900 border border-zinc-200 rounded-xl bg-zinc-50 focus:border-[#7B61FF] focus:ring-2 focus:ring-[#7B61FF]/20 outline-none transition-all"
              />
            ))}
          </div>

          <div className="flex flex-col gap-4">
            <button
              type="submit"
              disabled={loading}
              className="flex w-full items-center justify-center h-14 rounded-xl text-white font-sans text-[15px] font-bold shadow-md focus:outline-none disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
              style={{ background: "#7B61FF" }}
            >
              {loading ? (
                <svg className="animate-spin h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                </svg>
              ) : (
                "Confirm"
              )}
            </button>

            <button
              type="button"
              disabled={!canResend}
              onClick={handleResend}
              className="text-sm font-bold text-primary disabled:text-text-secondary hover:text-primary/80 disabled:hover:text-text-secondary focus:outline-none transition-colors self-center py-2"
            >
              {canResend ? "Send again" : `Send again in ${resendTimer}s`}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
