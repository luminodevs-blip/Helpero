"use client";

import React, { useState, useEffect, useRef } from "react";
import { useRouter, useParams } from "next/navigation";
import { supabase } from "@/lib/supabase";
import {
  ArrowLeft,
  Share2,
  Star,
  Clock,
  Loader2,
  Sparkles,
  ChevronDown,
  ChevronUp,
  Tag,
  Gift,
} from "lucide-react";
import ServiceCard from "@/components/ServiceCard";

export default function CategoryPage() {
  const router = useRouter();
  const params = useParams();
  const categoryId = params.id;
  const videoRef = useRef<HTMLVideoElement>(null);

  const [category, setCategory] = useState<any>(null);
  const [services, setServices] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!categoryId) return;

    async function loadCategoryData() {
      try {
        setLoading(true);
        setError(null);

        const { data: catData, error: catErr } = await supabase
          .from("service_categories")
          .select("*")
          .eq("id", categoryId)
          .maybeSingle();

        if (catErr) throw new Error(catErr.message);
        if (!catData) { setError("Category not found"); return; }
        setCategory(catData);

        const { data: servData, error: servErr } = await supabase
          .from("services")
          .select("*")
          .eq("category_id", categoryId)
          .eq("is_active", true)
          .order("sort_order", { ascending: true });

        if (servErr) throw new Error(servErr.message);
        setServices(servData || []);
      } catch (err: any) {
        setError(err?.message || "An unexpected error occurred");
      } finally {
        setLoading(false);
      }
    }

    loadCategoryData();
  }, [categoryId]);

  const handleShare = async () => {
    try {
      await navigator.share({ title: category?.name, url: window.location.href });
    } catch {
      await navigator.clipboard.writeText(window.location.href);
    }
  };

  if (loading) {
    return (
      <div className="flex h-screen w-full items-center justify-center bg-white">
        <Loader2 className="h-8 w-8 text-primary animate-spin" />
      </div>
    );
  }

  if (error || !category) {
    return (
      <div className="flex flex-col h-screen w-full items-center justify-center bg-white p-6 text-center">
        <p className="text-base font-semibold text-zinc-800">{error || "Something went wrong"}</p>
        <button
          onClick={() => router.push("/")}
          className="mt-4 px-6 py-2.5 rounded-full bg-primary text-white text-sm font-bold"
        >
          Go Home
        </button>
      </div>
    );
  }

  // Calculate mock aggregate rating from services
  const avgRating = services.length > 0
    ? (services.reduce((acc, s) => acc + (s.rating ?? 5), 0) / services.length).toFixed(2)
    : "4.92";
  const totalBookings = services.reduce((acc, s) => acc + (s.bookings_count ?? s.reviews_count ?? 0), 0) || 182;

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-zinc-200 relative flex flex-col">

      {/* ── 1. HERO: Video or Image — background layer ── */}
      <div className="h-[280px] w-full relative flex-shrink-0 overflow-hidden">
        {category.video_url ? (
          <video
            ref={videoRef}
            src={category.video_url}
            className="w-full h-full object-cover"
            autoPlay
            muted
            loop
            playsInline
          />
        ) : category.image_url ? (
          <img
            src={category.image_url}
            alt={category.name}
            className="w-full h-full object-cover"
          />
        ) : (
          <div className="w-full h-full bg-primary/20 flex items-center justify-center">
            <Sparkles className="h-12 w-12 text-primary/40" />
          </div>
        )}

        {/* Back Button — white circle, floating above video */}
        <button
          onClick={() => router.back()}
          className="absolute top-12 left-4 z-20 flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-md hover:bg-zinc-50 active:scale-95 transition-all focus:outline-none"
        >
          <ArrowLeft className="h-5 w-5 text-zinc-800" />
        </button>

        {/* Share Button — white circle, floating above video */}
        <button
          onClick={handleShare}
          className="absolute top-12 right-4 z-20 flex h-10 w-10 items-center justify-center rounded-full bg-white shadow-md hover:bg-zinc-50 active:scale-95 transition-all focus:outline-none"
        >
          <Share2 className="h-[18px] w-[18px] text-zinc-800" />
        </button>
      </div>

      {/* ── 2. CONTENT CARD — slides over hero, rounded top corners ── */}
      <div className="flex-1 bg-white rounded-t-[10px] -mt-12 relative z-10 px-5 pt-[10px] pb-32 shadow-[0_-4px_24px_rgba(0,0,0,0.08)]">

        {/* Category Title + Rating */}
        <div className="space-y-[6px] mb-[16px]">
          <h1 className="font-outfit text-[24px] font-semibold text-zinc-900 leading-tight">
            {category.name} Services
          </h1>
          <div className="flex items-end gap-1.5">
            <Star className="h-[14px] w-[14px] fill-zinc-900 text-zinc-900 mb-[1px]" />
            <button className="text-[14px] font-normal leading-none text-zinc-900 border-b border-dashed border-zinc-400 hover:border-zinc-900 pb-[4px]">
              {avgRating} ({Intl.NumberFormat("en-US").format(totalBookings)} bookings)
            </button>
          </div>
        </div>

        {/* ── Promo Banners Strip ── */}
        <div className="flex gap-3 overflow-x-auto scrollbar-none -mx-5 px-5 pb-[16px]">
          {/* Banner 1: Subscription */}
          <div className="flex items-center gap-2.5 border border-zinc-200 rounded-[10px] py-[6px] pl-[12px] pr-[14px] h-[60px] min-w-[170px] flex-shrink-0 bg-[#f5f7fb]">
            <Tag className="h-4 w-4 text-primary flex-shrink-0" />
            <div>
              <p className="text-[14px] font-medium text-zinc-900 leading-tight">
                Get Subscription Helpero Plus
              </p>
              <p className="text-[14px] font-light text-zinc-500 leading-tight mt-0.5">
                Use service without fee
              </p>
            </div>
          </div>
          {/* Banner 2: Discount */}
          <div className="flex items-center gap-2.5 border border-zinc-200 rounded-[10px] py-[6px] pl-[12px] pr-[14px] h-[60px] min-w-[170px] flex-shrink-0 bg-[#f5f7fb]">
            <Gift className="h-4 w-4 text-primary flex-shrink-0" />
            <div>
              <p className="text-[14px] font-medium text-zinc-900 leading-tight">
                25% Off First Order
              </p>
              <p className="text-[14px] font-light text-zinc-500 leading-tight mt-0.5">
                Activated automatically
              </p>
            </div>
          </div>
        </div>

        {/* ── Thick Divider ── */}
        <div className="h-[8px] bg-[#f5f7fb] w-[calc(100%+40px)] -mx-5 mb-[24px]" />

        {/* ── Packages Header ── */}
        <h2 className="font-outfit text-[20px] font-semibold text-zinc-900 mb-4">
          Packages
        </h2>
        <div className="h-[1px] bg-zinc-100 w-[calc(100%+40px)] -mx-5" />

        {/* ── Service Cards ── */}
        <div className="flex flex-col bg-white overflow-hidden">
          {services.map((serv, index) => (
            <ServiceCard 
              key={serv.id}
              service={serv} 
              className={index !== services.length - 1 ? "border-b border-zinc-100" : ""}
            />
          ))}

          {services.length === 0 && (
            <div className="text-center py-16 text-sm text-zinc-400">
              No services available in this category yet.
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
