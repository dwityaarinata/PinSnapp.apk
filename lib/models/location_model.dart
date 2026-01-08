class LocationModel {
  int? id;
  String placeName;
  String location;
  String description;
  double latitude;
  double longitude;
  String imagePath;
  String timestamp;

  LocationModel({
    this.id,
    required this.placeName,
    required this.location,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.imagePath,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'placeName': placeName,
      'location': location,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'imagePath': imagePath,
      'timestamp': timestamp,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'],
      placeName: map['placeName'],
      location: map['location'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      imagePath: map['imagePath'],
      timestamp: map['timestamp'],
    );
  }
}
