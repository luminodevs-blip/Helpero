import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  "https://hwgmjlsoeebgounmthmr.supabase.co",
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MjExMzUsImV4cCI6MjA4MjA5NzEzNX0.SOn3uvZKOZvy0xmg46oXIhGHiOVpPjRXG7cTfXcqqR4"
);

async function check() {
  const { data: d1, error: e1 } = await supabase.from("orders").select("*").limit(1);
  console.log("Orders error:", e1?.message);
  
  const { data: d2, error: e2 } = await supabase.from("booking_drafts").select("*").limit(1);
  console.log("Booking drafts error:", e2?.message);
  
  // try inserting a row to orders and catch the error
  const { error: e3 } = await supabase.from("orders").insert({
    user_id: "723b7b51-b0e5-4277-a8a2-a2df6a09044b", // dummy
    house_id: 1, // dummy
    status: "pending_payment"
  });
  console.log("Orders insert error:", e3?.message);
}

check();
