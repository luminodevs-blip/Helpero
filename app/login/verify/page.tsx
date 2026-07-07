"use client";

import React, { useState, useEffect, useRef, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { supabase } from "@/lib/supabase";
import { ArrowLeft, Loader2 } from "lucide-react";

function formatPhoneDisplay(phone: string): string {
  if (!phone.startsWith("+")) return phone;
  
  let cc = "";
  let digits = "";
  
  if (phone.startsWith("+1")) {
    cc = "+1";
    digits = phone.slice(2);
  } else if (phone.startsWith("+371")) {
    cc = "+371";
    digits = phone.slice(4);
  } else {
    cc = phone.slice(0, 3);
    digits = phone.slice(3);
  }

  if (cc === "+1") {
    if (digits.length <= 3) return `${cc} ${digits}`;
    if (digits.length <= 6) return `${cc} (${digits.slice(0, 3)}) ${digits.slice(3)}`;
    return `${cc} (${digits.slice(0, 3)}) ${digits.slice(3, 6)}-${digits.slice(6, 10)}`;
  }
  
  if (cc === "+44") {
    if (digits.length <= 4) return `${cc} ${digits}`;
    if (digits.length <= 7) return `${cc} ${digits.slice(0, 4)} ${digits.slice(4)}`;
    return `${cc} ${digits.slice(0, 4)} ${digits.slice(4, 7)}-${digits.slice(7, 10)}`;
  }
  
  if (digits.length <= 3) return `${cc} ${digits}`;
  if (digits.length <= 6) return `${cc} ${digits.slice(0, 3)} ${digits.slice(3)}`;
  return `${cc} ${digits.slice(0, 3)} ${digits.slice(3, 6)} ${digits.slice(6, 11)}`;
}

function VerifyOtpPageContent() {
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
    const cleanValue = value.replace(/\D/g, "");
    if (!cleanValue) return;

    if (cleanValue.length > 1) {
      const digits = cleanValue.split("").slice(0, 6);
      const newOtp = [...otp];
      for (let i = 0; i < digits.length; i++) {
        const targetIdx = index + i;
        if (targetIdx < 6) {
          newOtp[targetIdx] = digits[i];
        }
      }
      setOtp(newOtp);
      const focusIndex = Math.min(5, index + digits.length - 1);
      inputRefs.current[focusIndex]?.focus();
      return;
    }

    const newOtp = [...otp];
    newOtp[index] = cleanValue;
    setOtp(newOtp);

    if (index < 5) {
      inputRefs.current[index + 1]?.focus();
    }
  };

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>, index: number) => {
    if (e.key === "Backspace") {
      if (!otp[index] && index > 0) {
        const newOtp = [...otp];
        newOtp[index - 1] = "";
        setOtp(newOtp);
        inputRefs.current[index - 1]?.focus();
      } else {
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
        const { data: profile } = await supabase
          .from("profiles")
          .select("id")
          .eq("id", data.user.id)
          .maybeSingle();

        if (!profile) {
          router.push(`/register?phone=${encodeURIComponent(phone)}`);
          return;
        }

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
    setOtp(Array(6).fill(""));
    inputRefs.current[0]?.focus();

    try {
      const { error: resendError } = await supabase.auth.signInWithOtp({ phone });
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
    <div className="flex w-full min-h-screen items-center justify-center bg-[#1a1a2e] sm:p-4 animate-page-fade-in">
      {/* Phone-sized container: full screen on mobile, card on desktop */}
      <div className="relative w-full h-screen sm:h-[870px] sm:max-h-[95vh] overflow-hidden sm:rounded-[28px] sm:shadow-2xl bg-white flex flex-col max-w-[430px] border border-zinc-100 sm:border-zinc-200 px-6 pt-12 pb-8 sm:px-8 sm:py-8">
        {/* Back Button */}
        <div style={{ marginBottom: 34 }}>
          <button
            onClick={() => router.push("/login")}
            style={{
              display: "flex",
              alignItems: "center",
              background: "none",
              border: "none",
              cursor: "pointer",
              padding: 0,
              color: "#374151",
            }}
          >
            <ArrowLeft size={24} color="#374151" />
          </button>
        </div>

        {/* Title & Subtitle */}
        <div style={{ marginBottom: 32 }}>
          <h2
            style={{
              fontFamily: "'Outfit', sans-serif",
              fontSize: 24,
              fontWeight: 600,
              color: "#111111",
              margin: "0 0 10px",
              lineHeight: 1.2,
            }}
          >
            Confirm phone
          </h2>
          <p style={{ fontSize: 16, color: "#6b7280", margin: "0 0 4px", fontWeight: 400 }}>
            A confirmation code has been sent to:
          </p>
          <p style={{ fontSize: 16, color: "#111111", fontWeight: 400, margin: 0 }}>
            {formatPhoneDisplay(phone)}
          </p>
        </div>

        {/* Error Alert */}
        {error && (
          <div
            style={{
              marginBottom: 16,
              background: "#fff0f0",
              border: "1px solid #fca5a5",
              borderRadius: 10,
              padding: "10px 14px",
              fontSize: 13,
              color: "#dc2626",
            }}
          >
            {error}
          </div>
        )}

        {/* OTP Pin Grid */}
        <form onSubmit={handleVerify}>
          <div
            style={{
              display: "flex",
              justifyContent: "space-between",
              gap: 8,
              marginBottom: 32,
            }}
          >
            {otp.map((digit, idx) => (
              <input
                key={idx}
                type="text"
                inputMode="numeric"
                maxLength={1}
                autoComplete={idx === 0 ? "one-time-code" : "off"}
                value={digit}
                placeholder="–"
                ref={(el) => {
                  inputRefs.current[idx] = el;
                }}
                onChange={(e) => handleInputChange(e.target.value, idx)}
                onKeyDown={(e) => handleKeyDown(e, idx)}
                onPaste={idx === 0 ? handlePaste : undefined}
                style={{
                  width: 50,
                  height: 50,
                  flexShrink: 0,
                  textAlign: "center",
                  fontSize: 24,
                  fontWeight: 400,
                  color: "#111111",
                  border: "2px solid #e5e7eb",
                  borderRadius: 12,
                  background: "#ffffff",
                  outline: "none",
                  transition: "border-color 0.15s",
                }}
                onFocus={(e) => (e.target.style.borderColor = "#7B82F4")}
                onBlur={(e) => (e.target.style.borderColor = digit ? "#7B82F4" : "#e5e7eb")}
              />
            ))}
          </div>

          {/* Loading spinner shown while verifying */}
          {loading && (
            <div style={{ display: "flex", justifyContent: "center", marginBottom: 20 }}>
              <svg className="animate-spin h-6 w-6" style={{ color: "#7B82F4" }} fill="none" viewBox="0 0 24 24">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
              </svg>
            </div>
          )}

          {/* Resend */}
          <div style={{ textAlign: "center" }}>
            <button
              type="button"
              disabled={!canResend}
              onClick={handleResend}
              style={{
                background: "none",
                border: "none",
                cursor: canResend ? "pointer" : "default",
                fontSize: 16,
                fontWeight: 400,
                color: canResend ? "#7B82F4" : "#9ca3af",
                padding: "8px 0",
              }}
            >
              {canResend
                ? "Send again"
                : `Send again  ${String(Math.floor(resendTimer / 60)).padStart(2, "0")}:${String(resendTimer % 60).padStart(2, "0")}`}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default function VerifyOtpPage() {
  return (
    <Suspense
      fallback={
        <div
          style={{
            minHeight: "100dvh",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            background: "#ffffff",
          }}
        >
          <Loader2 className="h-6 w-6 animate-spin text-[#7B82F4]" />
        </div>
      }
    >
      <VerifyOtpPageContent />
    </Suspense>
  );
}
