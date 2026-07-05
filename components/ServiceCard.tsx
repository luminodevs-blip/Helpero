"use client";

import React, { useState } from "react";
import { useRouter } from "next/navigation";
import { Star, Sparkles, ChevronDown, ChevronUp, X } from "lucide-react";

interface ServiceCardProps {
  service: any;
  onClick?: () => void;
  className?: string;
}

export default function ServiceCard({ service, onClick, className = "" }: ServiceCardProps) {
  const router = useRouter();
  const [isExpanded, setIsExpanded] = useState(false);

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
                  <h3 className="font-outfit text-xl font-semibold text-zinc-900 mb-1">{service.name}</h3>
                  <p className="text-[14px] text-zinc-500 font-medium">
                    Starts at ${service.base_price?.toFixed(2) ?? "0.00"} 
                    {service.estimated_duration ? ` • ${formatDuration(service.estimated_duration)}` : ''}
                  </p>
                </div>
                <button onClick={() => setIsExpanded(false)} className="h-8 w-8 bg-zinc-100 rounded-full flex items-center justify-center text-zinc-500 hover:bg-zinc-200 transition-colors">
                  <X className="h-4 w-4" />
                </button>
              </div>
            </div>

            <div className="h-[1px] w-full bg-zinc-100 shrink-0" />

            {/* Scrollable Body */}
            <div className="overflow-y-auto px-5 py-6 pb-32 scrollbar-none flex flex-col gap-6 relative">
              
              {/* 1. What is included */}
              <div>
                <h4 className="font-outfit text-[16px] font-semibold text-zinc-900 mb-3">What is included:</h4>
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
                <p className="text-[12px] text-zinc-500 mt-3">* will be cleaned basis the selection</p>
              </div>

              <div className="h-[8px] bg-[#f5f7fb] w-[calc(100%+40px)] -mx-5 shrink-0" />

              {/* 2. What is excluded */}
              {service.excluded_items && service.excluded_items.length > 0 && (
                <div>
                  <h4 className="font-outfit text-[16px] font-semibold text-zinc-900 mb-4">What is excluded?</h4>
                  <ul className="space-y-3">
                    {service.excluded_items.map((ex: string, idx: number) => (
                      <li key={idx} className="flex items-start gap-2.5 text-[14.5px] font-light text-zinc-500 leading-snug">
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
                <div>
                  <h4 className="font-outfit text-[16px] font-semibold text-zinc-900 mb-4">See the difference yourself</h4>
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
                  <h4 className="font-outfit text-[16px] font-semibold text-zinc-900 mb-4">Our cleaning equipments</h4>
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
                  <h4 className="font-outfit text-[16px] font-semibold text-zinc-900 mb-4">Our cleaning equipments</h4>
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
                  <h4 className="font-outfit text-[16px] font-semibold text-zinc-900 mb-4">What we will need from you</h4>
                  <div className="grid grid-cols-3 gap-3">
                    {service.requirements.map((req: any, idx: number) => (
                      <div key={idx} className="bg-[#f8f9fa] rounded-xl p-3 aspect-square flex flex-col justify-center border border-zinc-50">
                        <div className="h-6 w-6 text-zinc-600 mb-2">
                          <Sparkles className="h-full w-full" /> {/* Using generic icon */}
                        </div>
                        <p className="text-[12px] leading-tight font-semibold text-zinc-800">{req.text}</p>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              <div className="h-[8px] bg-[#f5f7fb] w-[calc(100%+40px)] -mx-5 shrink-0" />

              {/* 6. Certified Experts */}
              {service.cleaner_bullets && service.cleaner_bullets.length > 0 && (
                <div>
                  <h4 className="font-outfit text-[16px] font-semibold text-zinc-900 mb-4">Certified Experts</h4>
                  <div className="flex justify-between gap-4">
                    <ul className="space-y-3 flex-1">
                      {service.cleaner_bullets.map((bullet: string, idx: number) => (
                        <li key={idx} className="flex items-center gap-2 text-[14px] text-zinc-500 font-medium">
                          <Star className="h-4 w-4 text-zinc-400 shrink-0" />
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

              {/* 7. Reviews Summary */}
              <div>
                <div className="flex items-center gap-2 mb-1">
                  <Star className="h-5 w-5 fill-[#6366f1] text-[#6366f1]" />
                  <span className="font-outfit text-2xl font-semibold text-zinc-900">
                    {(service.rating ?? 4.7).toFixed(2)}
                  </span>
                </div>
                <p className="text-[13px] text-zinc-500 mb-4">{service.reviews_count ?? 1240} reviews</p>
                
                {/* Mock progress bars */}
                <div className="space-y-2.5 max-w-[80%]">
                  <div className="flex items-center gap-3">
                    <div className="flex items-center gap-1 w-8 text-[13px] font-bold text-zinc-800"><Star className="h-3.5 w-3.5 fill-[#6366f1] text-[#6366f1]"/> 5</div>
                    <div className="h-1.5 flex-1 bg-zinc-100 rounded-full overflow-hidden"><div className="h-full bg-[#6366f1] rounded-full" style={{width: '75%'}}/></div>
                    <span className="text-[12px] text-zinc-500 w-6 text-right">865</span>
                  </div>
                  <div className="flex items-center gap-3">
                    <div className="flex items-center gap-1 w-8 text-[13px] font-bold text-zinc-800"><Star className="h-3.5 w-3.5 fill-[#6366f1] text-[#6366f1]"/> 4</div>
                    <div className="h-1.5 flex-1 bg-zinc-100 rounded-full overflow-hidden"><div className="h-full bg-[#6366f1] rounded-full" style={{width: '25%'}}/></div>
                    <span className="text-[12px] text-zinc-500 w-6 text-right">165</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Floating Book Now Button inside modal */}
            <div className="absolute bottom-6 right-5 left-5 flex justify-end pointer-events-none z-20">
              <button
                onClick={(e) => {
                  e.stopPropagation();
                  setIsExpanded(false);
                  handleCardClick();
                }}
                className="bg-[#1a1c20] text-white px-8 py-3.5 rounded-xl text-[16px] font-bold active:scale-95 transition-transform pointer-events-auto shadow-[0_8px_30px_rgba(0,0,0,0.12)] hover:bg-[#2a2c30]"
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
