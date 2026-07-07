import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://hwgmjlsoeebgounmthmr.supabase.co';
const supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUyMTEzNSwiZXhwIjoyMDgyMDk3MTM1fQ.Q_3he0tcb0w2-YbsLWnC1jFqafrxJVGmRc4mWXOW4tQ";
const supabase = createClient(supabaseUrl, supabaseKey);

async function test() {
  const { data, error } = await supabase
    .from('orders')
    .select(`
      id,
      order_items ( service_name, service:services ( image_url, duration_minutes, cat:service_categories ( image_url ) ) )
    `)
    .eq('id', 106)
    .single();
  
  if (error) {
    console.error("Error:", error);
  } else {
    console.log(JSON.stringify(data, null, 2));
  }
}

test();
