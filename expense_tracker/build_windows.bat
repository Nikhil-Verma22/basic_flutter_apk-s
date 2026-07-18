@echo off
echo ========================================
echo Flutter Windows Builder
echo ========================================
echo.
echo This script will build your Flutter app for Windows
echo.
pause

echo.
echo Building Flutter app for Windows (Release)...
echo.
flutter build windows --release

echo.
echo ========================================
echo Build Complete!
echo ========================================
echo.
echo Your app is located at:
echo build\windows\x64\runner\Release\expense_tracker.exe
echo.
echo You can run it by double-clicking the .exe file
echo.
pause
