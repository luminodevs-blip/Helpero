import { useEffect } from "react";

/**
 * Locks body scroll while a bottom sheet / modal is open.
 * Works on both iOS (uses position:fixed trick) and Android/desktop (overflow:hidden).
 * Call with `isOpen = true` to lock, `false` to release.
 */
export function useBodyScrollLock(isOpen: boolean) {
  useEffect(() => {
    if (!isOpen) return;

    const body = document.body;
    const scrollY = window.scrollY;

    // Save current scroll position and freeze the body in place
    body.style.position = "fixed";
    body.style.top = `-${scrollY}px`;
    body.style.left = "0";
    body.style.right = "0";
    body.style.overflowY = "scroll"; // keep scrollbar width to prevent layout shift

    return () => {
      // Restore scroll position exactly where the user was
      body.style.position = "";
      body.style.top = "";
      body.style.left = "";
      body.style.right = "";
      body.style.overflowY = "";
      window.scrollTo({ top: scrollY, behavior: "instant" as ScrollBehavior });
    };
  }, [isOpen]);
}
