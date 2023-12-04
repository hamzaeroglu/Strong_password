import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PasswordDatabase {
  static final PasswordDatabase instance = PasswordDatabase._init();

  static Database? _database;

  PasswordDatabase._init();
  static const String passwordTable = 'passwords';
  static const String columnId = 'id';


  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('passwords.db');
    return _database!;
  }


  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE passwords (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  password TEXT,
  created_at TEXT,
  note TEXT
)
''');
  }

  // Add this method to upgrade the database schema when the version is increased.
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion == 1 && newVersion == 2) {
      await db.execute('ALTER TABLE passwords ADD COLUMN note TEXT');
    }
  }

  Future<void> createPassword(String password, {String? note}) async {
    final db = await instance.database;
    final now = DateTime.now().toIso8601String();
    await db.insert(
      'passwords',
      {'password': password, 'created_at': now, 'note': note},
    );
  }


  Future<List<Map<String, dynamic>>> getPasswords() async {
    final db = await instance.database;
    return await db.query('passwords', orderBy: 'created_at DESC');
  }

  Future<void> deletePassword(int id) async {
    final db = await instance.database;
    await db.delete('passwords', where: 'id = ?', whereArgs: [id]);
  }
  Future<void> updatePassword(Map<String, dynamic> password) async {
    final db = await database;
    await db.update(
      passwordTable,
      password,
      where: '$columnId = ?',
      whereArgs: [password[columnId]],
    );
  }

}
