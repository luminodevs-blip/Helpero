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
    const userEmail = user.email;
    const userPhone = user.phone;

    // Find or create customer
    const customers = await stripe.customers.search({
      query: `metadata['supabase_user_id']:'${userId}'`,
    });

    let customerId = customers.data[0]?.id;

    if (!customerId) {
      const customer = await stripe.customers.create({
        email: userEmail || undefined,
        phone: userPhone || undefined,
        metadata: {
          supabase_user_id: userId,
        },
      });
      customerId = customer.id;
    }

    // Create SetupIntent
    const setupIntent = await stripe.setupIntents.create({
      customer: customerId,
      payment_method_types: ["card"],
      metadata: {
        supabase_user_id: userId,
      },
    });

    return NextResponse.json({
      clientSecret: setupIntent.client_secret,
      customerId,
    });

  } catch (error: any) {
    console.error("Create Setup Intent error:", error);
    return NextResponse.json(
      { error: error.message || "Internal Server Error" },
      { status: 500 }
    );
  }
}
