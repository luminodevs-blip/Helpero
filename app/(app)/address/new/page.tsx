"use client";

import React, { useState, useEffect, useRef } from "react";
import { createPortal } from "react-dom";
import { useRouter } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import { ArrowLeft, MapPin, Search, Loader2, Navigation, X, Locate, ChevronsRight, Home, Building2, Briefcase } from "lucide-react";
import { useJsApiLoader } from "@react-google-maps/api";

declare global {
  interface Window {
    google: any;
  }
}

// Google Maps API Key fallback
const GOOGLE_MAPS_API_KEY = process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY || "AIzaSyC_tcXVeDFmHjvpPz-ZMZXceu5PSppmXPM";
const LIBRARIES: any[] = ["places"];

const MAP_STYLES = [
  {
    featureType: "all",
    elementType: "geometry",
    stylers: [{ color: "#f5f5f5" }]
  },
  {
    featureType: "all",
    elementType: "labels.icon",
    stylers: [{ visibility: "off" }]
  },
  {
    featureType: "all",
    elementType: "labels.text.fill",
    stylers: [{ color: "#9e9e9e" }]
  },
  {
    featureType: "all",
    elementType: "labels.text.stroke",
    stylers: [{ color: "#f5f5f5" }]
  },
  {
    featureType: "administrative",
    elementType: "labels",
    stylers: [{ visibility: "off" }]
  },
  {
    featureType: "poi",
    elementType: "labels",
    stylers: [{ visibility: "off" }]
  },
  {
    featureType: "transit",
    elementType: "labels",
    stylers: [{ visibility: "off" }]
  },
  {
    featureType: "road",
    elementType: "geometry",
    stylers: [{ color: "#ffffff" }]
  },
  {
    featureType: "water",
    elementType: "geometry",
    stylers: [{ color: "#c9c9c9" }]
  }
];

const splitAddress = (description: string) => {
  const commaIndex = description.indexOf(",");
  if (commaIndex === -1) {
    return { main: description, sub: "" };
  }
  return {
    main: description.slice(0, commaIndex).trim(),
    sub: description.slice(commaIndex + 1).trim()
  };
};

function GoogleMapPreview({ lat, lng }: { lat: number; lng: number }) {
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!containerRef.current || !window.google) return;
    
    new window.google.maps.Map(containerRef.current, {
      center: { lat, lng },
      zoom: 16,
      disableDefaultUI: true,
      gestureHandling: "none",
      styles: MAP_STYLES,
    });
  }, [lat, lng]);

  return (
    <div className="w-full h-full relative flex items-center justify-center bg-zinc-100">
      <div ref={containerRef} className="w-full h-full" />
      {/* Central Pin overlay */}
      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 pointer-events-none z-10 flex items-center justify-center">
        {/* Black circular container */}
        <div className="w-[38px] h-[38px] rounded-full bg-zinc-900 border border-zinc-800 shadow-md flex items-center justify-center">
          {/* White Map Pin SVG */}
          <svg viewBox="0 0 24 24" className="w-5 h-5" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M12 2C8.13 2 5 5.13 5 9C5 14.25 12 22 12 22C12 22 19 14.25 19 9C19 5.13 15.87 2 12 2Z"
              fill="white"
            />
            {/* Inner Black Dot */}
            <circle cx="12" cy="9" r="2.5" fill="#18181b" />
          </svg>
        </div>
      </div>
    </div>
  );
}

const detectBuildingTypeFromAddress = (formattedAddress: string, components: any[], types: string[] = []) => {
  // 1. If types has subpremise
  if (types.includes("subpremise")) return "Apartment";

  // 2. Check if any component is a subpremise
  const hasSubpremise = components.some(c => c.types && c.types.includes("subpremise"));
  if (hasSubpremise) return "Apartment";

  // 3. Search for unit/suite keywords in the address string
  const addrLower = formattedAddress.toLowerCase();
  const unitKeywords = ["apt", "unit", "suite", "ste", "floor", "fl", "room", "rm", "office", "dept", "#"];
  
  const hasUnitKeyword = unitKeywords.some(keyword => {
    if (keyword === "#") return addrLower.includes("#");
    const regex = new RegExp(`\\b${keyword}\\b`, 'i');
    return regex.test(addrLower);
  });

  if (hasUnitKeyword) {
    if (addrLower.includes("suite") || addrLower.includes("ste") || addrLower.includes("office")) {
      return "Office";
    }
    return "Apartment";
  }

  return "House";
};

