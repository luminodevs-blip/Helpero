"use client";

import React, { useState, useEffect, Suspense } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { supabase } from "@/lib/supabase";
import { Loader2 } from "lucide-react";

function RegisterPageContent() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const phone = searchParams.get("phone") || "";

  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [email, setEmail] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [user, setUser] = useState<any>(null);

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      if (!data.user) {
        router.replace("/login");
      } else {
        setUser(data.user);
        // Pre-fill email if available from OAuth
        if (data.user.email) {
          setEmail(data.user.email);
        }
      }
    });
  }, [router]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) return;
    
    setError(null);
    setLoading(true);

    try {
      // Upsert profile in Supabase
      const { error: profileError } = await supabase
        .from("profiles")
        .upsert({
          id: user.id,
          first_name: firstName.trim(),
          last_name: lastName.trim(),
          email: email.trim(),
          phone_number: phone || user.phone || null,
          is_phone_verified: !!(phone || user.phone),
          role: "client",
          language: "en",
        });

      if (profileError) {
        setError(profileError.message);
      } else {
        // Since it's a new profile, redirect to Add First Address page
        router.push("/address/new");
      }
    } catch (err: any) {
      setError(err?.message || "Failed to create profile");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-bg-primary px-4 py-12 sm:px-6 lg:px-8">
      <div className="w-full max-w-md space-y-8 rounded-2xl bg-bg-secondary p-8 shadow-sm border border-alternate">
        {/* Title & Subtitle */}
        <div className="text-center">
          <h2 className="font-outfit text-3xl font-bold tracking-tight text-text-primary">
            Complete Profile
          </h2>
          <p className="mt-2 text-sm text-text-secondary">
            Please enter your details to complete registration
          </p>
        </div>

        {/* Error Alert */}
        {error && (
          <div className="rounded-lg bg-error/10 p-3 text-sm text-error border border-error/20">
            {error}
          </div>
        )}

        {/* Registration Form */}
        <form onSubmit={handleSubmit} className="mt-8 space-y-5">
          <div className="space-y-4">
            {/* First Name Input */}
            <div>
              <label htmlFor="first-name" className="block text-sm font-semibold text-text-secondary mb-1">
                First Name
              </label>
              <input
                id="first-name"
                type="text"
                required
                value={firstName}
                onChange={(e) => setFirstName(e.target.value)}
                placeholder="John"
                className="block w-full border border-alternate bg-bg-primary rounded-xl px-4 py-3 text-text-primary placeholder-text-secondary focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none text-base font-medium"
              />
            </div>

            {/* Last Name Input */}
            <div>
              <label htmlFor="last-name" className="block text-sm font-semibold text-text-secondary mb-1">
                Last Name
              </label>
              <input
                id="last-name"
                type="text"
                required
                value={lastName}
                onChange={(e) => setLastName(e.target.value)}
                placeholder="Doe"
                className="block w-full border border-alternate bg-bg-primary rounded-xl px-4 py-3 text-text-primary placeholder-text-secondary focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none text-base font-medium"
              />
            </div>

            {/* Email Input */}
            <div>
              <label htmlFor="email" className="block text-sm font-semibold text-text-secondary mb-1">
                Email Address
              </label>
              <input
                id="email"
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="john.doe@example.com"
                className="block w-full border border-alternate bg-bg-primary rounded-xl px-4 py-3 text-text-primary placeholder-text-secondary focus:border-primary focus:ring-2 focus:ring-primary/20 outline-none text-base font-medium"
              />
            </div>

            {/* Phone (Read Only if passed) */}
            {phone && (
              <div>
                <label className="block text-sm font-semibold text-text-secondary mb-1">
                  Phone Number
                </label>
                <input
                  type="text"
                  disabled
                  value={phone}
                  className="block w-full border border-alternate bg-bg-primary/50 rounded-xl px-4 py-3 text-text-secondary cursor-not-allowed outline-none text-base font-medium"
                />
              </div>
            )}
          </div>

          <div>
            <button
              type="submit"
              disabled={loading}
              className="flex w-full items-center justify-center h-14 rounded-full bg-primary text-white font-sans text-base font-bold shadow-md hover:bg-primary/95 focus:outline-none focus:ring-2 focus:ring-primary/50 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              {loading ? (
                <svg className="animate-spin h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                </svg>
              ) : (
                "Save Profile"
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default function RegisterPage() {
  return (
    <Suspense fallback={
      <div className="flex min-h-screen items-center justify-center bg-bg-primary px-4 py-12">
        <div className="text-text-primary text-lg font-semibold flex items-center gap-2">
          <Loader2 className="h-5 w-5 animate-spin text-primary" />
          Loading...
        </div>
      </div>
    }>
      <RegisterPageContent />
    </Suspense>
  );
}
