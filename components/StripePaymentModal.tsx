"use client";

import React, { useState } from "react";
import { loadStripe } from "@stripe/stripe-js";
import {
  Elements,
  PaymentElement,
  useStripe,
  useElements,
} from "@stripe/react-stripe-js";
import { X, Loader2 } from "lucide-react";

// Initialize Stripe (use environment variable or placeholder for testing)
const stripePromise = loadStripe(
  process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY || "pk_test_placeholder"
);

const CheckoutForm = ({ onSuccess }: { onSuccess: () => void }) => {
  const stripe = useStripe();
  const elements = useElements();
  const [isLoading, setIsLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!stripe || !elements) return;

    setIsLoading(true);
    setErrorMessage(null);

    const { error } = await stripe.confirmPayment({
      elements,
      redirect: "if_required",
      confirmParams: {
        return_url: window.location.origin + "/orders",
      },
    });

    if (error) {
      setErrorMessage(error.message || "An unexpected error occurred.");
      setIsLoading(false);
    } else {
      onSuccess();
    }
  };

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-6 pb-10">
      <PaymentElement
        options={{
          wallets: { applePay: "never", googlePay: "never" },
          fields: { billingDetails: { email: "never", phone: "never", name: "never" } },
        }}
      />
      {errorMessage && (
        <div className="text-red-500 text-[13px] font-medium leading-tight">
          {errorMessage}
        </div>
      )}
      <button
        disabled={isLoading || !stripe || !elements}
        className="w-full h-[50px] bg-zinc-900 text-white rounded-[10px] font-semibold text-[16px] flex items-center justify-center hover:bg-zinc-800 disabled:opacity-50 transition-colors"
      >
        {isLoading ? <Loader2 className="h-5 w-5 animate-spin" /> : "Confirm Payment"}
      </button>
    </form>
  );
};

interface StripePaymentModalProps {
  isOpen: boolean;
  onClose: () => void;
  clientSecret: string;
  onSuccess: () => void;
}

export default function StripePaymentModal({
  isOpen,
  onClose,
  clientSecret,
  onSuccess,
}: StripePaymentModalProps) {
  if (!isOpen || !clientSecret) return null;

  return (
    <div className="fixed inset-0 z-[100] flex items-end sm:items-center justify-center bg-black/40 backdrop-blur-sm animate-in fade-in duration-200">
      <div className="relative w-full max-w-md bg-white rounded-t-[20px] sm:rounded-[20px] flex flex-col pt-6 px-6 animate-in slide-in-from-bottom-10 sm:slide-in-from-bottom-0 sm:zoom-in-95 duration-300">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-[18px] font-semibold text-zinc-900 font-outfit">Payment</h2>
          <button
            onClick={onClose}
            className="p-2 -mr-2 text-zinc-400 hover:text-zinc-600 rounded-full hover:bg-zinc-100 transition-colors"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        <Elements
          stripe={stripePromise}
          options={{
            clientSecret,
            appearance: {
              theme: "stripe",
              variables: {
                colorPrimary: "#18181b",
                borderRadius: "10px",
              },
            },
          }}
        >
          <CheckoutForm onSuccess={onSuccess} />
        </Elements>
      </div>
    </div>
  );
}
