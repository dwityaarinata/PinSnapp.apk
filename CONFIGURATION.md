# PinSnap - Configuration Guide

## Aplikasi Configuration

### 1. Perubahan App Name

Untuk mengubah nama aplikasi dari "flutter_application_1" menjadi "PinSnap":

#### Android Configuration

**File**: `android/app/src/main/AndroidManifest.xml`

```xml
<application
    android:label="PinSnap"
    ...>
```

**File**: `android/app/build.gradle.kts` (atau `android/app/build.gradle`)

```gradle
defaultConfig {
    applicationId = "com.example.pinsnap"
    minSdk = 21
    targetSdk = 34
    versionCode = 1
    versionName = "1.0.0"
}
```

#### iOS Configuration

**File**: `ios/Runner/Info.plist`

```xml
<key>CFBundleDisplayName</key>
<string>PinSnap</string>
<key>CFBundleName</key>
<string>pinsnap</string>
```

#### pubspec.yaml

```yaml
name: pinsnap
description: "Aplikasi Android berbasis kamera dan geolokasi"
version: 1.0.0+1
```

### 2. Permissions Configuration

#### Android Permissions

**File**: `android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS Permissions

**File**: `ios/Runner/Info.plist`

```xml
<key>NSCameraUsageDescription</key>
<string>PinSnap memerlukan akses kamera untuk mengambil foto lokasi.</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>PinSnap memerlukan akses lokasi untuk menyimpan koordinat GPS yang akurat.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>PinSnap memerlukan akses lokasi untuk operasi normal aplikasi.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>PinSnap memerlukan akses library foto untuk menyimpan gambar lokasi.</string>

<key>NSPhotoLibraryAddOnlyUsageDescription</key>
<string>PinSnap memerlukan izin untuk menyimpan foto ke library.</string>
```

### 3. Google Maps Configuration

#### Android

**File**: `android/app/src/main/AndroidManifest.xml`

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE"/>
```

#### iOS

**File**: `ios/Runner/Info.plist`

```xml
<key>GMSApiKey</key>
<string>YOUR_GOOGLE_MAPS_API_KEY_HERE</string>
```

### 4. Database Configuration

Database SQLite akan otomatis dibuat di folder `getDatabasesPath()` dengan nama `pinsnap.db`

#### Database Location

- **Android**: `/data/data/com.example.pinsnap/databases/pinsnap.db`
- **iOS**: `Documents/pinsnap.db`

### 5. Geolocator Configuration

#### Android - build.gradle.kts

```gradle
android {
    compileSdk = 34

    defaultConfig {
        minSdk = 21
        targetSdk = 34
    }
}
```

#### iOS - Podfile

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end
```

### 6. Camera Configuration

Camera diatur dengan konfigurasi berikut di `main.dart`:

```dart
final cameras = await availableCameras();
final firstCamera = cameras.first;

_cameraController = CameraController(
  firstCamera,
  ResolutionPreset.high,  // Kualitas tinggi
);
```

#### Supported Resolution Presets

- `low`: 352×288
- `medium`: 480×360
- `high`: 1920×1080 (default untuk PinSnap)
- `veryHigh`: 2560×1920
- `ultraHigh`: 4096×2160

### 7. Geolocator Configuration

#### Accuracy Settings

```dart
Geolocator.getCurrentPosition(
  desiredAccuracy: LocationAccuracy.high,  // ±5 meter
  // Options: lowest, low, medium, high, best, bestForNavigation
)
```

#### Permission Handling

```dart
// Request permission
final permission = await Geolocator.requestPermission();

// Check permission
final permission = await Geolocator.checkPermission();

// Check service
final serviceEnabled = await Geolocator.isLocationServiceEnabled();
```

### 8. App Styling Configuration

#### Theme Colors

```dart
ThemeData(
  primarySwatch: Colors.deepPurple,
  useMaterial3: true,
)
```

#### Gradient Colors

- **Primary**: Colors.deepPurple[900] = #6A1B9A
- **Secondary**: Colors.deepPurple[600] = #9C27B0
- **Accent**: Colors.cyan[300] = #4DD0E1
- **Text**: Colors.white, Colors.white70, Colors.white54

### 9. Localization Configuration

#### Supported Languages

Saat ini hanya bahasa Indonesia (ID). Untuk menambah bahasa:

1. Buat folder `lib/l10n/`
2. Buat file `app_en.arb` dan `app_id.arb`
3. Update `pubspec.yaml`:

```yaml
flutter:
  generate: true
