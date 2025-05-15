import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Get Database Instance
  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  // Initialize Database
  static Future<Database> _initDB() async {
    var directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "users.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            password TEXT,
            phone TEXT
          )
        ''');
      },
    );
  }

  // Insert User Data
  static Future<void> insertUser(String name, String email, String password, String phone) async {
    final db = await database;
    await db.insert("users", {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    });
  }

  // Fetch All Users
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query("users");
  }
}
