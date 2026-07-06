import { NextResponse } from "next/server";
import Stripe from "stripe";
import { createClient } from "@supabase/supabase-js";

export async function POST(req: Request) {
  try {
    if (!process.env.STRIPE_SECRET_KEY) {
      return NextResponse.json({ error: "Stripe is not configured" }, { status: 500 });
    }

    const stripe = new Stripe(process.env.STRIPE_SECRET_KEY, {
      apiVersion: "2026-06-24.dahlia" as any,
    });

    const authHeader = req.headers.get("authorization");
    if (!authHeader?.startsWith("Bearer ")) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }
    const userJwt = authHeader.replace("Bearer ", "");

    const body = await req.json();
    const { id, gatewayId } = body;

    if (!id || !gatewayId) {
      return NextResponse.json({ error: "id and gatewayId are required" }, { status: 400 });
    }

    // Auth Supabase client
    const supabase = createClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
      { global: { headers: { Authorization: `Bearer ${userJwt}` } } }
    );

    // Get user details
    const { data: { user }, error: userError } = await supabase.auth.getUser();
    if (userError || !user) {
      return NextResponse.json({ error: "Invalid user token" }, { status: 401 });
    }

    // 1. Detach from Stripe customer
    try {
      await stripe.paymentMethods.detach(gatewayId);
    } catch (stripeErr: any) {
      console.warn("Stripe PM detach warning/error (might already be detached):", stripeErr);
    }

    // 2. Delete from Supabase database
    const { error: deleteError } = await supabase
      .from("payment_methods")
      .delete()
      .eq("id", id)
      .eq("user_id", user.id);

    if (deleteError) {
      console.error("Failed to delete payment method from DB:", deleteError);
      return NextResponse.json({ error: deleteError.message }, { status: 500 });
    }

    // 3. Make another card default if the deleted one was default and other cards exist
    const { data: remaining } = await supabase
      .from("payment_methods")
      .select("id, is_default")
      .eq("user_id", user.id);

    if (remaining && remaining.length > 0) {
      const hasDefault = remaining.some((r) => r.is_default);
      if (!hasDefault) {
        await supabase
          .from("payment_methods")
          .update({ is_default: true })
          .eq("id", remaining[0].id);
      }
    }

    return NextResponse.json({ success: true });

  } catch (error: any) {
    console.error("Delete Payment Method error:", error);
    return NextResponse.json(
      { error: error.message || "Internal Server Error" },
      { status: 500 }
    );
  }
}
