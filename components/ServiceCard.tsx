"use client";

import React, { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/supabase";
import { Star, Sparkles, ChevronDown, ChevronUp, X, Key, Zap, Droplet, DoorOpen, ParkingCircle, Box, Square, Package, Maximize, Wrench, Wifi, AppWindow, Leaf } from "lucide-react";

const iconMap: Record<string, any> = {
  access: Key,
  power: Zap,
  bucket: Droplet,
  water_drop: Droplet,
  cleaning_services: Sparkles,
  door_open: DoorOpen,
  local_parking: ParkingCircle,
  inventory_2: Box,
  wall: Square,
  items: Package,
  open_in_full: Maximize,
  tools: Wrench,
  wifi: Wifi,
  window: AppWindow,
};
interface ServiceCardProps {
  service: any;
  onClick?: () => void;
  className?: string;
}

export default function ServiceCard({ service, onClick, className = "" }: ServiceCardProps) {
  const router = useRouter();
  const [isExpanded, setIsExpanded] = useState(false);
  const [reviews, setReviews] = useState<any[]>([]);
  const [reviewsLoading, setReviewsLoading] = useState(false);
  const [activeFilter, setActiveFilter] = useState("Most detailed");

  useEffect(() => {
    if (isExpanded) {
      const fetchReviews = async () => {
        setReviewsLoading(true);
        const { data, error } = await supabase
          .from("reviews")
          .select("*, profiles(first_name, last_name)")
          .eq("service_id", service.id)
          .order("created_at", { ascending: false });
        
        if (data) {
          setReviews(data);
        }
        setReviewsLoading(false);
      };
      fetchReviews();
    }
  }, [isExpanded, service.id]);

  // Derived state for reviews
  const totalReviews = reviews.length || service.reviews_count || 1240;
  const ratingCounts = { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 };
  if (reviews.length > 0) {
    reviews.forEach((r) => {
      if (r.rating >= 1 && r.rating <= 5) {
        ratingCounts[r.rating as 1 | 2 | 3 | 4 | 5]++;
      }
    });
  } else {
    // Mock for when there are no reviews yet but we want to show the UI
    ratingCounts[5] = Math.floor(totalReviews * 0.7);
    ratingCounts[4] = Math.floor(totalReviews * 0.2);
    ratingCounts[3] = Math.floor(totalReviews * 0.05);
    ratingCounts[2] = Math.floor(totalReviews * 0.01);
    ratingCounts[1] = totalReviews - ratingCounts[5] - ratingCounts[4] - ratingCounts[3] - ratingCounts[2];
  }

  const progressBars = [5, 4, 3, 2, 1].map((stars) => {
    const count = ratingCounts[stars as 1 | 2 | 3 | 4 | 5];
    const percent = totalReviews > 0 ? (count / totalReviews) * 100 : 0;
    return { stars, percent, count };
  });

  const displayReviews = [...reviews].sort((a, b) => {
    if (activeFilter === "Most detailed") {
      return (b.comment?.length || 0) - (a.comment?.length || 0);
    }
    // "In my area" / "Frequent users" fallback to date sorting for now
    return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
  });

  // Format HH:MM:SS to "X hrs Y mins" or "Xh Y min"
  const formatDuration = (timeStr: string) => {
    if (!timeStr) return "";
    const parts = timeStr.split(":");
    if (parts.length >= 2) {
      const hrs = parseInt(parts[0], 10);
      const mins = parseInt(parts[1], 10);
      const arr = [];
      if (hrs > 0) arr.push(`${hrs} hr${hrs > 1 ? "s" : ""}`);
      if (mins > 0) arr.push(`${mins} min${mins > 1 ? "s" : ""}`);
      return arr.join(" ") || timeStr;
    }
    return timeStr;
  };

  // Parse bullet points — could be JSON array or plain string
  const getBullets = (serv: any): string[] => {
    const raw = serv.card_bullets ?? serv.included_items ?? serv.short_description;
    if (!raw) return [];
    if (Array.isArray(raw)) {
      return raw.map((b: any) => (typeof b === "object" ? b.name ?? b.text ?? "" : String(b)));
    }
    try {
      const parsed = JSON.parse(raw);
      if (Array.isArray(parsed)) return parsed.map((b: any) => (typeof b === "object" ? b.name ?? b.text ?? "" : String(b)));
    } catch { /* not JSON */ }
    // Plain string — split by newlines or semicolons
    return String(raw).split(/[\n;]+/).map((s) => s.trim()).filter(Boolean);
  };

  const bullets = getBullets(service);
  const visibleBullets = bullets.slice(0, 3);
  const hasMore = bullets.length > 3;

  const handleCardClick = () => {
    if (onClick) {
      onClick();
    } else {
      router.push(`/service/${service.id}`);
    }
  };

  return (
    <>
      <div className={`py-5 flex gap-4 bg-white cursor-pointer hover:bg-zinc-50/50 transition-colors ${className}`} onClick={handleCardClick}>
        {/* LEFT: title, price, bullets, learn-more */}
        <div className="flex-1 min-w-0 flex flex-col">
          <h3 className="font-outfit text-[18px] font-medium text-zinc-900 leading-snug">
            {service.name}
          </h3>
          <p className="text-[14px] font-normal text-zinc-900 mt-[4px] flex flex-wrap items-center gap-1">
            <span>Starts at</span>
            <span className="text-zinc-800">
              ${service.base_price?.toFixed(2) ?? "0.00"}
            </span>
            {service.estimated_duration && (
              <>
                <span className="text-zinc-500">•</span>
                <span className="text-zinc-500">{formatDuration(service.estimated_duration)}</span>
              </>
            )}
          </p>

          {/* Bullet points */}
          {bullets.length > 0 && (
            <>
              <div className="h-[1px] w-full bg-zinc-100 mt-[8px] mb-[8px]" />
              <ul className="space-y-1.5 flex-1">
              {visibleBullets.map((b, idx) => (
                <li
                  key={idx}
                  className="flex items-start gap-1.5 text-[14.5px] font-light leading-snug text-zinc-900"
                >
                  <span
                    className="mt-[6px] h-1 w-1 rounded-full flex-shrink-0 bg-zinc-800"
                  />
                  {b}
                </li>
              ))}
            </ul>
            </>
          )}

          {/* Learn more — bottom-left, always visible */}
          <button
            onClick={(e) => {
              e.stopPropagation();
              setIsExpanded(true); // using isExpanded as isSheetOpen
            }}
            className="flex items-center gap-0.5 text-primary text-[14px] font-normal mt-3 self-start hover:opacity-80 transition-opacity"
          >
            Learn more <ChevronDown className="h-3.5 w-3.5" />
          </button>
        </div>

        {/* RIGHT column: image on top → Book Now below */}
        <div className="flex flex-col gap-2 flex-shrink-0 w-[100px]">
          {/* Thumbnail */}
          <div className="h-[100px] w-full rounded-[8px] overflow-hidden bg-zinc-100">
            {service.image_url ? (
              <img
                src={service.image_url}
                alt={service.name}
                className="h-full w-full object-cover"
              />
            ) : (
              <div className="h-full w-full flex items-center justify-center">
                <Sparkles className="h-5 w-5 text-zinc-300" />
              </div>
            )}
          </div>

          {/* Book Now — same width as image, below it */}
          <button
            onClick={(e) => {
              e.stopPropagation();
              handleCardClick();
            }}
            className="w-full py-2 rounded-[8px] text-[14.5px] font-normal active:scale-[0.98] transition-all bg-zinc-900 text-white hover:bg-zinc-700"
          >
            Book Now
          </button>
        </div>
      </div>

      {/* Bottom Sheet Modal */}
      {isExpanded && (
        <div className="fixed inset-0 z-[100] flex flex-col justify-end" onClick={(e) => { e.stopPropagation(); setIsExpanded(false); }}>
          <div className="absolute inset-0 bg-black/40 backdrop-blur-[2px] transition-opacity" />
          <div 
            className="relative w-full max-w-md mx-auto bg-white rounded-t-[24px] overflow-hidden shadow-2xl transition-transform flex flex-col h-[96vh]"
            onClick={(e) => e.stopPropagation()}
            style={{ animation: "slideUp 0.3s ease-out forwards" }}
          >
            {/* Header (Sticky) */}
            <div className="bg-white px-5 pt-5 pb-4 shrink-0 relative z-10">
              <div className="w-10 h-1 bg-zinc-200 rounded-full mx-auto mb-4" />
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="font-outfit text-[20px] font-semibold text-zinc-900 mb-1">{service.name}</h3>
                  <p className="flex items-center gap-1">
                    <span className="text-[14px] font-medium text-zinc-900">Starts at ${service.base_price?.toFixed(2) ?? "0.00"}</span>
                    {service.estimated_duration && (
                      <span className="text-[14px] font-normal text-zinc-500"> • {formatDuration(service.estimated_duration)}</span>
                    )}
                  </p>
                </div>
                <button onClick={() => setIsExpanded(false)} className="h-8 w-8 bg-zinc-100 rounded-full flex items-center justify-center text-zinc-500 hover:bg-zinc-200 transition-colors">
                  <X className="h-4 w-4" />
                </button>
              </div>
            </div>

            <div className="h-[1px] w-full bg-zinc-100 shrink-0" />

            {/* Scrollable Body */}
            <div className="overflow-y-auto flex-1 min-h-0 px-5 py-6 pb-6 scrollbar-none flex flex-col gap-6 relative overscroll-contain">
              
              {/* 1. What is included */}
              <div>
                <h4 className="font-outfit text-[17px] font-medium text-zinc-900 mb-3">What is included:</h4>
                <div className="grid grid-cols-3 gap-2 pb-1">
                  {(service.included_items?.length ? service.included_items : [
                    { name: "Dust Surfaces", image: "https://images.unsplash.com/photo-1558402529-d2638a7023e9?w=200&h=200&fit=crop" },
                    { name: "Vacuum Floors", image: "https://images.unsplash.com/photo-1504328345606-18bbc8c9d7d1?w=200&h=200&fit=crop" },
                    { name: "Mop Floors", image: "https://images.unsplash.com/photo-1593784991095-a205069470b6?w=200&h=200&fit=crop" }
                  ]).map((item: any, idx: number) => (
                    <div key={idx} className="bg-[#f8f9fa] rounded-xl overflow-hidden shrink-0 flex flex-col border border-zinc-100 h-[125px]">
                      <div className="pt-1 px-2 pb-2 flex-1">
                        <p className="text-[14.5px] font-normal leading-[1.2] text-zinc-800 break-words">
                          {typeof item === 'object' ? item.name : item}
                        </p>
                      </div>
                      <div className="h-[85px] w-full shrink-0 bg-zinc-200 mt-auto">
                        {typeof item === 'object' && item.image && (
                          <img src={item.image} alt={item.name} className="h-full w-full object-cover" />
                        )}
                      </div>
                    </div>
                  ))}
                </div>
                <p className="text-[14px] font-normal text-zinc-500 mt-3">* will be cleaned basis the selection</p>
              </div>

              <div className="h-[8px] bg-[#f5f7fb] w-[calc(100%+40px)] -mx-5 shrink-0" />

              {/* 2. What is excluded */}
              {service.excluded_items && service.excluded_items.length > 0 && (
                <div>
                  <h4 className="font-outfit text-[17px] font-medium text-zinc-900 mb-4">What is excluded?</h4>
                  <ul className="space-y-3">
                    {service.excluded_items.map((ex: string, idx: number) => (
                      <li key={idx} className="flex items-start gap-2.5 text-[15px] font-normal text-zinc-500 leading-snug">
                        <X className="h-4 w-4 text-red-400 mt-0.5 shrink-0" strokeWidth={2.5} />
                        {ex}
                      </li>
                    ))}
                  </ul>
                </div>
              )}

              {service.excluded_items?.length > 0 && <div className="h-[8px] bg-[#f5f7fb] w-[calc(100%+40px)] -mx-5 shrink-0" />}

              {/* 3. See the difference yourself */}
              {service.before_after_images && service.before_after_images.length > 0 && (
                <div className="bg-[#f5f7fb] -mx-5 px-5 py-6">
                  <h4 className="font-outfit text-[17px] font-medium text-zinc-900 mb-4">See the difference yourself</h4>
                  <div className="grid grid-cols-2 gap-3">
                    {service.before_after_images.slice(0, 4).map((img: string, idx: number) => (
                      <div key={idx} className="h-[140px] rounded-xl overflow-hidden bg-zinc-100">
                        <img src={img} alt="Difference" className="h-full w-full object-cover" />
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* 4. Our cleaning equipments */}
              {(!service.equipment || service.equipment.length === 0) && (
                <div>
                  <h4 className="font-outfit text-[17px] font-medium text-zinc-900 mb-4">Our cleaning equipments</h4>
                  <div className="grid grid-cols-2 gap-4">
                    {[1, 2].map((_, idx) => (
                      <div key={idx} className="flex flex-col items-center">
                        <div className="h-[120px] w-full rounded-xl bg-white overflow-hidden flex items-center justify-center">
                          <img src="https://images.unsplash.com/photo-1584824486516-0555a07fc511?w=200&h=200&fit=crop" alt="Equipment" className="h-full w-full object-contain mix-blend-multiply" />
                        </div>
                        <p className="text-[13px] text-zinc-500 mt-2">Hello World</p>
                      </div>
                    ))}
                  </div>
                </div>
              )}
              {service.equipment && service.equipment.length > 0 && (
                <div>
                  <h4 className="font-outfit text-[17px] font-medium text-zinc-900 mb-4">Our cleaning equipments</h4>
                  <div className="grid grid-cols-2 gap-4">
                    {service.equipment.map((eq: any, idx: number) => (
                      <div key={idx} className="flex flex-col items-center">
                        <div className="h-[120px] w-full rounded-xl overflow-hidden flex items-center justify-center">
                          <img src={eq.image} alt={eq.name} className="h-full w-full object-contain" />
                        </div>
                        <p className="text-[13px] text-zinc-500 mt-2">{eq.name}</p>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              <div className="h-[8px] bg-[#f5f7fb] w-[calc(100%+40px)] -mx-5 shrink-0" />

              {/* 5. What we will need from you */}
              {service.requirements && service.requirements.length > 0 && (
                <div>
                  <h4 className="font-outfit text-[17px] font-medium text-zinc-900 mb-4">What we will need from you</h4>
                  <div className="grid grid-cols-3 gap-3">
                    {service.requirements.map((req: any, idx: number) => {
                      const IconComponent = (typeof req === 'object' && req.icon) ? (iconMap[req.icon] || Sparkles) : Sparkles;
                      const text = typeof req === 'object' ? (req.text || req.name) : req;
                      return (
                        <div key={idx} className="bg-[#f8f9fa] rounded-xl p-3 aspect-square flex flex-col justify-center border border-zinc-50">
                          <IconComponent className="h-6 w-6 text-zinc-600 mb-3" />
                          <p className="text-[14.5px] font-semibold text-zinc-900 leading-tight">{text}</p>
                        </div>
                      );
                    })}
                  </div>
                </div>
              )}

              <div className="h-[8px] bg-[#f5f7fb] w-[calc(100%+40px)] -mx-5 shrink-0" />

              {/* 6. Certified Experts */}
              {service.cleaner_bullets && service.cleaner_bullets.length > 0 && (
                <div>
                  <h4 className="font-outfit text-[17px] font-medium text-zinc-900 mb-4">Certified Experts</h4>
                  <div className="flex justify-between gap-4">
                    <ul className="space-y-3 flex-1">
                      {service.cleaner_bullets.map((bullet: string, idx: number) => (
                        <li key={idx} className="flex items-start gap-2.5 text-[15px] font-normal text-[#57636C] leading-snug">
                          <Leaf className="h-4 w-4 text-[#57636C] mt-0.5 shrink-0" fill="currentColor" />
                          {bullet}
                        </li>
                      ))}
                    </ul>
                    <div className="h-[100px] w-[100px] rounded-xl overflow-hidden shrink-0 bg-zinc-200">
                      <img src={service.top_master_image_url || "https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=300&h=300&fit=crop"} alt="Expert" className="h-full w-full object-cover" />
                    </div>
                  </div>
                </div>
              )}

              <div className="h-[8px] bg-[#f5f7fb] w-[calc(100%+40px)] -mx-5 shrink-0" />

              {/* 7. Reviews Summary & List */}
              <div className="min-h-[100px]">
                {reviewsLoading ? (
                  <div className="flex justify-center items-center py-10">
                    <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
                  </div>
                ) : (
                  <>
                    <div className="mb-4">
                      <div className="flex items-center gap-2 mb-0.5">
                        <Star className="h-[22px] w-[22px] fill-primary text-primary" />
                        <span className="font-outfit text-[22px] font-bold text-zinc-900 leading-none">
                          {(service.rating ?? 4.7).toFixed(2)}
                        </span>
                      </div>
                      <p className="text-[13px] text-zinc-600">{Intl.NumberFormat('en-US').format(totalReviews)} reviews</p>
                    </div>
                    
                    {/* Progress bars */}
                    <div className="space-y-[12px] mb-6 pr-4">
                      {progressBars.map(row => (
                        <div key={row.stars} className="flex items-center gap-3">
                          <div className="flex items-center gap-1.5 w-6 shrink-0">
                            <Star className="h-[14px] w-[14px] fill-primary text-primary shrink-0" />
                            <span className="text-[14px] font-bold text-zinc-900 leading-none">{row.stars}</span>
                          </div>
                          <div className="flex-1 h-[5px] bg-zinc-100 rounded-full overflow-hidden">
                            <div className="h-full bg-primary rounded-full transition-all duration-500" style={{ width: `${row.percent}%` }} />
                          </div>
                          <div className="w-8 text-right text-[13px] text-zinc-600 shrink-0">{row.count}</div>
                        </div>
                      ))}
                    </div>

                    <div className="h-[8px] bg-[#f5f7fb] w-[calc(100%+40px)] -mx-5 shrink-0" />

                    {/* 8. All reviews */}
                    <div className="mt-4">
                      <div className="mb-4 flex justify-between items-center">
                        <h4 className="font-outfit text-[17px] font-medium text-zinc-900">All reviews</h4>
                        <button className="text-[14px] text-primary font-medium">Filter</button>
                      </div>

                      {/* Filter chips */}
                      <div className="flex gap-2 overflow-x-auto scrollbar-none pb-2 -mx-5 px-5 mb-5">
                        {["Most detailed", "In my area", "Frequent users"].map((chip, idx) => (
                          <button 
                            key={idx} 
                            onClick={() => setActiveFilter(chip)}
                            className={`border rounded-[10px] px-3.5 py-2 whitespace-nowrap text-[13px] font-medium shrink-0 transition-colors ${
                              activeFilter === chip 
                                ? "border-primary bg-primary/5 text-primary" 
                                : "border-zinc-200 text-zinc-600 hover:bg-zinc-50"
                            }`}
                          >
                            {chip}
                          </button>
                        ))}
                      </div>

                      {/* Review list */}
                      <div className="space-y-6">
                        {displayReviews.length > 0 ? displayReviews.slice(0, 5).map((review, idx) => (
                          <div key={idx} className="border-b border-zinc-100 pb-6 last:border-0 last:pb-0">
                            <div className="flex justify-between items-start mb-3">
                              <div>
                                <h5 className="text-[15px] font-semibold text-zinc-900 leading-tight mb-1">
                                  {review.profiles?.first_name ? `${review.profiles.first_name} ${review.profiles.last_name || ""}` : "Helpero User"}
                                </h5>
                                <p className="text-[12.5px] text-zinc-500 leading-tight">
                                  {new Date(review.created_at).toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" })}
                                  {service.estimated_duration && ` • For ${formatDuration(service.estimated_duration)}`}
                                </p>
                              </div>
                              <div className="bg-[#0B7A5E] rounded-[4px] flex items-center gap-1 px-1.5 py-0.5 mt-0.5">
                                <Star className="h-[11px] w-[11px] text-white" fill="currentColor" />
                                <span className="text-white text-[13px] font-bold leading-none mt-0.5">{review.rating}</span>
                              </div>
                            </div>
                            <p className="text-[14px] text-zinc-700 leading-[1.45]">
                              {review.comment}
                            </p>
                          </div>
                        )) : (
                          <p className="text-[14px] text-zinc-500 text-center py-4">No reviews available yet.</p>
                        )}
                        
                        {displayReviews.length > 5 && (
                          <button className="w-full py-3 text-[14px] font-medium text-zinc-700 bg-zinc-50 hover:bg-zinc-100 rounded-xl transition-colors">
                            Show all {displayReviews.length} reviews
                          </button>
                        )}
                      </div>
                    </div>
                  </>
                )}
              </div>
              
              {/* Bottom spacer to prevent content from hiding behind the absolute Book Now button */}
              <div className="h-28 shrink-0 w-full" />
            </div>

            {/* Floating Book Now Button inside modal */}
            <div className="absolute bottom-6 right-5 left-5 flex justify-end pointer-events-none z-20">
              <button
                onClick={(e) => {
                  e.stopPropagation();
                  setIsExpanded(false);
                  handleCardClick();
                }}
                className="bg-[#1a1c20] text-white w-[140px] h-[50px] flex items-center justify-center rounded-lg text-[18px] font-semibold active:scale-95 transition-transform pointer-events-auto shadow-md hover:bg-[#2a2c30]"
              >
                Book Now
              </button>
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
    </>
  );
}
