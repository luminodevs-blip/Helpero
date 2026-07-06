const fs = require('fs');
const env = fs.readFileSync('.env.local', 'utf8');
const key = env.match(/NEXT_PUBLIC_SUPABASE_ANON_KEY=(.*)/)[1];

fetch(`https://hwgmjlsoeebgounmthmr.supabase.co/rest/v1/?apikey=${key}`)
  .then(r => r.json())
  .then(data => {
    fs.writeFileSync('openapi.json', JSON.stringify(data, null, 2));
    console.log("Written openapi.json");
  });
