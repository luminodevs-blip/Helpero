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
    const { paymentMethodId } = body;

    if (!paymentMethodId) {
      return NextResponse.json({ error: "paymentMethodId is required" }, { status: 400 });
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

    const userId = user.id;

    // Retrieve payment method details from Stripe securely
    const paymentMethod = await stripe.paymentMethods.retrieve(paymentMethodId);
    if (!paymentMethod || !paymentMethod.card) {
      return NextResponse.json({ error: "Invalid payment method" }, { status: 400 });
    }

    const cardBrand = paymentMethod.card.brand || "card";
    const cardLast4 = paymentMethod.card.last4 || "";
    const cardExpiry = `${paymentMethod.card.exp_month}/${paymentMethod.card.exp_year}`;

    // 1. Mark all existing user's payment methods as not default
    const { error: updateError } = await supabase
      .from("payment_methods")
      .update({ is_default: false })
      .eq("user_id", userId);

    if (updateError) {
      console.error("Failed to reset default payment methods:", updateError);
    }

    // 2. Insert new payment method
    const { data, error: insertError } = await supabase
      .from("payment_methods")
      .insert({
        user_id: userId,
        card_type: cardBrand,
        last4: cardLast4,
        expiry_date: cardExpiry,
        is_default: true,
        gateway_id: paymentMethodId,
      })
      .select()
      .single();

    if (insertError) {
      console.error("Failed to insert payment method:", insertError);
      return NextResponse.json({ error: insertError.message }, { status: 500 });
    }

    return NextResponse.json({ success: true, paymentMethod: data });

  } catch (error: any) {
    console.error("Save Payment Method error:", error);
    return NextResponse.json(
      { error: error.message || "Internal Server Error" },
      { status: 500 }
    );
  }
}
