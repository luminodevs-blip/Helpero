"use client";

import { useEffect, useState } from "react";
import { Bell } from "lucide-react";
import { useBodyScrollLock } from "@/lib/useBodyScrollLock";

const ONESIGNAL_APP_ID = "91eebd03-3003-4676-8534-99e9e4f6df92";

export default function OneSignalInit() {
  const [showPrompt, setShowPrompt] = useState(false);
  const [oneSignalInstance, setOneSignalInstance] = useState<any>(null);
  const [dismissing, setDismissing] = useState(false);

  useBodyScrollLock(showPrompt);

  useEffect(() => {
    if (typeof window === "undefined") return;

    const script = document.createElement("script");
    script.src = "https://cdn.onesignal.com/sdks/web/v16/OneSignalSDK.page.js";
    script.defer = true;
    script.onload = () => {
      (window as any).OneSignalDeferred = (window as any).OneSignalDeferred || [];
      (window as any).OneSignalDeferred.push(async (OneSignal: any) => {
        try {
          await OneSignal.init({
            appId: ONESIGNAL_APP_ID,
            serviceWorkerPath: "/OneSignalSDKWorker.js",
            notifyButton: { enable: false },
            allowLocalhostAsSecureOrigin: true,
          });

          const isSubscribed = await OneSignal.User.PushSubscription.optedIn;
          if (!isSubscribed) {
            // Delay to let the page settle before showing prompt
            setTimeout(() => {
              setOneSignalInstance(OneSignal);
              setShowPrompt(true);
            }, 2500);
          }
        } catch (err) {
          console.warn("[OneSignal] Init skipped:", err);
        }
      });
    };
    document.head.appendChild(script);

    return () => {
      if (document.head.contains(script)) document.head.removeChild(script);
    };
  }, []);

  const dismiss = () => {
    setDismissing(true);
    setTimeout(() => setShowPrompt(false), 300);
  };

  const handleAllow = async () => {
    dismiss();
    if (oneSignalInstance) {
      try {
        await oneSignalInstance.Notifications.requestPermission();
      } catch (e) {
        console.warn("[OneSignal] Permission denied:", e);
      }
    }
  };

  if (!showPrompt) return null;

  return (
    <>
      {/* Backdrop */}
      <div
        className="fixed inset-0 z-[9998] bg-black/30 backdrop-blur-[2px]"
        style={{
          animation: dismissing
            ? "fade-in 0.25s ease-out reverse both"
            : "fade-in 0.25s ease-out both",
        }}
        onClick={dismiss}
      />

      {/* Sheet */}
      <div
        className="fixed bottom-0 left-0 right-0 z-[9999] flex justify-center pointer-events-none"
      >
        <div
          className="w-full max-w-[430px] pointer-events-auto"
          style={{
            animation: dismissing
              ? "slide-up 0.28s cubic-bezier(0.16,1,0.3,1) reverse both"
              : "slide-up 0.38s cubic-bezier(0.16,1,0.3,1) both",
          }}
        >
          {/* Card */}
          <div
            className="bg-white rounded-t-[28px] px-6 pt-5 pb-10 shadow-2xl"
            style={{ boxShadow: "0 -8px 40px rgba(0,0,0,0.14)" }}
          >
            {/* Drag handle */}
            <div className="w-9 h-[4px] bg-zinc-200 rounded-full mx-auto mb-5" />

            {/* Content row */}
            <div className="flex items-start gap-4 mb-6">
              {/* App icon */}
              <div
                className="w-[60px] h-[60px] rounded-[14px] flex items-center justify-center flex-shrink-0 shadow-sm"
                style={{ background: "linear-gradient(135deg, #7B82F4 0%, #9b5de5 100%)" }}
              >
                <Bell className="w-7 h-7 text-white" strokeWidth={2.2} />
              </div>

              {/* Text */}
              <div className="flex-1 pt-0.5">
                <p className="font-outfit text-[17px] font-bold text-zinc-900 leading-snug mb-1">
                  Stay in the loop
                </p>
                <p className="text-[14px] font-medium text-zinc-500 leading-relaxed">
                  Get notified when your pro is on the way, your booking is confirmed, and more.
                </p>
              </div>
            </div>

            {/* Buttons */}
            <div className="flex flex-col gap-3">
              <button
                onClick={handleAllow}
                className="w-full h-[52px] rounded-2xl bg-primary text-white font-outfit text-[16px] font-bold flex items-center justify-center gap-2 shadow-sm active:scale-[0.98] transition-transform"
              >
                <Bell className="w-4 h-4" strokeWidth={2.5} />
                Allow Notifications
              </button>
              <button
                onClick={dismiss}
                className="w-full h-[44px] rounded-2xl text-zinc-500 font-outfit text-[15px] font-semibold flex items-center justify-center hover:bg-zinc-50 transition-colors active:scale-[0.99]"
              >
                Not Now
              </button>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
