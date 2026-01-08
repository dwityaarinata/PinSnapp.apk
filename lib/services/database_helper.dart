import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'pinsnap.db');

    return await openDatabase(
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

  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
