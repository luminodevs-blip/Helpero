"use client";

import React from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { X, Plus, MapPin, Check } from "lucide-react";
import { AddressStruct } from "@/lib/types";

interface AddressSelectorProps {
  isOpen: boolean;
  onClose: () => void;
}

export default function AddressSelector({ isOpen, onClose }: AddressSelectorProps) {
  const router = useRouter();
  const { savedAddresses, selectedAddress, setAddress } = useClientAuth();

  if (!isOpen) return null;

  const handleSelect = async (addr: AddressStruct) => {
    await setAddress(addr);
    onClose();
  };

  const handleAddNew = () => {
    onClose();
    router.push("/address/new");
  };

  return (
    <div className="fixed inset-0 z-50 flex items-end justify-center bg-black/40 backdrop-blur-[2px]">
      {/* Tap backdrop to close */}
      <div className="absolute inset-0" onClick={onClose} />

      {/* Slide up sheet */}
      <div className="relative w-full max-w-md bg-white rounded-t-[28px] shadow-2xl z-10 overflow-hidden flex flex-col max-h-[80vh] border-t border-zinc-100 animate-slide-up">
        {/* Handle Bar */}
        <div className="flex justify-center py-3">
          <div className="w-10 h-1 rounded-full bg-zinc-200" />
        </div>

        {/* Header */}
        <div className="flex items-center justify-between px-6 pb-4 border-b border-zinc-100">
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
        <div className="flex-1 overflow-y-auto px-6 py-4 space-y-3">
          {savedAddresses.map((addr) => {
            const isSelected = selectedAddress?.id === addr.id;
            return (
              <div
                key={addr.id}
                onClick={() => handleSelect(addr)}
                className={`flex items-center justify-between p-4 rounded-2xl border cursor-pointer transition-all ${
                  isSelected
                    ? "border-[#7B82F4] bg-[#7B82F4]/5"
                    : "border-zinc-200 bg-[#F1F4F8] hover:bg-zinc-100"
                }`}
              >
                <div className="flex items-start gap-3">
                  <div className={`p-2 rounded-xl mt-0.5 ${
                    isSelected ? "bg-[#7B82F4] text-white" : "bg-white border border-zinc-200 text-zinc-500"
                  }`}>
                    <MapPin className="h-4 w-4" />
                  </div>
                  <div>
                    <p className={`text-sm font-bold leading-tight ${isSelected ? "text-[#7B82F4]" : "text-zinc-900"}`}>
                      {addr.nameLabel}
                    </p>
                    <p className="text-xs text-zinc-500 mt-1 max-w-[240px] truncate leading-normal">
                      {addr.fullAddress}
                    </p>
                  </div>
                </div>
                {isSelected && (
                  <div className="h-5 w-5 rounded-full bg-[#7B82F4] text-white flex items-center justify-center shrink-0">
                    <Check className="h-3.5 w-3.5" strokeWidth={3} />
                  </div>
                )}
              </div>
            );
          })}

          {savedAddresses.length === 0 && (
            <div className="text-center py-6 text-sm text-zinc-400 font-medium">
              No addresses saved yet
            </div>
          )}
        </div>

        {/* Add New Address Button footer */}
        <div className="p-6 border-t border-zinc-100 bg-white">
          <button
            onClick={handleAddNew}
            className="flex items-center justify-center gap-2 w-full h-14 rounded-full border-2 border-dashed border-[#7B82F4] text-[#7B82F4] font-sans text-base font-bold hover:bg-[#7B82F4]/5 focus:outline-none transition-colors"
          >
            <Plus className="h-5 w-5" />
            Add New Address
          </button>
        </div>
      </div>
    </div>
  );
}

