"use client";

import React, { useState, useEffect } from "react";
import { useRouter, useParams } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import { ArrowLeft, Star, CheckCircle, AlertTriangle, Sparkles, Loader2 } from "lucide-react";
import { BookingDraft } from "@/lib/types";

export default function ServiceDetailPage() {
  const router = useRouter();
  const params = useParams();
  const serviceId = params.id;

  const { cart, updateCart, setActiveDraft } = useClientAuth();

  const [service, setService] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [sliderPos, setSliderPos] = useState(50); // For before/after slider

  useEffect(() => {
    if (!serviceId) return;

    async function loadService() {
      try {
        setLoading(true);
        setError(null);

        const { data, error: servErr } = await supabase
          .from("services")
          .select("*")
          .eq("id", serviceId)
          .maybeSingle();

        if (servErr) throw new Error(servErr.message);
        if (!data) {
          setError("Service not found");
          return;
        }

        setService(data);
      } catch (err: any) {
        console.error("Failed to load service:", err);
        setError(err?.message || "An unexpected error occurred");
      } finally {
        setLoading(false);
      }
    }

    loadService();
  }, [serviceId]);

  const handleConfigureAndBook = () => {
    if (!service) return;

    const sId = Number(serviceId);
    const catId = Number(service.category_id);

    // 1. Clean existing items in GeneralCart for this category to prevent duplicates
    const filteredCart = cart.filter((item) => item.categoryId !== catId);

    // 2. Create new draft item
    const newDraft: BookingDraft = {
      currentCartId: `${sId}-${Date.now()}`,
      serviceId: sId,
      categoryId: catId,
      serviceName: service.name,
      basePrice: service.base_price || 0,
      baseDuration: service.duration_minutes || 60,
      totalPrice: service.base_price || 0,
      totalDuration: service.duration_minutes || 60,
      itemsPrice: service.base_price || 0,
      selectedAddons: [],
      address: null,
    };

    // 3. Update states
    const updatedCart = [...filteredCart, newDraft];
    updateCart(updatedCart);
    setActiveDraft(newDraft);

    // 4. Navigate to Configure page
    router.push("/configure");
  };

  if (loading) {
    return (
      <div className="flex h-screen w-full items-center justify-center bg-bg-primary">
        <Loader2 className="h-8 w-8 text-primary animate-spin" />
      </div>
    );
  }

  if (error || !service) {
    return (
      <div className="flex flex-col h-screen w-full items-center justify-center bg-bg-primary p-6 text-center">
        <p className="text-base font-semibold text-text-primary">{error || "Something went wrong"}</p>
        <button
          onClick={() => router.push("/")}
          className="mt-4 px-6 py-2.5 rounded-full bg-primary text-white text-sm font-bold shadow-md hover:bg-primary/95 transition-all"
        >
          Go Home
        </button>
      </div>
    );
  }

  const beforeImage = service.before_after_images?.[0] || null;
  const afterImage = service.before_after_images?.[1] || null;

  // Fallback included items if database returns null
  const included = service.included_items || [
    "Professional deep steaming/cleaning of target areas",
    "Eco-friendly sanitizing solutions & deodorizers",
    "Pre-treatment for spots, spills, and heavy stains",
    "100% satisfaction guarantee with re-cleaning if needed"
  ];

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-bg-primary pb-32 relative flex flex-col border-x border-alternate shadow-md">
      {/* 1. Hero Image Cover */}
      <div className="h-72 w-full relative overflow-hidden bg-primary">
        {service.image_url ? (
          <img
            src={service.image_url}
            alt={service.name}
            className="w-full h-full object-cover"
          />
        ) : (
          <div className="w-full h-full bg-primary/10 flex items-center justify-center">
            <Sparkles className="h-12 w-12 text-primary/30" />
          </div>
        )}
        <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-black/20" />

        {/* Float Back Button */}
        <button
          onClick={() => router.back()}
          className="absolute top-10 left-4 z-10 flex h-11 w-11 items-center justify-center rounded-full bg-white/10 backdrop-blur-md border border-white/20 hover:bg-white/20 active:scale-95 transition-all focus:outline-none"
        >
          <ArrowLeft className="h-5 w-5 text-white" />
        </button>

        {/* Title overlay */}
        <div className="absolute bottom-6 left-5 right-5 text-white space-y-1">
          <div className="flex items-center gap-1.5 bg-secondary px-2.5 py-1 rounded-full text-[10px] font-extrabold w-fit uppercase tracking-wider mb-2">
            Discovery Layer
          </div>
          <h2 className="font-outfit text-2xl font-extrabold tracking-tight leading-tight">
            {service.name}
          </h2>
          <div className="flex items-center gap-1.5 mt-2">
            <div className="flex items-center text-warning">
              <Star className="h-3.5 w-3.5 fill-current" />
            </div>
            <span className="text-xs font-bold text-white">
              {service.rating?.toFixed(1) || "5.0"}
            </span>
            <span className="text-xs text-white/70">
              ({service.reviews_count || 120} reviews)
            </span>
          </div>
        </div>
      </div>

      {/* 2. Content Sections */}
      <div className="px-5 py-6 space-y-8 flex-1">
        
        {/* Section: Description */}
        <div className="space-y-2">
          <h3 className="font-outfit text-base font-bold text-text-primary">
            About service
          </h3>
          <p className="text-sm text-text-secondary leading-relaxed font-medium">
            {service.description || "Premium deep cleaning service with high-end tools and certified local specialists. We guarantee premium results."}
          </p>
        </div>

        {/* Section: What's Included */}
        <div className="space-y-4">
          <h3 className="font-outfit text-base font-bold text-text-primary">
            What is included
          </h3>
          <div className="space-y-3">
            {included.map((item: any, idx: number) => {
              const isObj = item && typeof item === "object";
              const label = isObj ? item.name : item;
              const imgUrl = isObj ? item.image : null;

              return (
                <div key={idx} className="flex gap-3.5 items-center bg-bg-secondary border border-alternate rounded-2xl p-3.5">
                  {imgUrl ? (
                    <img
                      src={imgUrl}
                      alt={label}
                      className="h-10 w-10 rounded-xl object-cover border border-alternate flex-shrink-0"
                    />
                  ) : (
                    <div className="h-10 w-10 rounded-xl bg-success/10 text-success flex items-center justify-center flex-shrink-0">
                      <CheckCircle className="h-5 w-5" />
                    </div>
                  )}
                  <span className="text-sm font-bold text-text-primary leading-tight">
                    {label}
                  </span>
                </div>
              );
            })}
          </div>
        </div>

        {/* Section: What's Excluded */}
        {service.excluded_items && service.excluded_items.length > 0 && (
          <div className="space-y-4">
            <h3 className="font-outfit text-base font-bold text-text-primary">
              What is excluded
            </h3>
            <div className="space-y-3">
              {service.excluded_items.map((item: string, idx: number) => (
                <div key={idx} className="flex gap-3 items-start">
                  <AlertTriangle className="h-5 w-5 text-error mt-0.5 flex-shrink-0" />
                  <span className="text-sm font-semibold text-text-secondary leading-normal">
                    {item}
                  </span>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Section: Before/After Sliding Comparison (Extremely Premium) */}
        {beforeImage && afterImage && (
          <div className="space-y-4">
            <h3 className="font-outfit text-base font-bold text-text-primary">
              Before / After Results
            </h3>
            <p className="text-xs text-text-secondary -mt-2">
              Drag the slider to see the difference.
            </p>
            <div className="relative h-64 w-full rounded-2xl overflow-hidden border border-alternate select-none">
              {/* After Image (Background) */}
              <img
                src={afterImage}
                alt="After"
                className="absolute inset-0 h-full w-full object-cover pointer-events-none"
              />
              <div className="absolute bottom-3 right-3 bg-secondary text-white text-[10px] font-bold px-2 py-0.5 rounded-md z-10 uppercase tracking-wider">
                After
              </div>

              {/* Before Image (Foreground Clipped) */}
              <div
                className="absolute inset-y-0 left-0 right-0 overflow-hidden"
                style={{ clipPath: `inset(0 ${100 - sliderPos}% 0 0)` }}
              >
                <img
                  src={beforeImage}
                  alt="Before"
                  className="absolute inset-0 h-64 w-full object-cover max-w-none pointer-events-none"
                  style={{ width: mapRefWidth() }}
                />
                <div className="absolute bottom-3 left-3 bg-error text-white text-[10px] font-bold px-2 py-0.5 rounded-md z-10 uppercase tracking-wider">
                  Before
                </div>
              </div>

              {/* Slider Line Overlay */}
              <div
                className="absolute inset-y-0 w-1 bg-white cursor-ew-resize flex items-center justify-center"
                style={{ left: `${sliderPos}%` }}
              >
                <div className="h-8 w-8 rounded-full bg-white shadow-lg border border-alternate flex items-center justify-center text-text-primary text-[10px] font-bold font-sans">
                  ↔
                </div>
              </div>

              {/* Hidden Range Input covering the area */}
              <input
                type="range"
                min="0"
                max="100"
                value={sliderPos}
                onChange={(e) => setSliderPos(Number(e.target.value))}
                className="absolute inset-0 w-full h-full opacity-0 cursor-ew-resize z-20"
              />
            </div>
          </div>
        )}
      </div>

      {/* 3. Sticky Bottom CTA Footer */}
      <div className="fixed bottom-0 left-0 right-0 z-40 bg-bg-secondary border-t border-alternate shadow-lg py-4 px-6 flex items-center justify-between max-w-md mx-auto">
        <div className="flex flex-col">
          <span className="text-[10px] font-semibold text-text-secondary uppercase tracking-wider">
            Starting Price
          </span>
          <span className="font-outfit text-xl font-extrabold text-primary mt-0.5">
            ${service.base_price?.toFixed(2) || "0.00"}
          </span>
        </div>

        <button
          onClick={handleConfigureAndBook}
          className="px-8 h-14 rounded-full bg-primary text-white font-sans text-base font-bold hover:bg-primary/95 focus:outline-none transition-all active:scale-95 shadow-md flex items-center justify-center gap-2"
        >
          Configure & Book
        </button>
      </div>
    </div>
  );

  // Helper to get screen width for absolute matching
  function mapRefWidth() {
    return "384px"; // Default mobile width (w-96/max-w-md)
  }
}
