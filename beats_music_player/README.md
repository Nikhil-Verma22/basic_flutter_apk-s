# 🎵 Beats — Local Music Player

A sleek, dark-themed music player for Android that reads and plays audio directly from your device's local storage. Built with Flutter and powered by the `just_audio` engine, Beats delivers a clean and distraction-free listening experience.

---

## Overview

Beats is a fully offline music player. It scans your device for audio files, organizes them by album, and gives you complete control over playback — all wrapped in a premium dark UI with pink/rose accent colors.

---

## Features

### 🏠 Home — All Songs
- Automatically queries all audio files from your device's **external storage**
- Displays song **title**, **artist name**, and **album artwork**
- Highlights the **currently playing track** in the list
- Tap any song to begin playback and open the full player
- Add songs to **custom albums** directly from the song list via a bottom sheet

### 🔍 Search
- Real-time search across song **title** and **artist name**
- Filtered results start playing in queue order (not the full library)
- Clear button to instantly reset the search query

### 📚 Library (Albums)
- **Device Albums** — Grid view of all system albums pulled from the device, with cover art
- **Custom Albums** — User-created playlists shown in a horizontal scroll strip
- Create a new custom album via the **"+" button** in the app bar (named collections like "Workout", "Romance", etc.)
- Tap any album to open a dedicated song list screen

### ❤️ Favorites
- Mark/unmark any song as a favorite directly from the **full player screen**
- Dedicated Favorites tab displays all liked songs
- Tap a favorite song to play it within the favorites queue

### 🎵 Full Player Screen
- Large **album artwork** display with deep shadow
- Song title and artist displayed below artwork
- **Seek bar** — drag to jump to any position; timestamps shown on both ends
- **Play / Pause** button with gradient circular design
- **Skip Previous / Skip Next** controls
- **Shuffle** toggle — randomizes playback order
- **Loop** toggle — cycles between Off → Loop All → Loop One
- **Favorite** toggle button in the app bar

### 🎛️ Mini Player
- A persistent **pill-shaped mini player** that appears above the bottom navigation bar whenever a song is playing
- Displays current song title, artist, and artwork
- Inline **Play/Pause** and **Skip Next** buttons
- Tap the mini player to open the full player screen

### 🔔 Background Playback & Notifications
- Playback continues in the background when the app is minimized
- Android **media notification** shows song info with playback controls (Play, Pause, Skip)
- Uses `just_audio_background` for seamless OS-level integration

### 💾 Persistent State
- Favorites are saved using **SharedPreferences** and persist across app restarts
- Custom album data (names and song IDs) is also persisted locally

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| State Management | Riverpod (`flutter_riverpod`) |
| Audio Engine | `just_audio` + `just_audio_background` |
| Device Audio Query | `on_audio_query` |
| Permissions | `permission_handler` |
| Local Storage | `shared_preferences` |
| Typography | Google Fonts — Inter |

---

## Project Structure

```
lib/
├── main.dart                    # App entry point, background audio init
├── theme.dart                   # Dark theme definition (colors, typography)
├── providers/
│   ├── audio_provider.dart      # Playback engine, shuffle, loop, skip logic
│   ├── favorites_provider.dart  # Favorites persistence
│   └── playlists_provider.dart  # Custom album CRUD logic
├── screens/
│   ├── main_tab_screen.dart     # Bottom nav controller + mini player host
│   ├── home_screen.dart         # All songs list
│   ├── search_screen.dart       # Search with live filtering
│   ├── albums_screen.dart       # Device + custom albums
│   ├── album_songs_screen.dart  # Songs inside a specific album
│   ├── favorites_screen.dart    # Favorited songs list
│   └── music_player_screen.dart # Full-screen player UI
└── widgets/
    ├── mini_player.dart         # Persistent pill-shaped mini player
    └── glass_container.dart     # Glassmorphism container widget
```

---

## Setup & Running

```bash
# Install dependencies
flutter pub get

# Run on a connected Android device
flutter run
```

> **Note:** The app requires **Audio** and **Storage** permissions on Android to scan local music files. Grant these when prompted on first launch.

---

## Platform Support

| Platform | Status |
|---|---|
| Android | ✅ Supported |
| iOS | ⚠️ Not tested |
| Web / Desktop | ❌ Not supported (local audio query is Android-only) |
