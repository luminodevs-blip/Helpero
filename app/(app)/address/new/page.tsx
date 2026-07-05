"use client";

import React, { useState, useEffect, useRef } from "react";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import { ArrowLeft, MapPin, Search, Loader2 } from "lucide-react";

declare global {
  interface Window {
    google: any;
  }
}

// Google Maps API Key fallback
const GOOGLE_MAPS_API_KEY = process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY || "AIzaSyC_tcXVeDFmHjvpPz-ZMZXceu5PSppmXPM";

export default function AddAddressPage() {
  const router = useRouter();
  const { user, setAddress, refreshAddresses } = useClientAuth();

  const mapRef = useRef<HTMLDivElement>(null);
  const mapInstanceRef = useRef<any>(null);
  const geocoderRef = useRef<any>(null);
  const searchInputRef = useRef<HTMLInputElement>(null);

  // States
  const [mapLoaded, setMapLoaded] = useState(false);
  const [pickedAddress, setPickedAddress] = useState("");
  const [pickedLat, setPickedLat] = useState(43.6532); // Toronto default
  const [pickedLng, setPickedLng] = useState(-79.3832);
  const [pickedCity, setPickedCity] = useState("Toronto");
  const [pickedZip, setPickedZip] = useState("");
  const [geocoding, setGeocoding] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Search autocomplete states
  const [searchOpen, setSearchOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [suggestions, setSuggestions] = useState<any[]>([]);
  const [searchingSuggestions, setSearchingSuggestions] = useState(false);

  // Load Google Maps Script
  useEffect(() => {
    if (window.google && window.google.maps) {
      setMapLoaded(true);
      return;
    }

    const script = document.createElement("script");
    script.src = `https://maps.googleapis.com/maps/api/js?key=${GOOGLE_MAPS_API_KEY}&libraries=places`;
    script.async = true;
    script.defer = true;
    script.onload = () => {
      setMapLoaded(true);
    };
    script.onerror = () => {
      setError("Failed to load Google Maps script. Check your internet connection.");
    };
    document.head.appendChild(script);

    return () => {
      // Clean up if needed
    };
  }, []);

  // Initialize Map
  useEffect(() => {
    if (!mapLoaded || !mapRef.current || mapInstanceRef.current) return;

    const initialCoords = { lat: pickedLat, lng: pickedLng };
    
    // Create Map
    const map = new window.google.maps.Map(mapRef.current, {
      center: initialCoords,
      zoom: 15,
      disableDefaultUI: true,
      zoomControl: false,
    });

    mapInstanceRef.current = map;
    geocoderRef.current = new window.google.maps.Geocoder();

    // Map drag end listener (idle event)
    map.addListener("idle", () => {
      const center = map.getCenter();
      const lat = center.lat();
      const lng = center.lng();

      setPickedLat(lat);
      setPickedLng(lng);
      reverseGeocode(lat, lng);
    });
  }, [mapLoaded]);

  // Reverse Geocoding
  const reverseGeocode = (lat: number, lng: number) => {
    if (!geocoderRef.current) return;

    setGeocoding(true);
    geocoderRef.current.geocode(
      { location: { lat, lng } },
      (results: any, status: string) => {
        setGeocoding(false);
        if (status === "OK" && results[0]) {
          const address = results[0].formatted_address;
          setPickedAddress(address);

          // Extract city and zip code from address components
          let city = "Toronto";
          let zip = "";
          const components = results[0].address_components;
          for (const component of components) {
            const types = component.types;
            if (types.includes("locality")) {
              city = component.long_name;
            } else if (types.includes("postal_code")) {
              zip = component.long_name;
            }
          }
          setPickedCity(city);
          setPickedZip(zip);
        } else {
          console.error("Geocoder failed due to: " + status);
        }
      }
    );
  };

  // Search Address suggestions
  const fetchSuggestions = (query: string) => {
    if (!query.trim() || !window.google || !window.google.maps) return;

    setSearchingSuggestions(true);
    const service = new window.google.maps.places.AutocompleteService();
    service.getPlacePredictions(
      {
        input: query,
        componentRestrictions: { country: "ca" }, // Default restriction to Canada
      },
      (predictions: any, status: string) => {
        setSearchingSuggestions(false);
        if (status === "OK" && predictions) {
          setSuggestions(predictions);
        } else {
          setSuggestions([]);
        }
      }
    );
  };

  // Handle Autocomplete selection
  const handleSelectSuggestion = (placeId: string, description: string) => {
    if (!geocoderRef.current || !mapInstanceRef.current) return;

    setGeocoding(true);
    setSearchOpen(false);
    setSearchQuery("");
    setSuggestions([]);

    geocoderRef.current.geocode(
      { placeId },
      (results: any, status: string) => {
        setGeocoding(false);
        if (status === "OK" && results[0]) {
          const location = results[0].geometry.location;
          const lat = location.lat();
          const lng = location.lng();

          setPickedLat(lat);
          setPickedLng(lng);
          setPickedAddress(results[0].formatted_address);

          // Extract city & zip
          let city = "Toronto";
          let zip = "";
          for (const component of results[0].address_components) {
            const types = component.types;
            if (types.includes("locality")) {
              city = component.long_name;
            } else if (types.includes("postal_code")) {
              zip = component.long_name;
            }
          }
          setPickedCity(city);
          setPickedZip(zip);

          // Move Map
          mapInstanceRef.current.panTo({ lat, lng });
          mapInstanceRef.current.setZoom(16);
        }
      }
    );
  };

  // Submit / Confirm Address
  const handleConfirmAddress = async () => {
    if (!pickedAddress || submitting) return;
    if (!user) {
      setError("You must be logged in to confirm an address");
      return;
    }

    setSubmitting(true);
    setError(null);

    try {
      // 1. Insert into houses
      const { data: newHouse, error: insertError } = await supabase
        .from("houses")
        .insert({
          user_id: user.id,
          full_address: pickedAddress,
          lat: pickedLat,
          lng: pickedLng,
          zip_code: pickedZip || null,
          city: pickedCity,
          is_default: true,
          property_type: "Apartment",
          name_label: "Home",
        })
        .select()
        .single();

      if (insertError) {
        throw new Error(insertError.message);
      }

      // 2. Refreshes context addresses list and sets the active selection
      await refreshAddresses();

      // 3. Map structure for Context state update
      const newAddressStruct = {
        id: newHouse.id,
        fullAddress: newHouse.full_address,
        lat: Number(newHouse.lat),
        lng: Number(newHouse.lng),
        zipCode: newHouse.zip_code,
        city: newHouse.city,
        isDefault: !!newHouse.is_default,
        nameLabel: newHouse.name_label || "Home",
        propertyType: newHouse.property_type || "Apartment",
      };

      await setAddress(newAddressStruct);

      // Redirect to Home
      router.push("/");
    } catch (err: any) {
      setError(err?.message || "Failed to confirm address. Please try again.");
      setSubmitting(false);
    }
  };

  // Debounced Search suggestion trigger
  useEffect(() => {
    const delayDebounceFn = setTimeout(() => {
      if (searchQuery) {
        fetchSuggestions(searchQuery);
      }
    }, 400);

    return () => clearTimeout(delayDebounceFn);
  }, [searchQuery]);

  return (
    <div className="relative w-full max-w-md mx-auto h-screen bg-bg-primary overflow-hidden flex flex-col border-x border-alternate shadow-md">
      {/* Map View */}
      <div className="flex-1 w-full relative">
        {!mapLoaded ? (
          <div className="absolute inset-0 flex items-center justify-center bg-bg-secondary">
            <Loader2 className="h-8 w-8 text-primary animate-spin" />
          </div>
        ) : (
          <div ref={mapRef} className="w-full h-full" />
        )}

        {/* Float Back Button */}
        <button
          onClick={() => router.back()}
          className="absolute top-4 left-4 z-10 flex h-11 w-11 items-center justify-center rounded-full bg-bg-secondary shadow-md border border-alternate hover:bg-bg-primary active:scale-95 transition-all focus:outline-none"
        >
          <ArrowLeft className="h-5 w-5 text-text-primary" />
        </button>

        {/* Center Map Pin Overlay */}
        {mapLoaded && (
          <div className="absolute inset-0 pointer-events-none flex items-center justify-center">
            <div className="flex flex-col items-center -mt-10">
              <MapPin className="h-10 w-10 text-primary drop-shadow-md animate-bounce" />
              {/* Little shadow dot on floor */}
              <div className="w-2.5 h-1 bg-black/30 rounded-full blur-[1px] mt-0.5" />
            </div>
          </div>
        )}
      </div>

      {/* Bottom Panel */}
      <div className="bg-bg-secondary rounded-t-[24px] shadow-2xl p-6 relative z-10 border-t border-alternate flex flex-col gap-5">
        <div>
          <h3 className="font-outfit text-xl font-bold text-text-primary">
            Where should the pro come?
          </h3>
          <p className="text-xs text-text-secondary mt-1">
            Drag the map to position the pin exactly on your home.
          </p>
        </div>

        {/* Search Trigger */}
        <div
          onClick={() => {
            setSearchOpen(true);
            setTimeout(() => searchInputRef.current?.focus(), 150);
          }}
          className="flex items-center gap-3 p-3.5 rounded-xl border border-alternate bg-bg-primary cursor-pointer hover:border-primary/50 transition-colors"
        >
          <Search className="h-4.5 w-4.5 text-text-secondary" />
          <span className="text-sm font-medium text-text-secondary truncate">
            {pickedAddress || "Search address..."}
          </span>
        </div>

        {/* Geocoding indicator or formatted address */}
        <div className="h-5 flex items-center justify-center">
          {geocoding ? (
            <div className="flex items-center gap-2 text-xs font-semibold text-primary">
              <Loader2 className="h-3.5 w-3.5 animate-spin" />
              Locating address...
            </div>
          ) : (
            pickedAddress && (
              <span className="text-xs font-medium text-text-secondary truncate max-w-xs">
                Selected: {pickedAddress}
              </span>
            )
          )}
        </div>

        {error && (
          <div className="rounded-lg bg-error/10 p-2.5 text-xs text-error border border-error/20 text-center">
            {error}
          </div>
        )}

        {/* Confirm Button */}
        <button
          onClick={handleConfirmAddress}
          disabled={!pickedAddress || geocoding || submitting}
          className="flex w-full items-center justify-center h-14 rounded-full bg-primary text-white font-sans text-base font-bold shadow-md hover:bg-primary/95 focus:outline-none disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
        >
          {submitting ? <Loader2 className="h-5 w-5 animate-spin" /> : "Confirm Address"}
        </button>
      </div>

      {/* Address Search Modal Overlay */}
      {searchOpen && (
        <div className="absolute inset-0 z-40 bg-bg-secondary flex flex-col">
          {/* Header */}
          <div className="flex items-center gap-4 px-4 py-3.5 border-b border-alternate">
            <button
              onClick={() => {
                setSearchOpen(false);
                setSearchQuery("");
                setSuggestions([]);
              }}
              className="p-1 rounded-full hover:bg-bg-primary text-text-primary focus:outline-none"
            >
              <ArrowLeft className="h-5 w-5" />
            </button>
            <div className="flex-1 flex items-center gap-2 p-2 rounded-xl bg-bg-primary border border-alternate">
              <Search className="h-4 w-4 text-text-secondary" />
              <input
                type="text"
                ref={searchInputRef}
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Enter address or postal code..."
                className="w-full bg-transparent border-none outline-none text-sm text-text-primary placeholder-text-secondary focus:ring-0"
              />
            </div>
          </div>

          {/* Suggestions List */}
          <div className="flex-1 overflow-y-auto p-4 space-y-2">
            {searchingSuggestions ? (
              <div className="flex items-center justify-center py-10">
                <Loader2 className="h-6 w-6 text-primary animate-spin" />
              </div>
            ) : (
              suggestions.map((s) => (
                <div
                  key={s.place_id}
                  onClick={() => handleSelectSuggestion(s.place_id, s.description)}
                  className="flex items-start gap-3 p-3.5 rounded-xl border border-alternate hover:border-primary/50 cursor-pointer bg-bg-primary/50 hover:bg-bg-primary transition-all"
                >
                  <MapPin className="h-4.5 w-4.5 text-text-secondary mt-0.5 flex-shrink-0" />
                  <span className="text-sm font-medium text-text-primary leading-normal">
                    {s.description}
                  </span>
                </div>
              ))
            )}

            {searchQuery && !searchingSuggestions && suggestions.length === 0 && (
              <div className="text-center py-10 text-sm text-text-secondary">
                No matching addresses found.
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
