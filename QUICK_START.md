# PinSnap - Quick Start Guide

## 5 Menit Setup Cepat

### Prasyarat

- Flutter SDK terinstal
- Android SDK atau Xcode (untuk iOS)
- Device/Emulator yang siap

### Langkah Cepat

```bash
# 1. Navigate ke folder project
cd c:\apk_mobile\flutter_application_1

# 2. Download dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

Selesai! Aplikasi akan terbuka di device Anda.

---

## App Flow

```
1. LOGIN SCREEN
   Username: user123
   Password: password123
   ↓
2. HOME SCREEN
   ├── History Button → 3. HISTORY SCREEN
   └── Camera Button → 4. CAMERA SCREEN

3. HISTORY SCREEN
   ├── View saved locations
   ├── Click "Open" → Google Maps
   └── Click "Delete" → Remove location

4. CAMERA SCREEN
   ├── Click Shutter → Take photo
   └── Auto-capture GPS coordinates
      ↓
   5. ADD LOCATION SCREEN
      ├── Enter place name
      ├── Enter location
      ├── Enter description
      └── Click "Save" → Save to database
```

---

## Key Features Testing

### 1. Login

- Username & Password: Any non-empty values
- Click "Login" → Goes to Home Screen

### 2. Take Photo

- Click "Camera" button
- Click circular shutter button
- Select or take photo
- Fill in location details
- Click "Save"

### 3. View History

- Click "History" button
- See all saved locations
- Tap card to expand/collapse
- Click "Open" to view in Google Maps
- Click delete to remove

### 4. Expand Location Details

- Tap the expand button (arrow icon)
- View full coordinates
- View full description
- View save date/time

---

## File Structure

```
lib/
└── main.dart           # All code (single file for simplicity)
    ├── LocationModel       # Data structure
    ├── LocationService     # Database operations
    ├── LoginScreen         # Login UI
    ├── HomeScreen          # Main menu
    ├── CameraScreen        # Camera & GPS
    ├── AddLocationScreen   # Form input
    ├── HistoryScreen       # Saved locations
    └── LocationCard        # Location display card
```

---

## Modifying the App

### Change App Name

Edit `pubspec.yaml`:

```yaml
name: pinsnap
```

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
android:label="PinSnap"
```

### Change Colors

Edit `main.dart` - Search for `Colors.deepPurple`:

```dart
// Primary color
Colors.deepPurple[900]  // Very dark purple
Colors.deepPurple[600]  // Medium purple
Colors.cyan[300]        // Cyan accent
```

### Change Login Credentials

Edit login logic in `LoginScreen`:

```dart
void _login() {
  if (_usernameController.text == 'admin' &&
      _passwordController.text == 'password') {
    // Authenticate
  }
}
```

### Add New Screen

1. Create new StatefulWidget in `main.dart`
2. Add to navigation:

```dart
Navigator.of(context).push(
  MaterialPageRoute(builder: (context) => NewScreen()),
);
```

---

## Common Issues & Solutions

### Issue: Camera shows black screen

**Solution**:

- Check if camera permission is granted
- Restart the app
- Restart device

### Issue: GPS not working

**Solution**:

- Enable location services on device
- Grant location permission
- Check internet connection (for maps)

### Issue: Database error

**Solution**:

```bash
flutter clean
flutter pub get
flutter run
```

### Issue: Photos not showing in history

**Solution**:

- Check if storage permission is granted
- Verify image file path is correct
- Check device storage space

---

## Testing Checklist

- [ ] Login with any username/password
- [ ] Navigate to Home Screen
- [ ] Click History - should show empty or saved locations
- [ ] Click Camera
- [ ] Take a photo
- [ ] Fill in location details
- [ ] Save location
- [ ] Go back to History
- [ ] See new location in list
- [ ] Expand location card to see details
- [ ] Click "Open" button - opens Google Maps
- [ ] Delete a location - shows confirmation dialog
- [ ] Confirm deletion - location removed from list

