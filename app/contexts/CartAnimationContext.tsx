"use client";

import React, { createContext, useContext, useState, ReactNode } from "react";
import dynamic from "next/dynamic";
import animationData from "@/addToCartAnimation.json";

// Dynamically import Lottie to avoid SSR issues
const Lottie = dynamic(() => import("lottie-react"), { ssr: false });

interface CartAnimationContextType {
  triggerAnimation: (onComplete: () => void) => void;
}

const CartAnimationContext = createContext<CartAnimationContextType | undefined>(undefined);

export function CartAnimationProvider({ children }: { children: ReactNode }) {
  const [isAnimating, setIsAnimating] = useState(false);

  const triggerAnimation = (onComplete: () => void) => {
    setIsAnimating(true);
    setTimeout(() => {
      setIsAnimating(false);
      onComplete();
    }, 1050);
  };

  return (
    <CartAnimationContext.Provider value={{ triggerAnimation }}>
      {children}
      
      {/* Animation Overlay */}
      {isAnimating && (
        <div className="fixed inset-0 z-[99999] bg-primary flex items-center justify-center pointer-events-none">
          <div className="w-[300px] h-[300px] flex items-center justify-center">
            <Lottie 
              animationData={animationData} 
              loop={false} 
              autoplay={true} 
              style={{ width: "100%", height: "100%" }}
            />
          </div>
        </div>
      )}
    </CartAnimationContext.Provider>
  );
}

export function useCartAnimation() {
  const context = useContext(CartAnimationContext);
  if (context === undefined) {
    throw new Error("useCartAnimation must be used within a CartAnimationProvider");
  }
  return context;
}
