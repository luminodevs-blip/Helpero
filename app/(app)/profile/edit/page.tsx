"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import {
  ArrowLeft,
  ChevronRight,
  User,
  Mail,
  Phone,
  Calendar,
  Smile,
  X,
  Loader2,
  Check,
  Pencil,
} from "lucide-react";

export default function EditProfilePage() {
  const router = useRouter();
  const { profile, user, refreshAddresses } = useClientAuth();

  const [activeEditField, setActiveEditField] = useState<
    "name" | "email" | "phone" | "birthdate" | "gender" | null
  >(null);

  // Form values
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [birthdate, setBirthdate] = useState("");
  const [gender, setGender] = useState("");

  const [saving, setSaving] = useState(false);

  // Initialize values
  useEffect(() => {
    if (profile) {
      setFirstName(profile.firstName || "");
      setLastName(profile.lastName || "");
      setEmail(profile.email || "");
      setPhone(profile.phoneNumber || "");
      setBirthdate(profile.birthdate || "");
      setGender(profile.gender || "");
    } else if (user) {
      setEmail(user.email || "");
      setPhone(user.phone || "");
    }
  }, [profile, user]);

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!user) return;

    setSaving(true);
    try {
      const updates: any = {};

      if (activeEditField === "name") {
        updates.first_name = firstName;
        updates.last_name = lastName;
      } else if (activeEditField === "email") {
        updates.email = email;
      } else if (activeEditField === "phone") {
        updates.phone_number = phone;
      } else if (activeEditField === "birthdate") {
        updates.birthdate = birthdate || null;
      } else if (activeEditField === "gender") {
        updates.gender = gender || null;
      }

      const { error } = await supabase
        .from("profiles")
        .update(updates)
        .eq("id", user.id);

      if (error) throw error;

      await refreshAddresses(); // reloads profile in context
      setActiveEditField(null);
    } catch (err) {
      console.error("Error updating profile:", err);
      alert("Failed to update profile field");
    } finally {
      setSaving(false);
    }
  };

  const handleEditAvatar = () => {
    alert("Avatar upload coming soon");
  };

  const displayName = profile?.firstName
    ? `${profile.firstName} ${profile.lastName || ""}`.trim()
    : "Master Helpero";

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-[#F1F4F8] relative flex flex-col border-x border-alternate shadow-md animate-page-fade-in font-sans">
      {/* ── 1. PURPLE HEADER (Account + Avatar) ── */}
      <div className="bg-[#7B82F4] text-white pt-12 pb-[56px] px-5 relative overflow-hidden flex-shrink-0">
        <div className="absolute inset-0 bg-radial-gradient from-white/10 to-transparent pointer-events-none opacity-40" />

        <div className="relative z-10 flex flex-col items-center">
          {/* Header row */}
          <div className="w-full flex items-center justify-between">
            <button
              onClick={() => router.back()}
              className="w-[42px] h-[42px] rounded-full border border-white/20 bg-white/10 hover:bg-white/20 flex items-center justify-center text-white focus:outline-none transition-colors"
            >
              <ArrowLeft className="w-5 h-5" strokeWidth={2.5} />
            </button>
            <h1 className="font-outfit text-[20px] font-bold">Account</h1>
            <div className="w-10" /> {/* spacer */}
          </div>

          {/* Avatar Circle with Edit Button exactly matching screenshot */}
          <div className="relative mt-6 select-none group cursor-pointer" onClick={handleEditAvatar}>
            <div className="w-[100px] h-[100px] rounded-full overflow-hidden border-2 border-white/30 shadow-lg bg-zinc-100 flex items-center justify-center">
              {profile?.avatarUrl ? (
                <img src={profile.avatarUrl} alt="Avatar" className="w-full h-full object-cover" />
              ) : (
                <svg className="w-full h-full" viewBox="0 0 100 100" fill="none">
                  <circle cx="50" cy="50" r="50" fill="#E5E7EB" />
                  <circle cx="50" cy="38" r="16" fill="#9CA3AF" />
                  <path d="M18 80 C 18 55, 82 55, 82 80 Z" fill="#7B82F4" />
                </svg>
              )}
            </div>

            {/* Blue Pencil Edit Icon Overlay */}
            <div className="absolute bottom-0 right-0 w-8 h-8 rounded-full bg-[#7B82F4] border-2 border-white flex items-center justify-center shadow-md text-white">
              <Pencil className="w-3.5 h-3.5" strokeWidth={2.5} />
            </div>
          </div>
        </div>
      </div>

      {/* ── 2. WHITE OVERLAPPING CONTENT CARD ── */}
      <div className="flex-1 bg-[#F1F4F8] rounded-t-[28px] -mt-6 pt-5 px-5 space-y-6 relative z-10">
        
        {/* Name Row Card exactly matching screenshot */}
        <div
          onClick={() => setActiveEditField("name")}
          className="rounded-2xl bg-white p-4.5 flex items-center justify-between cursor-pointer hover:bg-zinc-50 transition-colors shadow-sm"
        >
          <div className="flex items-center gap-4">
            <User className="h-5 w-5 text-[#7B82F4]" />
            <span className="font-outfit text-[15px] font-bold text-zinc-500">Name</span>
          </div>
          <div className="flex items-center gap-2">
            <span className="font-outfit text-[15px] font-bold text-zinc-900 pr-1">
              {displayName}
            </span>
            <ChevronRight className="h-5 w-5 text-[#7B82F4] shrink-0" />
          </div>
        </div>

        {/* Private Information Section */}
        <div className="space-y-4 pt-1">
          <h2 className="font-outfit text-[17px] font-bold text-zinc-900 px-1">
            Private information
          </h2>

          <div className="bg-white rounded-2xl p-2.5 shadow-sm divide-y divide-zinc-50">
            {/* Email Row */}
            <div
              onClick={() => setActiveEditField("email")}
              className="flex items-center justify-between py-3.5 px-3.5 cursor-pointer hover:bg-zinc-50 transition-colors rounded-xl"
            >
              <div className="flex items-center gap-4">
                <Mail className="h-5 w-5 text-zinc-400" />
                <span className="font-outfit text-[15px] font-bold text-zinc-700">Email</span>
              </div>
              <div className="flex items-center gap-2 min-w-0">
                <span className="font-sans text-[14.5px] font-medium text-zinc-900 truncate max-w-[200px]">
                  {email || "Set"}
                </span>
                <ChevronRight className="h-5 w-5 text-[#7B82F4] shrink-0" />
              </div>
            </div>

            {/* Phone Row */}
            <div
              onClick={() => setActiveEditField("phone")}
              className="flex items-center justify-between py-3.5 px-3.5 cursor-pointer hover:bg-zinc-50 transition-colors rounded-xl"
            >
              <div className="flex items-center gap-4">
                <Phone className="h-5 w-5 text-zinc-400" />
                <span className="font-outfit text-[15px] font-bold text-zinc-700">Phone</span>
              </div>
              <div className="flex items-center gap-2">
                <span className="font-sans text-[14.5px] font-medium text-zinc-900">
                  {phone || "Set"}
                </span>
                <ChevronRight className="h-5 w-5 text-[#7B82F4] shrink-0" />
              </div>
            </div>

            {/* Birthdate Row */}
            <div
              onClick={() => setActiveEditField("birthdate")}
              className="flex items-center justify-between py-3.5 px-3.5 cursor-pointer hover:bg-zinc-50 transition-colors rounded-xl"
            >
              <div className="flex items-center gap-4">
                <Calendar className="h-5 w-5 text-zinc-400" />
                <span className="font-outfit text-[15px] font-bold text-zinc-700">Birthdate</span>
              </div>
              <div className="flex items-center gap-2">
                <span className="font-sans text-[14.5px] font-medium text-zinc-900">
                  {birthdate || "Set"}
                </span>
                <ChevronRight className="h-5 w-5 text-[#7B82F4] shrink-0" />
              </div>
            </div>

            {/* Gender Row */}
            <div
              onClick={() => setActiveEditField("gender")}
              className="flex items-center justify-between py-3.5 px-3.5 cursor-pointer hover:bg-zinc-50 transition-colors rounded-xl"
            >
              <div className="flex items-center gap-4">
                <Smile className="h-5 w-5 text-zinc-400" />
                <span className="font-outfit text-[15px] font-bold text-zinc-700">Gender</span>
              </div>
              <div className="flex items-center gap-2">
                <span className="font-outfit text-[14.5px] font-bold text-zinc-900 capitalize">
                  {gender || "Set"}
                </span>
                <ChevronRight className="h-5 w-5 text-[#7B82F4] shrink-0" />
              </div>
            </div>
          </div>
        </div>

      </div>

      {/* ── 3. EDIT SLIDE-UP BOTTOM SHEET ── */}
      {activeEditField && (
        <div 
          className="fixed inset-0 z-50 flex flex-col justify-end bg-black/40 backdrop-blur-[2px] transition-opacity"
          onClick={() => setActiveEditField(null)}
        >
          <div
            className="w-full max-w-md mx-auto bg-white rounded-t-[28px] p-6 shadow-2xl relative animate-slide-up"
            onClick={(e) => e.stopPropagation()}
          >
            <form onSubmit={handleSave} className="space-y-6">
              <div className="flex justify-between items-center pb-2 border-b border-zinc-100">
                <h3 className="font-outfit text-[18px] font-bold text-zinc-900 capitalize">
                  Edit {activeEditField === "birthdate" ? "Birthdate" : activeEditField}
                </h3>
                <button
                  type="button"
                  onClick={() => setActiveEditField(null)}
                  disabled={saving}
                  className="p-1.5 rounded-full hover:bg-zinc-100 text-zinc-500 focus:outline-none"
                >
                  <X className="h-5 w-5" />
                </button>
              </div>

              {/* Dynamic Inputs depending on selected field */}
              {activeEditField === "name" && (
                <div className="space-y-4">
                  <div className="flex flex-col gap-1.5">
                    <label className="text-[12px] font-bold text-zinc-400 uppercase tracking-wider">
                      First Name
                    </label>
                    <input
                      type="text"
                      required
                      value={firstName}
                      onChange={(e) => setFirstName(e.target.value)}
                      className="w-full h-12 px-4 rounded-xl border border-zinc-200 bg-[#F1F4F8]/50 font-sans font-semibold text-[15px] focus:border-[#7B82F4] focus:outline-none"
                    />
                  </div>
                  <div className="flex flex-col gap-1.5">
                    <label className="text-[12px] font-bold text-zinc-400 uppercase tracking-wider">
                      Last Name
                    </label>
                    <input
                      type="text"
                      value={lastName}
                      onChange={(e) => setLastName(e.target.value)}
                      className="w-full h-12 px-4 rounded-xl border border-zinc-200 bg-[#F1F4F8]/50 font-sans font-semibold text-[15px] focus:border-[#7B82F4] focus:outline-none"
                    />
                  </div>
                </div>
              )}

              {activeEditField === "email" && (
                <div className="flex flex-col gap-1.5">
                  <label className="text-[12px] font-bold text-zinc-400 uppercase tracking-wider">
                    Email Address
                  </label>
                  <input
                    type="email"
                    required
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="w-full h-12 px-4 rounded-xl border border-zinc-200 bg-[#F1F4F8]/50 font-sans font-semibold text-[15px] focus:border-[#7B82F4] focus:outline-none"
                  />
                </div>
              )}

              {activeEditField === "phone" && (
                <div className="flex flex-col gap-1.5">
                  <label className="text-[12px] font-bold text-zinc-400 uppercase tracking-wider">
                    Phone Number
                  </label>
                  <input
                    type="tel"
                    required
                    value={phone}
                    onChange={(e) => setPhone(e.target.value)}
                    className="w-full h-12 px-4 rounded-xl border border-zinc-200 bg-[#F1F4F8]/50 font-sans font-semibold text-[15px] focus:border-[#7B82F4] focus:outline-none"
                  />
                </div>
              )}

              {activeEditField === "birthdate" && (
                <div className="flex flex-col gap-1.5">
                  <label className="text-[12px] font-bold text-zinc-400 uppercase tracking-wider">
                    Birthdate
                  </label>
                  <input
                    type="date"
                    value={birthdate}
                    onChange={(e) => setBirthdate(e.target.value)}
                    className="w-full h-12 px-4 rounded-xl border border-zinc-200 bg-[#F1F4F8]/50 font-sans font-semibold text-[15px] focus:border-[#7B82F4] focus:outline-none"
                  />
                </div>
              )}

              {activeEditField === "gender" && (
                <div className="flex flex-col gap-1.5">
                  <label className="text-[12px] font-bold text-zinc-400 uppercase tracking-wider">
                    Gender
                  </label>
                  <select
                    value={gender}
                    onChange={(e) => setGender(e.target.value)}
                    className="w-full h-12 px-4 rounded-xl border border-zinc-200 bg-[#F1F4F8]/50 font-sans font-semibold text-[15px] focus:border-[#7B82F4] focus:outline-none appearance-none"
                  >
                    <option value="">Select...</option>
                    <option value="male">Male</option>
                    <option value="female">Female</option>
                    <option value="other">Other</option>
                  </select>
                </div>
              )}

              <button
                type="submit"
                disabled={saving}
                className="w-full h-12 bg-zinc-900 text-white font-outfit font-bold rounded-xl active:scale-[0.98] transition-all hover:bg-zinc-800 disabled:opacity-50 flex items-center justify-center gap-2 shadow-sm"
              >
                {saving ? (
                  <>
                    <Loader2 className="h-5 w-5 animate-spin text-white" />
                    <span>Saving...</span>
                  </>
                ) : (
                  <>
                    <Check className="h-5 w-5" />
                    <span>Save changes</span>
                  </>
                )}
              </button>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
