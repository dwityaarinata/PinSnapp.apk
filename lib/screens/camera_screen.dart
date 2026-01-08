import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'add_location_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No camera found on device')),
          );
        }
        return;
      }

      final firstCamera = cameras.first;
      _cameraController = CameraController(firstCamera, ResolutionPreset.high);
      _initializeControllerFuture = _cameraController.initialize();
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera initialization error: $e')),
        );
      }
    }
  }

  Future<void> _capturePhoto() async {
    try {
      await _initializeControllerFuture;

      if (!_locationPermissionGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission required')),
          );
        }
        return;
      }

      // Get location
      final position =
          await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          ).timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Location timeout'),
          );

      // Take picture
      final image = await _cameraController.takePicture();
      final imagePath = image.path;

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddLocationScreen(
              imagePath: imagePath,
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _requestLocationPermission() async {
    try {
      final permission = await Geolocator.requestPermission();

      setState(() {
        _locationPermissionGranted =
            permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always;
      });

      if (!_locationPermissionGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission is required'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Permission error: $e')));
      }
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Photo'),
        backgroundColor: Colors.deepPurple[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple[900]!, Colors.deepPurple[600]!],
          ),
        ),
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: CameraPreview(_cameraController),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    child: GestureDetector(
                      onTap: _capturePhoto,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.deepPurple[600]!,
                            width: 4,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.deepPurple[900],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
          },
        ),
      ),
    );
  }
}
