"use client";

import { useEffect } from "react";

const ONESIGNAL_APP_ID = "91eebd03-3003-4676-8534-99e9e4f6df92";

export default function OneSignalInit() {
  useEffect(() => {
    if (typeof window === "undefined") return;

    // Dynamically load OneSignal SDK
    const script = document.createElement("script");
    script.src = "https://cdn.onesignal.com/sdks/web/v16/OneSignalSDK.page.js";
    script.defer = true;
    script.onload = () => {
      window.OneSignalDeferred = window.OneSignalDeferred || [];
      window.OneSignalDeferred.push(async (OneSignal: any) => {
        await OneSignal.init({
          appId: ONESIGNAL_APP_ID,
          serviceWorkerPath: "/OneSignalSDKWorker.js",
          notifyButton: {
            enable: false, // We handle permission prompts manually
          },
          allowLocalhostAsSecureOrigin: true,
        });

        // Auto-subscribe user after init
        const isSubscribed = await OneSignal.User.PushSubscription.optedIn;
        if (!isSubscribed) {
          await OneSignal.Slidedown.promptPush();
        }

        console.log("[OneSignal] Initialized. Subscribed:", isSubscribed);
      });
    };
    document.head.appendChild(script);

    return () => {
      document.head.removeChild(script);
    };
  }, []);

  return null;
}
