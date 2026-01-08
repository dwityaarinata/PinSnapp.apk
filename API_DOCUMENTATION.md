# PinSnap - API & Service Documentation

## Overview

Dokumentasi lengkap untuk services, models, dan APIs yang digunakan dalam aplikasi PinSnap.

---

## 1. Data Models

### LocationModel

Merepresentasikan data lokasi yang disimpan.

```dart
class LocationModel {
  int? id;                    // Primary key, auto-generated
  String placeName;          // Nama tempat
  String location;           // Nama/deskripsi lokasi
  String description;        // Detail deskripsi
  double latitude;           // Koordinat lintang
  double longitude;          // Koordinat bujur
  String imagePath;          // Path ke file gambar
  String timestamp;          // ISO8601 format timestamp
}
```

#### Methods

- `toMap()`: Konversi ke Map untuk database
- `fromMap()`: Konversi dari Map database ke object

#### Example

```dart
final location = LocationModel(
  placeName: 'Candi Borobudur',
  location: 'Magelang, Jawa Tengah',
  description: 'Candi Budha tertua dan terbesar di dunia',
  latitude: -7.6079,
  longitude: 110.2038,
  imagePath: '/storage/.../photo.jpg',
  timestamp: DateTime.now().toIso8601String(),
);
```

---

## 2. Services

### LocationService

Service untuk operasi database lokasi.

#### Methods

##### `addLocation(LocationModel location)`

Menyimpan lokasi baru ke database.

```dart
await LocationService.addLocation(location);
```

**Parameters**:

- `location` (LocationModel): Data lokasi yang akan disimpan

**Returns**: Future<void>

**Throws**: Database exceptions

---

##### `getAllLocations()`

Mengambil semua lokasi dari database.

```dart
final locations = await LocationService.getAllLocations();
```

**Parameters**: None

**Returns**: `Future<List<LocationModel>>` - Daftar semua lokasi

**Example**:

```dart
FutureBuilder<List<LocationModel>>(
  future: LocationService.getAllLocations(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      List<LocationModel> locations = snapshot.data!;
      // Display locations
    }
  },
)
```

---

##### `deleteLocation(int id)`

Menghapus lokasi dari database berdasarkan ID.

```dart
await LocationService.deleteLocation(id);
```

**Parameters**:

- `id` (int): ID lokasi yang akan dihapus

**Returns**: Future<void>

**Throws**: Database exceptions

---

### Database Initialization

```dart
Future<void> _initializeDatabase() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'pinsnap.db');

  _database = await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE locations('
        'id INTEGER PRIMARY KEY,'
        'placeName TEXT,'
        'location TEXT,'
        'description TEXT,'
        'latitude REAL,'
        'longitude REAL,'
        'imagePath TEXT,'
        'timestamp TEXT'
        ')',
      );
    },
  );
}
```

---

## 3. Camera Service Integration

### Camera Controller Setup

```dart
late CameraController _cameraController;

Future<void> _initializeCamera() async {
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  _cameraController = CameraController(
    firstCamera,
    ResolutionPreset.high,
  );

  _initializeControllerFuture = _cameraController.initialize();
}
```

### Capture Photo

```dart
Future<void> _capturePhoto() async {
  try {
    await _initializeControllerFuture;
    final image = await _cameraController.takePicture();
    // Process image
  } catch (e) {
    print('Error: $e');
  }
}
```

---

## 4. Geolocation Service Integration

### Get Current Position

```dart
Future<void> _getCurrentLocation() async {
  try {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude = position.latitude;
    longitude = position.longitude;

  } catch (e) {
    print('Error: $e');
  }
}
```

### Request Permission

```dart
Future<void> _requestLocationPermission() async {
  final permission = await Geolocator.requestPermission();

  if (permission == LocationPermission.denied) {
    // Permission denied
  } else if (permission == LocationPermission.deniedForever) {
    // Permission permanently denied
  } else {
    // Permission granted
  }
}
```