```

### 10. Build Configuration

#### Debug Build

```gradle
buildTypes {
    debug {
        debuggable true
        minifyEnabled false
    }
}
```

#### Release Build

```gradle
buildTypes {
    release {
        debuggable false
        minifyEnabled true
        shrinkResources true
        signingConfig signingConfigs.release
    }
}
```

### 11. App Icon Configuration

Untuk mengubah icon aplikasi:

#### Android

Ganti icon di folder: `android/app/src/main/res/mipmap-*`

- mipmap-ldpi/ (36x36)
- mipmap-mdpi/ (48x48)
- mipmap-hdpi/ (72x72)
- mipmap-xhdpi/ (96x96)
- mipmap-xxhdpi/ (144x144)
- mipmap-xxxhdpi/ (192x192)

#### iOS

File: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

Ukuran yang diperlukan:

- 20pt (20x20, 40x40, 60x60)
- 29pt (29x29, 58x58, 87x87)
- 40pt (40x40, 80x80, 120x120)
- 60pt (60x60, 120x120, 180x180)
- 1024pt (1024x1024)

### 12. Splash Screen Configuration

#### Android (android/app/src/main/res/values/strings.xml)

```xml
<string name="app_name">PinSnap</string>
```

#### iOS (ios/Runner/Base.lproj/LaunchScreen.storyboard)

Konfigurasi visual splash screen melalui Xcode

### 13. Environment-Specific Configuration

Buat file `.env.development` dan `.env.production`:

```
# .env.development
DATABASE_NAME=pinsnap_dev.db
LOG_LEVEL=DEBUG

# .env.production
DATABASE_NAME=pinsnap.db
LOG_LEVEL=ERROR
```

### 14. Firebase Configuration (Optional)

Untuk mengintegrasikan Firebase:

**File**: `pubspec.yaml`

```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_auth: ^4.14.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.2.0
```

**File**: `lib/main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _initializeDatabase();
  runApp(const PinSnapApp());
}
```

### 15. URL Scheme Configuration (Deep Links)

Untuk mendukung deep linking, tambahkan di `android/app/src/main/AndroidManifest.xml`:

```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="https"
        android:host="pinsnap.app"
        android:pathPrefix="/location/" />
</intent-filter>
```

## Development Workflow

### 1. Setup Development Environment

```bash
flutter doctor -v
flutter config --enable-web  # Optional: untuk web support
flutter config --enable-linux  # Optional: untuk Linux
flutter config --enable-windows  # Optional: untuk Windows
```

### 2. Code Formatting

```bash
# Format satu file
dart format lib/main.dart

# Format semua file
dart format lib/

# Check formatting
dart format --set-exit-if-changed lib/
```

### 3. Code Analysis

```bash
# Analyze dengan semua rules
flutter analyze

# Specific issues
flutter analyze --watch
```

### 4. Testing Configuration

**File**: `test/widget_test.dart`

```dart
void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(const PinSnapApp());
    expect(find.text('PinSnap'), findsOneWidget);
  });
}
```

## Performance Optimization

### 1. Image Optimization

```dart
Image.file(
  File(imagePath),
  cacheHeight: 400,
  cacheWidth: 400,
  fit: BoxFit.cover,
)
```

### 2. Database Indexing

```sql
CREATE INDEX idx_timestamp ON locations(timestamp);
CREATE INDEX idx_placeName ON locations(placeName);
```

### 3. Lazy Loading

```dart
ListView.builder(
  itemCount: snapshot.data!.length,
  itemBuilder: (context, index) {
    // Item diload hanya ketika di-scroll ke view
  },
)
```

## Monitoring & Debugging

### 1. Enable Logging

```dart
debugPrint('PinSnap: Location saved - $latitude, $longitude');
```

### 2. Performance Profiling

```bash
flutter run --profile
```

### 3. Memory Profiling

Gunakan DevTools:

```bash
devtools
```

---

**Last Updated**: 2026
**Configuration Version**: 1.0.0
