"use client";

import React, { useState } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import {
  ArrowLeft,
  Home,
  ChevronRight,
  Plus,
  Trash2,
  Check,
  Loader2,
  X,
  MapPin,
  Building,
  Briefcase,
} from "lucide-react";

export default function AddressesPage() {
  const router = useRouter();
  const { savedAddresses, refreshAddresses, user } = useClientAuth();
  const [selectedAddress, setSelectedAddress] = useState<any | null>(null);
  const [deleting, setDeleting] = useState(false);

  const handleMakeDefault = async (addressId: number) => {
    if (!user) return;
    try {
      // 1. Reset all houses of this user to is_default = false
      await supabase
        .from("houses")
        .update({ is_default: false })
        .eq("user_id", user.id);

      // 2. Set target house to is_default = true
      await supabase
        .from("houses")
        .update({ is_default: true })
        .eq("id", addressId)
        .eq("user_id", user.id);

      // 3. Refresh profile/addresses in context
      await refreshAddresses();
      setSelectedAddress(null);
    } catch (err) {
      console.error("Failed to update default address:", err);
    }
  };

  const handleDeleteAddress = async () => {
    if (!selectedAddress || !user) return;
    setDeleting(true);
    try {
      const { error } = await supabase
        .from("houses")
        .delete()
        .eq("id", selectedAddress.id)
        .eq("user_id", user.id);

      if (error) throw error;

      await refreshAddresses();
      setSelectedAddress(null);
    } catch (err) {
      console.error("Error deleting address:", err);
      alert("Failed to delete address");
    } finally {
      setDeleting(false);
    }
  };

  const getAddressIcon = (label: string) => {
    const l = label.toLowerCase();
    if (l.includes("work") || l.includes("office")) return Briefcase;
    if (l.includes("apartment") || l.includes("condo")) return Building;
    return Home;
  };

  return (
    <div className="flex flex-col flex-1 bg-white min-h-screen animate-page-fade-in font-sans relative">
      {/* Header */}
      <div className="px-5 pt-12 pb-4 flex flex-col gap-4">
        <button
          onClick={() => router.back()}
          className="p-2 -ml-2 self-start rounded-full hover:bg-zinc-100 transition-colors focus:outline-none"
        >
          <ArrowLeft className="h-6 w-6 text-zinc-900" />
        </button>
        <h1 className="font-outfit text-[28px] font-bold text-zinc-900 leading-tight">
          Addresses
        </h1>
      </div>

      {/* Content List */}
      <div className="px-5 space-y-5 flex-1 pb-10">
        
        {savedAddresses.length === 0 ? (
          <div className="p-8 border border-dashed border-zinc-200 rounded-2xl text-center">
            <MapPin className="h-10 w-10 text-zinc-300 mx-auto mb-2" />
            <p className="font-outfit text-[16px] font-bold text-zinc-800">
              No saved addresses
            </p>
            <p className="text-[12px] text-zinc-400 mt-1 max-w-[240px] mx-auto leading-relaxed">
              Add your home or office address to see local availability and book bookings.
            </p>
          </div>
        ) : (
          <div className="space-y-4">
            {savedAddresses.map((addr) => {
              const IconComponent = getAddressIcon(addr.nameLabel);
              return (
                <div
                  key={addr.id}
                  onClick={() => setSelectedAddress(addr)}
                  className={`flex items-center justify-between p-4 rounded-2xl border transition-all cursor-pointer bg-white hover:border-zinc-300 ${
                    addr.isDefault
                      ? "border-[#7B82F4] ring-1 ring-[#7B82F4]"
                      : "border-zinc-200/80"
                  }`}
                >
                  <div className="flex items-center gap-4 min-w-0 flex-1">
                    {/* Square button-like icon box exactly matching screenshot */}
                    <div className="w-12 h-12 rounded-xl bg-zinc-50 border border-zinc-100 flex items-center justify-center shrink-0 shadow-sm">
                      <IconComponent className="h-5 w-5 text-[#7B82F4]" />
                    </div>

                    <div className="flex flex-col min-w-0 flex-1">
                      <div className="flex items-center gap-2">
                        <span className="font-outfit text-[15px] font-bold text-zinc-900 truncate">
                          {addr.nameLabel}
                        </span>
                        {addr.isDefault && (
                          <span className="px-2 py-0.5 text-[10px] font-bold text-green-700 bg-green-50 rounded-full border border-green-200 shrink-0">
                            Default
                          </span>
                        )}
                      </div>
                      <span className="text-[12.5px] font-medium text-zinc-500 mt-1 truncate">
                        {addr.city ? `${addr.city} • ` : ""}{addr.fullAddress}
                      </span>
                    </div>
                  </div>

                  <ChevronRight className="h-5 w-5 text-[#7B82F4] shrink-0 ml-2" />
                </div>
              );
            })}
          </div>
        )}

        {/* Add New Property Button exactly matching screenshot */}
        <button
          onClick={() => router.push("/address/new")}
          className="w-full h-12 border border-[#7B82F4] text-[#7B82F4] bg-white rounded-xl active:scale-[0.98] transition-all flex items-center justify-center font-sans font-semibold text-[15px] hover:bg-[#7B82F4]/5"
        >
          + Add New Property
        </button>
      </div>

      {/* ── ADDRESS OPTIONS SHEET ── */}
      {selectedAddress && (
        <div 
          className="fixed inset-0 z-50 flex flex-col justify-end bg-black/40 backdrop-blur-[2px] transition-opacity"
          onClick={() => setSelectedAddress(null)}
        >
          <div
            className="w-full max-w-md mx-auto bg-white rounded-t-[28px] p-6 shadow-2xl relative animate-slide-up"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex justify-between items-center pb-4 border-b border-zinc-100 mb-4">
              <h3 className="font-outfit text-[18px] font-bold text-zinc-900">
                {selectedAddress.nameLabel}
              </h3>
              <button
                type="button"
                onClick={() => setSelectedAddress(null)}
                disabled={deleting}
                className="p-1.5 rounded-full hover:bg-zinc-100 text-zinc-500 focus:outline-none"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            <p className="text-[14px] text-zinc-500 font-sans font-medium mb-6">
              {selectedAddress.fullAddress}
            </p>

            <div className="space-y-3">
              {/* Make Default Address */}
              {!selectedAddress.isDefault && (
                <button
                  onClick={() => handleMakeDefault(selectedAddress.id)}
                  disabled={deleting}
                  className="w-full h-12 bg-[#7B82F4] text-white font-sans font-semibold rounded-xl flex items-center justify-center gap-2 hover:bg-[#6c73e3] active:scale-[0.98] transition-all"
                >
                  <Check className="h-5 w-5" />
                  <span>Set as Default</span>
                </button>
              )}

              {/* Delete Address */}
              <button
                onClick={handleDeleteAddress}
                disabled={deleting}
                className="w-full h-12 bg-red-600 hover:bg-red-500 text-white font-sans font-semibold rounded-xl active:scale-[0.98] transition-all disabled:opacity-50 flex items-center justify-center gap-2 shadow-sm"
              >
                {deleting ? (
                  <>
                    <Loader2 className="h-5 w-5 animate-spin text-white" />
                    <span>Removing...</span>
                  </>
                ) : (
                  <>
                    <Trash2 className="h-4.5 w-4.5" />
                    <span>Remove Address</span>
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
