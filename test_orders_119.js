const fs = require('fs');
const key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUyMTEzNSwiZXhwIjoyMDgyMDk3MTM1fQ.Q_3he0tcb0w2-YbsLWnC1jFqafrxJVGmRc4mWXOW4tQ";

fetch(`https://hwgmjlsoeebgounmthmr.supabase.co/rest/v1/orders?id=eq.119&select=id,order_items(service_name,service:services(image_url,duration_minutes,cat:service_categories(image_url)))`, {
  headers: {
    apikey: key,
    Authorization: `Bearer ${key}`
  }
}).then(r => r.json()).then(data => console.log(JSON.stringify(data, null, 2)));