const extractUnitFromAddress = (address: string): string => {
  const patterns = [
    /\b(?:apt|apartment|unit|suite|ste|room|rm|office|#)\s*([a-z0-9-]+)\b/i,
    /\b([a-z0-9]+)\s*-\s*\d+/i
  ];

  for (const pattern of patterns) {
    const match = address.match(pattern);
    if (match && match[1]) {
      return match[1].toUpperCase();
    }
  }

  return "";
};

export default function AddAddressPage() {
  const router = useRouter();
  const { user, setAddress, refreshAddresses, savedAddresses } = useClientAuth();

  const mapRef = useRef<HTMLDivElement>(null);
  const mapInstanceRef = useRef<any>(null);
  const geocoderRef = useRef<any>(null);
  const searchInputRef = useRef<HTMLInputElement>(null);

  // States
  const [pickedAddress, setPickedAddress] = useState("");
  const [pickedLat, setPickedLat] = useState(43.6532); // Toronto default
  const [pickedLng, setPickedLng] = useState(-79.3832);
  const [pickedCity, setPickedCity] = useState("Toronto");
  const [pickedZip, setPickedZip] = useState("");
  const [geocoding, setGeocoding] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [isMoving, setIsMoving] = useState(false);

  // Search autocomplete states
  const [searchOpen, setSearchOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [suggestions, setSuggestions] = useState<any[]>([]);
  const [searchingSuggestions, setSearchingSuggestions] = useState(false);

  // Details step and form states
  const [step, setStep] = useState<"map" | "details">("map");
  const [propertyName, setPropertyName] = useState("Home");
  const [buildingType, setBuildingType] = useState<"House" | "Apartment" | "Office">("House");
  const [gateCode, setGateCode] = useState("");
  const [floor, setFloor] = useState("");
  const [unitNumber, setUnitNumber] = useState("");
  const [intercomCode, setIntercomCode] = useState("");
  const [instructions, setInstructions] = useState("");
  const [validationError, setValidationError] = useState<string | null>(null);
  const [showAdvancedAccess, setShowAdvancedAccess] = useState(false);
  const [isFindingServices, setIsFindingServices] = useState(false);

  // Finding services redirection timer
  useEffect(() => {
    if (isFindingServices) {
      const timer = setTimeout(() => {
        router.push("/");
      }, 2300);
      return () => clearTimeout(timer);
    }
  }, [isFindingServices, router]);

  // Load Google Maps Script via library hook
  const { isLoaded, loadError } = useJsApiLoader({
    id: "google-map-script",
    googleMapsApiKey: GOOGLE_MAPS_API_KEY,
    libraries: LIBRARIES,
  });

  useEffect(() => {
    if (loadError) {
      setError("Failed to load Google Maps script. Check your internet connection.");
    }
  }, [loadError]);

  const handleMyLocation = () => {
    if (navigator.geolocation && mapInstanceRef.current) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const lat = position.coords.latitude;
          const lng = position.coords.longitude;
          setPickedLat(lat);
          setPickedLng(lng);
          mapInstanceRef.current.panTo({ lat, lng });
          mapInstanceRef.current.setZoom(16);
          reverseGeocode(lat, lng);
        },
        (err) => {
          console.error("Error getting geolocation:", err);
          setError("Couldn't retrieve your current location.");
        }
      );
    } else {
      setError("Geolocation is not supported by your browser.");
    }
  };

  // Initialize Map
  useEffect(() => {
    if (!isLoaded || !mapRef.current || mapInstanceRef.current) return;

    const initialCoords = { lat: pickedLat, lng: pickedLng };
    
    // Create Map
    const map = new window.google.maps.Map(mapRef.current, {
      center: initialCoords,
      zoom: 15,
      disableDefaultUI: true,
      zoomControl: false,
      styles: MAP_STYLES
    });

    mapInstanceRef.current = map;
    geocoderRef.current = new window.google.maps.Geocoder();

    // Map listeners for marker animations
    map.addListener("dragstart", () => {
      setIsMoving(true);
    });

    map.addListener("zoom_changed", () => {
      setIsMoving(true);
    });

    map.addListener("idle", () => {
      setIsMoving(false);
      const center = map.getCenter();
      const lat = center.lat();
      const lng = center.lng();

      setPickedLat(lat);
      setPickedLng(lng);
      reverseGeocode(lat, lng);
    });
  }, [isLoaded]);

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

           // Extract city, zip code and subpremise from address components
           let city = "Toronto";
           let zip = "";
           let subpremise = "";
           const components = results[0].address_components;
           for (const component of components) {
             const types = component.types;
             if (types.includes("locality")) {
               city = component.long_name;
             } else if (types.includes("postal_code")) {
               zip = component.long_name;
             } else if (types.includes("subpremise")) {
               subpremise = component.long_name;
             }
           }
           setPickedCity(city);
           setPickedZip(zip);
            const detectedType = detectBuildingTypeFromAddress(address, components, results[0].types || []);
            setBuildingType(detectedType);

            if (subpremise) {
              setUnitNumber(subpremise);
            } else {
              const extractedUnit = extractUnitFromAddress(address);
              setUnitNumber(extractedUnit);
            }
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

          // Extract city, zip code and subpremise from address components
          let city = "Toronto";
          let zip = "";
          let subpremise = "";
          for (const component of results[0].address_components) {
            const types = component.types;
            if (types.includes("locality")) {
              city = component.long_name;
            } else if (types.includes("postal_code")) {
              zip = component.long_name;
            } else if (types.includes("subpremise")) {
              subpremise = component.long_name;
            }
          }
          setPickedCity(city);
          setPickedZip(zip);
          const detectedType = detectBuildingTypeFromAddress(results[0].formatted_address, results[0].address_components, results[0].types || []);
          setBuildingType(detectedType);

          if (subpremise) {
            setUnitNumber(subpremise);
          } else {
            const extractedUnit = extractUnitFromAddress(results[0].formatted_address);
            setUnitNumber(extractedUnit);
          }

          // Move Map
          mapInstanceRef.current.panTo({ lat, lng });
          mapInstanceRef.current.setZoom(16);
        }
      }
    );
  };

  // Submit / Confirm Address (Map Step)
  const handleConfirmAddress = () => {
    if (!pickedAddress) return;
    setStep("details");
  };

  // Save Address Details and Insert into Supabase
  const handleSaveAddressDetails = async () => {
    if (!pickedAddress || submitting) return;
    if (!user) {
      setError("You must be logged in to confirm an address");
      return;
    }

    // Validation: Unit number is critical for apartments and offices
    if (buildingType !== "House" && !unitNumber.trim()) {
      const msg = buildingType === "Office"
        ? "Suite / Office number is required"
        : "Unit / Apartment number is required";
      setValidationError(msg);
      setError(msg);
      return;
    }

    setSubmitting(true);
    setError(null);
    setValidationError(null);

    try {
      const calculatedLabel = propertyName.trim() || (buildingType === "House" ? "Home" : buildingType === "Office" ? "Office" : "Apartment");
      const calculatedGateCode = buildingType === "House" && gateCode.trim() ? gateCode.trim() : null;
      const calculatedFloor = buildingType !== "House" && floor.trim() ? floor.trim() : null;
      const calculatedUnitNumber = buildingType !== "House" && unitNumber.trim() ? unitNumber.trim() : null;
      const calculatedIntercomCode = buildingType !== "House" && intercomCode.trim() ? intercomCode.trim() : null;
      const calculatedInstructions = buildingType !== "House" && instructions.trim() ? instructions.trim() : null;

      // Check if a record with the same address, type, and unit already exists
      let checkQuery = supabase
        .from("houses")
        .select("*")
        .eq("user_id", user.id)
        .eq("full_address", pickedAddress)
        .eq("property_type", buildingType);

      if (calculatedUnitNumber === null) {
        checkQuery = checkQuery.is("unit_number", null);
      } else {
        checkQuery = checkQuery.eq("unit_number", calculatedUnitNumber);
      }

      const { data: existingHouses, error: searchError } = await checkQuery;

      let targetHouse: any = null;

      if (!searchError && existingHouses && existingHouses.length > 0) {
        const existing = existingHouses[0];

        // Check if any of the optional details/fields differ
        const hasDifferences =
          existing.name_label !== calculatedLabel ||
          existing.gate_code !== calculatedGateCode ||
          existing.floor !== calculatedFloor ||
          existing.intercom_code !== calculatedIntercomCode ||
          existing.instructions !== calculatedInstructions;

        if (hasDifferences) {
          // Update the existing address record with the new details
          const { data: updatedHouse, error: updateError } = await supabase
            .from("houses")
            .update({
              name_label: calculatedLabel,
              gate_code: calculatedGateCode,
              floor: calculatedFloor,
              intercom_code: calculatedIntercomCode,
              instructions: calculatedInstructions,
            })
            .eq("id", existing.id)
            .select()
            .single();

          if (updateError) {
            throw new Error(updateError.message);
          }
          targetHouse = updatedHouse;
        } else {
          // No differences: reuse the existing record
          targetHouse = existing;
        }
      } else {
        // 1. Insert new address record if none exists for this physical location
        const { data: newHouse, error: insertError } = await supabase
          .from("houses")
          .insert({
            user_id: user.id,
            full_address: pickedAddress,
            lat: pickedLat,
            lng: pickedLng,
            zip_code: pickedZip || null,
            city: pickedCity,
            is_default: savedAddresses.length === 0, // default if first
            property_type: buildingType,
            name_label: calculatedLabel,
            gate_code: calculatedGateCode,
            floor: calculatedFloor,
            unit_number: calculatedUnitNumber,
            intercom_code: calculatedIntercomCode,
            instructions: calculatedInstructions,
          })
          .select()
          .single();

        if (insertError) {
          throw new Error(insertError.message);
        }
        targetHouse = newHouse;
      }

      // 2. Map structure for Context state update
      const newAddressStruct = {
        id: targetHouse.id,
        fullAddress: targetHouse.full_address,
        lat: Number(targetHouse.lat),
        lng: Number(targetHouse.lng),
        zipCode: targetHouse.zip_code,
        city: targetHouse.city,
        isDefault: !!targetHouse.is_default,
        nameLabel: targetHouse.name_label || "Home",
        propertyType: targetHouse.property_type || "Apartment",
        floor: targetHouse.floor || "",
        unitNumber: targetHouse.unit_number || "",
        intercomCode: targetHouse.intercom_code || "",
        gateCode: targetHouse.gate_code || "",
        instructions: targetHouse.instructions || "",
      };

      // Set this address as selected first (writes profiles.current_house_id)
      await setAddress(newAddressStruct);

      // Refresh list of saved addresses in background
      await refreshAddresses();

      // Trigger Finding Services Animation Overlay
      setIsFindingServices(true);
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

  if (isFindingServices) {
    return (
      <div className="fixed inset-0 z-[100] bg-[#7B82F4] flex flex-col items-center justify-center px-8 text-center animate-fade-in">
        <style>{`
          @keyframes loadingBar {
            0% { width: 0%; }
            100% { width: 100%; }
          }
          .animate-loading-bar {
            animation: loadingBar 2s cubic-bezier(0.1, 0.8, 0.2, 1) forwards;
          }
        `}</style>

        {/* Animated House Icon inside Circle */}
        <div className="relative mb-6">
          {/* Animated pulsing outer ring */}
          <div className="absolute inset-0 rounded-full bg-white/20 animate-ping duration-1000 scale-[1.35]" />
          <div className="w-[100px] h-[100px] rounded-full bg-white flex items-center justify-center shadow-lg relative border-[4px] border-[#7B82F4]/10">
            <Home className="w-12 h-12 text-[#7B82F4]" style={{ fill: 'currentColor' }} />
          </div>
        </div>

        {/* Text Details */}
        <h2 className="font-outfit text-[22px] font-bold text-white mb-2 tracking-wide">
          Finding services
        </h2>
        <p className="font-sans text-sm font-medium text-white/80 max-w-[260px] leading-relaxed mb-8">
          Locating available options near you...
        </p>

        {/* Progress Bar Container */}
        <div className="w-full max-w-[240px] h-[6px] bg-white/20 rounded-full overflow-hidden relative">
          {/* Animated Progress Fill */}
          <div className="h-full bg-white rounded-full animate-loading-bar" />
        </div>
      </div>
    );
  }

  if (step === "details") {
    return (
      <div className="relative w-full max-w-md mx-auto h-screen bg-[#F1F4F8] flex flex-col border-x border-zinc-100 shadow-md">
        {/* Header */}
        <div className="relative px-5 pt-[24px] pb-[16px] flex items-center justify-between border-b border-zinc-200 bg-white shrink-0">
          <button
            onClick={() => setStep("map")}
            className="flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-md border border-zinc-100 hover:bg-zinc-50 active:scale-95 transition-all focus:outline-none"
          >
            <ArrowLeft className="h-5 w-5 text-zinc-900" />
          </button>
          <h3 className="font-outfit text-[20px] font-semibold text-zinc-900">
            Save Address
          </h3>
          <div className="w-10" />
        </div>

        {/* Scrollable Form Body */}
        <div className="flex-1 overflow-y-auto px-5 py-6 pb-32 space-y-6">
          
          {/* Site Location Preview */}
          <div className="bg-white border border-zinc-200 rounded-[10px] p-4 space-y-4 shadow-sm">
            {/* Map Preview */}
            <div className="w-full h-[120px] rounded-[10px] overflow-hidden relative border border-zinc-100 bg-zinc-50">
              <GoogleMapPreview lat={pickedLat} lng={pickedLng} />
            </div>

            {/* Address Text */}
            <div className="bg-[#F1F4F8] rounded-[10px] p-3.5 text-sm font-semibold text-zinc-900 leading-relaxed border border-[#e0e3e7]">
              {pickedAddress}
            </div>
          </div>

          {/* BUILDING TYPE */}
          <div>
            <div className="text-[12px] font-bold text-zinc-500 uppercase tracking-wide mb-2">
              Select Building Type
            </div>
            <div className="space-y-3">
              {/* Professional Icon-based Selector (Low-profile, 52px height) */}
              <div className="flex gap-2">
                {[
                  { id: "House", label: "House", icon: Home },
                  { id: "Apartment", label: "Apartment", icon: Building2 },
                  { id: "Office", label: "Office", icon: Briefcase }
                ].map((item) => {
                  const isSelected = buildingType === item.id;
                  const IconComponent = item.icon;
                  return (
                    <button
                      key={item.id}
                      type="button"
                      onClick={() => {
                        setBuildingType(item.id as any);
                        setValidationError(null);
                        setError(null);
                      }}
                      className={`flex-1 h-[52px] rounded-[10px] border flex items-center justify-center gap-2 transition-all duration-200 active:scale-[0.98] focus:outline-none shadow-sm ${
                        isSelected
                          ? "bg-zinc-900 border-zinc-900 text-white shadow-md"
                          : "bg-white border-zinc-200 text-zinc-600 hover:border-zinc-300"
                      }`}
                    >
                      <IconComponent className="h-[18px] w-[18px]" strokeWidth={2} />
                      <span className="text-[13px] font-bold leading-none">{item.label}</span>
                    </button>
                  );
                })}
              </div>

              {/* Dynamic Unit Number Input (only for Apartment / Office) */}
              {buildingType !== "House" && (
                <div className="space-y-2 animate-slide-down">
                  <input
                    type="text"
                    value={unitNumber}
                    onChange={(e) => {
                      setUnitNumber(e.target.value);
                      setValidationError(null);
                      setError(null);
                    }}
                    placeholder={buildingType === "Office" ? "Suite / Office *" : "Unit / Apt *"}
                    className={`w-full bg-white border rounded-xl px-4 h-[52px] text-sm font-semibold text-zinc-900 placeholder-zinc-400 focus:outline-none focus:ring-1 focus:ring-[#7B82F4] shadow-sm ${
                      validationError && !unitNumber.trim() ? "border-red-500 ring-1 ring-red-500 bg-red-50/20" : "border-[#e0e3e7]"
                    }`}
                  />
                  {validationError && !unitNumber.trim() && (
                    <div className="text-xs font-semibold text-red-500 pl-1">
                      {validationError}
                    </div>
                  )}
                </div>
              )}
            </div>
          </div>

          {/* Toggle for Advanced Details */}
          <div className="pt-2">
            <button
              type="button"
              onClick={() => setShowAdvancedAccess(!showAdvancedAccess)}
              className="w-full h-[52px] rounded-xl border border-dashed border-[#7B82F4]/30 bg-[#7B82F4]/5 flex items-center justify-center gap-2 text-sm font-bold text-[#7B82F4] hover:bg-[#7B82F4]/10 active:scale-[0.99] transition-all focus:outline-none"
            >
              <span>{showAdvancedAccess ? "− Hide advanced options" : "+ Add entry code, floor, label, or notes"}</span>
            </button>
          </div>

          {/* Collapsible advanced section */}
          {showAdvancedAccess && (
            <div className="space-y-6 animate-slide-down bg-white border border-zinc-200 rounded-2xl p-5 shadow-sm">
              
              {/* ADDRESS LABEL */}
              <div>
                <div className="text-[12px] font-bold text-zinc-500 uppercase tracking-wide mb-2">
                  Address Label (e.g. Home, Work)
                </div>
                <div className="space-y-3">
                  {/* Pills row */}
                  <div className="flex gap-2">
                    {(["Home", "Work", "Other"] as const).map((tag) => (
                      <button
                        key={tag}
                        type="button"
                        onClick={() => {
                          if (tag === "Other") {
                            setPropertyName("");
                          } else {
                            setPropertyName(tag);
                          }
                        }}
                        className={`px-4 py-2 rounded-xl text-sm font-semibold border transition-all ${
                          propertyName === tag || (tag === "Other" && propertyName !== "Home" && propertyName !== "Work" && propertyName !== "")
                            ? "bg-zinc-900 text-white border-zinc-900 shadow-sm"
                            : "bg-white text-zinc-600 border-zinc-200 hover:bg-zinc-50"
                        }`}
                      >
                        {tag}
                      </button>
                    ))}
                  </div>

                  {/* Custom Label Input (only shown if Other or custom value is selected) */}
                  {(propertyName !== "Home" && propertyName !== "Work") && (
                    <input
                      type="text"
                      value={propertyName}
                      onChange={(e) => setPropertyName(e.target.value)}
                      placeholder="e.g., Mom's house, Cabin"
                      className="w-full bg-[#F1F4F8] border border-[#e0e3e7] rounded-xl px-4 h-[52px] text-sm font-semibold text-zinc-900 placeholder-zinc-400 focus:outline-none focus:ring-1 focus:ring-[#7B82F4]"
                    />
                  )}
                </div>
              </div>

              {/* Access Details depending on Building Type */}
              {buildingType === "House" ? (
                <div>
                  <div className="text-[12px] font-bold text-zinc-500 uppercase tracking-wide mb-2">
                    Gate Code
                  </div>
                  <input
                    type="text"
                    value={gateCode}
                    onChange={(e) => setGateCode(e.target.value)}
                    placeholder="Gate code (Optional)"
                    className="w-full bg-[#F1F4F8] border border-[#e0e3e7] rounded-xl px-4 h-[52px] text-sm font-semibold text-zinc-900 placeholder-zinc-400 focus:outline-none focus:ring-1 focus:ring-[#7B82F4]"
                  />
                </div>
              ) : (
                <div className="flex gap-3">
                  <div className="flex-1 min-w-0">
                    <div className="text-[12px] font-bold text-zinc-500 uppercase tracking-wide mb-2">
                      Floor
                    </div>
                    <input
                      type="text"
                      value={floor}
                      onChange={(e) => setFloor(e.target.value)}
                      placeholder="Floor"
                      className="w-full bg-[#F1F4F8] border border-[#e0e3e7] rounded-xl px-4 h-[52px] text-sm font-semibold text-zinc-900 placeholder-zinc-400 focus:outline-none focus:ring-1 focus:ring-[#7B82F4]"
                    />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="text-[12px] font-bold text-zinc-500 uppercase tracking-wide mb-2">
                      Buzz Code
                    </div>
                    <input
                      type="text"
                      value={intercomCode}
                      onChange={(e) => setIntercomCode(e.target.value)}
                      placeholder="Buzz code"
                      className="w-full bg-[#F1F4F8] border border-[#e0e3e7] rounded-xl px-4 h-[52px] text-sm font-semibold text-zinc-900 placeholder-zinc-400 focus:outline-none focus:ring-1 focus:ring-[#7B82F4]"
                    />
                  </div>
                </div>
              )}

              {/* Special Instructions (Optional) */}
              <div>
                <div className="text-[12px] font-bold text-zinc-500 uppercase tracking-wide mb-2">
                  Special Instructions
                </div>
                <textarea
                  value={instructions}
                  onChange={(e) => setInstructions(e.target.value)}
                  placeholder={
                    buildingType === "House"
                      ? "e.g., Entrance is around the back of the house. You can park on the driveway."
                      : "e.g., Visitor parking is on level P1. Please register with the concierge at the front desk to get the key."
                  }
                  className="w-full min-h-[100px] bg-[#F1F4F8] border border-[#e0e3e7] rounded-xl p-4 text-sm font-semibold text-zinc-900 placeholder-zinc-400 focus:outline-none focus:ring-1 focus:ring-[#7B82F4] resize-none"
                />
              </div>
            </div>
          )}

          {error && (
            <div className="rounded-lg bg-red-50 p-2.5 text-xs text-red-500 border border-red-100 text-center">
              {error}
            </div>
          )}
        </div>

        {/* Bottom Save Zone (Button) */}
        <div className="absolute bottom-0 left-0 right-0 bg-white border-t border-zinc-200 p-6 z-10">
          <button
            onClick={handleSaveAddressDetails}
            disabled={submitting}
            className="flex w-full items-center justify-center gap-2 h-[56px] rounded-xl bg-zinc-900 text-white font-sans text-[18px] font-semibold shadow-md hover:bg-zinc-800 focus:outline-none disabled:opacity-40 disabled:cursor-not-allowed transition-colors"
          >
            {submitting ? (
              <Loader2 className="h-5 w-5 animate-spin" />
            ) : (
              <>
                <span>Confirm</span>
                <ChevronsRight className="h-5 w-5" />
              </>
            )}
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="relative w-full max-w-md mx-auto h-screen bg-white overflow-hidden border-x border-zinc-100 shadow-md">
      {/* Map View */}
      <div className="absolute top-0 left-0 right-0 w-full h-[calc(100vh-210px)] z-0">
        {!isLoaded ? (
          <div className="absolute inset-0 flex items-center justify-center bg-zinc-50">
            <Loader2 className="h-8 w-8 text-zinc-900 animate-spin" />
          </div>
        ) : (
          <div ref={mapRef} className="w-full h-full" />
        )}

        {/* Float Back Button */}
        <button
          onClick={() => router.back()}
          className="absolute top-12 left-4 z-10 flex h-11 w-11 items-center justify-center rounded-full bg-white shadow-md border border-zinc-100 hover:bg-zinc-50 active:scale-95 transition-all focus:outline-none"
        >
          <ArrowLeft className="h-5 w-5 text-zinc-900" />
        </button>

        {/* Center Map Pin Overlay */}
        {isLoaded && (
          <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-full pointer-events-none z-10 flex flex-col items-center">
            {/* Pin Head and Stick wrapper */}
            <div 
              className="flex flex-col items-center transition-transform duration-200 ease-out"
              style={{
                transform: isMoving ? "translateY(-15px)" : "translateY(0)"
              }}
            >
              {/* Outer black circle with white border and inner dot */}
              <div className="w-8 h-8 rounded-full bg-zinc-950 border-[3px] border-white shadow-md flex items-center justify-center">
                <div className="w-2.5 h-2.5 rounded-full bg-white" />
              </div>
              {/* Vertical line pointing down */}
              <div className="w-[3px] h-[18px] bg-zinc-950 shadow-sm" />
            </div>

            {/* Shadow dot on floor */}
            <div 
              className="absolute left-1/2 -translate-x-1/2 top-full mt-[1px] w-[18px] h-[5px] bg-black/20 rounded-full blur-[1px] transition-all duration-200 ease-out"
              style={{
                transform: isMoving ? "scale(0.6)" : "scale(1)",
                opacity: isMoving ? 0.35 : 0.8
              }}
            />
          </div>
        )}

        {/* Geolocation Button */}
        {isLoaded && (
          <button
            onClick={handleMyLocation}
            className="absolute bottom-[110px] right-4 z-10 flex h-12 w-12 items-center justify-center rounded-full bg-white shadow-md border border-zinc-200 hover:bg-zinc-50 active:scale-95 transition-all focus:outline-none"
          >
            <Navigation className="h-5 w-5 text-zinc-900 fill-zinc-900" />
          </button>
        )}
      </div>

      {/* Bottom Panel */}
      <div className="absolute bottom-0 left-0 right-0 min-h-[300px] bg-white rounded-t-[10px] shadow-2xl px-6 pt-[20px] pb-[40px] z-10 border-t border-zinc-100 flex flex-col">
        <h2 className="font-outfit text-[24px] font-semibold text-zinc-900 mb-[16px] shrink-0">
          Where should the pro come?
        </h2>

        {/* Search Trigger */}
        <div
          onClick={() => {
            setSearchOpen(true);
            setTimeout(() => searchInputRef.current?.focus(), 150);
          }}
          className="flex items-center gap-3 px-4 h-[56px] rounded-[10px] border border-[#e0e3e7] bg-[#F1F4F8] cursor-pointer hover:bg-zinc-100 transition-colors mb-[16px] shrink-0"
        >
          <Search className="h-5 w-5 text-zinc-400" />
          <span className="text-[18px] font-normal text-zinc-900 truncate">
            {geocoding ? "Locating address..." : (pickedAddress || "Search address...")}
          </span>
        </div>

        {/* Subtitle / Help text */}
        <p className="text-[16px] font-normal text-zinc-500 leading-normal mb-[16px] shrink-0">
          Place the pin at the building entrance so the pro can find you faster.
        </p>

        {error && (
          <div className="rounded-lg bg-red-50 p-2.5 text-xs text-red-500 border border-red-100 text-center mb-[16px] shrink-0">
            {error}
          </div>
        )}

        {/* Confirm Button */}
        <button
          onClick={handleConfirmAddress}
          disabled={!pickedAddress || geocoding || submitting}
          className="flex w-full items-center justify-center h-[56px] rounded-[8px] bg-zinc-900 text-white font-sans text-[18px] font-semibold shadow-md hover:bg-zinc-800 focus:outline-none disabled:opacity-40 disabled:cursor-not-allowed transition-colors shrink-0"
        >
          {submitting ? <Loader2 className="h-5 w-5 animate-spin" /> : "Confirm Address"}
        </button>
      </div>

      {/* Address Search Modal Overlay (Full-screen) */}
      {searchOpen && typeof document !== "undefined" && createPortal(
        <div className="fixed inset-0 z-[9999] bg-white flex flex-col w-full max-w-md mx-auto border-x border-zinc-100 shadow-md animate-slide-up">
          {/* Header */}
          <div className="px-5 pt-[24px] pb-[16px] flex items-center justify-between border-b border-zinc-100">
            <button
              onClick={() => {
                setSearchOpen(false);
                setSearchQuery("");
                setSuggestions([]);
              }}
              className="flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-md border border-zinc-100 hover:bg-zinc-50 active:scale-95 transition-all focus:outline-none"
            >
              <X className="h-5 w-5 text-zinc-900" />
            </button>
            <h3 className="font-outfit text-[20px] font-semibold text-zinc-900">
              Address
            </h3>
            <div className="w-10" />
          </div>

          {/* Inputs Row */}
          <div className="px-5 pt-[20px] pb-2 flex gap-3 items-center">
            {/* Search input field */}
            <div className="flex-1 flex items-center gap-3 px-4 h-[52px] rounded-[10px] border border-[#e0e3e7] bg-[#F1F4F8]">
              <Search className="h-5 w-5 text-zinc-400" />
              <input
                type="text"
                ref={searchInputRef}
                autoFocus
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Enter address or postal code..."
                className="w-full bg-transparent border-none outline-none text-[16px] font-normal text-zinc-900 placeholder-zinc-400 focus:ring-0"
              />
            </div>

            {/* Geolocation Pin button */}
            <button
              onClick={() => {
                setSearchOpen(false);
                setSearchQuery("");
                setSuggestions([]);
                handleMyLocation();
              }}
              className="w-[56px] h-[52px] flex items-center justify-center rounded-[10px] border border-[#e0e3e7] bg-[#F1F4F8] hover:bg-zinc-100 active:scale-95 transition-all focus:outline-none shrink-0"
            >
              <MapPin className="h-6 w-6 text-zinc-900" />
            </button>
          </div>

          {/* Use Current Position CTA */}
          <div 
            onClick={() => {
              setSearchOpen(false);
              setSearchQuery("");
              setSuggestions([]);
              handleMyLocation();
            }}
            className="px-5 py-3.5 flex items-center gap-3 cursor-pointer hover:bg-zinc-50 transition-colors"
          >
            <Navigation className="h-5 w-5 text-[#7B82F4] fill-[#7B82F4]/10" />
            <span className="text-[#7B82F4] font-medium text-[16px]">
              Use current position
            </span>
          </div>

          {/* Suggestions List */}
          <div className="flex-1 overflow-y-auto px-5 py-2">
            {searchingSuggestions ? (
              <div className="flex items-center justify-center py-10">
                <Loader2 className="h-6 w-6 text-zinc-900 animate-spin" />
              </div>
            ) : !searchQuery.trim() ? (
              // Default View: Show saved addresses loaded from Supabase
              savedAddresses && savedAddresses.length > 0 ? (
                savedAddresses.map((addr) => (
                  <div
                    key={addr.id}
                    onClick={async () => {
                      await setAddress(addr);
                      setSearchOpen(false);
                      setSearchQuery("");
                      setSuggestions([]);
                      router.back();
                    }}
                    className="py-4 flex items-start gap-4 border-b border-zinc-100 cursor-pointer hover:bg-zinc-50 transition-colors"
                  >
                    <Locate className="h-5 w-5 text-[#7B82F4] shrink-0 mt-1" />
                    <div className="flex flex-col">
                      <span className="text-base font-semibold text-zinc-900 leading-normal">
                        {addr.nameLabel || "Home"}
                      </span>
                      <span className="text-sm text-zinc-500 mt-0.5 leading-normal">
                        {addr.fullAddress}
                      </span>
                    </div>
                  </div>
                ))
              ) : (
                <div className="text-center py-10 text-sm text-zinc-500">
                  No saved addresses found.
                </div>
              )
            ) : (
              // Search predictions view
              suggestions.map((s) => {
                const { main, sub } = splitAddress(s.description);
                return (
                  <div
                    key={s.place_id}
                    onClick={() => handleSelectSuggestion(s.place_id, s.description)}
                    className="py-4 flex items-start gap-4 border-b border-zinc-100 cursor-pointer hover:bg-zinc-50 transition-colors"
                  >
                    <Locate className="h-5 w-5 text-[#7B82F4] shrink-0 mt-1" />
                    <div className="flex flex-col">
                      <span className="text-base font-semibold text-zinc-900 leading-normal">
                        {main}
                      </span>
                      {sub && (
                        <span className="text-sm text-zinc-500 mt-0.5 leading-normal">
                          {sub}
                        </span>
                      )}
                    </div>
                  </div>
                );
              })
            )}

            {searchQuery && !searchingSuggestions && suggestions.length === 0 && (
              <div className="text-center py-10 text-sm text-zinc-500">
                No matching addresses found.
              </div>
            )}
          </div>
        </div>,
        document.body
      )}
    </div>
  );
}
