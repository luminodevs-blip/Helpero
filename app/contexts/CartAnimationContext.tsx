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
  const [isFadingOut, setIsFadingOut] = useState(false);

  const triggerAnimation = (onComplete: () => void) => {
    setIsAnimating(true);
    setIsFadingOut(false);
    
    setTimeout(() => {
      setIsFadingOut(true);
      onComplete(); // This triggers navigation/state change behind the overlay
      
      // Remove overlay completely after fade out duration
      setTimeout(() => {
        setIsAnimating(false);
        setIsFadingOut(false);
      }, 500);
    }, 1200);
  };

  return (
    <CartAnimationContext.Provider value={{ triggerAnimation }}>
      {children}
      
      {/* Animation Overlay */}
      {isAnimating && (
        <div 
          className={`fixed inset-0 z-[99999] bg-primary flex items-center justify-center pointer-events-none transition-opacity duration-500 ${isFadingOut ? 'opacity-0' : 'opacity-100'}`}
          style={!isFadingOut ? { animation: "fadeOverlay 0.3s ease-out forwards" } : undefined}
        >
          <div className="w-[300px] h-[300px] flex items-center justify-center">
            <Lottie 
              animationData={animationData} 
              loop={false} 
              autoplay={true} 
              style={{ width: "100%", height: "100%" }}
            />
          </div>
          <style dangerouslySetInnerHTML={{__html: `
            @keyframes fadeOverlay {
              0% { opacity: 0; }
              100% { opacity: 1; }
            }
          `}} />
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
