"use client";

import React, { createContext, useContext, useState, useEffect } from "react";
import { User, Session } from "@supabase/supabase-js";
import { supabase } from "@/lib/supabase";
import { AddressStruct, BookingDraft, UserProfile } from "@/lib/types";

interface ClientAuthContextProps {
  user: User | null;
  session: Session | null;
  profile: UserProfile | null;
  selectedAddress: AddressStruct | null;
  savedAddresses: AddressStruct[];
  currentZoneId: number | null;
  isLoading: boolean;
  cart: BookingDraft[];
  activeBookingDraft: BookingDraft | null;
  setAddress: (address: AddressStruct) => Promise<void>;
  refreshAddresses: () => Promise<void>;
  updateCart: (newCart: BookingDraft[]) => void;
  setActiveDraft: (draft: BookingDraft | null) => void;
  signOut: () => Promise<void>;
}

const ClientAuthContext = createContext<ClientAuthContextProps | undefined>(undefined);

export function ClientAuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [session, setSession] = useState<Session | null>(null);
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [selectedAddress, setSelectedAddress] = useState<AddressStruct | null>(null);
  const [savedAddresses, setSavedAddresses] = useState<AddressStruct[]>([]);
  const [currentZoneId, setCurrentZoneId] = useState<number | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  // Cart state
  const [cart, setCart] = useState<BookingDraft[]>([]);
  const [activeBookingDraft, setActiveBookingDraft] = useState<BookingDraft | null>(null);

  // Fetch zone ID for the given address coordinates
  const fetchZoneId = async (lat: number, lng: number) => {
    try {
      const { data, error } = await supabase.rpc("get_zone_for_location", {
        user_lat: lat,
        user_lng: lng,
      });
      if (!error && data) {
        setCurrentZoneId(Number(data.zone_id || data.id || null));
      } else {
        // Fallback or default
        setCurrentZoneId(1); // Default to Toronto zone
      }
    } catch {
      setCurrentZoneId(1);
    }
  };

  // Fetch houses/addresses and profile data
  const loadUserData = async (currentUser: User) => {
    try {
      setIsLoading(true);
      
      // 1. Fetch Profile
      const { data: profileData, error: profileErr } = await supabase
        .from("profiles")
        .select("*")
        .eq("id", currentUser.id)
        .maybeSingle();

      if (profileErr) {
        console.error("Error loading profile:", profileErr);
      }

      // 2. Fetch Houses
      const { data: housesData, error: housesErr } = await supabase
        .from("houses")
        .select("*")
        .eq("user_id", currentUser.id)
        .order("is_default", { ascending: false });

      if (housesErr) {
        console.error("Error loading houses:", housesErr);
      }

      const mappedAddresses: AddressStruct[] = (housesData || []).map((h: any) => ({
        id: h.id,
        fullAddress: h.full_address,
        lat: Number(h.lat),
        lng: Number(h.lng),
        zipCode: h.zip_code,
        city: h.city,
        isDefault: !!h.is_default,
        nameLabel: h.name_label || "Home",
        propertyType: h.property_type || "Apartment",
      }));

      setSavedAddresses(mappedAddresses);

      // Determine selected address
      let currentSelection: AddressStruct | null = null;
      const currentHouseId = profileData?.current_house_id;

      if (currentHouseId) {
        currentSelection = mappedAddresses.find((a) => a.id === currentHouseId) || null;
      }
      
      if (!currentSelection && mappedAddresses.length > 0) {
        currentSelection = mappedAddresses[0];
      }

      setSelectedAddress(currentSelection);

      if (currentSelection) {
        await fetchZoneId(currentSelection.lat, currentSelection.lng);
      }

      setProfile(
        profileData
          ? {
              id: profileData.id,
              firstName: profileData.first_name,
              lastName: profileData.last_name,
              phoneNumber: profileData.phone_number,
              avatarUrl: profileData.avatar_url,
              currentHouseId: currentHouseId,
              savedAddresses: mappedAddresses,
            }
          : null
      );
    } catch (err) {
      console.error("Failed to load user data:", err);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    // 1. Initial Session Check
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setUser(session?.user ?? null);
      if (session?.user) {
        loadUserData(session.user);
      } else {
        setIsLoading(false);
      }
    });

    // 2. Auth state change listener
    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, currentSession) => {
        setSession(currentSession);
        setUser(currentSession?.user ?? null);

        if (event === "SIGNED_IN" && currentSession?.user) {
          await loadUserData(currentSession.user);
        } else if (event === "SIGNED_OUT") {
          setProfile(null);
          setSelectedAddress(null);
          setSavedAddresses([]);
          setCurrentZoneId(null);
          setCart([]);
          setActiveBookingDraft(null);
          setIsLoading(false);
        }
      }
    );

    return () => {
      subscription.unsubscribe();
    };
  }, []);

  const setAddress = async (address: AddressStruct) => {
    if (!user || !address.id) return;
    try {
      setSelectedAddress(address);
      await fetchZoneId(address.lat, address.lng);

      // Update current_house_id in profiles
      const { error } = await supabase
        .from("profiles")
        .update({ current_house_id: address.id })
        .eq("id", user.id);

      if (error) {
        console.error("Error setting current house in profile:", error);
      }
      
      // Update local profile state
      if (profile) {
        setProfile({ ...profile, currentHouseId: address.id });
      }
    } catch (err) {
      console.error("Failed to update selected address:", err);
    }
  };

  const refreshAddresses = async () => {
    if (user) {
      await loadUserData(user);
    }
  };

  const updateCart = (newCart: BookingDraft[]) => {
    setCart(newCart);
  };

  const setActiveDraft = (draft: BookingDraft | null) => {
    setActiveBookingDraft(draft);
  };

  const signOut = async () => {
    await supabase.auth.signOut();
  };

  return (
    <ClientAuthContext.Provider
      value={{
        user,
        session,
        profile,
        selectedAddress,
        savedAddresses,
        currentZoneId,
        isLoading,
        cart,
        activeBookingDraft,
        setAddress,
        refreshAddresses,
        updateCart,
        setActiveDraft,
        signOut,
      }}
    >
      {children}
    </ClientAuthContext.Provider>
  );
}

export function useClientAuth() {
  const context = useContext(ClientAuthContext);
  if (context === undefined) {
    throw new Error("useClientAuth must be used within a ClientAuthProvider");
  }
  return context;
}
