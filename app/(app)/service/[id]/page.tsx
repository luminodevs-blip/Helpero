"use client";

import { useEffect } from "react";
import { useRouter, useParams } from "next/navigation";
import { supabase } from "@/lib/supabase";
import { Loader2 } from "lucide-react";

export default function RedirectServicePage() {
  const router = useRouter();
  const params = useParams();
  const serviceId = params.id;

  useEffect(() => {
    if (!serviceId) return;
    
    supabase
      .from("services")
      .select("category_id")
      .eq("id", Number(serviceId))
      .maybeSingle()
      .then(({ data }) => {
        if (data?.category_id) {
          router.replace(`/category/${data.category_id}?serviceId=${serviceId}`);
        } else {
          router.replace("/");
        }
      });
  }, [serviceId, router]);

  return (
    <div className="flex h-screen w-full items-center justify-center bg-white">
      <Loader2 className="h-8 w-8 text-primary animate-spin" />
    </div>
  );
}
