# PinSnap Flutter Application - Modular Architecture

## Project Structure Overview

Aplikasi PinSnap telah direfaktor dari monolitic single-file (985 lines) menjadi modular multi-file architecture untuk meningkatkan maintainability dan scalability.

```
lib/
├── main.dart                          # Entry point aplikasi
├── main_backup_old.dart              # Backup kode lama (untuk referensi)
├── models/
│   └── location_model.dart           # Data model untuk Location
├── services/
│   ├── database_helper.dart          # Singleton database management
│   └── location_service.dart         # Business logic layer - CRUD operations
└── screens/
    ├── login_screen.dart             # Authentication screen
    ├── welcome_screen.dart           # Home/Menu screen
    ├── camera_screen.dart            # Camera + GPS capture screen
    ├── add_location_screen.dart      # Location details form
    └── history_screen.dart           # Saved locations list
```

## File Descriptions

### Core Entry Point

- **main.dart** (23 lines)
  - Entry point aplikasi
  - Database initialization via DatabaseHelper singleton
  - Root widget: PinSnapApp
  - Navigation root: LoginScreen

### Models

- **models/location_model.dart** (51 lines)
  - LocationModel class
  - Properties: id, placeName, location, description, latitude, longitude, imagePath, timestamp
  - Methods: toMap() untuk database serialization, fromMap() factory untuk deserialization

### Services

- **services/database_helper.dart** (45 lines)

  - Singleton pattern untuk database lifecycle management
  - SQLite database initialization
  - CREATE TABLE locations schema
  - closeDatabase() cleanup method

- **services/location_service.dart** (18 lines)
  - Business logic layer untuk location operations
  - Methods:
    - addLocation(LocationModel) - INSERT
    - getAllLocations() - SELECT all
    - deleteLocation(int id) - DELETE by ID
  - Menggunakan DatabaseHelper singleton internally

### Screens

- **screens/login_screen.dart** (140 lines)

  - Authentication UI
  - Username/password input
  - Validation & navigation to WelcomeScreen
  - Gradient background dengan camera+location logo

- **screens/welcome_screen.dart** (88 lines)

  - Home/menu screen setelah login
  - Two buttons: History & Camera
  - Navigation to HistoryScreen dan CameraScreen

- **screens/camera_screen.dart** (131 lines)

  - Real-time camera preview
  - Photo capture dengan automatic GPS capture
  - Permission handling via Geolocator
  - CameraController management

- **screens/add_location_screen.dart** (172 lines)

  - Form untuk location details
  - TextEditingControllers: placeName, location, description
  - Photo preview dari captured image
  - Save functionality via LocationService
  - Validation & error handling

- **screens/history_screen.dart** (220 lines)
  - Menampilkan semua saved locations
  - LocationCard widget: expandable cards
  - Google Maps integration (url_launcher)
  - Delete functionality dengan confirmation dialog
  - FutureBuilder dengan LocationService.getAllLocations()

## Architecture Pattern

### Separation of Concerns

1. **Models** - Data structure dan serialization
2. **Services** - Business logic dan database operations
3. **Screens** - UI presentation layer
4. **Main** - Application configuration dan routing

### State Management

- StatefulWidget pattern untuk local state
- FutureBuilder untuk async database operations
- Simple navigation dengan Navigator

### Database

- SQLite via sqflite package
- DatabaseHelper singleton pattern
- Async operations untuk non-blocking DB access

## Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  camera: ^0.10.5
  geolocator: ^9.0.2
  sqflite: ^2.3.0
  intl: ^0.19.0
  url_launcher: ^6.2.0
  google_maps_flutter: ^2.5.0
```

## Permissions (Already Configured)

### Android (AndroidManifest.xml)

- CAMERA
- ACCESS_FINE_LOCATION
- ACCESS_COARSE_LOCATION
- INTERNET

### iOS (Info.plist)

- NSCameraUsageDescription
- NSLocationWhenInUseUsageDescription

## Flow Application

```
main()
  ↓
LoginScreen (Authentication)
  ↓
WelcomeScreen (Menu)
  ├── Camera button → CameraScreen
  │      ↓
  │   Add photo + GPS capture
  │      ↓
  │   AddLocationScreen (Form)
  │      ↓
  │   LocationService.addLocation()
  │      ↓
  │   DatabaseHelper (SQLite)
  │
  └── History button → HistoryScreen
         ↓
      LocationService.getAllLocations()
         ↓
      Display LocationCard widgets
         ↓
      Options: Open Maps, View Details, Delete
```

## Migration Notes

- Old monolithic main.dart (985 lines) dipindahkan ke main_backup_old.dart untuk referensi
- Semua class dan fungsi dipisah ke file-file sesuai responsibility
- DatabaseHelper singleton menghilangkan kebutuhan passing database instance
- LocationService menggunakan DatabaseHelper internal - tidak perlu parameter database

## Next Steps

1. Test aplikasi: `flutter run`
2. Verify semua imports bekerja dengan baik
3. Test camera capture → location save → history view flow
4. Optional: Tambah error handling, logging, analytics
5. Optional: Refactor dengan state management (Provider, GetX, Riverpod)

## Cleanup

File-file lama yang sudah di-remove:

- main_new.dart (replaced by main.dart)
- main_final.dart (replaced by main.dart)
- add_location_screen_v1.dart (replaced by add_location_screen.dart)
- history_screen_v1.dart (replaced by history_screen.dart)

Hanya main_backup_old.dart yang dipertahankan untuk referensi historical code.
