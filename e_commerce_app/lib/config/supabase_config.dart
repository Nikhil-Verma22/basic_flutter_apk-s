/// ───────────────────────────────────────────────────────────
/// SUPABASE CONFIGURATION
///
/// 🔴 PLACEHOLDER #1 and #2 are in this file.
/// Fill them in to connect to your Supabase backend.
/// If left as-is, the app runs with built-in mock data.
/// ───────────────────────────────────────────────────────────

class SupabaseConfig {
  // ══════════════════════════════════════════════════════════
  // 🔴 PLACEHOLDER #1: YOUR SUPABASE PROJECT URL
  //
  // Where to find it:
  //   Supabase Dashboard → Your Project → Settings → API
  //   → "Project URL" field
  //
  // Example value:
  //   'https://abcdefghijklmnopqrstuvwxyz.supabase.co'
  // ══════════════════════════════════════════════════════════
  static const String supabaseUrl = 'https://dfdojjaywrpvgspchtzi.supabase.co';

  // ══════════════════════════════════════════════════════════
  // 🔴 PLACEHOLDER #2: YOUR SUPABASE ANON (PUBLIC) KEY
  //
  // Where to find it:
  //   Supabase Dashboard → Your Project → Settings → API
  //   → "Project API keys" → "anon public" key
  //
  // Example value:
  //   'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBh...'
  // ══════════════════════════════════════════════════════════
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRmZG9qamF5d3JwdmdzcGNodHppIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU3ODk0OTQsImV4cCI6MjA5MTM2NTQ5NH0.kW0DYnAxDrsKdChkdD0iz5xyyZd3uKCSbvVD1TWRBoA';

  // ══════════════════════════════════════════════════════════
  // 🔴 PLACEHOLDER #3: YOUR TABLE NAMES
  //
  // Change these if your Supabase tables have different names.
  // The SQL schema to create these tables is below.
  // ══════════════════════════════════════════════════════════
  static const String productsTable = 'products';
  static const String categoriesTable = 'categories';

  // ───────────────────────────────────────────────────────────
  // REQUIRED SQL SCHEMA — Run this in Supabase SQL Editor
  // ───────────────────────────────────────────────────────────
  //
  // CREATE TABLE categories (
  //   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  //   name TEXT NOT NULL,
  //   slug TEXT UNIQUE NOT NULL,
  //   created_at TIMESTAMPTZ DEFAULT NOW()
  // );
  //
  // INSERT INTO categories (name, slug) VALUES
  //   ('Plants', 'plants'),
  //   ('Vessels', 'vessels'),
  //   ('Accessories', 'accessories');
  //
  // CREATE TABLE products (
  //   id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  //   name TEXT NOT NULL,
  //   description TEXT,
  //   price DECIMAL(10,2) NOT NULL,
  //   image_url TEXT,
  //   category TEXT,
  //   variant TEXT,
  //   is_featured BOOLEAN DEFAULT false,
  //   artisan_name TEXT,
  //   artisan_avatar TEXT,
  //   artisan_process TEXT,
  //   created_at TIMESTAMPTZ DEFAULT NOW()
  // );
  //
  // -- Allow public read access (adjust RLS as needed)
  // ALTER TABLE products ENABLE ROW LEVEL SECURITY;
  // ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
  //
  // CREATE POLICY "Public read products" ON products
  //   FOR SELECT USING (true);
  //
  // CREATE POLICY "Public read categories" ON categories
  //   FOR SELECT USING (true);
  //
  // ───────────────────────────────────────────────────────────
}
