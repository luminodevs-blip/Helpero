import { NextResponse } from "next/server";
import Stripe from "stripe";

// Initialize Stripe (requires STRIPE_SECRET_KEY in .env.local)
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY || "sk_test_mock_fallback", {
  apiVersion: "2026-06-24.dahlia",
});

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const { amount, currency = "cad", customerId } = body;

    // Fallback if no secret key is provided yet
    if (!process.env.STRIPE_SECRET_KEY) {
      return NextResponse.json({
        clientSecret: "pi_mock_secret_for_ui_testing",
        ephemeralKey: "ek_mock",
        customer: "cus_mock"
      });
    }

    let customer = customerId;
    if (!customer) {
      const newCustomer = await stripe.customers.create();
      customer = newCustomer.id;
    }

    const ephemeralKey = await stripe.ephemeralKeys.create(
      { customer },
      { apiVersion: "2026-06-24.dahlia" }
    );

    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount * 100), // convert to cents
      currency,
      customer,
      // In the web, automatic_payment_methods enables Apple/Google pay and other local methods
      automatic_payment_methods: {
        enabled: true,
      },
    });

    return NextResponse.json({
      clientSecret: paymentIntent.client_secret,
      ephemeralKey: ephemeralKey.secret,
      customer,
    });
  } catch (error: any) {
    console.error("Stripe payment intent error:", error);
    return NextResponse.json(
      { error: error.message || "Internal Server Error" },
      { status: 500 }
    );
  }
}
