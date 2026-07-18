@echo off
echo ========================================
echo Flutter Emulator Runner
echo ========================================
echo.
echo Starting Android Emulator...
echo.

start /B flutter emulators --launch Medium_Phone_API_36.0

echo.
echo Waiting for emulator to boot (30 seconds)...
echo.
timeout /t 30 /nobreak

echo.
echo Checking devices...
echo.
flutter devices

echo.
echo ========================================
echo Running your app on emulator...
echo ========================================
echo.
echo TIP: Once running, press 'r' for hot reload!
echo.

flutter run

pause
