"use client";

import React, { useState, useEffect, useRef, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { supabase } from "@/lib/supabase";
import { ArrowLeft, Loader2 } from "lucide-react";

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

    const newOtp = [...otp];
    newOtp[index] = cleanValue.slice(-1);
    setOtp(newOtp);

    if (index < 5 && cleanValue) {
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
    <div
      style={{
        minHeight: "100dvh",
        background: "#ffffff",
        display: "flex",
        flexDirection: "column",
        padding: "0 24px",
        maxWidth: 430,
        margin: "0 auto",
        boxSizing: "border-box",
      }}
    >
      {/* Back Button */}
      <div style={{ paddingTop: 56, marginBottom: 32 }}>
        <button
          onClick={() => router.push("/login")}
          style={{
            display: "flex",
            alignItems: "center",
            gap: 6,
            background: "none",
            border: "none",
            cursor: "pointer",
            padding: 0,
            color: "#374151",
            fontSize: 14,
            fontWeight: 500,
          }}
        >
          <ArrowLeft size={18} color="#374151" />
          Back to login
        </button>
      </div>

      {/* Title & Subtitle */}
      <div style={{ marginBottom: 32 }}>
        <h2
          style={{
            fontFamily: "'Outfit', sans-serif",
            fontSize: 28,
            fontWeight: 700,
            color: "#111111",
            margin: "0 0 10px",
            lineHeight: 1.2,
          }}
        >
          Confirm phone
        </h2>
        <p style={{ fontSize: 14, color: "#6b7280", margin: "0 0 4px", fontWeight: 400 }}>
          A confirmation code has been sent to:
        </p>
        <p style={{ fontSize: 15, color: "#7B82F4", fontWeight: 700, margin: 0 }}>
          {phone}
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
            marginBottom: 28,
          }}
        >
          {otp.map((digit, idx) => (
            <input
              key={idx}
              type="text"
              inputMode="numeric"
              maxLength={1}
              value={digit}
              ref={(el) => {
                inputRefs.current[idx] = el;
              }}
              onChange={(e) => handleInputChange(e.target.value, idx)}
              onKeyDown={(e) => handleKeyDown(e, idx)}
              onPaste={idx === 0 ? handlePaste : undefined}
              style={{
                flex: 1,
                height: 56,
                textAlign: "center",
                fontSize: 22,
                fontWeight: 700,
                color: "#111111",
                border: "1.5px solid #e5e7eb",
                borderRadius: 12,
                background: "#ffffff",
                outline: "none",
                transition: "border-color 0.15s",
              }}
              onFocus={(e) => (e.target.style.borderColor = "#7B82F4")}
              onBlur={(e) => (e.target.style.borderColor = "#e5e7eb")}
            />
          ))}
        </div>

        {/* Confirm Button */}
        <button
          type="submit"
          disabled={loading}
          style={{
            width: "100%",
            height: 56,
            borderRadius: 12,
            background: "#7B82F4",
            border: "none",
            color: "#ffffff",
            fontSize: 18,
            fontWeight: 700,
            cursor: loading ? "not-allowed" : "pointer",
            opacity: loading ? 0.7 : 1,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            marginBottom: 20,
            transition: "opacity 0.15s",
          }}
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
              fontSize: 14,
              fontWeight: 600,
              color: canResend ? "#7B82F4" : "#9ca3af",
              padding: "8px 0",
            }}
          >
            {canResend ? "Send again" : `Send again in ${resendTimer}s`}
          </button>
        </div>
      </form>
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
