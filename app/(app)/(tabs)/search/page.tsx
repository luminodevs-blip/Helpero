"use client";

import React, { useState, useEffect, useRef } from "react";
import { useRouter } from "next/navigation";
import { supabase } from "@/lib/supabase";
import { Search, Loader2, AlertCircle, ShoppingCart } from "lucide-react";
import ServiceCard from "@/components/ServiceCard";
import CartIcon from "@/components/CartIcon";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";

interface ServiceResult {
  id: number;
  name: string;
  short_description: string | null;
  base_price: number;
  image_url: string | null;
  rating: number;
}

export default function SearchPage() {
  const router = useRouter();
  const { cart } = useClientAuth();
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<ServiceResult[]>([]);
  const [loading, setLoading] = useState(false);
  const [allServices, setAllServices] = useState<ServiceResult[]>([]);
  const [pinned, setPinned] = useState(false);

  // Watch the title block — the moment it exits viewport, show pinned bar instantly
  const titleRef = useRef<HTMLDivElement>(null);
  useEffect(() => {
    const el = titleRef.current;
    if (!el) return;
    const observer = new IntersectionObserver(
      ([entry]) => setPinned(!entry.isIntersecting),
      { threshold: 0, rootMargin: "0px" }
    );
    observer.observe(el);
    return () => observer.disconnect();
  }, []);

  useEffect(() => {
    const load = async () => {
      try {
        setLoading(true);
        const { data, error } = await supabase
          .from("services")
          .select("id, name, short_description, base_price, image_url, rating, card_bullets")
          .eq("is_active", true)
          .order("rating", { ascending: false })
          .limit(8);
        if (!error && data) {
          const mapped = data.map((s: any) => ({
            id: s.id, name: s.name,
            short_description: s.short_description,
            card_bullets: s.card_bullets,
            base_price: Number(s.base_price || 0),
            image_url: s.image_url, rating: s.rating || 5.0,
          }));
          setAllServices(mapped);
          setResults(mapped);
        }
      } catch (err) { console.error(err); }
      finally { setLoading(false); }
    };
    load();
  }, []);

  useEffect(() => {
    if (!query.trim()) { setResults(allServices); return; }
    const run = async () => {
      setLoading(true);
      try {
        const { data, error } = await supabase
          .from("services")
          .select("id, name, short_description, base_price, image_url, rating, search_tags")
          .eq("is_active", true);
        if (!error && data) {
          const q = query.toLowerCase();
          setResults(data
            .filter((s: any) =>
              s.name.toLowerCase().includes(q) ||
              s.short_description?.toLowerCase().includes(q) ||
              (s.search_tags || []).some((t: string) => t.toLowerCase().includes(q))
            )
            .map((s: any) => ({
              id: s.id, name: s.name,
              short_description: s.short_description,
              base_price: Number(s.base_price || 0),
              image_url: s.image_url, rating: s.rating || 5.0,
            }))
          );
        }
      } catch (err) { console.error(err); }
      finally { setLoading(false); }
    };
    const t = setTimeout(run, 200);
    return () => clearTimeout(t);
  }, [query, allServices]);

  const searchBar = (
    <div className="flex items-center bg-white/20 rounded-xl h-[44px] px-4 border border-white/10">
      <Search className="h-5 w-5 text-white/80 mr-2.5 flex-shrink-0" />
      <input
        type="text"
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Mounting, cleaning..."
        className="w-full bg-transparent border-none outline-none font-outfit text-[16px] font-normal text-white placeholder-white/80 focus:ring-0"
      />
    </div>
  );

  return (
    <div className="flex flex-col flex-1 bg-white animate-page-fade-in">

      {/* ── PINNED BAR: instant, no animation, identical to original ── */}
      {pinned && (
        <div
          className="fixed top-0 left-1/2 -translate-x-1/2 w-full max-w-md z-50 bg-primary px-5 pt-3 pb-4"
          style={{ boxShadow: "none" }}
        >
          {searchBar}
        </div>
      )}

      {/* ── FULL HEADER ── */}
      <div className="bg-primary text-white pt-10 pb-[40px] px-5 relative overflow-hidden flex-shrink-0">
        <div className="absolute inset-0 bg-radial-gradient from-white/10 to-transparent pointer-events-none opacity-40" />
        <div className="relative z-10 space-y-[12px]">

          {/* Title — observed. When it leaves view, pinned bar appears */}
          <div ref={titleRef} className="flex justify-between items-start">
            <div>
              <h2 className="font-outfit text-[18px] font-bold text-white">Search service</h2>
              <p className="font-outfit text-[15px] font-medium text-white/80 mt-1">
                Anything, whenever it's convenient
              </p>
            </div>
            <CartIcon />
          </div>

          {/* Original search bar */}
          {searchBar}

        </div>
      </div>

      {/* ── RESULTS ── */}
      <div className="flex-1 bg-white rounded-t-[16px] -mt-[24px] pt-[24px] pb-28 px-5 relative z-10">
        <div className="flex items-center justify-between mb-[14px]">
          <h3 className="font-outfit text-[18px] font-semibold text-zinc-900">
            {query.trim() ? `Search results (${results.length})` : "Trending searches"}
          </h3>
        </div>
        <div className="h-[1px] bg-zinc-100 w-[calc(100%+40px)] -mx-5" />

        {loading ? (
          <div className="flex justify-center items-center py-20">
            <Loader2 className="h-8 w-8 text-primary animate-spin" />
          </div>
        ) : results.length === 0 ? (
          <div className="flex flex-col items-center justify-center py-16 text-center space-y-3">
            <div className="h-14 w-14 bg-zinc-100 rounded-full flex items-center justify-center text-zinc-400">
              <AlertCircle className="h-7 w-7" />
            </div>
            <div>
              <p className="font-outfit text-base font-bold text-text-primary">No results found</p>
              <p className="text-xs text-text-secondary mt-1 px-8 leading-relaxed">
                We couldn't find any services matching "{query}". Try checking your spelling or search for general keywords.
              </p>
            </div>
          </div>
        ) : (
          <div className="flex flex-col">
            {results.map((serv, index) => (
              <ServiceCard
                key={serv.id}
                service={serv}
                className={index !== results.length - 1 ? "border-b border-zinc-100" : ""}
              />
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
