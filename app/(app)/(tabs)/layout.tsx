"use client";

import React from "react";
import BottomNavigationBar from "@/components/BottomNavigationBar";

export default function TabsLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="flex flex-col min-h-screen bg-bg-primary">
      <div className="flex-1 w-full max-w-md mx-auto bg-white shadow-md min-h-screen flex flex-col">
        {children}
      </div>
      <BottomNavigationBar />
    </div>
  );
}
