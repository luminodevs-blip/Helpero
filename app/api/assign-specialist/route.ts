import { NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";
import Stripe from "stripe";

export async function POST(req: Request) {
  try {
    const { bookingId } = await req.json();
    if (!bookingId) {
      return NextResponse.json({ error: "Missing bookingId" }, { status: 400 });
    }

    // 1. Extract and verify user JWT from Authorization header
    const authHeader = req.headers.get("authorization");
    if (!authHeader?.startsWith("Bearer ")) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }
    const userJwt = authHeader.replace("Bearer ", "");

    const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
    const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;
    
    // Create Supabase client using user JWT (so it respects RLS and doesn't require service role key)
    const supabaseClient = createClient(supabaseUrl, supabaseAnonKey, {
      global: {
        headers: {
          Authorization: `Bearer ${userJwt}`
        }
      }
    });

    const { data: { user }, error: authErr } = await supabaseClient.auth.getUser();
    if (authErr || !user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    // 2. Get order details
    const { data: order, error: orderErr } = await supabaseClient
      .from("orders")
      .select("*")
      .eq("id", bookingId)
      .maybeSingle();

    if (orderErr || !order) {
      return NextResponse.json({ error: "Order not found" }, { status: 404 });
    }

    // 3. SECURE CHECK: Verify that the order belongs to the authenticated user
    if (order.user_id !== user.id) {
      return NextResponse.json({ error: "Forbidden: Order does not belong to user" }, { status: 403 });
    }

    // 4. If it is already assigned or cancelled, do nothing
    if (order.status === "assigned" || order.status === "canceled") {
      return NextResponse.json({ success: true, message: "Order already processed" });
    }

    // 5. SECURE CHECK: Verify with Stripe that the payment succeeded
    if (!order.payment_id) {
      return NextResponse.json({ error: "Order has no associated payment" }, { status: 400 });
    }

    const stripe = new Stripe(process.env.STRIPE_SECRET_KEY || "", {
      apiVersion: "2026-06-24.dahlia" as any,
    });

    const paymentIntent = await stripe.paymentIntents.retrieve(order.payment_id);
    const isPaymentValid = paymentIntent.status === "succeeded" || paymentIntent.status === "requires_capture";

    if (!isPaymentValid) {
      return NextResponse.json({ error: "Payment not verified on Stripe" }, { status: 402 });
    }

    // 6. Mark the order as paid & searching immediately
    await supabaseClient
      .from("orders")
      .update({
        status: "searching",
        payment_status: "paid",
        paid_at: new Date().toISOString()
      })
      .eq("id", bookingId);

    // 7. Try to find the specialist
    let finalSpecialistId = order.specialist_id;
    let newStatus = "searching";

    if (finalSpecialistId) {
      newStatus = "assigned";
    } else {
      // Lookup active booking intent
      const { data: intent } = await supabaseClient
        .from("booking_intents")
        .select("specialist_id")
        .eq("user_id", order.user_id)
        .eq("scheduled_start_at", order.scheduled_start_at)
        .gt("expires_at", new Date().toISOString())
        .order("created_at", { ascending: false })
        .limit(1)
        .maybeSingle();

      if (intent?.specialist_id) {
        finalSpecialistId = intent.specialist_id;
        newStatus = "assigned";
      } else if (order.house_id) {
        // Fallback to find_smart_slots
        const { data: house } = await supabaseClient
          .from("houses")
          .select("lat, lng")
          .eq("id", order.house_id)
          .single();

        if (house) {
          // Get duration & service from order items
          const { data: cartItems } = await supabaseClient
            .from("cart_items")
            .select("quantity, services(id, duration_minutes)")
            .eq("cart_id", order.cart_id);

          const totalDuration = cartItems?.reduce((acc, item: any) => {
            const svc = Array.isArray(item.services) ? item.services[0] : item.services;
            return acc + (((svc as any)?.duration_minutes || 0) * (item.quantity || 1));
          }, 0) || 60;
          const mainServiceId = cartItems && cartItems.length > 0 ? (cartItems[0] as any).services?.id : null;

          const { data: newSlots } = await supabaseClient.rpc("find_smart_slots", {
            p_house_lat: house.lat,
            p_house_lng: house.lng,
            p_duration_min: totalDuration,
            p_start_date: new Date(order.scheduled_start_at).toISOString().split("T")[0],
            p_days_to_check: 1,
            p_total_limit: 1,
            p_service_id: mainServiceId,
            p_specialists_count: 1
          });

          if (newSlots && newSlots.length > 0) {
            finalSpecialistId = newSlots[0].spec_id;
            newStatus = "assigned";
          }
        }
      }
    }

    if (newStatus === "assigned") {
      const arrivalMode = order.arrival_mode_id;
      const isPriority = arrivalMode === "2bafdcc6-4340-47ef-a412-26e108ad45cb";
      const isScheduled = arrivalMode === "b46ffadd-8017-4e25-82eb-6550988ab31d";
      
      // Delay
      // Priority: 10-15s
      // Standard: 25-35s
      // Scheduled: 10-15s
      let delayMs = 0;
      if (isPriority || isScheduled) {
        delayMs = Math.floor(Math.random() * (15000 - 10000 + 1)) + 10000;
      } else {
        delayMs = Math.floor(Math.random() * (35000 - 25000 + 1)) + 25000;
      }

      console.log(`[Next.js API] Specialist found. Delaying ${delayMs/1000}s before assignment...`);
      await new Promise((resolve) => setTimeout(resolve, delayMs));

      // Update to assigned
      await supabaseClient
        .from("orders")
        .update({
          status: "assigned",
          specialist_id: finalSpecialistId
        })
        .eq("id", bookingId);
    }

    return NextResponse.json({ success: true });
  } catch (err: any) {
    console.error("Error in assign-specialist API:", err);
    return NextResponse.json({ error: err.message }, { status: 500 });
  }
}
