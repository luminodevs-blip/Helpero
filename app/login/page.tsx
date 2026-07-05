"use client";

import React, { useState } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/supabase";
import { KeyRound, Mail } from "lucide-react";

export default function LoginPage() {
  const router = useRouter();
  const [phoneNumber, setPhoneNumber] = useState("");
  const [countryCode, setCountryCode] = useState("+1");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handlePhoneChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const cleaned = e.target.value.replace(/\D/g, "");
    if (cleaned.length <= 10) setPhoneNumber(cleaned);
  };

  const handlePhoneSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    const digitOnly = phoneNumber.replace(/\D/g, "");
    if (digitOnly.length < 10) {
      setError("Please enter a valid 10-digit phone number");
      return;
    }
    const fullPhone = `${countryCode}${digitOnly}`;
    try {
      setLoading(true);
      const { error: otpError } = await supabase.auth.signInWithOtp({ phone: fullPhone });
      if (otpError) setError(otpError.message);
      else router.push(`/login/verify?phone=${encodeURIComponent(fullPhone)}`);
    } catch (err: any) {
      setError(err?.message || "An unexpected error occurred");
    } finally {
      setLoading(false);
    }
  };

  const handleOAuthLogin = async (provider: "google" | "apple") => {
    setError(null);
    try {
      const { error: e } = await supabase.auth.signInWithOAuth({
        provider,
        options: { redirectTo: `${window.location.origin}/` },
      });
      if (e) setError(e.message);
    } catch (err: any) {
      setError(err?.message || "OAuth login failed");
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-[#1a1a2e] sm:p-4">
      {/* Phone-sized container: full screen on mobile, card on desktop */}
      <div className="relative w-full h-screen sm:h-[870px] sm:max-h-[95vh] sm:rounded-[28px] sm:shadow-2xl overflow-y-auto bg-white flex flex-col max-w-[430px] border border-zinc-100 sm:border-zinc-200">
        {/* ── PURPLE HEADER ───────────────────────────────────── */}
        <div
          className="relative overflow-hidden flex-shrink-0"
          style={{ background: "#7B61FF", height: 310 }}
        >
          {/* Floating pill: Offices — top-center, a bit right */}
          <div
            className="absolute flex items-center gap-1 bg-white rounded-2xl shadow-md px-4 py-2"
            style={{ top: 38, left: "50%", transform: "translateX(-16px)" }}
          >
            <span style={{ fontSize: 14 }}>☕</span>
            <span style={{ fontSize: 13, fontWeight: 700, color: "#1a1a1a" }}>Offices</span>
          </div>

          {/* Floating pill: Houses — left */}
          <div
            className="absolute flex items-center gap-1 bg-white rounded-2xl shadow-md px-4 py-2"
            style={{ top: 108, left: 18 }}
          >
            <span style={{ fontSize: 14 }}>🏠</span>
            <span style={{ fontSize: 13, fontWeight: 700, color: "#1a1a1a" }}>Houses</span>
          </div>

          {/* Floating pill: Apart — right */}
          <div
            className="absolute flex items-center gap-1 bg-white rounded-2xl shadow-md px-4 py-2"
            style={{ top: 118, right: 18 }}
          >
            <span style={{ fontSize: 14 }}>🏢</span>
            <span style={{ fontSize: 13, fontWeight: 700, color: "#1a1a1a" }}>Apart</span>
          </div>

          {/* Illustration — bottom-center */}
          <img
            src="/Handyman_and_cleaner_in_harmony.png"
            alt="Handyman and cleaner"
            style={{
              position: "absolute",
              bottom: 0,
              left: "50%",
              transform: "translateX(-50%)",
              height: 278,
              objectFit: "contain",
              userSelect: "none",
              pointerEvents: "none",
            }}
            draggable={false}
          />
        </div>

        {/* ── WHITE CARD ──────────────────────────────────────── */}
        <div
          style={{
            background: "#ffffff",
            borderRadius: "28px 28px 0 0",
            marginTop: -22,
            padding: "24px 24px 20px",
            position: "relative",
            zIndex: 10,
            flexGrow: 1,
            display: "flex",
            flexDirection: "column",
          }}
        >
          {/* Title */}
          <h2
            style={{
              fontFamily: "'Outfit', sans-serif",
              fontSize: 22,
              fontWeight: 800,
              color: "#111111",
              margin: "0 0 20px",
            }}
          >
            Welcome to Helpero
          </h2>

          {/* Error */}
          {error && (
            <div
              style={{
                marginBottom: 14,
                background: "#fff0f0",
                border: "1px solid #fca5a5",
                borderRadius: 12,
                padding: "10px 14px",
                fontSize: 12,
                color: "#dc2626",
              }}
            >
              {error}
            </div>
          )}

          {/* Phone row */}
          <form onSubmit={handlePhoneSubmit}>
            <div style={{ display: "flex", gap: 10, marginBottom: 12 }}>
              {/* Country selector */}
              <div
                style={{
                  position: "relative",
                  display: "flex",
                  alignItems: "center",
                  gap: 6,
                  border: "1.5px solid #e5e7eb",
                  borderRadius: 16,
                  background: "#f9fafb",
                  padding: "0 14px",
                  height: 54,
                  minWidth: 96,
                  cursor: "pointer",
                  userSelect: "none",
                }}
              >
                <span style={{ fontSize: 18 }}>🇨🇦</span>
                <span style={{ fontSize: 14, fontWeight: 700, color: "#111111" }}>
                  {countryCode}
                </span>
                <svg
                  width="10"
                  height="6"
                  viewBox="0 0 10 6"
                  fill="none"
                  style={{ marginLeft: 2 }}
                >
                  <path
                    d="M1 1l4 4 4-4"
                    stroke="#9ca3af"
                    strokeWidth="1.8"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  />
                </svg>
                <select
                  value={countryCode}
                  onChange={(e) => setCountryCode(e.target.value)}
                  style={{
                    position: "absolute",
                    inset: 0,
                    opacity: 0,
                    cursor: "pointer",
                    width: "100%",
                  }}
                >
                  <option value="+1">🇨🇦 Canada +1</option>
                  <option value="+7">🇷🇺 Russia +7</option>
                  <option value="+44">🇬🇧 UK +44</option>
                  <option value="+380">🇺🇦 Ukraine +380</option>
                </select>
              </div>

              {/* Phone input */}
              <input
                type="tel"
                required
                value={phoneNumber}
                onChange={handlePhoneChange}
                placeholder="Phone number"
                style={{
                  flex: 1,
                  border: "1.5px solid #e5e7eb",
                  borderRadius: 16,
                  background: "#f9fafb",
                  padding: "0 18px",
                  height: 54,
                  fontSize: 15,
                  fontWeight: 500,
                  color: "#111111",
                  outline: "none",
                }}
                onFocus={(e) => (e.target.style.borderColor = "#7B61FF")}
                onBlur={(e) => (e.target.style.borderColor = "#e5e7eb")}
              />
            </div>

            {/* Continue button */}
            <button
              type="submit"
              disabled={loading}
              style={{
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                width: "100%",
                height: 54,
                borderRadius: 16,
                background: loading ? "#a5a0e0" : "#7B61FF",
                color: "#ffffff",
                fontSize: 15,
                fontWeight: 700,
                border: "none",
                cursor: loading ? "not-allowed" : "pointer",
                transition: "background 0.15s",
                marginBottom: 0,
              }}
            >
              {loading ? (
                <svg
                  className="animate-spin"
                  width="22"
                  height="22"
                  fill="none"
                  viewBox="0 0 24 24"
                >
                  <circle
                    className="opacity-25"
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="white"
                    strokeWidth="4"
                  />
                  <path
                    className="opacity-75"
                    fill="white"
                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
                  />
                </svg>
              ) : (
                "Continue"
              )}
            </button>
          </form>

          {/* Divider */}
          <div
            style={{
              display: "flex",
              alignItems: "center",
              gap: 12,
              margin: "18px 0",
            }}
          >
            <div style={{ flex: 1, height: 1, background: "#e5e7eb" }} />
            <span style={{ fontSize: 13, color: "#9ca3af", fontWeight: 500 }}>or</span>
            <div style={{ flex: 1, height: 1, background: "#e5e7eb" }} />
          </div>

          {/* Social auth buttons — 4 square, bordered */}
          <div
            style={{
              display: "flex",
              justifyContent: "center",
              gap: 12,
              marginBottom: 20,
            }}
          >
            {/* Google */}
            <button
              onClick={() => handleOAuthLogin("google")}
              style={socialBtnStyle}
            >
              <svg width="22" height="22" viewBox="0 0 24 24">
                <path
                  d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                  fill="#4285F4"
                />
                <path
                  d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                  fill="#34A853"
                />
                <path
                  d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.63z"
                  fill="#FBBC05"
                />
                <path
                  d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.53 12-4.53z"
                  fill="#EA4335"
                />
              </svg>
            </button>

            {/* Key */}
            <button
              onClick={() =>
                setError("Email login is coming soon. Please use phone OTP.")
              }
              style={socialBtnStyle}
            >
              <KeyRound size={20} color="#374151" />
            </button>

            {/* Apple */}
            <button
              onClick={() => handleOAuthLogin("apple")}
              style={socialBtnStyle}
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="#111111">
                <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M15.97 4.17c.66-.81 1.11-1.93.99-3.06-1 .04-2.2.67-2.92 1.51-.62.73-1.16 1.87-1.01 2.98 1.11.08 2.25-.59 2.94-1.43z" />
              </svg>
            </button>

            {/* Email / @ */}
            <button
              onClick={() =>
                setError("Magic Link is coming soon. Please use phone OTP.")
              }
              style={socialBtnStyle}
            >
              <Mail size={20} color="#374151" />
            </button>
          </div>

          {/* Terms */}
          <p
            style={{
              textAlign: "center",
              fontSize: 11,
              color: "#6b7280",
              lineHeight: 1.6,
              margin: 0,
            }}
          >
            By continuing, you agree to our{" "}
            <a
              href="https://helpero.ca/terms"
              target="_blank"
              rel="noopener noreferrer"
              style={{ color: "#7B61FF", textDecoration: "underline" }}
            >
              Terms and Conditions
            </a>{" "}
            and{" "}
            <a
              href="https://helpero.ca/privacy"
              target="_blank"
              rel="noopener noreferrer"
              style={{ color: "#7B61FF", textDecoration: "underline" }}
            >
              Privacy Policy
            </a>
            . You&apos;ll receive notifications, which you can manage in your profile settings.
          </p>
        </div>
      </div>
    </div>
  );
}

// ── Shared style for social auth icon buttons ──────────────────────────
const socialBtnStyle: React.CSSProperties = {
  display: "flex",
  alignItems: "center",
  justifyContent: "center",
  width: 56,
  height: 56,
  borderRadius: 16,
  border: "1.5px solid #e5e7eb",
  background: "#ffffff",
  cursor: "pointer",
  boxShadow: "0 1px 3px rgba(0,0,0,0.06)",
  transition: "background 0.1s",
};
