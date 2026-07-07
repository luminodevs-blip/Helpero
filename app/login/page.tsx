"use client";

import React, { useState } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/supabase";
import { KeyRound, Mail, X, Home, Building2, Coffee } from "lucide-react";
import { useBodyScrollLock } from "@/lib/useBodyScrollLock";

const countries = [
  { name: "United States", code: "+1", flag: "🇺🇸", short: "US" },
  { name: "Canada", code: "+1", flag: "🇨🇦", short: "CA" },
  { name: "United Kingdom", code: "+44", flag: "🇬🇧", short: "GB" },
  { name: "Germany", code: "+49", flag: "🇩🇪", short: "DE" },
  { name: "Poland", code: "+48", flag: "🇵🇱", short: "PL" },
  { name: "Norway", code: "+47", flag: "🇳🇴", short: "NO" },
  { name: "Japan", code: "+81", flag: "🇯🇵", short: "JP" },
  { name: "Hungary", code: "+36", flag: "🇭🇺", short: "HU" },
  { name: "Latvia", code: "+371", flag: "🇱🇻", short: "LV" },
  { name: "Switzerland", code: "+41", flag: "🇨🇭", short: "CH" },
  { name: "New Zealand", code: "+64", flag: "🇳🇿", short: "NZ" },
  { name: "Philippines", code: "+63", flag: "🇵🇭", short: "PH" },
];

const formatPhoneNumber = (value: string, countryShort: string) => {
  const digits = value.replace(/\D/g, "");
  if (countryShort === "US" || countryShort === "CA") {
    if (digits.length <= 3) return digits;
    if (digits.length <= 6) return `(${digits.slice(0, 3)}) ${digits.slice(3)}`;
    return `(${digits.slice(0, 3)}) ${digits.slice(3, 6)}-${digits.slice(6, 10)}`;
  }
  if (countryShort === "GB") {
    if (digits.length <= 4) return digits;
    if (digits.length <= 7) return `${digits.slice(0, 4)} ${digits.slice(4)}`;
    return `${digits.slice(0, 4)} ${digits.slice(4, 7)}-${digits.slice(7, 10)}`;
  }
  // Generic spacing for other countries (e.g. XXX XXX XXX)
  if (digits.length <= 3) return digits;
  if (digits.length <= 6) return `${digits.slice(0, 3)} ${digits.slice(3)}`;
  return `${digits.slice(0, 3)} ${digits.slice(3, 6)} ${digits.slice(6, 11)}`;
};

