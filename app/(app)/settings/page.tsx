"use client";

import React, { useState, useEffect } from "react";
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
  X,
  Trash2,
  Check,
  Plus,
  Laptop,
  Flame
} from "lucide-react";
import { version } from "../../../package.json";
import { useBodyScrollLock } from "@/lib/useBodyScrollLock";

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
  const { profile, user, signOut } = useClientAuth();

  const handleSignOut = async () => {
    try {
      await signOut();
      router.push("/login");
    } catch (e) {
      console.error(e);
      router.push("/login");
    }
  };

  // Dynamic States
  const [activeSheet, setActiveSheet] = useState<string | null>(null);

  // Lock body scroll when any settings sheet is open
  useBodyScrollLock(activeSheet !== null);
  const [language, setLanguage] = useState("English");
  const [themeSetting, setThemeSetting] = useState("System mode");
  
  const [pushEnabled, setPushEnabled] = useState(true);
  const [emailEnabled, setEmailEnabled] = useState(true);
  const [smsEnabled, setSmsEnabled] = useState(false);
  const [offersEnabled, setOffersEnabled] = useState(true);

  const [largeText, setLargeText] = useState(false);
  const [highContrast, setHighContrast] = useState(false);
  const [reduceMotion, setReduceMotion] = useState(false);
  const [hapticFeedback, setHapticFeedback] = useState(true);

  const [profileVisible, setProfileVisible] = useState(true);
  const [shareHistory, setShareHistory] = useState(false);
  const [exportRequested, setExportRequested] = useState(false);

  const [twoFactor, setTwoFactor] = useState(false);
  const [biometrics, setBiometrics] = useState(true);

  const [contacts, setContacts] = useState([
    { id: "1", name: "Anna Mihanovskaja", phone: "+44 7392 343411" }
  ]);
  const [newContactName, setNewContactName] = useState("");
  const [newContactPhone, setNewContactPhone] = useState("");
  const [isAddingContact, setIsAddingContact] = useState(false);

  // Active Sessions States
  const [otherSessions, setOtherSessions] = useState([
    { id: "2", device: "Chrome on Windows", location: "London, UK", time: "Active 2 hours ago" },
    { id: "3", device: "Safari on iPad", location: "London, UK", time: "Active yesterday" }
  ]);
  const [logoutSuccess, setLogoutSuccess] = useState(false);

  // Load preferences from localStorage on mount
  useEffect(() => {
    if (typeof window !== "undefined") {
      const savedLang = localStorage.getItem("helpero_language");
      if (savedLang) setLanguage(savedLang);

      const savedTheme = localStorage.getItem("helpero_theme");
      if (savedTheme) setThemeSetting(savedTheme);

      const savedPush = localStorage.getItem("helpero_push");
      if (savedPush) setPushEnabled(savedPush === "true");

      const savedEmail = localStorage.getItem("helpero_email");
      if (savedEmail) setEmailEnabled(savedEmail === "true");

      const savedSms = localStorage.getItem("helpero_sms");
      if (savedSms) setSmsEnabled(savedSms === "true");

      const savedOffers = localStorage.getItem("helpero_offers");
      if (savedOffers) setOffersEnabled(savedOffers === "true");

      const savedLargeText = localStorage.getItem("helpero_large_text");
      if (savedLargeText) setLargeText(savedLargeText === "true");

      const savedHighContrast = localStorage.getItem("helpero_high_contrast");
      if (savedHighContrast) setHighContrast(savedHighContrast === "true");

      const savedReduceMotion = localStorage.getItem("helpero_reduce_motion");
      if (savedReduceMotion) setReduceMotion(savedReduceMotion === "true");

      const savedHaptic = localStorage.getItem("helpero_haptic");
      if (savedHaptic) setHapticFeedback(savedHaptic === "true");

      const savedVisible = localStorage.getItem("helpero_profile_visible");
      if (savedVisible) setProfileVisible(savedVisible === "true");

      const savedShare = localStorage.getItem("helpero_share_history");
      if (savedShare) setShareHistory(savedShare === "true");

      const savedTwoFactor = localStorage.getItem("helpero_two_factor");
      if (savedTwoFactor) setTwoFactor(savedTwoFactor === "true");

      const savedBiometrics = localStorage.getItem("helpero_biometrics");
      if (savedBiometrics) setBiometrics(savedBiometrics === "true");

      const savedContacts = localStorage.getItem("helpero_contacts");
      if (savedContacts) {
        try {
          setContacts(JSON.parse(savedContacts));
        } catch (e) {
          console.error(e);
        }
      }
    }
  }, []);

  const handleLanguageSelect = (lang: string) => {
    setLanguage(lang);
    localStorage.setItem("helpero_language", lang);
    setActiveSheet(null);
  };

  const handleThemeSelect = (theme: string) => {
    setThemeSetting(theme);
    localStorage.setItem("helpero_theme", theme);
    setActiveSheet(null);
  };

  const handleToggle = (key: string, value: boolean, setter: (v: boolean) => void) => {
    setter(value);
    localStorage.setItem(key, String(value));
  };

  const handleAddContact = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newContactName.trim() || !newContactPhone.trim()) return;

    const newContact = {
      id: String(Date.now()),
      name: newContactName.trim(),
      phone: newContactPhone.trim(),
    };

    const updated = [...contacts, newContact];
    setContacts(updated);
    localStorage.setItem("helpero_contacts", JSON.stringify(updated));

    setNewContactName("");
    setNewContactPhone("");
    setIsAddingContact(false);
  };

  const handleDeleteContact = (id: string) => {
    const updated = contacts.filter((c) => c.id !== id);
    setContacts(updated);
    localStorage.setItem("helpero_contacts", JSON.stringify(updated));
  };

  const displayName = profile?.firstName
    ? `${profile.firstName} ${profile.lastName || ""}`.trim()
    : "Max Mihanovskij";

  const displayPhone = profile?.phoneNumber || user?.phone || "+441234567867";

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
          action: () => setActiveSheet("confidentiality"),
        },
        {
          id: "special_features",
          title: "Special features",
          subtitle: "Accessibility and comfort settings",
          icon: User,
          action: () => setActiveSheet("special_features"),
        },
        {
          id: "communication",
          title: "Communication",
          subtitle: "Select your preferred communication methods and set up notifications",
          icon: MessageSquare,
          action: () => setActiveSheet("communication"),
        },
        {
          id: "language",
          title: "Language",
          subtitle: language,
          icon: Globe,
          action: () => setActiveSheet("language"),
        },
        {
          id: "theme",
          title: "Theme",
          subtitle: themeSetting,
          icon: Sun,
          action: () => setActiveSheet("theme"),
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
          action: () => setActiveSheet("security_settings"),
        },
        {
          id: "trusted_contacts",
          title: "Trusted contacts",
          icon: Users,
          action: () => setActiveSheet("trusted_contacts"),
        },
        {
          id: "active_sessions",
          title: "Active Sessions",
          icon: Laptop,
          action: () => setActiveSheet("active_sessions"),
        },
      ],
    },
    {
      title: "Feedback",
      items: [
        {
          id: "ideas_partnerships",
          title: "Ideas & Partnerships",
          subtitle: "Share your feature requests or propose a business collaboration",
          icon: Flame,
          action: () => setActiveSheet("ideas_partnerships"),
        },
      ],
    },
  ];

  // Reusable iOS-style Toggle Switch
  const Toggle = ({ enabled, onChange }: { enabled: boolean; onChange: () => void }) => (
    <button
      onClick={onChange}
      className={`w-[51px] h-[31px] flex items-center rounded-full p-0.5 transition-colors duration-200 focus:outline-none shrink-0 ${
        enabled ? "bg-[#7B82F4]" : "bg-zinc-200"
      }`}
    >
      <div
        className={`bg-white w-[27px] h-[27px] rounded-full shadow-md transform transition-transform duration-200 ${
          enabled ? "translate-x-[20px]" : "translate-x-0"
        }`}
      />
    </button>
  );

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-white relative flex flex-col border-x border-alternate shadow-md font-sans pb-10">
      {/* Header */}
      <div className="px-5 pt-12 pb-5 flex items-center justify-between border-b border-zinc-100 sticky top-0 bg-white z-20">
        <button
          onClick={() => router.back()}
          className="p-1 -ml-1 flex items-center justify-center rounded-full hover:bg-zinc-100 text-zinc-900 focus:outline-none transition-colors"
        >
          <ArrowLeft className="w-[24px] h-[24px]" strokeWidth={2} />
        </button>
        
        <h1 className="font-outfit text-[20px] font-semibold text-zinc-900 absolute left-1/2 -translate-x-1/2">
          Settings
        </h1>
        
        <div className="w-8" /> {/* Spacer */}
      </div>

      {/* Main Content List */}
      <div className="flex-1 pb-10">
        {/* Settings Groups */}
        {settingsGroups.map((group, gIdx) => (
          <div key={gIdx} className="flex flex-col">
            {group.title && (
              <>
                <div className="h-3 bg-[#F1F4F8] border-y border-zinc-100/60" />
                <div className="px-5 pt-5 pb-3">
                  <h3 className="font-outfit text-[17px] font-medium text-zinc-900">
                    {group.title}
                  </h3>
                </div>
              </>
            )}

            <div className="flex flex-col">
              {group.items.map((item) => {
                const Icon = item.icon;
                const hasSubtitle = !!item.subtitle;
                return (
                  <div
                    key={item.id}
                    onClick={item.action}
                    className={`flex items-center justify-between px-5 border-b border-zinc-100 hover:bg-zinc-50 transition-colors cursor-pointer bg-white ${
                      hasSubtitle ? "py-5" : "h-[70px]"
                    }`}
                  >
                    <div className="flex items-center gap-5">
                      <div className="flex items-center justify-center shrink-0">
                        <Icon className="h-5 w-5 text-zinc-900" />
                      </div>
                      <div className="flex flex-col pr-4">
                        <span className="font-outfit text-[15px] font-medium text-zinc-900 leading-tight">
                          {item.title}
                        </span>
                        {item.subtitle && (
                          <span className="text-[14px] font-normal text-zinc-400 mt-0.5 leading-none">
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
        {/* Divider before bottom actions */}
        <div className="h-3 bg-[#F1F4F8] border-y border-zinc-100/60" />
        
        {/* Log Out */}
        <div className="flex flex-col bg-white">
          <div
            onClick={() => setActiveSheet("logout_confirm")}
            className="flex items-center pl-[60px] pr-5 h-[70px] hover:bg-zinc-50 transition-colors cursor-pointer text-red-500 font-medium text-[15px]"
          >
            Log Out
          </div>
        </div>

        {/* Divider after bottom actions */}
        <div className="h-3 bg-[#F1F4F8] border-t border-zinc-100/60" />
      </div>

      {/* Reusable Bottom Sheet Modal for Settings Sub-Screens */}
      {activeSheet && (
        <div
          className="fixed inset-0 z-50 bg-black/40 backdrop-blur-[2px] flex items-end justify-center"
          onClick={() => {
            setActiveSheet(null);
            setIsAddingContact(false);
          }}
        >
          <div
            className="relative w-full max-w-md bg-white rounded-t-[28px] shadow-2xl flex flex-col max-h-[85vh] animate-slide-up border-t border-zinc-100"
            onClick={(e) => e.stopPropagation()}
            style={{ animation: "slideUp 0.3s ease-out forwards" }}
          >
            {/* Drag Handle */}
            <div className="flex justify-center pt-3 pb-2 shrink-0">
              <div className="w-10 h-1 rounded-full bg-zinc-200" />
            </div>

            {/* Header */}
            <div className="px-5 pb-4 border-b border-zinc-100 flex items-center justify-between relative shrink-0">
              <h3 className="font-outfit text-[18px] font-bold text-zinc-900 mx-auto">
                {activeSheet === "language" && "Select Language"}
                {activeSheet === "theme" && "Choose Theme"}
                {activeSheet === "communication" && "Notification Preferences"}
                {activeSheet === "special_features" && "Special Features"}
                {activeSheet === "confidentiality" && "Privacy & Data Control"}
                {activeSheet === "security_settings" && "Security Settings"}
                {activeSheet === "trusted_contacts" && "Trusted Contacts"}
                {activeSheet === "active_sessions" && "Active Sessions"}
                {activeSheet === "ideas_partnerships" && "Ideas & Partnerships"}
                {activeSheet === "logout_confirm" && "Confirm Log Out"}
                {activeSheet === "delete_account_confirm" && "Confirm Delete Account"}
              </h3>
              <button
                onClick={() => {
                  setActiveSheet(null);
                  setIsAddingContact(false);
                }}
                className="absolute right-5 p-1.5 rounded-full hover:bg-zinc-100 text-zinc-500 focus:outline-none transition-colors"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            {/* Scrollable Content */}
            <div className="overflow-y-auto p-5 pb-12 flex-1 flex flex-col space-y-6">
              
              {/* LANGUAGE SHEET */}
              {activeSheet === "language" && (
                <div className="flex flex-col space-y-2">
                  {["English", "Français", "Español", "Deutsch", "Русский"].map((lang) => (
                    <button
                      key={lang}
                      onClick={() => handleLanguageSelect(lang)}
                      className="flex items-center justify-between p-4 rounded-xl border border-zinc-100 hover:bg-zinc-50 transition-all text-left"
                    >
                      <span className={`text-sm font-semibold ${language === lang ? "text-[#7B82F4]" : "text-zinc-800"}`}>
                        {lang}
                      </span>
                      {language === lang && (
                        <Check className="h-5 w-5 text-[#7B82F4]" strokeWidth={2.5} />
                      )}
                    </button>
                  ))}
                </div>
              )}

              {/* THEME SHEET */}
              {activeSheet === "theme" && (
                <div className="flex flex-col space-y-2">
                  {["Light mode", "Dark mode", "System mode"].map((theme) => (
                    <button
                      key={theme}
                      onClick={() => handleThemeSelect(theme)}
                      className="flex items-center justify-between p-4 rounded-xl border border-zinc-100 hover:bg-zinc-50 transition-all text-left"
                    >
                      <span className={`text-sm font-semibold ${themeSetting === theme ? "text-[#7B82F4]" : "text-zinc-800"}`}>
                        {theme}
                      </span>
                      {themeSetting === theme && (
                        <Check className="h-5 w-5 text-[#7B82F4]" strokeWidth={2.5} />
                      )}
                    </button>
                  ))}
                </div>
              )}

              {/* COMMUNICATION SHEET */}
              {activeSheet === "communication" && (
                <div className="flex flex-col space-y-5">
                  <div className="flex items-start justify-between">
                    <div className="flex flex-col pr-4">
                      <span className="text-sm font-bold text-zinc-950">Push Notifications</span>
                      <span className="text-xs text-zinc-500 mt-1">Get instant booking status updates on your phone</span>
                    </div>
                    <Toggle enabled={pushEnabled} onChange={() => handleToggle("helpero_push", !pushEnabled, setPushEnabled)} />
                  </div>
                  <div className="flex items-start justify-between border-t border-zinc-100 pt-5">
                    <div className="flex flex-col pr-4">
                      <span className="text-sm font-bold text-zinc-950">Email updates</span>
                      <span className="text-xs text-zinc-500 mt-1">Receive monthly invoices, receipts, and reports</span>
                    </div>
                    <Toggle enabled={emailEnabled} onChange={() => handleToggle("helpero_email", !emailEnabled, setEmailEnabled)} />
                  </div>
                  <div className="flex items-start justify-between border-t border-zinc-100 pt-5">
                    <div className="flex flex-col pr-4">
                      <span className="text-sm font-bold text-zinc-950">SMS reminders</span>
                      <span className="text-xs text-zinc-500 mt-1">Text messages for immediate arrival notifications</span>
                    </div>
                    <Toggle enabled={smsEnabled} onChange={() => handleToggle("helpero_sms", !smsEnabled, setSmsEnabled)} />
                  </div>
                  <div className="flex items-start justify-between border-t border-zinc-100 pt-5">
                    <div className="flex flex-col pr-4">
                      <span className="text-sm font-bold text-zinc-950">Special offers</span>
                      <span className="text-xs text-zinc-500 mt-1">Get custom promo codes, discounts, and partnership news</span>
                    </div>
                    <Toggle enabled={offersEnabled} onChange={() => handleToggle("helpero_offers", !offersEnabled, setOffersEnabled)} />
                  </div>
                </div>
              )}

              {/* SPECIAL FEATURES SHEET */}
              {activeSheet === "special_features" && (
                <div className="flex flex-col space-y-5">
                  <div className="flex items-start justify-between">
                    <div className="flex flex-col pr-4">
                      <span className="text-sm font-bold text-zinc-950">Large text</span>
                      <span className="text-xs text-zinc-500 mt-1">Increase font size across all booking steps</span>
                    </div>
                    <Toggle enabled={largeText} onChange={() => handleToggle("helpero_large_text", !largeText, setLargeText)} />
                  </div>
                  <div className="flex items-start justify-between border-t border-zinc-100 pt-5">
                    <div className="flex flex-col pr-4">
                      <span className="text-sm font-bold text-zinc-950">High contrast</span>
                      <span className="text-xs text-zinc-500 mt-1">Enhance screen contrast for outdoor accessibility</span>
                    </div>
                    <Toggle enabled={highContrast} onChange={() => handleToggle("helpero_high_contrast", !highContrast, setHighContrast)} />
                  </div>
                  <div className="flex items-start justify-between border-t border-zinc-100 pt-5">
                    <div className="flex flex-col pr-4">
                      <span className="text-sm font-bold text-zinc-950">Reduce motion</span>
                      <span className="text-xs text-zinc-500 mt-1">Minimize animations for page slide-ups and sheets</span>
                    </div>
                    <Toggle enabled={reduceMotion} onChange={() => handleToggle("helpero_reduce_motion", !reduceMotion, setReduceMotion)} />
                  </div>
                  <div className="flex items-start justify-between border-t border-zinc-100 pt-5">
                    <div className="flex flex-col pr-4">
                      <span className="text-sm font-bold text-zinc-950">Haptic feedback</span>
                      <span className="text-xs text-zinc-500 mt-1">Device vibrations on booking counters and success actions</span>
                    </div>
                    <Toggle enabled={hapticFeedback} onChange={() => handleToggle("helpero_haptic", !hapticFeedback, setHapticFeedback)} />
                  </div>
                </div>
              )}

              {/* PRIVACY & DATA CONTROL SHEET */}
              {activeSheet === "confidentiality" && (
                <div className="flex flex-col space-y-5">
                  <div className="flex items-start justify-between">
                    <div className="flex flex-col pr-4">
                      <span className="text-sm font-bold text-zinc-950">Profile visibility</span>
                      <span className="text-xs text-zinc-500 mt-1">Allow specialists to find your profile details by name</span>
                    </div>
                    <Toggle enabled={profileVisible} onChange={() => handleToggle("helpero_profile_visible", !profileVisible, setProfileVisible)} />
                  </div>
                  <div className="flex items-start justify-between border-t border-zinc-100 pt-5">
                    <div className="flex flex-col pr-4">
                      <span className="text-sm font-bold text-zinc-950">Share booking history</span>
                      <span className="text-xs text-zinc-500 mt-1">Allow household members at your addresses to view order logs</span>
                    </div>
                    <Toggle enabled={shareHistory} onChange={() => handleToggle("helpero_share_history", !shareHistory, setShareHistory)} />
                  </div>

                  <div className="border-t border-zinc-100 pt-6 space-y-2">
                    <button
                      onClick={() => {
                        setExportRequested(true);
                        setTimeout(() => setExportRequested(false), 3000);
                      }}
                      className="w-full py-3 border border-zinc-200 rounded-xl font-semibold text-zinc-700 text-sm hover:bg-zinc-50 active:scale-98 transition-all"
                    >
                      {exportRequested ? "Data export requested!" : "Export My Data"}
                    </button>
                    <button
                      onClick={() => alert("Please contact support at support@helpero.com to permanently delete your account.")}
                      className="w-full py-3 rounded-xl font-semibold text-red-500 text-sm bg-red-50 hover:bg-red-100 active:scale-98 transition-all"
                    >
                      Delete My Account
                    </button>
                  </div>
                </div>
              )}

              {/* SECURITY SETTINGS SHEET */}
              {activeSheet === "security_settings" && (
                <div className="flex flex-col space-y-5">
                  <div className="flex items-start justify-between">
                    <div className="flex flex-col pr-4">
                      <span className="text-sm font-bold text-zinc-950">Two-factor authentication</span>
                      <span className="text-xs text-zinc-500 mt-1">Confirm logins using code sent to your phone</span>
                    </div>
                    <Toggle enabled={twoFactor} onChange={() => handleToggle("helpero_two_factor", !twoFactor, setTwoFactor)} />
                  </div>
                  <div className="flex items-start justify-between border-t border-zinc-100 pt-5">
                    <div className="flex flex-col pr-4">
                      <span className="text-sm font-bold text-zinc-950">Biometric Login</span>
                      <span className="text-xs text-zinc-500 mt-1">Unlock the app with FaceID or TouchID</span>
                    </div>
                    <Toggle enabled={biometrics} onChange={() => handleToggle("helpero_biometrics", !biometrics, setBiometrics)} />
                  </div>

                  <div className="border-t border-zinc-100 pt-6">
                    <button
                      onClick={() => alert("Password reset link has been sent to your email.")}
                      className="w-full py-3 border border-[#7B82F4] text-[#7B82F4] rounded-xl font-semibold text-sm hover:bg-[#7B82F4]/5 active:scale-98 transition-all"
                    >
                      Change password
                    </button>
                  </div>
                </div>
              )}

              {/* TRUSTED CONTACTS SHEET */}
              {activeSheet === "trusted_contacts" && (
                <div className="flex flex-col space-y-4">
                  <p className="text-xs text-zinc-500 leading-relaxed">
                    Add people you trust to share your live booking status, arrival details, and address with.
                  </p>

                  <div className="flex flex-col space-y-2 mt-2">
                    {contacts.length === 0 ? (
                      <p className="text-sm font-medium text-zinc-400 text-center py-6">No trusted contacts added yet.</p>
                    ) : (
                      contacts.map((c) => (
                        <div key={c.id} className="flex items-center justify-between p-4 bg-zinc-50 rounded-xl border border-zinc-100">
                          <div className="flex flex-col">
                            <span className="text-sm font-bold text-zinc-900">{c.name}</span>
                            <span className="text-xs text-zinc-500 mt-0.5">{c.phone}</span>
                          </div>
                          <button
                            onClick={() => handleDeleteContact(c.id)}
                            className="p-2 text-zinc-400 hover:text-red-500 hover:bg-red-50 rounded-full transition-colors"
                          >
                            <Trash2 className="h-4.5 w-4.5" />
                          </button>
                        </div>
                      ))
                    )}
                  </div>

                  {isAddingContact ? (
                    <form onSubmit={handleAddContact} className="flex flex-col space-y-3 border-t border-zinc-100 pt-4 mt-2">
                      <div className="flex flex-col space-y-1">
                        <label className="text-[11px] font-bold text-zinc-400 uppercase">Contact Name</label>
                        <input
                          type="text"
                          required
                          value={newContactName}
                          onChange={(e) => setNewContactName(e.target.value)}
                          placeholder="Anna Mihanovskaja"
                          className="px-4 py-3 rounded-xl border border-zinc-200 text-sm focus:outline-none focus:border-[#7B82F4]"
                        />
                      </div>
                      <div className="flex flex-col space-y-1">
                        <label className="text-[11px] font-bold text-zinc-400 uppercase">Phone Number</label>
                        <input
                          type="tel"
                          required
                          value={newContactPhone}
                          onChange={(e) => setNewContactPhone(e.target.value)}
                          placeholder="+44 7392 343411"
                          className="px-4 py-3 rounded-xl border border-zinc-200 text-sm focus:outline-none focus:border-[#7B82F4]"
                        />
                      </div>
                      <div className="flex gap-2 pt-2">
                        <button
                          type="button"
                          onClick={() => setIsAddingContact(false)}
                          className="flex-1 py-3 border border-zinc-200 rounded-xl font-semibold text-zinc-700 text-xs hover:bg-zinc-50"
                        >
                          Cancel
                        </button>
                        <button
                          type="submit"
                          className="flex-1 py-3 bg-[#7B82F4] text-white rounded-xl font-semibold text-xs hover:bg-[#6c73e0]"
                        >
                          Save Contact
                        </button>
                      </div>
                    </form>
                  ) : (
                    <button
                      onClick={() => setIsAddingContact(true)}
                      className="w-full py-3.5 mt-2 bg-zinc-950 text-white rounded-xl font-semibold text-sm flex items-center justify-center gap-1.5 hover:bg-zinc-900 active:scale-98 transition-all"
                    >
                      <Plus className="h-4 w-4" strokeWidth={3} />
                      Add trusted contact
                    </button>
                  )}
                </div>
              )}

              {/* ACTIVE SESSIONS SHEET */}
              {activeSheet === "active_sessions" && (
                <div className="flex flex-col space-y-4">
                  <p className="text-xs text-zinc-500 leading-relaxed">
                    These are the devices that have logged into your Helpero account.
                  </p>

                  <div className="flex flex-col space-y-2 mt-2">
                    {/* This Device */}
                    <div className="p-4 bg-zinc-50 rounded-xl border border-zinc-100 flex items-start justify-between">
                      <div className="flex flex-col">
                        <div className="flex items-center gap-1.5">
                          <span className="text-sm font-bold text-zinc-900">iPhone 15 Pro</span>
                          <span className="px-1.5 py-0.5 rounded-full bg-emerald-50 text-emerald-600 text-[10px] font-bold">This device</span>
                        </div>
                        <span className="text-xs text-zinc-500 mt-1">London, UK · Active now</span>
                      </div>
                    </div>

                    {/* Other Devices */}
                    {otherSessions.map((s) => (
                      <div key={s.id} className="p-4 bg-white rounded-xl border border-zinc-100 flex items-start justify-between">
                        <div className="flex flex-col">
                          <span className="text-sm font-bold text-zinc-800">{s.device}</span>
                          <span className="text-xs text-zinc-400 mt-1">{s.location} · {s.time}</span>
                        </div>
                      </div>
                    ))}
                  </div>

                  {otherSessions.length > 0 && (
                    <div className="border-t border-zinc-100 pt-5 mt-2">
                      <button
                        onClick={() => {
                          setOtherSessions([]);
                          setLogoutSuccess(true);
                          setTimeout(() => setLogoutSuccess(false), 3000);
                        }}
                        className="w-full py-3.5 rounded-xl font-semibold text-red-500 text-sm bg-red-50 hover:bg-red-100 active:scale-98 transition-all"
                      >
                        {logoutSuccess ? "Logged out successfully!" : "Log out of all other sessions"}
                      </button>
                    </div>
                  )}
                </div>
              )}

              {/* IDEAS & PARTNERSHIPS SHEET */}
              {activeSheet === "ideas_partnerships" && (
                <div className="flex flex-col space-y-4">
                  <p className="text-xs text-zinc-500 leading-relaxed">
                    Have an idea to improve Helpero or want to explore partnership opportunities? We are all ears!
                  </p>
                  
                  {logoutSuccess ? (
                    <div className="p-6 bg-emerald-50 text-emerald-700 text-sm font-semibold rounded-xl text-center">
                      Thank you! Your submission was received successfully.
                    </div>
                  ) : (
                    <form
                      onSubmit={(e) => {
                        e.preventDefault();
                        setLogoutSuccess(true);
                        setTimeout(() => {
                          setLogoutSuccess(false);
                          setActiveSheet(null);
                        }, 2500);
                      }}
                      className="flex flex-col space-y-4"
                    >
                      <div className="flex flex-col space-y-1">
                        <label className="text-[11px] font-bold text-zinc-400 uppercase">Message</label>
                        <textarea
                          required
                          rows={4}
                          placeholder="Your idea, suggestion, or proposal details..."
                          className="px-4 py-3 rounded-xl border border-zinc-200 text-sm focus:outline-none focus:border-[#7B82F4] resize-none"
                        />
                      </div>
                      <div className="flex flex-col space-y-1">
                        <label className="text-[11px] font-bold text-zinc-400 uppercase">Contact Email / Phone</label>
                        <input
                          type="text"
                          required
                          placeholder="alex@example.com"
                          className="px-4 py-3 rounded-xl border border-zinc-200 text-sm focus:outline-none focus:border-[#7B82F4]"
                        />
                      </div>
                      <button
                        type="submit"
                        className="w-full py-3.5 bg-zinc-950 text-white rounded-xl font-semibold text-sm hover:bg-zinc-900 active:scale-98 transition-all"
                      >
                        Submit Proposal
                      </button>
                    </form>
                  )}
                </div>
              )}

              {/* LOGOUT CONFIRM SHEET */}
              {activeSheet === "logout_confirm" && (
                <div className="flex flex-col space-y-5 text-center">
                  <p className="text-sm text-zinc-600">
                    Are you sure you want to log out of your Helpero account?
                  </p>
                  <div className="flex gap-3 pt-2">
                    <button
                      onClick={() => setActiveSheet(null)}
                      className="flex-1 py-3.5 border border-zinc-200 rounded-xl font-semibold text-zinc-700 text-sm hover:bg-zinc-50"
                    >
                      Cancel
                    </button>
                    <button
                      onClick={handleSignOut}
                      className="flex-1 py-3.5 bg-red-500 text-white rounded-xl font-semibold text-sm hover:bg-red-650 active:scale-98 transition-all"
                    >
                      Log Out
                    </button>
                  </div>
                </div>
              )}

              {/* DELETE ACCOUNT CONFIRM SHEET */}
              {activeSheet === "delete_account_confirm" && (
                <div className="flex flex-col space-y-5 text-center">
                  <p className="text-sm text-zinc-600 leading-relaxed">
                    This action is permanent and cannot be undone. All your saved addresses, vouchers, and active drafts will be permanently deleted.
                  </p>
                  <div className="flex gap-3 pt-2">
                    <button
                      onClick={() => setActiveSheet(null)}
                      className="flex-1 py-3.5 border border-zinc-200 rounded-xl font-semibold text-zinc-700 text-sm hover:bg-zinc-50"
                    >
                      Cancel
                    </button>
                    <button
                      onClick={async () => {
                        alert("Account scheduled for deletion. You will now be logged out.");
                        await signOut();
                        router.push("/login");
                      }}
                      className="flex-1 py-3.5 bg-red-600 text-white rounded-xl font-semibold text-sm hover:bg-red-750 active:scale-98 transition-all"
                    >
                      Permanently Delete
                    </button>
                  </div>
                </div>
              )}

            </div>
          </div>
          <style dangerouslySetInnerHTML={{__html: `
            @keyframes slideUp {
              from { transform: translateY(100%); }
              to { transform: translateY(0); }
            }
          `}} />
        </div>
      )}
    </div>
  );
}
