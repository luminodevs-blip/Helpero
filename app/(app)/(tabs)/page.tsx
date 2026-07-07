"use client";

import React, { useState, useEffect, useRef } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/supabase";
import HomeAppBar from "@/components/HomeAppBar";
import { Loader2, Sparkles, BadgeAlert, MapPinOff, CheckCircle, X } from "lucide-react";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";

export default function HomePage() {
  const router = useRouter();
  const { selectedAddress, currentZoneId, detectedZone, user, profile } = useClientAuth();
  const [joinedWaitlist, setJoinedWaitlist] = useState(false);
  const [joining, setJoining] = useState(false);

  // Check if user is already on waitlist for this address
  useEffect(() => {
    if (selectedAddress && user) {
      supabase
        .from("zone_leads")
        .select("id")
        .eq("user_id", user.id)
        .eq("email", profile?.email || user.email || "")
        .then(({ data }) => {
          if (data && data.length > 0) {
            setJoinedWaitlist(true);
          } else {
            setJoinedWaitlist(false);
          }
        });
    }
  }, [selectedAddress, user, profile]);

  const handleJoinWaitlist = async () => {
    if (!user || !selectedAddress) return;
    try {
      setJoining(true);
      const { error } = await supabase.from("zone_leads").insert({
        user_id: user.id,
        email: profile?.email || user.email || null,
        phone_number: profile?.phoneNumber || user.phone || null,
        zone_id: detectedZone?.id || null,
        status: "waitlist",
        metadata: {
          full_address: selectedAddress.fullAddress,
          lat: selectedAddress.lat,
          lng: selectedAddress.lng,
        }
      });
      if (!error) {
        setJoinedWaitlist(true);
      }
    } catch (err) {
      console.error(err);
    } finally {
      setJoining(false);
    }
  };

  const isOutOfCoverage = selectedAddress !== null && currentZoneId === null;

  const [categories, setCategories] = useState<any[]>([]);
  const [featuredServices, setFeaturedServices] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [categoriesPinned, setCategoriesPinned] = useState(false);
  const [banners, setBanners] = useState<any[]>([]);
  const [selectedBannerForArticle, setSelectedBannerForArticle] = useState<any | null>(null);

  const categoriesRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (loading) return; // Wait until content is rendered
    const el = categoriesRef.current;
    if (!el) return;
    const observer = new IntersectionObserver(
      ([entry]) => setCategoriesPinned(!entry.isIntersecting),
      { threshold: 0, rootMargin: "-72px 0px 0px 0px" }
    );
    observer.observe(el);
    return () => observer.disconnect();
  }, [loading]);

  useEffect(() => {
    async function loadHomeData() {
      try {
        setLoading(true);
        
        // 1. Fetch Categories
        const { data: catData, error: catErr } = await supabase
          .from("service_categories")
          .select("*")
          .eq("is_active", true)
          .order("sort_order", { ascending: true });

        if (catErr) console.error("Error loading categories:", catErr);
        else setCategories(catData || []);

        // 2. Fetch Featured Services
        const { data: servData, error: servErr } = await supabase
          .from("services")
          .select("*")
          .eq("is_active", true)
          .order("sort_order", { ascending: true })
          .limit(5);

        if (servErr) console.error("Error loading services:", servErr);
        else setFeaturedServices(servData || []);

        // 3. Fetch App Banners
        const { data: bannerData, error: bannerErr } = await supabase
          .from("app_banners")
          .select("*")
          .eq("is_active", true)
          .order("sort_order", { ascending: true });

        if (bannerErr) console.error("Error loading banners:", bannerErr);
        else setBanners(bannerData || []);

      } catch (err) {
        console.error("Failed to load home data:", err);
      } finally {
        setLoading(false);
      }
    }

    loadHomeData();
  }, []);

  // Prefetch category details to make page navigation instant
  useEffect(() => {
    if (categories.length > 0) {
      categories.forEach((cat) => {
        router.prefetch(`/category/${cat.id}`);
      });
    }
  }, [categories, router]);

  const handleBannerClick = async (banner: any) => {
    if (banner.body_text) {
      setSelectedBannerForArticle(banner);
    } else if (banner.action_type === "open_service") {
      const serviceId = Number(banner.action_payload);
      const { data } = await supabase
        .from("services")
        .select("category_id")
        .eq("id", serviceId)
        .maybeSingle();
      if (data?.category_id) {
        router.push(`/category/${data.category_id}?serviceId=${serviceId}`);
      } else {
        router.push(`/category/1?serviceId=${serviceId}`);
      }
    } else if (banner.action_type === "open_category") {
      router.push(`/category/${banner.action_payload}`);
    }
  };

  return (
    <div className="flex flex-col flex-1 bg-white">
      {/* 1. Header (Address selector + Cart + Search) */}
      <HomeAppBar categories={categories} categoriesPinned={categoriesPinned} />

      {/* 2. Main Content (White Container overlapping) */}
      <div className="flex-1 bg-white rounded-t-[16px] -mt-[24px] pt-[24px] pb-28 px-5 space-y-[20px] relative z-10">
        
        {loading ? (
          <div className="flex justify-center items-center py-20">
            <Loader2 className="h-8 w-8 text-primary animate-spin" />
          </div>
        ) : isOutOfCoverage ? (
          <div className="flex flex-col items-center justify-center text-center py-10 px-4 animate-fade-in">
            <div className="w-16 h-16 rounded-full bg-amber-50 border border-amber-100 flex items-center justify-center mb-5 text-amber-500 shadow-sm animate-pulse">
              <MapPinOff className="w-8 h-8" />
            </div>
            
            <h3 className="font-outfit text-xl font-bold text-zinc-900 mb-2.5">
              {detectedZone ? `We are not in ${detectedZone.name} yet` : "We are not in your area yet"}
            </h3>
            
            <p className="text-zinc-500 text-sm font-semibold max-w-xs leading-relaxed mb-8">
              We don't service this location yet. Join our waitlist to vote for your neighborhood and get notified when we launch here!
            </p>

            {joinedWaitlist ? (
              <div className="w-full max-w-sm bg-emerald-50 border border-emerald-100 rounded-xl p-4 flex flex-col items-center justify-center gap-1.5 animate-slide-up">
                <div className="flex items-center gap-2 text-emerald-600 font-bold text-sm">
                  <CheckCircle className="w-4 h-4" />
                  <span>You're on the waitlist!</span>
                </div>
                <span className="text-[11px] text-emerald-500 font-medium">
                  We will notify you as soon as we launch in this zone.
                </span>
              </div>
            ) : (
              <button
                onClick={handleJoinWaitlist}
                disabled={joining}
                className="w-full max-w-sm h-12 rounded-xl bg-zinc-900 hover:bg-zinc-800 text-white font-sans text-sm font-bold flex items-center justify-center gap-2 shadow-sm transition-colors active:scale-[0.98] disabled:opacity-50"
              >
                {joining ? (
                  <Loader2 className="w-4 h-4 animate-spin" />
                ) : (
                  <span>Join the Waitlist</span>
                )}
              </button>
            )}
          </div>
        ) : (
          <>

            {/* Section A: Select a Category */}
            <div className="space-y-[14px]">
              <h3 className="font-outfit text-[17px] font-semibold text-zinc-900">
                Select a category
              </h3>

              {/* Category Grid */}
              <div className="grid grid-cols-4 gap-3 pb-2 w-full">
                {categories.map((cat) => (
                  <div
                    key={cat.id}
                    onClick={() => router.push(`/category/${cat.id}`)}
                    className="flex flex-col items-center justify-center gap-[4px] cursor-pointer text-center h-[110px] rounded-[8px] bg-[#f5f7fb] border border-[#e0e3e7] hover:scale-105 transition-all px-1"
                  >
                    {cat.image_url ? (
                      <img
                        src={cat.image_url}
                        alt={cat.name}
                        className="h-[50px] w-[50px] object-contain"
                      />
                    ) : (
                      <Sparkles className="h-[50px] w-[50px] text-primary/50" />
                    )}
                    <span className="text-[14px] font-medium text-zinc-700 leading-tight line-clamp-1 w-full">
                      {cat.name}
                    </span>
                  </div>
                ))}
              </div>
            </div>

            {/* Marker for intersection observer - positioned at the bottom of the categories section */}
            <div ref={categoriesRef} />

            {/* Section B: Near For You (Promo banner) */}
            <div className="space-y-[16px] -mx-5">
              <div className="flex items-center justify-between px-5">
                <h3 className="font-outfit text-[17px] font-semibold text-zinc-900">
                  Near for you
                </h3>
              </div>
              
              <div className="flex overflow-x-auto snap-x snap-mandatory gap-4 pb-2 px-5 [&::-webkit-scrollbar]:hidden [-ms-overflow-style:none] [scrollbar-width:none]">
                {(banners.filter(b => b.section_id === 'near_for_you').length > 0
                  ? banners.filter(b => b.section_id === 'near_for_you')
                  : [
                      {
                        id: 1,
                        title: "Too lazy to clean the house?",
                        cta_text: "Place an order",
                        image_url: "https://images.unsplash.com/photo-1713110824336-f78c320dcf8e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyM3x8Q0xFQU5JTkd8ZW58MHx8fHwxNzY2MjQwMTAxfDA&ixlib=rb-4.1.0&q=80&w=1080",
                        bg: "bg-[#7b82f4]",
                        action_type: "open_category",
                        action_payload: categories[0]?.id || "1"
                      },
                      {
                        id: 2,
                        title: "Need help assembling new furniture?",
                        cta_text: "Find a pro",
                        image_url: "https://images.unsplash.com/photo-1585704032915-c3400ca199e7?auto=format&fit=crop&q=80&w=400",
                        bg: "bg-[#7b82f4]",
                        action_type: "open_category",
                        action_payload: categories[0]?.id || "1"
                      }
                    ]
                ).map((promo: any) => (
                  <div
                    key={promo.id}
                    onClick={() => handleBannerClick(promo)}
                    className={`w-[352px] shrink-0 snap-center h-[160px] rounded-[10px] ${promo.bg || "bg-[#7b82f4]"} border border-[#e0e3e7] relative overflow-hidden flex cursor-pointer hover:opacity-98 transition-opacity`}
                  >
                    {/* Text section */}
                    <div className="w-[144px] flex-shrink-0 p-[16px] pr-[24px] flex flex-col justify-between text-white z-10">
                      <h4 className="font-outfit text-[17px] font-semibold leading-snug">
                        {promo.title}
                      </h4>
                      <span className="text-[15px] font-normal text-[#e0e3e7] block">
                        {promo.cta_text || promo.action}
                      </span>
                    </div>

                    {/* Cover Image section */}
                    <div className="flex-1 h-full relative">
                      {promo.image_url && (
                        <img
                          src={promo.image_url}
                          alt="Promo"
                          className="w-full h-full object-cover"
                        />
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Section C: New Services */}
            {(() => {
              const newServiceBanners = banners.filter(b => b.section_id === 'new_service');
              const displayBanners = newServiceBanners.length > 0 
                ? newServiceBanners 
                : [
                    {
                      id: 4,
                      title: "Are you afraid to drill into walls yourself?",
                      body_text: "Trust the pros! We'll securely mount any TV, hide the wires, and set up your sound system. Your equipment is in safe hands.",
                      image_url: "https://images.unsplash.com/photo-1635426563924-c7d685b6f3a1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMXx8bW91bnRpbmd8ZW58MHx8fHwxNzY2MjQzMDczfDA&ixlib=rb-4.1.0&q=80&w=1080",
                      cta_text: "Order installation",
                      action_type: "open_service",
                      action_payload: "3"
                    }
                  ];

              return (
                <div className="space-y-[16px]">
                  <div className="flex items-center justify-between">
                    <h3 className="font-outfit text-[17px] font-semibold text-zinc-900">
                      New service
                    </h3>
                  </div>

                  {displayBanners.map((banner) => (
                    <div 
                      key={banner.id}
                      onClick={() => handleBannerClick(banner)}
                      className="bg-[#f5f7fb] rounded-[10px] border border-[#e0e3e7] shadow-[0px_2px_4px_#f5f7fb] overflow-hidden cursor-pointer hover:border-[#7b82f4]/50 transition-colors"
                    >
                      <div className="h-[120px] w-full relative">
                        {banner.image_url && (
                          <img 
                            src={banner.image_url} 
                            alt="Promo"
                            className="w-full h-full object-cover"
                          />
                        )}
                        <div className="absolute top-0 right-0 bg-[#7b82f4] text-white px-3 py-1.5 rounded-bl-[10px] flex items-center gap-1.5">
                          <BadgeAlert className="w-[18px] h-[18px]" />
                          <span className="text-[13.5px] font-semibold tracking-wide">NEW</span>
                        </div>
                      </div>
                      <div className="p-4 space-y-2">
                        <h4 className="font-outfit text-[16px] font-semibold text-zinc-900 leading-snug">
                          {banner.title}
                        </h4>
                        {banner.body_text && (
                          <p className="text-[15px] font-normal text-zinc-600 leading-relaxed">
                            {banner.body_text}
                          </p>
                        )}
                        {banner.cta_text && (
                          <div>
                            <span className="text-[14.5px] font-normal text-[#7b82f4]">
                              {banner.cta_text}
                            </span>
                          </div>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              );
            })()}

            {/* Section D: More about us */}
            <div className="space-y-[16px]">
              <div className="flex items-center justify-between">
                <h3 className="font-outfit text-[17px] font-semibold text-zinc-900">
                  More about us
                </h3>
              </div>

              <div className="flex overflow-x-auto snap-x snap-mandatory gap-4 pb-2 px-5 -mx-5 [&::-webkit-scrollbar]:hidden [-ms-overflow-style:none] [scrollbar-width:none]">
                {(banners.filter(b => b.section_id === 'more_about_us').length > 0
                  ? banners.filter(b => b.section_id === 'more_about_us')
                  : [
                      {
                        id: 5,
                        title: "Verified Professionals Only",
                        body_text: "Every pro on our team undergoes a rigorous background check. Your home and safety are in good hands.",
                        image_url: "https://images.unsplash.com/photo-1633332755192-727a05c4013d?auto=format&fit=crop&q=80&w=400",
                        action_type: "none"
                      },
                      {
                        id: 6,
                        title: "Quality Guarantee",
                        body_text: "We stand behind our work. If you're not fully satisfied, we'll make it right at no extra cost.",
                        image_url: "https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&q=80&w=400",
                        action_type: "none"
                      }
                    ]
                ).map((item: any) => (
                  <div 
                    key={item.id} 
                    onClick={() => handleBannerClick(item)}
                    className="w-[352px] shrink-0 snap-center bg-white rounded-[10px] border border-[#e0e3e7] overflow-hidden cursor-pointer hover:border-[#7b82f4]/50 transition-colors"
                  >
                    <div className="h-[120px] w-full bg-[#e8ecf4]">
                      {item.image_url && (
                        <img src={item.image_url} alt={item.title} className="w-full h-full object-cover" />
                      )}
                    </div>
                    <div className="p-4 space-y-2">
                      <h4 className="font-outfit text-[15px] font-semibold text-zinc-900 leading-snug">
                        {item.title}
                      </h4>
                      {item.body_text && (
                        <p className="text-[13.5px] font-normal text-zinc-600 leading-relaxed line-clamp-2">
                          {item.body_text}
                        </p>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </>
        )}
      </div>

      {/* Premium Article / Details Bottom Sheet */}
      {selectedBannerForArticle && (
        <div 
          className="fixed inset-0 z-[10000] flex items-end justify-center bg-black/40 backdrop-blur-[2px]"
          onClick={() => setSelectedBannerForArticle(null)}
        >
          <div 
            className="relative w-full max-w-md bg-white rounded-t-[28px] shadow-2xl z-10 overflow-hidden flex flex-col h-[75vh]"
            onClick={(e) => e.stopPropagation()}
            style={{ animation: "slideUp 0.3s ease-out forwards" }}
          >
            {/* Drag Handle */}
            <div className="flex justify-center pt-3 pb-2 shrink-0">
              <div className="w-10 h-1 rounded-full bg-zinc-200" />
            </div>

            {/* Close Button */}
            <button 
              onClick={() => setSelectedBannerForArticle(null)} 
              className="absolute top-4 right-4 z-20 h-8 w-8 bg-white/80 hover:bg-zinc-100 rounded-full flex items-center justify-center text-zinc-500 shadow-sm transition-colors"
            >
              <X className="h-4 w-4" />
            </button>

            {/* Scrollable Body */}
            <div className="overflow-y-auto flex-1 min-h-0 pb-12">
              {selectedBannerForArticle.image_url && (
                <div className="w-full h-[220px] relative overflow-hidden mb-6">
                  <img 
                    src={selectedBannerForArticle.image_url} 
                    alt={selectedBannerForArticle.title} 
                    className="w-full h-full object-cover"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent" />
                </div>
              )}

              <div className="px-5 space-y-4">
                <h3 className="font-outfit text-[22px] font-bold text-zinc-900 leading-tight">
                  {selectedBannerForArticle.title}
                </h3>
                
                <div className="h-[1px] bg-zinc-100 w-full my-2" />

                <p className="text-[15px] font-normal text-zinc-600 leading-relaxed whitespace-pre-wrap">
                  {selectedBannerForArticle.body_text || "No details available."}
                </p>

                {/* Call To Action button */}
                {selectedBannerForArticle.cta_text && (selectedBannerForArticle.action_type === 'open_service' || selectedBannerForArticle.action_type === 'open_category') && (
                  <div className="pt-6">
                    <button
                      onClick={async () => {
                        const banner = selectedBannerForArticle;
                        setSelectedBannerForArticle(null);
                        if (banner.action_type === 'open_service') {
                          const serviceId = Number(banner.action_payload);
                          const { data } = await supabase
                            .from("services")
                            .select("category_id")
                            .eq("id", serviceId)
                            .maybeSingle();
                          if (data?.category_id) {
                            router.push(`/category/${data.category_id}?serviceId=${serviceId}`);
                          } else {
                            router.push(`/category/1?serviceId=${serviceId}`);
                          }
                        } else {
                          router.push(`/category/${banner.action_payload}`);
                        }
                      }}
                      className="w-full py-3.5 rounded-xl bg-zinc-900 hover:bg-zinc-800 text-white font-semibold text-sm active:scale-95 transition-all text-center"
                    >
                      {selectedBannerForArticle.cta_text}
                    </button>
                  </div>
                )}
              </div>
            </div>
          </div>
          <style dangerouslySetInnerHTML={{__html: `
            @keyframes slideUp {
              from { transform: translateY(100%); }
              to { transform: translateY(0); }
            }
          `}} />
        </div>
      )}
    </div>
  );
}
