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

    // Extract user JWT from Authorization header (sent by the client)
    const authHeader = req.headers.get("authorization");
    if (!authHeader?.startsWith("Bearer ")) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }
    const userJwt = authHeader.replace("Bearer ", "");

    const body = await req.json();
    const { orderId, currency = "cad" } = body;

    if (!orderId) {
      return NextResponse.json({ error: "orderId is required" }, { status: 400 });
    }

    // Create a Supabase client authenticated as the user (respects RLS)
    // This means we can only read orders that belong to this user
    const supabase = createClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
      { global: { headers: { Authorization: `Bearer ${userJwt}` } } }
    );

    // Fetch the order amount from the database — NOT from the client request
    // RLS ensures the user can only read their own order
    const { data: order, error: orderError } = await supabase
      .from("orders")
      .select("id, final_total_price, status, user_id")
      .eq("id", orderId)
      .eq("status", "pending_payment") // only allow payment for pending orders
      .single();

    if (orderError || !order) {
      return NextResponse.json({ error: "Order not found or not payable" }, { status: 404 });
    }

    if (!order.final_total_price || order.final_total_price <= 0) {
      return NextResponse.json({ error: "Invalid order amount" }, { status: 400 });
    }

    // Create Stripe PaymentIntent with the DB amount — client has zero influence on price
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(Number(order.final_total_price) * 100), // dollars → cents
      currency,
      metadata: {
        order_id: String(orderId),
        user_id: order.user_id,
      },
      automatic_payment_methods: { enabled: true },
    });

    // Update order with the payment intent ID so the Stripe webhook can find it
    const { error: updateError } = await supabase
      .from("orders")
      .update({ payment_id: paymentIntent.id })
      .eq("id", orderId);

    if (updateError) {
      console.error("Failed to update order payment_id:", updateError);
      return NextResponse.json({ error: "Failed to update order with payment ID" }, { status: 500 });
    }

    return NextResponse.json({ clientSecret: paymentIntent.client_secret });

  } catch (error: any) {
    console.error("Stripe payment intent error:", error);
    return NextResponse.json(
      { error: error.message || "Internal Server Error" },
      { status: 500 }
    );
  }
}
