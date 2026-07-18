# 🛍️ Apni Dukan — E-Commerce App

A modern, artisan-themed e-commerce Flutter application styled like a premium boutique marketplace. The app fetches products from a **Supabase** backend (with a built-in mock fallback) and lets users browse, filter, view product details, and manage a shopping cart.

---

## Overview

"Apni Dukan" (Your Store) is a beautifully designed e-commerce reference application. It showcases a clean, organic visual language — large pill-shaped images, earthy tonal colors, and Plus Jakarta Sans typography — making it feel like a curated artisan marketplace. The product model supports rich metadata including artisan names, avatars, and hand-crafting process descriptions.

---

## Features

### 🏠 Home — Product Catalogue
- Full-screen product grid with a **2-column layout**
- App title "Apni Dukan." displayed in a large editorial heading
- **Pill-shaped search bar** with live text filtering across product name and description
- **Category filter chips** (All, Clothing, Accessories, Electronics, Wellness, and more from the backend) — animated on selection
- Empty state with icon and helpful message when no results are found
- Smooth scroll-to-top when returning to the search bar

### 🔍 Search & Filter
- Search query updates the product grid in real time
- Combines category filter and text search simultaneously
- Clear button inside the search field to reset the query instantly

### 📦 Product Detail Screen
- Large **rounded image container** (480px tall) with cached network loading
- Product **name** (large heading) and **price** in Indian Rupees (₹) side by side
- **Variant tag** (e.g., "Organic Cotton", "Silver Mesh") as a pill chip
- Full **description** text with generous line height
- **"The Process"** section — artisan craft description in a tonal card (shown if available)
- **Artisan Card** — displays the maker's avatar, name, and role (shown if available)
- **"ADD TO BAG"** button — adds the product to the cart with a floating snackbar confirmation

### 🛒 Cart (Bag)
- Lists all added products with their **thumbnail image**, name, variant, and quantity
- **Quantity controls** (+ / −) with animated hover/press states — item scales up on hover for a tactile feel
- **Remove** link to delete a product from the cart
- **Order Summary** section with:
  - Subtotal
  - Shipping (shown as "Complimentary" when free)
  - Grand Total
- **CHECKOUT** button (UI-ready)
- Empty state with a "Browse Collection" CTA

### 👤 Profile Screen
- Basic profile screen placeholder within the bottom navigation

### 🧭 Floating Navigation Bar
- A shared floating navigation bar (pill-shaped glass design) persists across all screens
- Tabs: **Home**, **Search**, **Bag**, **Profile**
- Active tab highlighted with the primary color

### 🌐 Supabase Backend Integration
- Fetches products from a `products` table in Supabase
- Fetches categories from a `categories` table
- Automatically falls back to **mock product data** (4 demo products) if Supabase is unavailable or not configured
- Images served over HTTPS (HTTP URLs are automatically upgraded)

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| Backend | Supabase (`supabase_flutter`) |
| State Management | Provider (`provider`) |
| Image Caching | `cached_network_image` |
| Typography | Google Fonts — Plus Jakarta Sans |
| Localization / Formatting | `intl` |

---

## Project Structure

```
lib/
├── main.dart                        # App entry point, Supabase init
├── config/
│   └── supabase_config.dart         # Supabase URL and anon key
├── models/
│   ├── product.dart                 # Product data model (with artisan fields)
│   └── cart_item.dart               # Cart item wrapper
├── providers/
│   └── cart_provider.dart           # Cart state (add, remove, update qty)
├── screens/
│   ├── home_screen.dart             # Product grid + search + filter
│   ├── product_detail_screen.dart   # Full product view + add to cart
│   ├── cart_screen.dart             # Cart items, order summary, checkout
│   └── profile_screen.dart          # Profile placeholder
├── services/
│   └── supabase_service.dart        # Supabase queries + mock fallback
├── utils/
│   └── keys.dart                    # Global keys for navigation
└── widgets/
    ├── product_card.dart             # Product grid card widget
    └── shared_nav_bar.dart           # Floating bottom navigation bar
```

---

## Setup & Configuration

### 1. Create a Supabase Project
Visit [supabase.com](https://supabase.com), create a project, and create two tables: `products` and `categories`.

### 2. Add Your Supabase Credentials
Open `lib/config/supabase_config.dart` and fill in your project URL and anon key.

> If no Supabase credentials are provided, the app will automatically use the built-in mock product data.

### 3. Install Dependencies & Run

```bash
flutter pub get
flutter run
```

---

## Platform Support

| Platform | Status |
|---|---|
| Android | ✅ Supported |
| Web | ✅ Supported |
| Windows | ✅ Supported |
| iOS | ⚠️ Not tested |
