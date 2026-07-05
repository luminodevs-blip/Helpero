"use client";

import React, { createContext, useContext, useState, ReactNode } from "react";

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
          <div className="relative flex flex-col items-center justify-center mt-[-10vh]">
            
            {/* The dropping item (glassmorphism style) */}
            <div 
              className="absolute -top-[110px] w-[60px] h-[80px] rounded-[10px] border-[1.5px] border-white/20 bg-white/20 backdrop-blur-sm flex flex-col items-center justify-center gap-1.5 opacity-0 z-10"
              style={{ animation: "dropItem 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) 0.1s forwards" }}
            >
              <div className="w-[30px] h-[34px] rounded-[6px] bg-white/20 border border-white/10" />
              <div className="w-[34px] h-[5px] rounded-full bg-white/20" />
              <div className="w-[24px] h-[5px] rounded-full bg-white/20" />
            </div>

            {/* The Cart and Motion Lines Container */}
            <div 
              className="relative flex items-center justify-center opacity-0 z-20"
              style={{ animation: "slideInCart 0.4s ease-out forwards" }}
            >
              {/* Motion lines (Speed lines) */}
              <div className="absolute -left-12 flex flex-col gap-[14px]">
                <div className="w-6 h-2 rounded-full bg-white/90" />
                <div className="w-10 h-2 rounded-full bg-white/90 -ml-5" />
              </div>

              {/* Shopping Cart Icon (custom SVG to match the screenshot) */}
              <svg 
                width="110" 
                height="110" 
                viewBox="0 0 24 24" 
                fill="none" 
                stroke="white" 
                strokeWidth="2" 
                strokeLinecap="round" 
                strokeLinejoin="round" 
              >
                <circle cx="9" cy="20" r="2.5" fill="white" stroke="none" />
                <circle cx="20" cy="20" r="2.5" fill="white" stroke="none" />
                <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6" fill="white" stroke="white" strokeWidth="0.5" />
                <path d="M10 11l4-4m0 0l4 4m-4-4v9" stroke="white" strokeWidth="1" strokeLinecap="round" opacity="0.3" />
              </svg>
            </div>

            <style dangerouslySetInnerHTML={{__html: `
              @keyframes dropItem {
                0% { transform: translateY(-30px) scale(0.9); opacity: 0; }
                30% { opacity: 1; transform: translateY(0px) scale(1); }
                100% { transform: translateY(110px) scale(0.5); opacity: 0; }
              }
              @keyframes slideInCart {
                0% { transform: translateX(40px); opacity: 0; }
                100% { transform: translateX(0); opacity: 1; }
              }
            `}} />
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
