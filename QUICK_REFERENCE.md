# 📌 PinSnap - Quick Reference Card

## 🗂️ File Location Guide

| Feature             | File                     | Location                             |
| ------------------- | ------------------------ | ------------------------------------ |
| App Entry Point     | main.dart                | lib/main.dart                        |
| Location Data       | location_model.dart      | lib/models/location_model.dart       |
| Database Management | database_helper.dart     | lib/services/database_helper.dart    |
| CRUD Operations     | location_service.dart    | lib/services/location_service.dart   |
| Login Screen        | login_screen.dart        | lib/screens/login_screen.dart        |
| Home Menu           | welcome_screen.dart      | lib/screens/welcome_screen.dart      |
| Camera & GPS        | camera_screen.dart       | lib/screens/camera_screen.dart       |
| Location Form       | add_location_screen.dart | lib/screens/add_location_screen.dart |
| Location History    | history_screen.dart      | lib/screens/history_screen.dart      |

---

## 🎯 Where to Make Changes?

### Want to...

**Change app colors?**
→ Edit main.dart, add custom ThemeData

**Change database fields?**
→ Edit lib/services/database_helper.dart (CREATE TABLE) AND lib/models/location_model.dart

**Add new CRUD operation?**
→ Add method in lib/services/location_service.dart

**Change UI of login screen?**
→ Edit lib/screens/login_screen.dart

**Change GPS capture behavior?**
→ Edit lib/screens/camera_screen.dart

**Change location form validation?**
→ Edit lib/screens/add_location_screen.dart

**Change history list display?**
→ Edit lib/screens/history_screen.dart

---

## 🚀 Common Commands

```bash
# Run app
flutter run

# Check for errors
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test

# Clean build
flutter clean

# Get dependencies
flutter pub get
```

---

## 📦 Project Dependencies

```yaml
camera: ^0.10.5 # Camera access
geolocator: ^9.0.2 # GPS location
sqflite: ^2.3.0 # SQLite database
intl: ^0.19.0 # Date formatting
url_launcher: ^6.2.0 # Open URLs
google_maps_flutter: ^2.5.0 # Maps
```

---

## 🔌 Import Patterns

### From main.dart

```dart
import 'screens/login_screen.dart';
import 'services/database_helper.dart';
```

### From screens/

```dart
import '../models/location_model.dart';
import '../services/location_service.dart';
```

### From services/

```dart
import 'database_helper.dart';  // Same folder
import '../models/location_model.dart';  // Parent folder
```

---

## 🎨 Architecture Layers

```
UI Layer (Screens)
  ↓ imports
Business Logic Layer (Services)
  ↓ uses
Data Layer (Models)
```

---

## 🔄 Data Flow

1. **Camera Screen** captures photo + GPS
2. **Add Location Screen** gets details from user
3. **Location Service** saves to database
4. **Database Helper** manages SQLite
5. **Location Model** serializes data

---

## 📱 Navigation Flow

```
LoginScreen
  ↓
WelcomeScreen
  ├─ CameraScreen → AddLocationScreen
  └─ HistoryScreen
```

---

## ⚙️ Database Schema

```sql
CREATE TABLE locations (
  id INTEGER PRIMARY KEY,
  placeName TEXT,
  location TEXT,
  description TEXT,
  latitude REAL,
  longitude REAL,
  imagePath TEXT,
  timestamp TEXT
)
```

---

## 🔐 Permissions Required

✅ Camera  
✅ ACCESS_FINE_LOCATION  
✅ ACCESS_COARSE_LOCATION  
✅ INTERNET

_Already configured in AndroidManifest.xml & Info.plist_

---

## 🧪 Testing the App

1. **Run app:** `flutter run`
2. **Login:** Use any username/password
3. **Capture photo:** Tap Camera button
4. **Add details:** Fill location form
5. **Save:** Tap Save button
6. **View history:** Tap History button

---

## 🐛 Debugging

### Check imports

```bash
flutter analyze
```

### Clean and rebuild

```bash
flutter clean
flutter pub get
flutter run
```

### Check database

→ Use database_helper.dart singleton
→ LocationService provides query methods

---

## 📊 File Statistics

- **Total Lines:** ~1,200
- **Total Files:** 9 Dart files
- **Average File:** ~130 lines
- **Largest:** history_screen.dart (269 lines)
- **Smallest:** location_service.dart (18 lines)

---

## ✨ Key Classes

```dart
// Models
class LocationModel {
  String placeName;
  String location;
  String description;
  double latitude;
  double longitude;
  String imagePath;
  String timestamp;

  Map<String, dynamic> toMap() {}
  factory LocationModel.fromMap() {}
}

// Services
class DatabaseHelper {
  factory DatabaseHelper() => _instance;
  Future<Database> get database async {}
}

class LocationService {
  Future<void> addLocation(LocationModel) {}
  Future<List<LocationModel>> getAllLocations() {}
  Future<void> deleteLocation(int id) {}
}
```

---

## 🎓 Tips

1. **Use LocationService** instead of accessing database directly
2. **Use DatabaseHelper singleton** to manage database lifecycle
3. **Keep UI logic in screens**, business logic in services
4. **Always use relative imports** (../ and ../)
5. **Test features** after making changes

---

## 📖 Documentation Files

- `lib/ARCHITECTURE.md` - Technical details
- `FILE_STRUCTURE_GUIDE.md` - Visual structure
- `MODULAR_ARCHITECTURE_README.md` - Overview
- `VERIFICATION_REPORT.md` - Completion report

---

## ✅ Checklist for Adding New Feature

- [ ] Identify which layer (model/service/screen)
- [ ] Create/modify file in correct folder
- [ ] Add proper imports
- [ ] Test the feature
- [ ] Update documentation if needed

---

## 🆘 Quick Help

**App won't run?**
→ `flutter clean` then `flutter run`

**Import errors?**
→ Check relative paths (../ paths)

**Database errors?**
→ Check database_helper.dart initialization

**UI looks wrong?**
→ Check screen file styling

**Feature not working?**
→ Check service layer logic

---

**Happy coding!** 🚀
