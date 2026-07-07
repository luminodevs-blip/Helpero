"use client";

import React, { useState, useEffect } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { useClientAuth } from "@/app/contexts/ClientAuthContext";
import { supabase } from "@/lib/supabase";
import {
  ArrowLeft,
  CreditCard,
  Plus,
  ChevronRight,
  Loader2,
  Trash2,
  Check,
  AlertCircle,
  X,
} from "lucide-react";
import { loadStripe } from "@stripe/stripe-js";
import {
  Elements,
  CardElement,
  useStripe,
  useElements,
} from "@stripe/react-stripe-js";
import { useBodyScrollLock } from "@/lib/useBodyScrollLock";

// Initialize Stripe Promise
const stripePromise = loadStripe(process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY || "");

// Add Card Form Component (Wrapped in Stripe Elements)
function AddCardForm({
  onClose,
  onSaved,
}: {
  onClose: () => void;
  onSaved: () => void;
}) {
  const stripe = useStripe();
  const elements = useElements();
  const { user } = useClientAuth();

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!stripe || !elements || !user) return;

    setLoading(true);
    setError(null);

    const cardElement = elements.getElement(CardElement);
    if (!cardElement) {
      setLoading(false);
      return;
    }

    try {
      // 1. Get user session token
      const { data: { session } } = await supabase.auth.getSession();
      const token = session?.access_token;
      if (!token) throw new Error("Authentication token not found");

      // 2. Create SetupIntent on backend
      const resIntent = await fetch("/api/stripe/create-setup-intent", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
      });

      if (!resIntent.ok) {
        const errBody = await resIntent.json();
        throw new Error(errBody.error || "Failed to initialize card setup");
      }

      const { clientSecret } = await resIntent.json();

      // 3. Confirm SetupIntent on Stripe
      const { setupIntent, error: stripeError } = await stripe.confirmCardSetup(
        clientSecret,
        {
          payment_method: {
            card: cardElement,
          },
        }
      );

      if (stripeError) {
        throw new Error(stripeError.message || "Failed to verify card");
      }

      if (!setupIntent?.payment_method) {
        throw new Error("Setup failed. Please try again.");
      }

      // 4. Save payment method to DB via backend
      const resSave = await fetch("/api/stripe/save-payment-method", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          paymentMethodId: setupIntent.payment_method,
        }),
      });

      if (!resSave.ok) {
        const errBody = await resSave.json();
        throw new Error(errBody.error || "Failed to link card to account");
      }

      // Success
      onSaved();
      onClose();
    } catch (err: any) {
      console.error(err);
      setError(err?.message || "An unexpected error occurred");
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div className="flex justify-between items-center pb-2">
        <h3 className="font-outfit text-[18px] font-bold text-zinc-900">Add card</h3>
        <button
          type="button"
          onClick={onClose}
          disabled={loading}
          className="p-1.5 rounded-full hover:bg-zinc-100 text-zinc-500 focus:outline-none"
        >
          <X className="h-5 w-5" />
        </button>
      </div>

      {error && (
        <div className="p-3 bg-red-50 border border-red-100 rounded-xl flex items-start gap-2 text-[13px] text-red-600 font-semibold">
          <AlertCircle className="h-4 w-4 shrink-0 mt-0.5" />
          <span>{error}</span>
        </div>
      )}

      {/* Stripe CardElement input */}
      <div className="p-4 rounded-xl border border-zinc-200 bg-[#F1F4F8]/50 min-h-[50px] flex items-center">
        <div className="w-full">
          <CardElement
            options={{
              style: {
                base: {
                  color: "#14181B",
                  fontFamily: "'Outfit', sans-serif",
                  fontSize: "16px",
                  fontWeight: "600",
                  fontSmoothing: "antialiased",
                  "::placeholder": {
                    color: "#9ca3af",
                  },
                },
                invalid: {
                  color: "#FF5963",
                  iconColor: "#FF5963",
                },
              },
            }}
          />
        </div>
      </div>

      <button
        type="submit"
        disabled={loading || !stripe}
        className="w-full h-12 bg-zinc-900 text-white font-outfit font-bold rounded-xl active:scale-[0.98] transition-all hover:bg-zinc-800 disabled:opacity-50 flex items-center justify-center gap-2"
      >
        {loading ? (
          <>
            <Loader2 className="h-5 w-5 animate-spin text-white" />
            <span>Linking card...</span>
          </>
        ) : (
          <span>Save Card</span>
        )}
      </button>
    </form>
  );
}

