"use client";

import React, { useState, useEffect } from "react";
import { createPortal } from "react-dom";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import { X, Plus, MapPin, Check } from "lucide-react";
import { AddressStruct } from "@/lib/types";
import { useBodyScrollLock } from "@/lib/useBodyScrollLock";

interface AddressSelectorProps {
  isOpen: boolean;
  onClose: () => void;
  hideInactiveZones?: boolean;
}

export default function AddressSelector({ 
  isOpen, 
  onClose,
  hideInactiveZones = false
}: AddressSelectorProps) {
  const router = useRouter();
  const { savedAddresses, selectedAddress, setAddress } = useClientAuth();
  const [mounted, setMounted] = useState(false);
  const [activeZones, setActiveZones] = useState<any[]>([]);
  const [loadingZones, setLoadingZones] = useState(true);

  useBodyScrollLock(isOpen);

  useEffect(() => {
    setMounted(true);
  }, []);

  useEffect(() => {
    if (isOpen) {
      const fetchActiveZones = async () => {
        try {
          const { data, error } = await supabase
            .from("service_zones")
            .select("min_lat, max_lat, min_lng, max_lng")
            .eq("is_active", true);
          if (!error && data) {
            setActiveZones(data);
          }
        } catch (e) {
          console.error("Error loading active service zones:", e);
        } finally {
          setLoadingZones(false);
        }
      };
      fetchActiveZones();
    }
  }, [isOpen]);

  if (!isOpen || !mounted) return null;

  const isAddressActive = (addr: AddressStruct) => {
    return activeZones.some((zone) => {
      const minLat = Number(zone.min_lat);
      const maxLat = Number(zone.max_lat);
      const minLng = Number(zone.min_lng);
      const maxLng = Number(zone.max_lng);
      return (
        addr.lat >= minLat &&
        addr.lat <= maxLat &&
        addr.lng >= minLng &&
        addr.lng <= maxLng
      );
    });
  };

  const handleSelect = async (addr: AddressStruct) => {
    if (!isAddressActive(addr)) return; // Prevent selection of inactive addresses
    await setAddress(addr);
    onClose();
  };

  const handleAddNew = () => {
    onClose();
    router.push("/address/new");
  };

  return createPortal(
    <div className="fixed inset-0 z-[9999] flex items-end justify-center bg-black/40 backdrop-blur-[2px]">
      {/* Tap backdrop to close */}
      <div className="absolute inset-0" onClick={onClose} />

      {/* Slide up sheet */}
      <div className="relative w-full max-w-md bg-white rounded-t-[14px] shadow-2xl z-10 overflow-hidden flex flex-col max-h-[80vh] border-t border-zinc-100 animate-slide-up">
        {/* Handle Bar */}
        <div className="flex justify-center pt-3 pb-2">
          <div className="w-10 h-1 rounded-full bg-zinc-200" />
        </div>

        {/* Header */}
        <div className="flex items-center justify-between px-5 pb-4 border-b border-zinc-100">
          <h3 className="font-outfit text-xl font-bold text-zinc-900">
            Your Addresses
          </h3>
          <button
            onClick={onClose}
            className="p-1.5 rounded-full hover:bg-zinc-100 text-zinc-500 focus:outline-none transition-colors"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        {/* Saved Addresses List */}
        <div className="flex-1 overflow-y-auto px-5 pt-5 pb-5 space-y-2">
          {loadingZones ? (
            <div className="flex flex-col items-center justify-center py-[60px]">
              <div className="w-8 h-8 border-2 border-zinc-200 border-t-[#7B82F4] rounded-full animate-spin" />
              <span className="text-[13px] text-zinc-500 font-semibold mt-3">Loading addresses...</span>
            </div>
          ) : (() => {
            const addressesToRender = hideInactiveZones 
              ? savedAddresses.filter(isAddressActive)
              : savedAddresses;

            if (addressesToRender.length === 0) {
              return (
                <div className="text-center py-8 text-sm text-zinc-500 font-medium">
                  {savedAddresses.length > 0 
                    ? "No saved addresses are currently in active service zones."
                    : "No addresses saved yet."}
                </div>
              );
            }

            return addressesToRender.map((addr) => {
              const isSelected = selectedAddress?.id === addr.id;
              const isActive = isAddressActive(addr);
              
              return (
                <div
                  key={addr.id}
                  onClick={() => isActive && handleSelect(addr)}
                  className={`flex items-center justify-between p-4 rounded-[10px] border transition-all ${
                    isSelected
                      ? "border-[#7B82F4] bg-[#7B82F4]/5"
                      : !isActive
                      ? "border-zinc-100 bg-zinc-50/50 opacity-60 cursor-not-allowed"
                      : "border-zinc-200 bg-[#F1F4F8] hover:bg-zinc-100 cursor-pointer"
                  }`}
                >
                  <div className="flex items-start gap-3">
                    <div className={`p-2 rounded-[8px] mt-0.5 ${
                      isSelected ? "bg-[#7B82F4] text-white" : "bg-white border border-zinc-200 text-zinc-500"
                    }`}>
                      <MapPin className="h-4 w-4" />
                    </div>
                    <div>
                      <p className={`text-sm font-bold leading-tight ${isSelected ? "text-[#7B82F4]" : "text-zinc-900"}`}>
                        {addr.nameLabel}
                      </p>
                      <p className="text-xs text-zinc-500 mt-1 max-w-[200px] truncate leading-normal">
                        {addr.fullAddress}
                      </p>
                    </div>
                  </div>
                  {isSelected ? (
                    <div className="h-5 w-5 rounded-full bg-[#7B82F4] text-white flex items-center justify-center shrink-0">
                      <Check className="h-3.5 w-3.5" strokeWidth={3} />
                    </div>
                  ) : !isActive ? (
                    <span className="text-[10px] font-extrabold text-red-500 bg-red-50 px-2 py-0.5 rounded-full border border-red-100 shrink-0 ml-2">
                      Out of zone
                    </span>
                  ) : null}
                </div>
              );
            });
          })()}
        </div>

        {/* Add New Address Button footer */}
        <div className="px-5 pt-5 pb-10 border-t border-zinc-100 bg-white">
          <button
            onClick={handleAddNew}
            className="flex items-center justify-center gap-2 w-full h-14 rounded-full border-2 border-dashed border-[#7B82F4] text-[#7B82F4] font-sans text-base font-bold hover:bg-[#7B82F4]/5 focus:outline-none transition-colors"
          >
            <Plus className="h-5 w-5" />
            Add New Address
          </button>
        </div>
      </div>
    </div>,
    document.body
  );
}

