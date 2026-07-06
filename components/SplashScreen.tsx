"use client";

import React, { useEffect, useState } from "react";

export default function SplashScreen() {
  const [visible, setVisible] = useState(true);

  useEffect(() => {
    // Fade out after a short minimum display time
    const timer = setTimeout(() => setVisible(false), 200);
    return () => clearTimeout(timer);
  }, []);

  return (
    <div
      style={{
        position: "fixed",
        inset: 0,
        zIndex: 9999,
        background: "#7B82F4",
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
        justifyContent: "center",
        opacity: visible ? 1 : 0,
        transition: "opacity 0.3s ease",
        pointerEvents: "none",
      }}
    >
      <h1
        style={{
          fontFamily: "'Outfit', sans-serif",
          fontSize: 40,
          fontWeight: 700,
          color: "#ffffff",
          margin: 0,
          letterSpacing: "-0.5px",
        }}
      >
        Helpero
      </h1>
      <p
        style={{
          fontFamily: "'Outfit', sans-serif",
          fontSize: 18,
          fontWeight: 100,
          color: "#ffffff",
          margin: "10px 0 0",
          letterSpacing: "2px",
          textTransform: "uppercase",
        }}
      >
        Consider it done.
      </p>
    </div>
  );
}
