"use client";

import React from "react";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { ShoppingCart } from "lucide-react";

interface CartIconProps {
  className?: string;
}

export default function CartIcon({ className = "" }: CartIconProps) {
  const { cart, setCartSheetOpen } = useClientAuth();

  return (
    <div 
      onClick={() => setCartSheetOpen(true)}
      className={`relative cursor-pointer hover:scale-105 active:scale-95 transition-all ${className}`}
    >
      <div className="flex items-center justify-center h-[42px] w-[42px] rounded-full border border-white/40 bg-white/10">
        <ShoppingCart className="h-4.5 w-4.5 text-white" />
      </div>
      {cart.length > 0 && (
        <span className="absolute -top-1 -right-1 flex h-5 w-5 items-center justify-center rounded-full bg-[#f43f5e] text-[9px] font-bold text-white shadow-md">
          {cart.length}
        </span>
      )}
    </div>
  );
}
