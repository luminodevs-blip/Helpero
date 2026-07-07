"use client";

import React from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import {
  ArrowLeft,
  Home,
  Lock,
  User,
  MessageSquare,
  Globe,
  Sun,
  Shield,
  Users,
  ChevronRight,
} from "lucide-react";

interface SettingItem {
  id: string;
  title: string;
  subtitle?: string;
  icon: any;
  action: () => void;
}

interface SettingsGroup {
  title?: string;
  items: SettingItem[];
}

export default function SettingsPage() {
  const router = useRouter();
  const { profile, user } = useClientAuth();

  const displayName = profile?.firstName
    ? `${profile.firstName} ${profile.lastName || ""}`.trim()
    : "Master Helpero";

  const displayPhone = profile?.phoneNumber || user?.phone || "+44 7392 212105";

  const settingsGroups: SettingsGroup[] = [
    {
      items: [
        {
          id: "addresses",
          title: "My Addresses",
          subtitle: "Your saved places",
          icon: Home,
          action: () => router.push("/address"),
        },
        {
          id: "confidentiality",
          title: "Confidentiality",
          subtitle: "Control your data and visibility",
          icon: Lock,
          action: () => alert("Confidentiality settings coming soon"),
        },
        {
          id: "special_features",
          title: "Special features",
          subtitle: "Accessibility and comfort settings",
          icon: User,
          action: () => alert("Accessibility settings coming soon"),
        },
        {
          id: "communication",
          title: "Communication",
          subtitle: "Select your preferred communication methods and set up notifications",
          icon: MessageSquare,
          action: () => alert("Communication settings coming soon"),
        },
        {
          id: "language",
          title: "Language",
          subtitle: "English, Français, etc.",
          icon: Globe,
          action: () => alert("Language settings coming soon"),
        },
        {
          id: "theme",
          title: "Theme",
          subtitle: "System mode",
          icon: Sun,
          action: () => alert("Theme settings coming soon"),
        },
      ],
    },
    {
      title: "Safety",
      items: [
        {
          id: "security_settings",
          title: "Security settings",
          icon: Shield,
          action: () => alert("Security settings coming soon"),
        },
        {
          id: "trusted_contacts",
          title: "Trusted contacts",
          icon: Users,
          action: () => alert("Trusted contacts coming soon"),
        },
      ],
    },
  ];

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-white relative flex flex-col border-x border-alternate shadow-md animate-page-fade-in font-sans">
      {/* Header */}
      <div className="px-5 pt-12 pb-5 flex items-center justify-between border-b border-zinc-100 sticky top-0 bg-white z-20">
        <button
          onClick={() => router.back()}
          className="p-1 -ml-1 flex items-center justify-center rounded-full hover:bg-zinc-100 text-zinc-900 focus:outline-none transition-colors"
        >
          <ArrowLeft className="w-[24px] h-[24px]" strokeWidth={2} />
        </button>
        
        <h1 className="font-outfit text-[20px] font-bold text-zinc-900 absolute left-1/2 -translate-x-1/2">
          Settings
        </h1>
        
        <div className="w-8" /> {/* Spacer */}
      </div>

      {/* Main Content List */}
      <div className="flex-1 pb-10">
        {/* User Card */}
        <div
          onClick={() => router.push("/profile/edit")}
          className="flex items-center justify-between px-5 py-5 border-b border-zinc-100 hover:bg-zinc-50 transition-colors cursor-pointer"
        >
          <div className="flex items-center gap-4">
            {/* Custom SVG Avatar matching the image exactly */}
            <div className="w-[50px] h-[50px] rounded-full overflow-hidden shrink-0 border border-zinc-100 shadow-sm">
              <svg className="w-full h-full" viewBox="0 0 100 100" fill="none">
                <circle cx="50" cy="50" r="50" fill="#E5E7EB" />
                <circle cx="50" cy="38" r="16" fill="#9CA3AF" />
                <path d="M18 80 C 18 55, 82 55, 82 80 Z" fill="#7B82F4" />
              </svg>
            </div>

            <div className="flex flex-col">
              <span className="font-outfit text-[17px] font-bold text-zinc-900">
                {displayName}
              </span>
              <span className="text-[13.5px] font-medium text-zinc-400 mt-0.5">
                {displayPhone}
              </span>
            </div>
          </div>
          <ChevronRight className="h-5 w-5 text-zinc-400" />
        </div>

        {/* Settings Groups */}
        {settingsGroups.map((group, gIdx) => (
          <div key={gIdx} className="flex flex-col">
            {group.title && (
              <div className="px-5 pt-6 pb-2.5">
                <h3 className="font-outfit text-[16px] font-bold text-zinc-900 uppercase tracking-wider">
                  {group.title}
                </h3>
              </div>
            )}

            <div className="flex flex-col">
              {group.items.map((item) => {
                const Icon = item.icon;
                return (
                  <div
                    key={item.id}
                    onClick={item.action}
                    className="flex items-center justify-between px-5 py-4 border-b border-zinc-50 hover:bg-zinc-50 transition-colors cursor-pointer"
                  >
                    <div className="flex items-center gap-4">
                      <div className="flex items-center justify-center shrink-0">
                        <Icon className="h-5 w-5 text-zinc-900" />
                      </div>
                      <div className="flex flex-col pr-4">
                        <span className="font-outfit text-[15px] font-bold text-zinc-900">
                          {item.title}
                        </span>
                        {item.subtitle && (
                          <span className="text-[12px] font-medium text-zinc-400 mt-0.5 leading-normal">
                            {item.subtitle}
                          </span>
                        )}
                      </div>
                    </div>
                    <ChevronRight className="h-5 w-5 text-zinc-400 shrink-0" />
                  </div>
                );
              })}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
