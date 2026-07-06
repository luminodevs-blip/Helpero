"use client";

import { useEffect } from "react";
import { useRouter, usePathname } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";

import CartSheet from "@/components/CartSheet";

export default function AppLayout({ children }: { children: React.ReactNode }) {
  const { user, profile, selectedAddress, isLoading } = useClientAuth();
  const router = useRouter();
  const pathname = usePathname();

  useEffect(() => {
    if (isLoading) return;

    if (!user) {
      router.replace("/login");
      return;
    }

    if (!profile) {
      router.replace(`/register?phone=${encodeURIComponent(user.phone || "")}`);
      return;
    }

    // If they have no address and are not already on the address creation page, redirect
    if (!selectedAddress && pathname !== "/address/new") {
      router.replace("/address/new");
      return;
    }
  }, [user, profile, selectedAddress, isLoading, pathname, router]);

  if (isLoading) {
    return (
      <div className="flex h-screen w-screen items-center justify-center bg-bg-primary">
        <svg className="animate-spin h-10 w-10 text-primary" fill="none" viewBox="0 0 24 24">
          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
        </svg>
      </div>
    );
  }

  // While redirecting, show a spinner to avoid flash of protected content
  if (!user || !profile || (!selectedAddress && pathname !== "/address/new")) {
    return (
      <div className="flex h-screen w-screen items-center justify-center bg-bg-primary">
        <svg className="animate-spin h-10 w-10 text-primary" fill="none" viewBox="0 0 24 24">
          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
        </svg>
      </div>
    );
  }

  return (
    <>
      {children}
      <CartSheet />
    </>
  );
}
