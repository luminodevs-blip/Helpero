const fs = require('fs');
const env = fs.readFileSync('.env.local', 'utf8');
const lines = env.split('\n');
for (let line of lines) {
  if (line.startsWith('NEXT_PUBLIC_SUPABASE_URL=')) process.env.NEXT_PUBLIC_SUPABASE_URL = line.split('=')[1].trim();
  if (line.startsWith('NEXT_PUBLIC_SUPABASE_ANON_KEY=')) process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY = line.split('=')[1].trim();
}

const { createClient } = require('@supabase/supabase-js');
const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL, process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY);

async function run() {
  let res1 = await supabase.from('orders').select(`
    id, status, final_total_price, scheduled_start_at,
    house:houses ( full_address, lat, lng, name_label ),
    specialist:profiles!specialist_id ( id, first_name, last_name, avatar_url, rating, phone_number )
  `).eq('id', 119).single();
  console.log('full query result:', JSON.stringify(res1));
}
run();