### Check Permission Status

```dart
Future<LocationPermission> _checkPermission() async {
  return await Geolocator.checkPermission();
}
```

#### Permission Enum

```
LocationPermission.unableToDetermine  // Unknown status
LocationPermission.denied             // User denied
LocationPermission.deniedForever       // Permanently denied
LocationPermission.whileInUse          // Allowed while using
LocationPermission.always              // Always allowed
```

### Location Accuracy Levels

```dart
LocationAccuracy.lowest      // ±500m
LocationAccuracy.low         // ±100m
LocationAccuracy.medium      // ±15m
LocationAccuracy.high        // ±5m
LocationAccuracy.best        // Best available
LocationAccuracy.bestForNavigation  // For GPS navigation
```

---

## 5. URL Launcher Service

### Open Google Maps

```dart
void _openInMaps(double latitude, double longitude) async {
  final googleMapsUrl =
      'https://maps.google.com/?q=$latitude,$longitude';

  if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
    await launchUrl(Uri.parse(googleMapsUrl));
  } else {
    // Handle error
  }
}
```

### URL Format Examples

```
# View marker
https://maps.google.com/?q=latitude,longitude

# Search location
https://maps.google.com/?q=Borobudur

# Get directions
https://maps.google.com/?q=<start>&destination=<end>

# Street view
https://maps.google.com/maps?layer=c&cbll=latitude,longitude
```

---

## 6. Image Handling

### Display Cached Image

```dart
Image.file(
  File(imagePath),
  height: 250,
  width: double.infinity,
  fit: BoxFit.cover,
  cacheHeight: 400,
  cacheWidth: 400,
)
```

### Image File Handling

```dart
final imageFile = File(imagePath);

// Check if exists
if (imageFile.existsSync()) {
  final sizeInBytes = imageFile.lengthSync();
  final sizeInMB = sizeInBytes / (1024 * 1024);
}

// Delete image
imageFile.deleteSync();
```

---

## 7. Date & Time Handling

### Format DateTime

```dart
import 'package:intl/intl.dart';

final timestamp = DateTime.parse(locationModel.timestamp);
final formatted = DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
```

### Format Options

```dart
DateFormat('yyyy-MM-dd')          // 2026-01-08
DateFormat('dd/MM/yyyy')          // 08/01/2026
DateFormat('HH:mm')               // 14:30
DateFormat('HH:mm:ss')            // 14:30:45
DateFormat('E, d MMM y')          // Thu, 8 Jan 2026
DateFormat('EEEE, MMMM d, yyyy')  // Thursday, January 8, 2026
```

---

## 8. Navigation Routes

### Simple Navigation

```dart
Navigator.of(context).push(
  MaterialPageRoute(builder: (context) => const HistoryScreen()),
);
```

### Replace Navigation

```dart
Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (context) => const HomeScreen()),
);
```

### Pop Navigation

```dart
Navigator.of(context).pop();
```

### Pop Until Root

```dart
Navigator.of(context).popUntil((route) => route.isFirst);
```

### Named Routes

```dart
// Setup in MaterialApp
MaterialApp(
  routes: {
    '/': (context) => const LoginScreen(),
    '/home': (context) => const HomeScreen(),
    '/history': (context) => const HistoryScreen(),
  },
)

// Navigate
Navigator.of(context).pushNamed('/history');
```

---

## 9. Dialog & Alert

### Show SnackBar

```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Location saved successfully!'),
    duration: Duration(seconds: 2),
  ),
);
```

### Show Alert Dialog

```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Delete Location'),
    content: const Text('Are you sure?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          // Delete logic
          Navigator.of(context).pop();
        },
        child: const Text('Delete'),
      ),
    ],
  ),
);
```

---

## 10. Form Handling

### TextField Setup

