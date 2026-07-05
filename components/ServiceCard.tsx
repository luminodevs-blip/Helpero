"use client";

import React, { useState } from "react";
import { useRouter } from "next/navigation";
import { Star, Sparkles, ChevronDown, ChevronUp } from "lucide-react";

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
  const visibleBullets = isExpanded ? bullets : bullets.slice(0, 3);
  const hasMore = bullets.length > 3;

  const handleCardClick = () => {
    if (onClick) {
      onClick();
    } else {
      router.push(`/service/${service.id}`);
    }
  };

  return (
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
            if (hasMore) {
              setIsExpanded(!isExpanded);
            } else {
              handleCardClick();
            }
          }}
          className="flex items-center gap-0.5 text-primary text-[14px] font-normal mt-3 self-start hover:opacity-80 transition-opacity"
        >
          {isExpanded && hasMore ? (
            <>Show less <ChevronUp className="h-3.5 w-3.5" /></>
          ) : (
            <>Learn more <ChevronDown className="h-3.5 w-3.5" /></>
          )}
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
  );
}