export default function PaymentsPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const fromCheckout = searchParams.get("fromCheckout") === "true";
  const { user } = useClientAuth();

  const [balance, setBalance] = useState<{ amount: string; currency_code: string } | null>(null);
  const [loadingBalance, setLoadingBalance] = useState(true);
  const [savedCards, setSavedCards] = useState<any[]>([]);
  const [loadingCards, setLoadingCards] = useState(true);
  const [selectedMethod, setSelectedMethod] = useState<"apple_pay" | "bank_card">("bank_card");
  const [isAddCardOpen, setIsAddCardOpen] = useState(false);
  const [deleteConfirmCard, setDeleteConfirmCard] = useState<any | null>(null);
  const [deleting, setDeleting] = useState(false);

  useBodyScrollLock(isAddCardOpen || deleteConfirmCard !== null);

  const fetchBalanceAndCards = async () => {
    if (!user) return;
    try {
      // 1. Fetch user balance
      setLoadingBalance(true);
      const { data: balanceData, error: balanceErr } = await supabase
        .from("user_balance")
        .select("amount, currency_code")
        .eq("user_id", user.id)
        .maybeSingle();

      if (!balanceErr && balanceData) {
        setBalance({
          amount: Number(balanceData.amount).toFixed(2),
          currency_code: balanceData.currency_code || "USD",
        });
      } else {
        setBalance({ amount: "0.00", currency_code: "USD" });
      }

      // 2. Fetch saved cards from supabase
      setLoadingCards(true);
      const { data: cardsData, error: cardsErr } = await supabase
        .from("payment_methods")
        .select("*")
        .eq("user_id", user.id)
        .order("is_default", { ascending: false })
        .order("id", { ascending: true });

      if (!cardsErr && cardsData) {
        setSavedCards(cardsData);
      }
    } catch (err) {
      console.error("Error loading payment data:", err);
    } finally {
      setLoadingBalance(false);
      setLoadingCards(false);
    }
  };

  useEffect(() => {
    // Load preferred payment method type from localStorage
    const saved = localStorage.getItem("preferred_payment_method");
    if (saved === "apple_pay" || saved === "bank_card") {
      setSelectedMethod(saved);
    } else {
      setSelectedMethod("bank_card");
    }

    fetchBalanceAndCards();
  }, [user]);

  const handleSelectMethodType = (method: "apple_pay" | "bank_card") => {
    setSelectedMethod(method);
    localStorage.setItem("preferred_payment_method", method);
    localStorage.setItem("last_payment_method", method);
  };

  const handleMakeCardDefault = async (cardId: number) => {
    if (!user) return;
    try {
      // 1. Reset all to false
      await supabase
        .from("payment_methods")
        .update({ is_default: false })
        .eq("user_id", user.id);

      // 2. Set target card as default
      await supabase
        .from("payment_methods")
        .update({ is_default: true })
        .eq("id", cardId)
        .eq("user_id", user.id);

      // Reload
      fetchBalanceAndCards();
    } catch (err) {
      console.error("Failed to make card default:", err);
    }
  };

  const handleDeleteCard = async () => {
    if (!deleteConfirmCard || !user) return;
    setDeleting(true);
    try {
      const { data: { session } } = await supabase.auth.getSession();
      const token = session?.access_token;
      if (!token) throw new Error("Auth token not found");

      const res = await fetch("/api/stripe/delete-payment-method", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          id: deleteConfirmCard.id,
          gatewayId: deleteConfirmCard.gateway_id,
        }),
      });

      if (!res.ok) {
        const err = await res.json();
        throw new Error(err.error || "Failed to delete card");
      }

      setDeleteConfirmCard(null);
      fetchBalanceAndCards();
    } catch (err) {
      console.error("Error deleting card:", err);
      alert(err instanceof Error ? err.message : "Failed to delete card");
    } finally {
      setDeleting(false);
    }
  };

  const handleBack = () => {
    if (fromCheckout) {
      router.push("/checkout");
    } else {
      router.push("/profile");
    }
  };

  return (
    <div className="w-full max-w-md mx-auto min-h-screen bg-white relative flex flex-col border-x border-alternate shadow-md">
      {/* Header */}
      <div className="px-5 pt-12 pb-4 flex flex-col gap-4 sticky top-0 bg-white z-10">
        <button
          onClick={handleBack}
          className="p-2 -ml-2 self-start rounded-full hover:bg-zinc-100 transition-colors"
        >
          <ArrowLeft className="h-6 w-6 text-zinc-900" />
        </button>
        <h1 className="font-outfit text-[28px] font-bold text-zinc-900 leading-tight">
          Payment method
        </h1>
      </div>

      {/* Content */}
      <div className="px-5 space-y-6 flex-1 pb-10">
        {/* Helpero Credits Card */}
        <div className="rounded-2xl border border-zinc-200/80 bg-white p-5 shadow-sm">
          <div className="flex flex-col">
            <span className="text-[12px] font-bold text-zinc-500 uppercase tracking-wider">
              Helpero-credits
            </span>
            {loadingBalance ? (
              <div className="h-10 flex items-center mt-1">
                <Loader2 className="h-5 w-5 animate-spin text-[#7B82F4]" />
              </div>
            ) : (
              <span className="font-outfit text-[32px] font-extrabold text-zinc-900 mt-1">
                {balance?.amount} $
              </span>
            )}
          </div>
          
          <div className="h-px bg-zinc-100 my-4" />

          <button
            onClick={() => alert("Transaction history coming soon")}
            className="w-full flex items-center justify-between text-zinc-500 hover:text-zinc-700 transition-colors"
          >
            <span className="text-[13px] font-semibold">View transactions</span>
            <ChevronRight className="h-4 w-4" />
          </button>
        </div>

        {/* Payment Methods Type Selection */}
        <div className="space-y-4">
          <span className="text-[11px] font-bold text-zinc-400 tracking-wider uppercase block">
            Payment Type
          </span>

          {/* Apple Pay Option */}
          <div
            onClick={() => handleSelectMethodType("apple_pay")}
            className={`flex items-center justify-between p-4 rounded-2xl border cursor-pointer transition-colors bg-[#F8F9FA] ${
              selectedMethod === "apple_pay" ? "border-[#7B82F4]" : "border-zinc-100"
            }`}
          >
            <div className="flex items-center gap-3">
              <div className="h-10 w-[52px] bg-black rounded-xl flex items-center justify-center shrink-0 shadow-sm">
                <span className="text-white font-extrabold text-[12px] tracking-tight"> Pay</span>
              </div>
              <div className="flex flex-col">
                <span className="font-outfit text-[15px] font-bold text-zinc-900">
                  Apple Pay
                </span>
                <span className="text-[11px] font-medium text-zinc-500">
                  Fast and secure
                </span>
              </div>
            </div>
            <div
              className={`h-5 w-5 rounded-full border-2 flex items-center justify-center shrink-0 transition-colors ${
                selectedMethod === "apple_pay"
                  ? "border-[#7B82F4] bg-white"
                  : "border-zinc-200"
              }`}
            >
              {selectedMethod === "apple_pay" && (
                <div className="h-2.5 w-2.5 rounded-full bg-[#7B82F4]" />
              )}
            </div>
          </div>

          {/* Bank Card Option */}
          <div
            onClick={() => handleSelectMethodType("bank_card")}
            className={`flex items-center justify-between p-4 rounded-2xl border cursor-pointer transition-colors bg-white ${
              selectedMethod === "bank_card" ? "border-[#7B82F4]" : "border-zinc-200"
            }`}
          >
            <div className="flex items-center gap-3">
              <div className="h-10 w-[52px] border border-zinc-200 rounded-xl flex items-center justify-center shrink-0 bg-white">
                <CreditCard className="h-5 w-5 text-zinc-700" />
              </div>
              <div className="flex flex-col">
                <span className="font-outfit text-[15px] font-bold text-zinc-900">
                  Bank Cards
                </span>
                <span className="text-[11px] font-medium text-zinc-500">
                  Manage cards below
                </span>
              </div>
            </div>
            <div
              className={`h-5 w-5 rounded-full border-2 flex items-center justify-center shrink-0 transition-colors ${
                selectedMethod === "bank_card"
                  ? "border-[#7B82F4] bg-white"
                  : "border-zinc-200"
              }`}
            >
              {selectedMethod === "bank_card" && (
                <div className="h-2.5 w-2.5 rounded-full bg-[#7B82F4]" />
              )}
            </div>
          </div>
        </div>

        {/* Saved Credit Cards Section */}
        {selectedMethod === "bank_card" && (
          <div className="space-y-4 pt-2">
            <span className="text-[11px] font-bold text-zinc-400 tracking-wider uppercase block">
              Saved Bank Cards
            </span>

            {loadingCards ? (
              <div className="flex items-center justify-center py-6">
                <Loader2 className="h-6 w-6 animate-spin text-[#7B82F4]" />
              </div>
            ) : savedCards.length === 0 ? (
              <div className="p-5 border border-dashed border-zinc-200 rounded-2xl text-center">
                <CreditCard className="h-8 w-8 text-zinc-300 mx-auto mb-2" />
                <p className="font-outfit text-[15px] font-semibold text-zinc-800">
                  No cards linked
                </p>
                <p className="text-[11px] text-zinc-400 mt-0.5">
                  Link a card below to start booking services
                </p>
              </div>
            ) : (
              <div className="space-y-3">
                {savedCards.map((card) => (
                  <div
                    key={card.id}
                    onClick={() => handleMakeCardDefault(card.id)}
                    className={`flex items-center justify-between p-4 rounded-2xl border bg-white transition-all cursor-pointer hover:border-zinc-300 ${
                      card.is_default ? "border-[#7B82F4] ring-1 ring-[#7B82F4]" : "border-zinc-200/80"
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <div className="h-10 w-[52px] border border-zinc-200 rounded-xl flex items-center justify-center shrink-0 bg-white font-outfit text-[11px] font-bold text-zinc-600 uppercase tracking-tight shadow-sm">
                        {card.card_type}
                      </div>
                      <div className="flex flex-col">
                        <div className="flex items-center gap-2">
                          <span className="font-sans text-[15px] font-bold text-zinc-900">
                            •••• {card.last4}
                          </span>
                          {card.is_default && (
                            <span className="px-2 py-0.5 text-[10px] font-bold text-green-700 bg-green-50 rounded-full border border-green-200">
                              Default
                            </span>
                          )}
                        </div>
                        <span className="text-[11px] font-medium text-zinc-400">
                          Expires {card.expiry_date}
                        </span>
                      </div>
                    </div>

                    <div className="flex items-center gap-2" onClick={(e) => e.stopPropagation()}>
                      <button
                        onClick={() => setDeleteConfirmCard(card)}
                        className="p-2 rounded-xl text-zinc-400 hover:text-red-500 hover:bg-red-50 transition-colors"
                      >
                        <Trash2 className="h-4.5 w-4.5" />
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}

            {/* Try another way to pay (Link a new card) */}
            <div
              onClick={() => setIsAddCardOpen(true)}
              className="flex items-center justify-between p-4 rounded-2xl border border-zinc-200 bg-white cursor-pointer hover:bg-zinc-50 transition-colors"
            >
              <div className="flex items-center gap-3">
                <div className="h-10 w-[52px] bg-[#7B82F4]/10 rounded-xl flex items-center justify-center shrink-0">
                  <Plus className="h-5 w-5 text-[#7B82F4]" />
                </div>
                <div className="flex flex-col">
                  <span className="font-outfit text-[15px] font-bold text-zinc-900">
                    Add new card
                  </span>
                  <span className="text-[11px] font-medium text-zinc-500">
                    Stripe Secure Link
                  </span>
                </div>
              </div>
              <ChevronRight className="h-5 w-5 text-zinc-400" />
            </div>
          </div>
        )}
      </div>

      {/* ── ADD CARD MODAL BOTTOM SHEET ── */}
      {isAddCardOpen && (
        <div 
          className="fixed inset-0 z-50 flex flex-col justify-end bg-black/40 backdrop-blur-[2px] transition-opacity"
          onClick={() => setIsAddCardOpen(false)}
        >
          <div
            className="w-full max-w-md mx-auto bg-white rounded-t-[28px] p-6 shadow-2xl relative animate-slide-up"
            onClick={(e) => e.stopPropagation()}
          >
            <Elements stripe={stripePromise}>
              <AddCardForm
                onClose={() => setIsAddCardOpen(false)}
                onSaved={() => {
                  setIsAddCardOpen(false);
                  fetchBalanceAndCards();
                }}
              />
            </Elements>
          </div>
        </div>
      )}

      {/* ── DELETE CONFIRMATION BOTTOM SHEET ── */}
      {deleteConfirmCard && (
        <div 
          className="fixed inset-0 z-50 flex flex-col justify-end bg-black/40 backdrop-blur-[2px] transition-opacity"
          onClick={() => setDeleteConfirmCard(null)}
        >
          <div
            className="w-full max-w-md mx-auto bg-white rounded-t-[28px] p-6 shadow-2xl relative animate-slide-up"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex justify-between items-center pb-4">
              <h3 className="font-outfit text-[18px] font-bold text-zinc-900">Remove card</h3>
              <button
                type="button"
                onClick={() => setDeleteConfirmCard(null)}
                disabled={deleting}
                className="p-1.5 rounded-full hover:bg-zinc-100 text-zinc-500 focus:outline-none"
              >
                <X className="h-5 w-5" />
              </button>
            </div>

            <p className="text-[14.5px] text-zinc-500 font-sans font-medium mb-6">
              Are you sure you want to delete card Ending in{" "}
              <strong className="text-zinc-900">•••• {deleteConfirmCard.last4}</strong>? 
              This action cannot be undone.
            </p>

            <div className="flex gap-4">
              <button
                onClick={() => setDeleteConfirmCard(null)}
                disabled={deleting}
                className="flex-1 h-12 border border-zinc-200 text-zinc-700 font-sans font-semibold rounded-xl hover:bg-zinc-50 disabled:opacity-50"
              >
                Cancel
              </button>
              <button
                onClick={handleDeleteCard}
                disabled={deleting}
                className="flex-1 h-12 bg-red-600 hover:bg-red-500 text-white font-sans font-semibold rounded-xl active:scale-[0.98] transition-all disabled:opacity-50 flex items-center justify-center gap-2 shadow-sm"
              >
                {deleting ? (
                  <>
                    <Loader2 className="h-5 w-5 animate-spin text-white" />
                    <span>Removing...</span>
                  </>
                ) : (
                  <>
                    <Trash2 className="h-4.5 w-4.5" />
                    <span>Remove</span>
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
