# PinSnap - Setup dan Instalasi Guide

## Prasyarat

Sebelum memulai, pastikan Anda telah menginstal:

1. **Flutter SDK** (versi 3.9.2 atau lebih baru)

   - Download dari: https://flutter.dev/docs/get-started/install

2. **Android Studio** atau **Visual Studio Code**

   - Android Studio recommended untuk development Android

3. **Java Development Kit (JDK)** 11 atau lebih baru

   - Diperlukan untuk build Android

4. **Xcode** (untuk iOS development - macOS only)
   - Install dari App Store

## Langkah-Langkah Instalasi

### 1. Clone atau Ekstrak Project

```bash
cd c:\apk_mobile\flutter_application_1
```

### 2. Update Flutter

```bash
flutter upgrade
```

### 3. Install Dependencies

```bash
flutter pub get
```

Ini akan mendownload semua package yang diperlukan termasuk:

- camera
- geolocator
- google_maps_flutter
- sqflite
- intl
- url_launcher

### 4. Setup Android

#### Option A: Menggunakan Android Studio

1. Buka Android Studio
2. File → Open → Pilih folder `android`
3. Tunggu gradle sync selesai
4. Jalankan `Gradle → Tasks → build → assembleDebug`

#### Option B: Menggunakan Command Line

```bash
cd android
./gradlew clean
./gradlew build
cd ..
```

### 5. Setup iOS (macOS Only)

```bash
cd ios
pod install
cd ..
```

### 6. Konfigurasi Google Maps API (Optional)

Jika ingin menggunakan Google Maps dengan API Key:

**Android** (android/app/src/main/AndroidManifest.xml):

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY"/>
```

**iOS** (ios/Runner/Info.plist):

```xml
<key>GMSApiKey</key>
<string>YOUR_API_KEY</string>
```

## Menjalankan Aplikasi

### Debug Mode (Development)

```bash
flutter run
```

### Release Mode (Production)

```bash
flutter run --release
```

### Menjalankan dengan Device Spesifik

```bash
# List available devices
flutter devices

# Run di device tertentu
flutter run -d <device_id>
```

## Troubleshooting

### Issue: Gradle Build Failed

**Solution**:

```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Camera Permission Denied

**Android**: Settings → Apps → PinSnap → Permissions → Enable Camera
**iOS**: Settings → PinSnap → Camera → Allow

### Issue: Location Permission Denied

**Android**: Settings → Apps → PinSnap → Permissions → Enable Location
**iOS**: Settings → Privacy → Location Services → Enable

### Issue: Database Error

```bash
# Clear app data
adb shell pm clear com.example.flutter_application_1

# Or uninstall and reinstall
flutter clean
flutter run
```

### Issue: Hot Reload Not Working

```bash
# Restart the app
flutter run --no-fast-start
```

## Build APK (Android)

### Debug APK

```bash
flutter build apk --debug
```

### Release APK

```bash
flutter build apk --release
```

Output file: `build/app/outputs/flutter-apk/app-release.apk`

## Build IPA (iOS)

### Development Build

```bash
flutter build ios --debug
```

### Release Build

```bash
flutter build ios --release
```

## Testing

### Run Tests

```bash
flutter test
```

### Run Specific Test File

```bash
flutter test test/widget_test.dart
```

## Development Commands

### Format Code

```bash
dart format lib/
```

### Analyze Code

```bash
flutter analyze
```

### Check Dependencies

```bash
flutter pub outdated
```

### Update Dependencies

```bash
flutter pub upgrade
```

## Project Structure

```
flutter_application_1/
├── lib/
│   └── main.dart              # Main application code
├── test/
│   └── widget_test.dart       # Widget tests
├── android/                   # Android-specific code
├── ios/                       # iOS-specific code
├── web/                       # Web support
├── linux/                     # Linux support
├── macos/                     # macOS support
├── windows/                   # Windows support
├── pubspec.yaml              # Dependencies & configuration
├── analysis_options.yaml     # Lint rules
└── README.md                 # Documentation
```

## Konfigurasi IDE

### Visual Studio Code

Install extensions:

- Flutter
- Dart
- Material Icon Theme

### Android Studio

1. Plugins → Search "Flutter" → Install
2. Plugins → Search "Dart" → Install
3. Restart Android Studio

## Performance Tips

1. **Use Release Mode** untuk testing performance
2. **Enable Profiler** untuk menganalisis performance
3. **Use DevTools** untuk debugging

## Security Notes

- Ganti username/password default di Login Screen
- Implementasikan proper authentication (Firebase Auth recommended)
- Amankan Google Maps API Key
- Validasi semua input user

## Environment Variables (Optional)

Buat file `.env` di root project:

```
GOOGLE_MAPS_API_KEY=your_api_key_here
```

Lalu load di main.dart:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  // ... rest of code
}
```

## Debugging

### Enable Verbose Logging

```bash
flutter run -v
```

### Debug Specific Widget

```bash
// Di main.dart
debugPrintBeginFrameBanner = true;
debugPrintEndFrameBanner = true;
```

### Using DevTools

```bash
flutter pub global activate devtools
devtools
```

## Deployment Checklist

- [ ] Update app version di pubspec.yaml
- [ ] Update app name di AndroidManifest.xml dan Info.plist
- [ ] Generate app icon
- [ ] Add proper permissions
- [ ] Test semua fitur
- [ ] Build release APK/IPA
- [ ] Sign aplikasi (untuk release)
- [ ] Upload ke Play Store / App Store

## Support & Resources

- **Flutter Documentation**: https://flutter.dev/docs
- **Dart Documentation**: https://dart.dev/guides
- **Stack Overflow**: Tag dengan `flutter`
- **Flutter Community**: https://flutter.dev/community

## Next Steps

1. Test aplikasi di emulator atau device
2. Implementasikan proper authentication
3. Setup cloud database (Firebase recommended)
4. Create app icon dan splash screen
5. Publish ke Play Store dan App Store

---

**Last Updated**: 2026
**Flutter Version**: ^3.9.2
**Dart Version**: ^3.0.0
