import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

const supabase = createClient(supabaseUrl, supabaseKey);

async function check() {
  const { data, error } = await supabase
    .from('services')
    .select('id, name, card_bullets, included_items, short_description')
    .in('name', ['TV Mounting', 'Furniture Cleaning', 'PAX Wardrobe Expert', 'Plumbing: Leak Fix & Repairs']);

  if (error) console.error(error);
  else console.log(JSON.stringify(data, null, 2));
}

check();
