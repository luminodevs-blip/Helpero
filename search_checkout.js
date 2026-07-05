const { createClient } = require('@supabase/supabase-js');
const supabaseUrl = 'https://hwgmjlsoeebgounmthmr.supabase.co';
const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh3Z21qbHNvZWViZ291bm10aG1yIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MjExMzUsImV4cCI6MjA4MjA5NzEzNX0.SOn3uvZKOZvy0xmg46oXIhGHiOVpPjRXG7cTfXcqqR4';

const supabase = createClient(supabaseUrl, supabaseAnonKey);

async function run() {
  const { data: cleaningAddons, error } = await supabase
    .from('service_addons')
    .select('*')
    .ilike('name', '%bedroom%');

  if (error) {
    console.error(error);
  } else {
    console.log('Bedroom addons:', cleaningAddons);
  }

  const { data: allAddonsForService1 } = await supabase
    .from('service_addons')
    .select('*')
    .eq('service_id', 1);
  console.log('Addons for Service 1:', allAddonsForService1);
}

run();
