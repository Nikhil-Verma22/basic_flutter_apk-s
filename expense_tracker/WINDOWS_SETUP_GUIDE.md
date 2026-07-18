# Flutter Windows Development Setup Guide

## Prerequisites

### 1. Enable Windows Developer Mode

**IMPORTANT:** This is required to run Flutter apps on Windows!

#### Steps:
1. Open Windows Settings (or run `start ms-settings:developers` in terminal)
2. Go to: **Privacy & Security** → **For developers**
3. Turn on **Developer Mode**
4. Click "Yes" when prompted
5. Wait for the Developer Mode package to install
6. **Restart your computer** (recommended)

#### Why is this needed?
Developer Mode enables symlink support, which Flutter requires for Windows development.

---

## Running Your Flutter App on Windows

### Method 1: Using the Batch Scripts (Easiest)

I've created two helper scripts for you:

#### A. Run in Development Mode (with Hot Reload)
```bash
run_windows.bat
```
- Double-click `run_windows.bat` in your project folder
- The app will open in a window
- You can make code changes and press `r` in the terminal for hot reload
- Press `q` to quit

#### B. Build Release Version
```bash
build_windows.bat
```
- Double-click `build_windows.bat` in your project folder
- Creates a standalone .exe file
- Location: `build\windows\x64\runner\Release\expense_tracker.exe`
- You can share this .exe with others!

---

### Method 2: Using Flutter Commands Directly

#### Run in Development Mode:
```bash
flutter run -d windows
```

#### Build Release Version:
```bash
flutter build windows --release
```

#### Run Release Build:
```bash
.\build\windows\x64\runner\Release\expense_tracker.exe
```

---

## Troubleshooting

### Error: "Building with plugins requires symlink support"
**Solution:** Enable Developer Mode (see steps above)

### Error: "No devices found"
**Solution:** 
```bash
flutter devices
```
Make sure "Windows (desktop)" appears in the list

### App won't start
**Solution:**
1. Clean the build:
   ```bash
   flutter clean
   flutter pub get
   ```
2. Try building again

---

## Advantages of Windows Development

✅ **Instant Testing** - No need to build APK every time
✅ **Hot Reload** - See changes instantly (press `r` in terminal)
✅ **Hot Restart** - Full app restart (press `R` in terminal)
✅ **Debugging** - Use breakpoints and inspect variables
✅ **Faster Development** - Much quicker than building APKs
✅ **Same Codebase** - Code works on Windows, Android, iOS, Web, etc.

---

## Quick Reference Commands

| Command | Description |
|---------|-------------|
| `flutter run -d windows` | Run app on Windows |
| `flutter build windows` | Build Windows app |
| `flutter clean` | Clean build files |
| `flutter pub get` | Get dependencies |
| `flutter devices` | List available devices |
| `r` (in running app) | Hot reload |
| `R` (in running app) | Hot restart |
| `q` (in running app) | Quit app |

---

## For Future Projects

Once Developer Mode is enabled, you can run ANY Flutter project on Windows:

1. Navigate to your Flutter project folder
2. Run: `flutter run -d windows`
3. That's it! 🎉

No need to enable Developer Mode again - it stays enabled permanently.

---

## Building for Other Platforms

### Android APK:
```bash
flutter build apk --release
```

### Android App Bundle (for Play Store):
```bash
flutter build appbundle --release
```

### Web:
```bash
flutter build web
```

### iOS (requires Mac):
```bash
flutter build ios --release
```

---

## Tips for Efficient Development

1. **Use Windows for development** - Fastest way to test
2. **Build APK only when needed** - For testing on actual Android devices
3. **Use Hot Reload** - Press `r` to see changes instantly
4. **Keep terminal open** - See debug messages and errors
5. **Use VS Code/Android Studio** - Better debugging experience

---

## Need Help?

If you encounter any issues:
1. Check if Developer Mode is enabled
2. Run `flutter doctor` to check your setup
3. Try `flutter clean` and rebuild
4. Restart your computer if needed

Happy coding! 🚀
