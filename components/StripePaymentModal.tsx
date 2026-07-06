"use client";

import React, { useState } from "react";
import { loadStripe } from "@stripe/stripe-js";
import {
  Elements,
  PaymentElement,
  useStripe,
  useElements,
} from "@stripe/react-stripe-js";
import { X, Loader2, CheckCircle2 } from "lucide-react";

const stripePromise = loadStripe(
  process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY || "pk_test_placeholder"
);

interface CheckoutFormProps {
  onSuccess: () => void;
}

const CheckoutForm = ({ onSuccess }: CheckoutFormProps) => {
  const stripe = useStripe();
  const elements = useElements();
  const [isLoading, setIsLoading] = useState(false);
  const [isPaid, setIsPaid] = useState(false);
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
      // Show success animation then call onSuccess
      setIsPaid(true);
      setIsLoading(false);
      setTimeout(() => {
        onSuccess();
      }, 1800);
    }
  };

  // ── Success animation overlay ──
  if (isPaid) {
    return (
      <div className="flex flex-col items-center justify-center py-10 pb-10 gap-5 animate-in fade-in duration-300">
        <div className="relative flex items-center justify-center">
          {/* Pulsing ring */}
          <div className="absolute h-28 w-28 rounded-full bg-emerald-100 animate-ping opacity-50" />
          <div className="relative h-24 w-24 rounded-full bg-emerald-500 flex items-center justify-center shadow-xl shadow-emerald-200">
            <CheckCircle2 className="h-12 w-12 text-white" strokeWidth={2.5} />
          </div>
        </div>
        <div className="text-center">
          <p className="font-outfit text-[20px] font-extrabold text-zinc-900">Payment Successful!</p>
          <p className="text-[13px] text-zinc-500 mt-1">Securing your booking...</p>
        </div>
      </div>
    );
  }

  return (
    <form onSubmit={handleSubmit} className="flex flex-col gap-6 pb-10">
      <PaymentElement
        options={{
          wallets: { applePay: "never", googlePay: "never" },
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
      <div className="relative w-full max-w-md bg-white rounded-t-[20px] sm:rounded-[20px] flex flex-col pt-5 px-6 animate-in slide-in-from-bottom-10 sm:slide-in-from-bottom-0 sm:zoom-in-95 duration-300">
        {/* Drag handle */}
        <div className="absolute top-[10px] left-1/2 -translate-x-1/2 w-[36px] h-[4px] rounded-full bg-zinc-200 sm:hidden" />

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