export default function LoginPage() {
  const router = useRouter();
  const [phoneNumber, setPhoneNumber] = useState("");
  const [countryCode, setCountryCode] = useState("+1");
  const [selectedCountry, setSelectedCountry] = useState(countries[1]); // Default to Canada
  const [isCountryModalOpen, setIsCountryModalOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  useBodyScrollLock(isCountryModalOpen);

  const filteredCountries = countries.filter(c => 
    c.name.toLowerCase().includes(searchQuery.toLowerCase()) || 
    c.code.includes(searchQuery)
  );

  const handlePhoneChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const cleaned = e.target.value.replace(/\D/g, "");
    const maxDigits = selectedCountry.short === "US" || selectedCountry.short === "CA" ? 10 : 11;
    if (cleaned.length <= maxDigits) {
      setPhoneNumber(cleaned);
    }
  };

  const handlePhoneSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    const digitOnly = phoneNumber.replace(/\D/g, "");
    const minDigits = selectedCountry.short === "US" || selectedCountry.short === "CA" ? 10 : 8;
    if (digitOnly.length < minDigits) {
      setError(
        selectedCountry.short === "US" || selectedCountry.short === "CA"
          ? "Please enter a valid 10-digit phone number"
          : "Please enter a valid phone number"
      );
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
    <div className="flex w-full min-h-screen items-center justify-center bg-[#1a1a2e] sm:p-4">
      {/* Phone-sized container: full screen on mobile, card on desktop */}
      <div className="relative w-full h-screen sm:h-[870px] sm:max-h-[95vh] overflow-hidden sm:rounded-[28px] sm:shadow-2xl bg-white flex flex-col max-w-[430px] sm:border sm:border-zinc-200">
        {/* ── PURPLE HEADER ───────────────────────────────────── */}
        <div
          className="relative overflow-hidden"
          style={{ background: "#7B82F4", height: 372, flexShrink: 0 }}
        >
          {/* Floating pill: Offices — top-center */}
          <div
            className="absolute"
            style={{
              top: 40,
              left: "50%",
              transform: "translateX(-50%)",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              gap: 6,
              width: 100,
              height: 40,
              borderRadius: 10,
              background: "#ffffff",
              boxShadow: "0 2px 4px rgba(0,0,0,0.2)",
            }}
          >
            <Coffee size={16} color="#7B82F4" className="shrink-0" />
            <span style={{ fontSize: 16, fontWeight: 600, color: "#1a1a1a" }}>Offices</span>
          </div>

          {/* Floating pill: Houses — left */}
          <div
            className="absolute"
            style={{
              top: 80,
              left: 16,
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              gap: 6,
              width: 100,
              height: 40,
              borderRadius: 10,
              background: "#ffffff",
              boxShadow: "0 2px 4px rgba(0,0,0,0.2)",
            }}
          >
            <Home size={24} color="#7B82F4" className="shrink-0" />
            <span style={{ fontSize: 16, fontWeight: 600, color: "#1a1a1a" }}>Houses</span>
          </div>

          {/* Floating pill: Apart — right */}
          <div
            className="absolute"
            style={{
              top: 95,
              right: 16,
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
              gap: 6,
              width: 100,
              height: 40,
              borderRadius: 10,
              background: "#ffffff",
              boxShadow: "0 2px 4px rgba(0,0,0,0.2)",
            }}
          >
            <Building2 size={24} color="#7B82F4" className="shrink-0" />
            <span style={{ fontSize: 16, fontWeight: 600, color: "#1a1a1a" }}>Apart</span>
          </div>

          {/* Illustration — 16px below Offices chip, 16px above white card */}
          <img
            src="/Handyman_and_cleaner_in_harmony.png"
            alt="Handyman and cleaner"
            style={{
              position: "absolute",
              top: 96,
              left: 24,
              width: "calc(100% - 48px)",
              height: 260,
              objectFit: "contain",
              objectPosition: "bottom center",
              userSelect: "none",
              pointerEvents: "none",
            }}
            draggable={false}
          />
        </div>

        <div
          style={{
            background: "#ffffff",
            borderRadius: "28px 28px 0 0",
            marginTop: -22,
            padding: "20px 24px 20px",
            position: "relative",
            zIndex: 10,
            flex: 1,
            display: "flex",
            flexDirection: "column",
          }}
        >
          {/* Title */}
          <h2
            style={{
              fontFamily: "'Outfit', sans-serif",
              fontSize: 24,
              fontWeight: 600,
              color: "#111111",
              margin: "0 0 22px",
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
                onClick={() => setIsCountryModalOpen(true)}
                style={{
                  position: "relative",
                  display: "flex",
                  alignItems: "center",
                  gap: 6,
                  border: "1.5px solid #e5e7eb",
                  borderRadius: 8,
                  background: "#f9fafb",
                  padding: "0 14px",
                  height: 54,
                  minWidth: 96,
                  cursor: "pointer",
                  userSelect: "none",
                }}
              >
                <span style={{ fontSize: 20, lineHeight: 1 }}>
                  {selectedCountry.flag}
                </span>
                <span style={{ fontSize: 16, fontWeight: 500, color: "#111111" }}>
                  {selectedCountry.code}
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
              </div>

              {/* Phone input */}
              <input
                type="tel"
                required
                value={formatPhoneNumber(phoneNumber, selectedCountry.short)}
                onChange={handlePhoneChange}
                placeholder="Phone number"
                style={{
                  flex: 1,
                  border: "1.5px solid #e5e7eb",
                  borderRadius: 8,
                  background: "#f9fafb",
                  padding: "0 18px",
                  height: 54,
                  fontSize: 16,
                  fontWeight: 500,
                  color: "#111111",
                  outline: "none",
                }}
                onFocus={(e) => (e.target.style.borderColor = "#7B82F4")}
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
                height: 56,
                borderRadius: 8,
                background: loading ? "#b0b4f8" : "#7B82F4",
                color: "#ffffff",
                fontSize: 18,
                fontWeight: 600,
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
            <span style={{ fontSize: 14, color: "#9ca3af", fontWeight: 500 }}>or</span>
            <div style={{ flex: 1, height: 1, background: "#e5e7eb" }} />
          </div>

          {/* Social auth buttons — 4 square, bordered */}
          <div
            style={{
              display: "flex",
              justifyContent: "center",
              gap: 9,
              marginBottom: 20,
            }}
          >
            {/* Google */}
            <button
              onClick={() => handleOAuthLogin("google")}
              style={socialBtnStyle}
            >
              <svg width="24" height="24" viewBox="0 0 24 24">
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
              <KeyRound size={28} color="#374151" />
            </button>

            {/* Apple */}
            <button
              onClick={() => handleOAuthLogin("apple")}
              style={socialBtnStyle}
            >
              <svg width="30" height="30" viewBox="0 0 24 24" fill="#111111">
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
              <Mail size={28} color="#374151" />
            </button>
          </div>

          {/* Terms */}
          <p
            style={{
              textAlign: "center",
              fontSize: 14,
              fontWeight: 400,
              color: "#6b7280",
              lineHeight: 1.6,
              margin: 0,
              marginBottom: 60,
            }}
          >
            By continuing, you agree to our{" "}
            <a
              href="https://helpero.ca/terms"
              target="_blank"
              rel="noopener noreferrer"
              style={{ color: "#7B82F4", textDecoration: "underline" }}
            >
              Terms and Conditions
            </a>{" "}
            and{" "}
            <a
              href="https://helpero.ca/privacy"
              target="_blank"
              rel="noopener noreferrer"
              style={{ color: "#7B82F4", textDecoration: "underline" }}
            >
              Privacy Policy
            </a>
            . You&apos;ll receive notifications, which you can manage in your profile settings.
          </p>

          {isCountryModalOpen && (
            <div className="fixed inset-0 z-[9999] flex flex-col justify-end bg-black/45 animate-fade-in">
              {/* Backdrop */}
              <div 
                className="absolute inset-0 cursor-default" 
                onClick={() => setIsCountryModalOpen(false)} 
              />
              
              {/* Modal Container */}
              <div className="relative bg-white rounded-t-[28px] h-full flex flex-col overflow-hidden animate-slide-up" style={{ boxShadow: "0 -8px 40px rgba(0,0,0,0.18)" }}>
                {/* Header */}
                <div className="px-6 pt-6 pb-4 flex items-center justify-between border-b border-zinc-100">
                  <span className="font-outfit text-[20px] font-extrabold text-zinc-900">
                    Select Country
                  </span>
                  <button
                    type="button"
                    onClick={() => setIsCountryModalOpen(false)}
                    className="h-8 w-8 rounded-full bg-zinc-100 hover:bg-zinc-200 flex items-center justify-center text-zinc-600 transition-colors focus:outline-none"
                  >
                    <X className="h-4 w-4" />
                  </button>
                </div>

                {/* Search Input */}
                <div className="px-6 py-4">
                  <input
                    type="text"
                    placeholder="Search by country or code"
                    value={searchQuery}
                    onChange={(e) => setSearchQuery(e.target.value)}
                    className="w-full h-12 px-4 bg-[#F1F4F8] text-[15px] font-semibold text-zinc-900 placeholder-zinc-400 rounded-2xl border border-transparent focus:border-zinc-200 outline-none transition-all"
                  />
                </div>

                {/* Country List */}
                <div className="flex-1 overflow-y-auto px-6 pb-6 space-y-1">
                  {filteredCountries.map((c) => (
                    <div
                      key={c.short}
                      onClick={() => {
                        setSelectedCountry(c);
                        setCountryCode(c.code);
                        setIsCountryModalOpen(false);
                        setSearchQuery("");
                      }}
                      className="flex items-center justify-between py-3.5 px-2 hover:bg-zinc-50 rounded-2xl cursor-pointer transition-colors"
                    >
                      <div className="flex items-center gap-3">
                        <span className="text-2xl shrink-0 leading-none">{c.flag}</span>
                        <span className="font-sans text-[15px] font-semibold text-zinc-900">
                          {c.name}
                        </span>
                      </div>
                      <span className="font-sans text-[15px] font-bold text-zinc-900">
                        {c.code}
                      </span>
                    </div>
                  ))}
                  {filteredCountries.length === 0 && (
                    <div className="text-center py-12 text-zinc-400 text-sm font-semibold">
                      No countries found
                    </div>
                  )}
                </div>
              </div>
            </div>
          )}
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
  width: 100,
  height: 60,
  borderRadius: 16,
  border: "1.5px solid #e5e7eb",
  background: "#ffffff",
  cursor: "pointer",
  boxShadow: "0 2px 4px #f5f7fb",
  transition: "background 0.1s",
};
