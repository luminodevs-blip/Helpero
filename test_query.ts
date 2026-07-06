import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'https://hwgmjlsoeebgounmthmr.supabase.co';
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
const supabase = createClient(supabaseUrl, supabaseKey);

async function test() {
  const { data, error } = await supabase
    .from('orders')
    .select(`
      id,
      order_items ( service_name, service:services ( image_url, duration_minutes, service_categories ( image_url ) ) )
    `)
    .eq('id', 119)
    .limit(1);
  
  if (error) {
    console.error("Error:", error);
  } else {
    console.log(JSON.stringify(data, null, 2));
  }
}

test();
