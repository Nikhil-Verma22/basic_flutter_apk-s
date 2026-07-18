# 🏃 Pulse Tracker — Step Count & Health Monitor

A lightweight, step-counting health app built with Flutter. Pulse Tracker uses the device's hardware **pedometer sensor** to count your steps in real time, calculates calories burned and active minutes, tracks hydration, and visualizes weekly progress — all wrapped in a stunning glassmorphism dark UI.

---

## Overview

Pulse Tracker is a simple but complete health monitoring app driven entirely by step data. It avoids complex biometric sensors and instead derives calories burned, active minutes, and progress towards goals directly from the step count, making it accessible on any Android device. Data is stored locally in SQLite and persists across sessions.

---

## Features

### 🧭 Onboarding
- First-launch screen collects **height (cm)** and **weight (kg)**
- Requests **Activity Recognition** permission (required for the pedometer on Android)
- Requests **Notification** permission for hydration reminders
- Saves the user profile and transitions to the dashboard — never shown again after completion

### 🏠 Home Dashboard
The main dashboard is divided into two sections:

**Today's Summary Card (glass panel)**
- Dynamic heading: *"Excellent"* when step goal is met, *"Good Progress"* otherwise
- Three animated **progress bars**:
  - 🟢 **Steps** — current steps vs. daily goal
  - 🟠 **Calories** — kcal burned (calculated as `steps × weight × 0.0005`)
  - 🟡 **Active Minutes** — estimated from steps (100 steps ≈ 1 minute)

**Quick Stats Grid (2 columns)**
- 💧 **Hydration** — total water intake in liters; tap to **add 250ml** manually
- 🔥 **Calories** — same calorie value, shown as a standalone tile

### 📈 Stats Overview (Weekly History)
- Accessed via the "Stats" tab in the bottom navigation
- **Weekly Steps Bar Chart** — day-by-day step count for the last 7 days (Mon–Sun labels)
- **Weekly Hydration Bar Chart** — water intake per day in ml for the last 7 days
- Both charts rendered with `fl_chart`, styled with the app's primary colors

### 🎯 Set Goals Screen
- Accessed via the "Goals" tab
- Set your **Daily Steps Goal** (default: 6,000 steps)
- Set your **Daily Water Goal** in ml (default: 2,500 ml)
- Goals are saved to `SharedPreferences` and immediately reflected on the dashboard

### ⚙️ Settings Screen
- Accessed via the settings icon in the app bar
- **Hydration Reminders** — schedule local push notifications every 2 hours between 8 AM and 10 PM, reminding the user to drink water
- Toggle to enable/disable the reminder schedule

### 🦶 Live Pedometer Integration
- Subscribes to the device's **step count sensor stream** (`pedometer` package)
- Calculates delta steps from the session's start value to avoid counting previous sessions
- Step data is written to a local SQLite database daily, keyed by date string (`yyyy-MM-dd`)
- On app restart, loads today's previously stored steps so the count is never reset mid-day

### 🔔 Hydration Notifications
- Scheduled using `flutter_local_notifications` with `timezone` support
- Up to 7 notifications scheduled per day (every 2 hours, 8 AM–10 PM)
- Notification channel: **Hydration Reminders**
- All existing reminders are cancelled and rescheduled when the user activates the feature

### 🎨 UI & Design
- **Glassmorphism** design language — frosted glass panels with `BackdropFilter` blur
- Blurred color blobs in the background for ambient depth
- Blurred app bar with translucent background
- **Gradient app title** using `ShaderMask` (green-to-teal gradient)
- Pill-shaped glassmorphism **floating bottom navigation bar**

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| State Management | Riverpod (`flutter_riverpod`) |
| Step Counting | `pedometer` |
| Local Database | SQLite (`sqflite`) — raw helper |
| Notifications | `flutter_local_notifications` + `timezone` |
| Permissions | `permission_handler` |
| Charts | `fl_chart` |
| Persistent Storage | `shared_preferences` |
| Typography | Google Fonts |
| Date Formatting | `intl` + `timeago` |

---

## Project Structure

```
lib/
├── main.dart                              # Entry point, SharedPreferences init, notification init
├── core/
│   ├── database/
│   │   └── database_helper.dart           # SQLite helper (daily steps + water storage)
│   ├── services/
│   │   └── notification_service.dart      # Hydration notification scheduling
│   └── theme/
│       └── app_theme.dart                 # Dark glassmorphism theme
├── providers/
│   ├── activity_provider.dart             # Live pedometer + water state
│   └── goals_provider.dart                # User profile + goal persistence (Riverpod)
└── ui/
    ├── screens/
    │   ├── onboarding_screen.dart          # First-launch profile + permission setup
    │   ├── home_dashboard.dart             # Main step/calorie/water dashboard
    │   ├── stats_overview.dart             # Weekly bar charts
    │   ├── set_goals_screen.dart           # Steps & water goal editor
    │   └── settings_screen.dart           # Notification toggle
    └── widgets/
        └── glass_container.dart            # Reusable glassmorphism card
```

---

## Setup & Running

```bash
# Install dependencies
flutter pub get

# Run on a connected Android device
flutter run
```

> **Permissions Required:**
> - `ACTIVITY_RECOGNITION` — for the pedometer sensor
> - `POST_NOTIFICATIONS` — for hydration reminder notifications
>
> Both are requested during the onboarding flow.

---

## Platform Support

| Platform | Status |
|---|---|
| Android | ✅ Supported |
| iOS | ⚠️ Pedometer may work; not fully tested |
| Web / Desktop | ❌ Not supported (pedometer sensor is mobile-only) |
