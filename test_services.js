const fs = require('fs');
const env = fs.readFileSync('.env.local', 'utf8');
const key = env.match(/NEXT_PUBLIC_SUPABASE_ANON_KEY=(.*)/)[1];

fetch(`https://hwgmjlsoeebgounmthmr.supabase.co/rest/v1/order_items?select=service_name,service:services(image_url,duration_minutes,cat:service_categories(image_url))&order_id=eq.119`, {
  headers: {
    apikey: key,
    Authorization: `Bearer ${key}`
  }
}).then(r => r.json()).then(data => console.log(JSON.stringify(data, null, 2)));