---

## Database Queries

### View All Locations

```dart
final locations = await LocationService.getAllLocations();
locations.forEach((loc) {
  print('${loc.placeName}: ${loc.latitude}, ${loc.longitude}');
});
```

### Search Location

```dart
final locations = await LocationService.getAllLocations();
final filtered = locations.where(
  (loc) => loc.placeName.toLowerCase().contains('borobudur')
).toList();
```

### Delete All Locations

```dart
final locations = await LocationService.getAllLocations();
for (var loc in locations) {
  await LocationService.deleteLocation(loc.id!);
}
```

---

## Build & Deploy

### Build APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Build iOS App

```bash
flutter build ios --release
```

Output: `build/ios/iphoneos/Runner.app`

### Install APK

```bash
flutter install
```

---

## Customization Ideas

1. **Add Firebase** for cloud backup
2. **Add Google Sign-In** instead of simple login
3. **Add Photo Filter** effects
4. **Add Location Search** feature
5. **Add Sharing** functionality
6. **Add Dark Mode**
7. **Add Notifications** for locations
8. **Add Offline Maps**
9. **Add Location Clustering**
10. **Add Rating System**

---

## Useful Commands

```bash
# Check device status
flutter devices

# Run in release mode
flutter run --release

# Run in debug mode (default)
flutter run

# Run on specific device
flutter run -d <device_id>

# Verbose output for debugging
flutter run -v

# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Format code
dart format lib/main.dart

# Analyze code
flutter analyze

# Update dependencies
flutter pub upgrade

# Check outdated packages
flutter pub outdated
```

---

## Permissions on Different Devices

### Android 6.0+ (API 23+)

Runtime permissions required:

- CAMERA
- ACCESS_FINE_LOCATION
- ACCESS_COARSE_LOCATION

**How to grant**:
Settings → Apps → PinSnap → Permissions → Enable Camera & Location

### iOS 10+

Request shown on first use:

- Camera access
- Location access

**How to grant**:
Settings → PinSnap → Toggle Camera & Location On

---

## Troubleshooting Commands

```bash
# If pub get fails
flutter pub get --offline

# If build fails
flutter clean
flutter pub get
flutter pub upgrade

# Clear cache
flutter clean
rm -rf pubspec.lock

# Fix common issues
flutter fix

# Update Flutter
flutter upgrade

# Check Flutter status
flutter doctor
```

---

## Performance Tips

1. **Use Release Mode** for testing performance

   ```bash
   flutter run --release
   ```

2. **Optimize Images** before saving

   - Compress images
   - Resize to needed dimensions

3. **Lazy Load** history when needed

   - Only load visible items
   - Pagination for large lists

4. **Cache Photos** efficiently
   - Use image cache height/width
   - Delete old unused images

---

## Security Notes

- Change default login credentials
- Don't store sensitive data in plain text
- Use HTTPS for external APIs
- Validate all user inputs
- Sanitize file paths

---

## Next Steps

1. Test the app thoroughly
2. Add your own branding (logo, colors)
3. Implement proper authentication
4. Add backend/cloud support
5. Publish to Play Store/App Store

---

## Support Resources

- Flutter Docs: https://flutter.dev/docs
- Dart Docs: https://dart.dev/guides
- Stack Overflow: Search with `[flutter]` tag
- GitHub Issues: Report bugs and feature requests

---

## Version Info

- **App Version**: 1.0.0
- **Flutter**: 3.9.2+
- **Dart**: 3.0.0+
- **Minimum Android**: API 21
- **Minimum iOS**: 11.0

---

**Happy Coding! 🚀**

For detailed documentation, see:

- `README.md` - Overview and features
- `SETUP.md` - Detailed installation
- `CONFIGURATION.md` - Configuration options
- `API_DOCUMENTATION.md` - Code API reference
