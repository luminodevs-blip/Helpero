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
  let res1 = await supabase.from('orders').select('specialist:profiles!specialist_id(id)').limit(1);
  console.log('!specialist_id error:', JSON.stringify(res1.error));
  
  let res2 = await supabase.from('orders').select('specialist:profiles!orders_specialist_id_fkey(id)').limit(1);
  console.log('!orders_specialist_id_fkey error:', JSON.stringify(res2.error));

  let res3 = await supabase.from('orders').select('specialist:profiles(id)').limit(1);
  console.log('profiles(id) error:', JSON.stringify(res3.error));
}
run();
