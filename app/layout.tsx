import type { Metadata } from "next";
import { Outfit, Readex_Pro } from "next/font/google";
import { ClientAuthProvider } from "@/app/contexts/ClientAuthContext";
import { CartAnimationProvider } from "@/app/contexts/CartAnimationContext";
import "./globals.css";

const outfit = Outfit({
  variable: "--font-outfit",
  subsets: ["latin"],
  weight: ["300", "400", "500", "600", "700"],
});

const readexPro = Readex_Pro({
  variable: "--font-readex-pro",
  subsets: ["latin"],
  weight: ["300", "400", "500", "600", "700"],
});

export const metadata: Metadata = {
  title: "Helpero",
  description: "Premium Home Services Booking in Toronto",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${outfit.variable} ${readexPro.variable} h-full antialiased overflow-x-hidden`}
      suppressHydrationWarning
    >
      <body 
        className="min-h-full flex flex-col bg-bg-primary text-text-primary font-sans overflow-x-hidden"
        suppressHydrationWarning
      >
        <ClientAuthProvider>
          <CartAnimationProvider>
            {children}
          </CartAnimationProvider>
        </ClientAuthProvider>

        {/* Landscape Blocker Overlay */}
        <div className="hidden landscape:flex fixed inset-0 z-[9999] bg-primary text-white flex-col items-center justify-center p-8 text-center sm:hidden">
          <svg 
            xmlns="http://www.w3.org/2000/svg" 
            width="64" 
            height="64" 
            viewBox="0 0 24 24" 
            fill="none" 
            stroke="currentColor" 
            strokeWidth="1.5" 
            strokeLinecap="round" 
            strokeLinejoin="round" 
            className="mb-6 animate-bounce"
          >
            <rect x="5" y="2" width="14" height="20" rx="2" ry="2" transform="rotate(90 12 12)"></rect>
            <line x1="12" y1="18" x2="12.01" y2="18"></line>
          </svg>
          <h2 className="text-2xl font-bold font-outfit mb-3">Portrait Mode Only</h2>
          <p className="text-white/80 font-outfit text-[16px]">
            Please rotate your device back to portrait mode to use the app.
          </p>
        </div>
      </body>
    </html>
  );
}
