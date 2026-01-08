import '../models/location_model.dart';
import 'database_helper.dart';

class LocationService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> addLocation(LocationModel location) async {
    final db = await _dbHelper.database;
    await db.insert('locations', location.toMap());
  }

  Future<List<LocationModel>> getAllLocations() async {
    final db = await _dbHelper.database;
    final maps = await db.query('locations');
    return maps.map((map) => LocationModel.fromMap(map)).toList();
  }

  Future<void> deleteLocation(int id) async {
    final db = await _dbHelper.database;
    await db.delete('locations', where: 'id = ?', whereArgs: [id]);
  }
}