```dart
final _controller = TextEditingController();

// Use
TextField(
  controller: _controller,
  decoration: InputDecoration(
    hintText: 'Enter value',
    border: OutlineInputBorder(),
  ),
)

// Get value
final value = _controller.text;

// Validation
if (_controller.text.isEmpty) {
  // Show error
}

// Cleanup
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

---

## 11. FutureBuilder Pattern

### Load Data Pattern

```dart
FutureBuilder<List<LocationModel>>(
  future: LocationService.getAllLocations(),
  builder: (context, snapshot) {
    // Check states
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return LocationCard(
            location: snapshot.data![index],
          );
        },
      );
    } else {
      return const Text('No data');
    }
  },
)
```

---

## 12. State Management Patterns

### StatefulWidget Pattern

```dart
class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  // State variables
  List<LocationModel> locations = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      // Update UI
    });
  }

  @override
  void dispose() {
    // Cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Build UI
    );
  }
}
```

---

## 13. Error Handling

### Try-Catch Pattern

```dart
try {
  final position = await Geolocator.getCurrentPosition();
  // Process position
} on LocationServiceDisabledException {
  print('Location service disabled');
} on PermissionDeniedException {
  print('Permission denied');
} catch (e) {
  print('Unknown error: $e');
}
```

### Async-Await Error Handling

```dart
Future<void> _saveLocation() async {
  try {
    await LocationService.addLocation(location);
    // Show success message
  } catch (e) {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
```

---

## 14. Constants & Configuration

### Create constants.dart

```dart
// lib/constants/app_constants.dart

const String APP_NAME = 'PinSnap';
const String APP_VERSION = '1.0.0';

const double DEFAULT_LATITUDE = -7.0;
const double DEFAULT_LONGITUDE = 110.0;

const String DATABASE_NAME = 'pinsnap.db';
const int DATABASE_VERSION = 1;

const Duration LOCATION_TIMEOUT = Duration(seconds: 30);
const double MIN_LOCATION_ACCURACY = 20.0; // meters
```

---

## 15. Testing Examples

### Widget Test

```dart
void main() {
  testWidgets('LoginScreen displays correctly',
    (WidgetTester tester) async {
      await tester.pumpWidget(const PinSnapApp());
      expect(find.text('Login'), findsOneWidget);
    },
  );
}
```

### Unit Test

```dart
void main() {
  group('LocationModel', () {
    test('toMap returns correct map', () {
      final location = LocationModel(
        placeName: 'Test Place',
        location: 'Test Location',
        description: 'Test',
        latitude: 0.0,
        longitude: 0.0,
        imagePath: '/path',
        timestamp: DateTime.now().toIso8601String(),
      );

      final map = location.toMap();
      expect(map['placeName'], 'Test Place');
    });
  });
}
```

---

## Integration with External APIs

### Google Maps Integration

```dart
// pubspec.yaml
google_maps_flutter: ^2.5.0

// Implementation
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 15,
  ),
  markers: {
    Marker(
      markerId: MarkerId('location'),
      position: LatLng(latitude, longitude),
    ),
  },
)
```

### Firebase Integration (Optional)

```dart
// pubspec.yaml
firebase_core: ^2.24.0
firebase_auth: ^4.14.0
cloud_firestore: ^4.14.0

// Implementation
await Firebase.initializeApp();

// Save to Firestore
await FirebaseFirestore.instance
  .collection('locations')
  .add(location.toMap());
```

---

## Best Practices

### 1. Null Safety

```dart
String? nullableString;  // Can be null
String nonNullString;    // Cannot be null

// Null coalescing
final value = nullableString ?? 'default';
```

### 2. Constant Usage

```dart
const Widget = Container();  // Compile-time constant
final widget = Container();  // Runtime constant
```

### 3. Error Messages

```dart
// Good
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Location saved successfully')),
);

// Bad
print('Saved');  // Not user-friendly
```

### 4. Resource Cleanup

```dart
@override
void dispose() {
  _cameraController.dispose();
  _controller.dispose();
  super.dispose();
}
```

---

**Version**: 1.0.0  
**Last Updated**: 2026
