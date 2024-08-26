import 'package:flutter/services.dart'; // For rootBundle
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io'; // For file operations

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath(); // Get the default database path
    final path = join(dbPath, 'database.db'); // Set the path to database.db in local storage

    // Check if the database file already exists in the local storage
    if (await File(path).exists()) {
      print('Database already exists in local storage.');
    } else {
      print('Database does not exist. Copying from assets.');
      await _copyDatabaseFromAssets(path);
    }

    return await openDatabase(path, version: 1);
  }

  Future<void> _copyDatabaseFromAssets(String path) async {
    try {
      // Load the database file from the assets (adjusted path)
      ByteData data = await rootBundle.load('lib/assets/database.db');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write the database file to the local path
      await File(path).writeAsBytes(bytes, flush: true);
      print('Database copied successfully from assets to local storage.');
    } catch (e) {
      print('Error copying the database from assets: $e');
      rethrow;
    }
  }

  Future<bool> checkDatabaseExists() async {
    try {
      // Check if the database file exists in the assets using rootBundle
      ByteData data = await rootBundle.load('lib/assets/database.db');
      return data != null; // Return true if the database is found
    } catch (e) {
      print('Database not found in assets: $e');
      return false; // Return false if the database is not found
    }
  }

  Future<String> getRandomCellData() async {
    final db = await database;

    // Example query to fetch a random cell. Adjust according to your database structure.
    final List<Map<String, dynamic>> result = await db.rawQuery('SELECT * FROM TEST_QUESTIONS LIMIT 1');
    
    if (result.isNotEmpty) {
      return result.first.values.first.toString(); // Get the first cell from the first row
    } else {
      return 'No data found';
    }
  }
}
