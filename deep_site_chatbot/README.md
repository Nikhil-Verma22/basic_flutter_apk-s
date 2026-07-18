# 🤖 DeepSite — AI Chatbot powered by Gemini

A futuristic, real-time AI chat application built with Flutter, using Google's **Gemini API** as its intelligence backend. DeepSite features streaming responses, full Markdown rendering, and a cyberpunk-inspired dark UI.

---

## Overview

DeepSite is a conversational AI interface that connects directly to the **Gemini** generative AI model. Messages stream token-by-token in real time, giving the feeling of the AI "thinking out loud." The UI is designed with a deep dark background and glowing cyan/blue accents for a premium futuristic aesthetic.

---

## Features

### 💬 Real-Time Streaming Chat
- Messages from the AI are delivered **token-by-token** as they are generated — no waiting for the full response
- The streaming text animates into the bubble with a **blinking cursor** (`█`) while active
- The send button dynamically changes to a **Stop** button during generation, allowing the user to interrupt the stream at any point
- Interrupted messages are saved as-is to the conversation history

### 📝 Full Markdown Rendering
- AI responses are rendered using **`flutter_markdown`**, supporting:
  - **Bold** and *italic* text
  - Inline `code` and fenced code blocks with syntax-aware styling
  - Bullet and numbered lists
  - Block quotes and headers
- Code blocks appear with a near-black background, a subtle border, and **cyan-colored text** for excellent readability

### 🗨️ Chat History
- All completed messages (both user and AI) are stored in an in-memory list
- The list is **reverse-scrolled** so the newest message is always at the bottom of the screen
- A welcome screen ("How can I help you today?") is shown when the history is empty

### 🖌️ Differentiated Message Bubbles
- **User messages** — Gradient cyan-to-blue pill bubble, bold black text, displayed on the right
- **AI messages** — Dark container (`#1E1E1E`) with a left-side cyan accent border, displayed on the left
- Each bubble is headed with a label: **"YOU"** or **"AI WRITER"** with a corresponding icon

### 📐 Adaptive Input Area
- Multi-line expandable text field (up to 5 lines)
- Glassmorphism-styled input panel with a **blur backdrop filter**
- Submit on the **Enter** key or via the send button
- A microphone icon placeholder is included in the text field

### 🎨 Futuristic UI Design
- Pure black (`#0D0D0D`) background with subtle depth
- **Glassmorphism app bar** using `BackdropFilter` blur
- App title "DEEPSITE" rendered with a **cyan gradient ShaderMask**
- Animated send button with a cyan glow (`boxShadow`) effect

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| AI Backend | Google Gemini API (`google_generative_ai`) |
| State Management | Provider (`provider`) |
| Markdown Rendering | `flutter_markdown` |
| Typography | Google Fonts — Space Grotesk, Manrope |

---

## Project Structure

```
lib/
├── main.dart                    # App entry point, Provider setup
├── models/
│   └── chat_message.dart        # Data model for a single message
├── providers/
│   └── chat_provider.dart       # Chat state, streaming logic, stop support
├── screens/
│   └── chat_screen.dart         # Main chat UI (input, message list, app bar)
├── services/
│   └── gemini_service.dart      # Gemini API client (model init, stream method)
└── widgets/
    └── message_bubble.dart      # User and AI message bubble renderer
```

---

## Setup & Configuration

### 1. Get a Gemini API Key
Visit [Google AI Studio](https://aistudio.google.com/) and create an API key.

### 2. Add Your API Key
Open `lib/services/gemini_service.dart` and replace the placeholder:

```dart
static const String _apiKey = 'YOUR_GEMINI_API_KEY_HERE';
```

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
| iOS | ✅ Supported |
| Web | ✅ Supported |
| Windows | ✅ Supported |
| Linux / macOS | ✅ Supported |
