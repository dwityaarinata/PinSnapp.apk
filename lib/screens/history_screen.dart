import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';
import 'camera_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<LocationModel>> _locationsFuture;
  late LocationService _locationService;

  @override
  void initState() {
    super.initState();
    _locationService = LocationService();
    _loadLocations();
  }

  void _loadLocations() {
    _locationsFuture = _locationService.getAllLocations();
  }

  void _deleteLocation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Location'),
        content: const Text('Are you sure you want to delete this location?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _locationService.deleteLocation(id);
              Navigator.of(context).pop();
              setState(() {
                _loadLocations();
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openInMaps(double latitude, double longitude) async {
    final googleMapsUrl = 'https://maps.google.com/?q=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.deepPurple[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CameraScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple[900]!, Colors.deepPurple[600]!],
          ),
        ),
        child: FutureBuilder<List<LocationModel>>(
          future: _locationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final location = snapshot.data![index];
                  return LocationCard(
                    location: location,
                    onDelete: () => _deleteLocation(location.id!),
                    onOpenMaps: () =>
                        _openInMaps(location.latitude, location.longitude),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'No saved locations yet',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class LocationCard extends StatefulWidget {
  final LocationModel location;
  final VoidCallback onDelete;
  final VoidCallback onOpenMaps;

  const LocationCard({
    super.key,
    required this.location,
    required this.onDelete,
    required this.onOpenMaps,
  });

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: const Radius.circular(16)),
            child: Image.file(
              File(widget.location.imagePath),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.location.placeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.cyan[300], size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.location.location,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (_isExpanded) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Koordinat: ${widget.location.latitude.toStringAsFixed(6)}, ${widget.location.longitude.toStringAsFixed(6)}',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Deskripsi:',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.location.description,
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Disimpan: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(widget.location.timestamp))}',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: widget.onOpenMaps,
                        icon: const Icon(Icons.map),
                        label: const Text('Open'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan[300],
                          foregroundColor: Colors.deepPurple[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: widget.onDelete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
