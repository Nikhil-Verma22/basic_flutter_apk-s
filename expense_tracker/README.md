# 💸 Expense Tracker — Personal Finance Journal

A beautifully designed personal expense tracking app built with Flutter. It helps you log daily spending, organize expenses by category, monitor spending with visual analytics, and stay within a configurable daily budget limit. Data is stored locally using a SQLite database (via the Floor ORM).

---

## Overview

Expense Tracker is a full-featured, offline-first finance journal. It supports multiple time-range filters, category-based breakdowns, a pie chart on the insights page, and a color-coded daily limit indicator — all styled with a sleek dark/light adaptive theme.

---

## Features

### 📋 Feed — Expense Journal
- Displays all logged expenses for the currently selected time range in a scrollable list
- Each entry shows: **description**, **amount**, **category icon & color**, and **date**
- **Sort Order Toggle** — switch between ascending and descending date order instantly
- **Category Filter** — filter the list to show only a specific category's expenses
- Total spending for the active filter period shown as a summary card at the top
- **Floating Action Button (+)** to quickly add a new expense via a bottom sheet

### ➕ Add Expense (Bottom Sheet)
- Slide-up modal for fast entry without leaving the current view
- Fields:
  - **Description** — free text (e.g., "Cinema tickets")
  - **Amount** — numeric input in Indian Rupees (₹)
  - **Category** — horizontal scroll of icon tiles; tap to select
  - **Date** — tap to open the date picker (defaults to today)
- Validation ensures all fields are filled before saving

### 📊 Insights (Statistics Screen)
- **Pie chart** showing spending proportions per category (uses `fl_chart`)
- Each slice colored with the category's custom color
- Percentage labels on each slice
- **Category breakdown list** with sortable totals (toggle between high-to-low and low-to-high)
- **Custom date picker** — filter the chart to a specific day's data

### 👤 Profile Screen
- Shows user's total spending **all time**
- Total **number of expense entries** logged
- **Number of categories** in use
- Quick buttons to:
  - Manage categories (opens the category manager)
  - Export data (UI placeholder)

### 🗂️ Category Manager
- View all existing categories with their icon and color
- **Add new categories** — set a name, pick an icon from a predefined set, and choose a color swatch
- **Delete categories** — with a safety check: if a category has expenses linked to it, deletion is blocked with a warning dialog

### ⏱️ Time-Range Filters
The following filters are available from the home screen filter chips:
| Filter | Description |
|---|---|
| Today | Expenses logged today |
| Weekly | Current calendar week (Mon–Sun) |
| Monthly | Current calendar month |
| Yearly | Current calendar year |
| All | All time |
| Custom | A specific day chosen via the date picker |

### 🔔 Daily Spending Limit
- Set a **daily spending limit** via the bell icon in the app bar
- The bell icon changes **color** based on today's spending ratio:
  - 🟢 **Green** — below 40% of limit
  - 🟠 **Orange** — between 40% and 95%
  - 🔴 **Red** — at or above limit (limit exceeded)
- Limit value is persisted using **SharedPreferences**

### 🌙 Light & Dark Theme
- Automatically follows the **system theme** (light or dark)
- Fully themed using Material 3 color schemes

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| Database ORM | Floor (`floor` + `floor_generator`) |
| Database Engine | SQLite (`sqflite`) + FFI for desktop/web |
| State Management | Provider (`provider`) |
| Charts | `fl_chart` (Pie chart) |
| Local Storage | `shared_preferences` (daily limit) |
| Typography | Google Fonts |
| Date Formatting | `intl` |

---

## Project Structure

```
lib/
├── main.dart                          # App entry, database init per platform
├── theme.dart                         # Light + Dark theme definitions
├── database/
│   ├── app_database.dart              # Floor database configuration
│   ├── app_database.g.dart            # Generated Floor code
│   ├── dao/
│   │   ├── expense_dao.dart           # Expense CRUD queries
│   │   └── category_dao.dart          # Category CRUD queries
│   └── entity/
│       ├── expense.dart               # Expense entity (Floor table)
│       └── category.dart              # Category entity (Floor table)
├── providers/
│   └── expense_provider.dart          # All state, filters, sorting, limit logic
└── screens/
    ├── home_screen.dart               # Feed + bottom nav + daily limit dialog
    ├── add_expense_screen.dart        # Add expense bottom sheet
    ├── statistics_screen.dart         # Pie chart + category insights
    ├── manage_categories_screen.dart  # CRUD for categories
    └── profile_screen.dart            # User stats and settings
```

---

## Setup & Running

```bash
# Install dependencies
flutter pub get

# Run on Android / iOS
flutter run

# Run on Windows
flutter run -d windows

# Run on Web
flutter run -d chrome
```

> **Database note:** The app uses `sqflite` for Android/iOS and `sqflite_common_ffi` for Windows/Linux/macOS, with `sqflite_common_ffi_web` for browser.

---

## Platform Support

| Platform | Status |
|---|---|
| Android | ✅ Supported |
| iOS | ✅ Supported |
| Web | ✅ Supported |
| Windows | ✅ Supported |
| Linux / macOS | ✅ Supported |
