"use client";

import React, { useState, useEffect, useRef } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/supabase";
import HomeAppBar from "@/components/HomeAppBar";
import { Loader2, Sparkles, BadgeAlert } from "lucide-react";

export default function HomePage() {
  const router = useRouter();

  const [categories, setCategories] = useState<any[]>([]);
  const [featuredServices, setFeaturedServices] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [categoriesPinned, setCategoriesPinned] = useState(false);

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

      } catch (err) {
        console.error("Failed to load home data:", err);
      } finally {
        setLoading(false);
      }
    }

    loadHomeData();
  }, []);

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
                {[
                  {
                    id: 1,
                    title: "Too lazy to clean the house?",
                    action: "Place an order",
                    img: "https://images.unsplash.com/photo-1713110824336-f78c320dcf8e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyM3x8Q0xFQU5JTkd8ZW58MHx8fHwxNzY2MjQwMTAxfDA&ixlib=rb-4.1.0&q=80&w=1080",
                    bg: "bg-[#7b82f4]"
                  },
                  {
                    id: 2,
                    title: "Need help assembling new furniture?",
                    action: "Find a pro",
                    img: "https://images.unsplash.com/photo-1585704032915-c3400ca199e7?auto=format&fit=crop&q=80&w=400",
                    bg: "bg-[#7b82f4]"
                  }
                ].map((promo) => (
                  <div
                    key={promo.id}
                    onClick={() => {
                      if (categories.length > 0) {
                        router.push(`/category/${categories[0].id}`);
                      }
                    }}
                    className={`w-[352px] shrink-0 snap-center h-[160px] rounded-[10px] ${promo.bg} border border-[#e0e3e7] relative overflow-hidden flex cursor-pointer hover:opacity-98 transition-opacity`}
                  >
                    {/* Text section */}
                    <div className="w-[144px] flex-shrink-0 p-[16px] pr-[24px] flex flex-col justify-between text-white z-10">
                      <h4 className="font-outfit text-[17px] font-semibold leading-snug">
                        {promo.title}
                      </h4>
                      <span className="text-[15px] font-normal text-[#e0e3e7] block">
                        {promo.action}
                      </span>
                    </div>

                    {/* Cover Image section */}
                    <div className="flex-1 h-full relative">
                      <img
                        src={promo.img}
                        alt="Promo"
                        className="w-full h-full object-cover"
                      />
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Section C: New Services */}
            <div className="space-y-[16px]">
              <div className="flex items-center justify-between">
                <h3 className="font-outfit text-[17px] font-semibold text-zinc-900">
                  New service
                </h3>
              </div>

              {/* Promo Card */}
              <div className="bg-[#f5f7fb] rounded-[10px] border border-[#e0e3e7] shadow-[0px_2px_4px_#f5f7fb] overflow-hidden cursor-pointer hover:border-[#7b82f4]/50 transition-colors">
                <div className="h-[120px] w-full relative">
                  <img 
                    src="https://images.unsplash.com/photo-1635426563924-c7d685b6f3a1?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHwyMXx8bW91bnRpbmd8ZW58MHx8fHwxNzY2MjQzMDczfDA&ixlib=rb-4.1.0&q=80&w=1080" 
                    alt="TV Mounting"
                    className="w-full h-full object-cover"
                  />
                  <div className="absolute top-0 right-0 bg-[#7b82f4] text-white px-3 py-1.5 rounded-bl-[10px] flex items-center gap-1.5">
                    <BadgeAlert className="w-[18px] h-[18px]" />
                    <span className="text-[13.5px] font-semibold tracking-wide">NEW</span>
                  </div>
                </div>
                <div className="p-4 space-y-2">
                  <h4 className="font-outfit text-[16px] font-semibold text-zinc-900 leading-snug">
                    Are you afraid to drill into walls yourself?
                  </h4>
                  <p className="text-[15px] font-normal text-zinc-600 leading-relaxed">
                    Trust the pros! We'll install any TV mount, hide wires, and assemble your furniture. Your equipment is in safe hands.
                  </p>
                  <div>
                    <span className="text-[14.5px] font-normal text-[#7b82f4]">
                      Order installation
                    </span>
                  </div>
                </div>
              </div>
            </div>

            {/* Section D: More about us */}
            <div className="space-y-[16px]">
              <div className="flex items-center justify-between">
                <h3 className="font-outfit text-[17px] font-semibold text-zinc-900">
                  More about us
                </h3>
              </div>

              <div className="flex overflow-x-auto snap-x snap-mandatory gap-4 pb-2 px-5 -mx-5 [&::-webkit-scrollbar]:hidden [-ms-overflow-style:none] [scrollbar-width:none]">
                {[
                  {
                    id: 1,
                    title: "Verified Professionals Only",
                    desc: "Every pro on our team undergoes a rigorous background check. Your home and safety are in good hands.",
                    img: "https://images.unsplash.com/photo-1633332755192-727a05c4013d?auto=format&fit=crop&q=80&w=400",
                  },
                  {
                    id: 2,
                    title: "Quality Guarantee",
                    desc: "We stand behind our work. If you're not fully satisfied, we'll make it right at no extra cost.",
                    img: "https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&q=80&w=400",
                  }
                ].map((item) => (
                  <div key={item.id} className="w-[352px] shrink-0 snap-center bg-white rounded-[10px] border border-[#e0e3e7] overflow-hidden cursor-pointer hover:border-[#7b82f4]/50 transition-colors">
                    <div className="h-[120px] w-full bg-[#e8ecf4]">
                      <img src={item.img} alt={item.title} className="w-full h-full object-cover" />
                    </div>
                    <div className="p-4 space-y-2">
                      <h4 className="font-outfit text-[15px] font-semibold text-zinc-900 leading-snug">
                        {item.title}
                      </h4>
                      <p className="text-[13.5px] font-normal text-zinc-600 leading-relaxed">
                        {item.desc}
                      </p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </>
        )}
      </div>
    </div>
  );
}
