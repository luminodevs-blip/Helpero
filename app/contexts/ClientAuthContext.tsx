"use client";

import React, { createContext, useContext, useState, useEffect } from "react";
import { User, Session } from "@supabase/supabase-js";
import { supabase } from "@/lib/supabase";
import { AddressStruct, BookingDraft, UserProfile } from "@/lib/types";
import SplashScreen from "@/components/SplashScreen";

interface ClientAuthContextProps {
  user: User | null;
  session: Session | null;
  profile: UserProfile | null;
  selectedAddress: AddressStruct | null;
  savedAddresses: AddressStruct[];
  currentZoneId: number | null;
  detectedZone: any | null;
  isLoading: boolean;
  cart: BookingDraft[];
  activeBookingDraft: BookingDraft | null;
  cartSheetOpen: boolean;
  setCartSheetOpen: (open: boolean) => void;
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
  const [detectedZone, setDetectedZone] = useState<any | null>(null);
  const [isLoading, setIsLoading] = useState(() => {
    if (typeof window !== "undefined" && window.self !== window.top) {
      return false; // Disable loading splash screens inside visual editor previews
    }
    return true;
  });

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
        const zone = Array.isArray(data) ? data[0] : data;
        if (zone) {
          setDetectedZone(zone);
          if (zone.is_active) {
            setCurrentZoneId(Number(zone.id || zone.zone_id));
          } else {
            setCurrentZoneId(null);
          }
        } else {
          setDetectedZone(null);
          setCurrentZoneId(null);
        }
      } else {
        setDetectedZone(null);
        setCurrentZoneId(null);
      }
    } catch {
      setDetectedZone(null);
      setCurrentZoneId(null);
    }
  };

  // Fetch houses/addresses and profile data
  const loadUserData = async (currentUser: User, forceLoadingState = false) => {
    try {
      const isIframe = typeof window !== "undefined" && window.self !== window.top;
      if (!isIframe && (forceLoadingState || !profile || savedAddresses.length === 0)) {
        setIsLoading(true);
      }
      
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
        floor: h.floor || "",
        unitNumber: h.unit_number || "",
        intercomCode: h.intercom_code || "",
        gateCode: h.gate_code || "",
        instructions: h.instructions || "",
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
              email: profileData.email,
              birthdate: profileData.birthdate,
              gender: profileData.gender,
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
    const isIframe = typeof window !== "undefined" && window.self !== window.top;
    if (isIframe) {
      setIsLoading(false);
    }

    try {
      // 1. Initial Session Check
      supabase.auth.getSession().then(({ data: { session } }) => {
        setSession(session);
        setUser(session?.user ?? null);
        if (session?.user) {
          loadUserData(session.user, !isIframe);
        } else {
          setIsLoading(false);
        }
      }).catch((err) => {
        console.error("Supabase getSession error:", err);
        setIsLoading(false);
      });

      // 2. Auth state change listener
      const { data: { subscription } } = supabase.auth.onAuthStateChange(
        async (event, currentSession) => {
          try {
            setSession(currentSession);
            setUser(currentSession?.user ?? null);

            if (event === "SIGNED_IN" && currentSession?.user) {
              await loadUserData(currentSession.user, true);
            } else if (event === "SIGNED_OUT") {
              setProfile(null);
              setSelectedAddress(null);
              setSavedAddresses([]);
              setCurrentZoneId(null);
              setDetectedZone(null);
              setCart([]);
              setActiveBookingDraft(null);
              setIsLoading(false);
            }
          } catch (err) {
            console.error("Auth state change callback error:", err);
            setIsLoading(false);
          }
        }
      );

      return () => {
        subscription?.unsubscribe();
      };
    } catch (err) {
      console.error("Auth initialization error (likely blocked localStorage inside iframe):", err);
      setIsLoading(false);
    }
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
      await loadUserData(user, false);
    }
  };

  // Cart sheet state
  const [cartSheetOpen, setCartSheetOpen] = useState(false);

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
        detectedZone,
        isLoading,
        cart,
        activeBookingDraft,
        cartSheetOpen,
        setCartSheetOpen,
        setAddress,
        refreshAddresses,
        updateCart,
        setActiveDraft,
        signOut,
      }}
    >
      {isLoading ? <SplashScreen /> : children}
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
