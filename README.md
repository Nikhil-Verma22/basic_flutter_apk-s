# 📱 Flutter App Collection

A collection of five fully-featured Flutter applications, each built as a standalone project demonstrating different use cases, UI patterns, state management strategies, and third-party integrations. All apps are written in Dart using the Flutter framework.

---

## Projects

| # | App | Description | Key Tech |
|---|-----|-------------|----------|
| 1 | [🎵 Beats](#-beats--music-player) | Local music player with background playback | `just_audio`, Riverpod |
| 2 | [🤖 DeepSite](#-deepsite--ai-chatbot) | Real-time AI chatbot powered by Gemini | `google_generative_ai`, Provider |
| 3 | [🛍️ Apni Dukan](#️-apni-dukan--e-commerce-app) | Artisan-themed e-commerce marketplace | Supabase, Provider |
| 4 | [💸 Expense Tracker](#-expense-tracker) | Personal finance journal with analytics | Floor ORM, SQLite, `fl_chart` |
| 5 | [🏃 Health Tracker](#-health-tracker--health-monitor) | Step counter & health tracker | Pedometer, Riverpod, SQLite |

---

## 🎵 Beats — Music Player

> **Location:** `beats_music_player/`

A sleek, dark-themed local music player that reads audio files directly from your Android device's storage. It features a full-screen player, a persistent mini player, custom albums, favorites, and real-time search — all with background playback via Android media notifications.

**Highlights:**
- Scans device storage for all audio files using `on_audio_query`
- Full-screen player with album art, seek bar, shuffle, loop, and play controls
- Persistent pill-shaped mini player with inline controls
- Custom album creation and device album browsing
- Favorites system persisted with `SharedPreferences`
- Background playback with Android media notification (`just_audio_background`)

**Tech:** Flutter · Riverpod · `just_audio` · `on_audio_query` · `shared_preferences` · Google Fonts (Inter)

📄 [Read the Beats README](beats_music_player/README.md)

---

## 🤖 DeepSite — AI Chatbot

> **Location:** `deep_site_chatbot/`

A futuristic AI chat interface powered by Google's **Gemini** API. AI responses stream token-by-token in real time and are rendered as rich Markdown — including styled code blocks. The UI features a cyberpunk aesthetic with glassmorphism panels and glowing cyan accents.

**Highlights:**
- Real-time streaming responses from Gemini with a live cursor indicator
- Full Markdown rendering for AI replies (bold, code, lists, headers)
- Stop-stream button to interrupt a response at any time
- Differentiated user vs. AI message bubbles with distinct gradient styling
- Glassmorphism app bar and input panel with backdrop blur

**Tech:** Flutter · Provider · `google_generative_ai` · `flutter_markdown` · Google Fonts (Space Grotesk, Manrope)

📄 [Read the DeepSite README](deep_site_chatbot/README.md)

---

## 🛍️ Apni Dukan — E-Commerce App

> **Location:** `e_commerce_app/`

A premium artisan-themed e-commerce app ("Apni Dukan" = "Your Store") that fetches products from a **Supabase** backend and presents them in a curated browsing experience. Features include live product search, category filtering, a detailed product view with artisan information, and a full shopping cart with quantity management.

**Highlights:**
- Live search + multi-category filter chips on the product grid
- Product detail screen with artisan name, avatar, and craft process description
- Shopping cart with quantity controls, item removal, order summary, and a checkout button
- Animated cart item cards with hover and press states
- Floating pill-shaped navigation bar persistent across all screens
- Auto-fallback to built-in mock data when Supabase is not configured

**Tech:** Flutter · Provider · Supabase · `cached_network_image` · Google Fonts (Plus Jakarta Sans)

📄 [Read the Apni Dukan README](e_commerce_app/README.md)

---

## 💸 Expense Tracker

> **Location:** `expense_tracker/`

A comprehensive personal finance journal that lets you log expenses, organize them by custom categories, and analyze spending with pie charts and category breakdowns. It stores all data locally using the **Floor ORM** on top of SQLite and runs on Android, iOS, Web, and Desktop.

**Highlights:**
- Log expenses with description, amount, category, and date
- Time-range filters: Today, Weekly, Monthly, Yearly, All, or a custom date
- Pie chart (via `fl_chart`) showing category spending proportions on the Insights screen
- Sortable category totals (high to low / low to high)
- Create and delete custom categories with a name, icon, and color
- Daily spending limit with a color-coded bell indicator (green → orange → red)
- Light and dark theme following the system setting

**Tech:** Flutter · Provider · Floor ORM · SQLite · `fl_chart` · `shared_preferences` · Google Fonts

📄 [Read the Expense Tracker README](expense_tracker/README.md)

---

## 🏃 Health Tracker — Health Monitor

> **Location:** `health_tracker/`

A step-counting health app that uses the device's hardware **pedometer sensor** to track daily steps, estimates calories burned and active minutes, and logs hydration. Weekly history is displayed as bar charts, and scheduled local notifications remind the user to drink water throughout the day.

**Highlights:**
- Real-time step counting using the device pedometer sensor (`pedometer`)
- Calorie and active minutes estimation derived from steps and user weight
- Manual hydration logging (tap to add 250 ml per tap)
- Weekly step and hydration bar charts
- Configurable daily step and water goals persisted via `SharedPreferences`
- Scheduled hydration push notifications every 2 hours (8 AM–10 PM)
- Onboarding screen to collect height, weight, and grant permissions
- Full glassmorphism dark UI with backdrop blur panels and floating glass nav bar

**Tech:** Flutter · Riverpod · `pedometer` · SQLite · `flutter_local_notifications` · `fl_chart` · Google Fonts

📄 [Read the Health Tracker README](health_tracker/README.md)

---

## Getting Started

Each project is a fully independent Flutter application. To run any of them:

```bash
# Navigate into the project folder
cd beats_music_player   # or deep_site_chatbot / e_commerce_app / expense_tracker / health_tracker

# Install dependencies
flutter pub get

# Run on a connected device or emulator
flutter run
```

> Refer to each project's individual README for specific setup steps, API key configuration, and platform notes.

---

## Tech Stack Overview

| Technology | Used In |
|---|---|
| Flutter + Dart | All projects |
| Riverpod | Beats, Health Tracker |
| Provider | DeepSite, Apni Dukan, Expense Tracker |
| SQLite (Floor ORM) | Expense Tracker |
| SQLite (raw helper) | Health Tracker |
| Supabase | Apni Dukan |
| Google Gemini API | DeepSite |
| Pedometer Sensor | Health Tracker |
| `fl_chart` | Expense Tracker, Health Tracker |
| `just_audio` | Beats |
| `flutter_markdown` | DeepSite |
| `cached_network_image` | Apni Dukan |
| `shared_preferences` | Beats, Health Tracker, Expense Tracker |

---

## Repository Structure

```
.
├── beats_music_player/      # 🎵 Local music player
├── deep_site_chatbot/       # 🤖 Gemini AI chatbot
├── e_commerce_app/          # 🛍️ E-commerce marketplace
├── expense_tracker/         # 💸 Personal finance journal
└── health_tracker/          # 🏃 Step counter & health tracker
```
