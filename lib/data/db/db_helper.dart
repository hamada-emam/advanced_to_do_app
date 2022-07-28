// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart" as path_provider;

class DBHelper {
  /// INITIALIZATION

  DBHelper._internal(); // named constructor
  static final DBHelper _instance = DBHelper._internal(); // singltone
  factory DBHelper() => _instance; // factoring an instaance
  /// DATABASE

  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';
  static String get tableName => _tableName;

  /// CREATION

// return the data base
  static Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      return initDb();
    }
  }

  static String? _dbPath;
// return data bas e file path
  static Future<String> get databaseFilepath async {
    if (_dbPath != null) {
      return _dbPath!;
    } else {
      return await getDatabasesPath();
    }
  }

//that's initialize data base
  static Future<Database> initDb() async {
    //if it already here just tell me
    // Get a location using getDatabasesPath
    String path = path_provider.join(await databaseFilepath, 'task.db');
    debugPrint("path $path");
    Database ourDb = await openDatabase(
      path,
      version: _version,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table columns
        await db.execute('''
                CREATE TABLE $_tableName (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT, note TEXT, date TEXT, startTime TEXT,
                statusoffave TEXT, statusofcomplete TEXT,
                endTime TEXT, color INTEGER, remind INTEGER, repeat TEXT)
                 ''').then((value) {
          debugPrint("database created $_db => $_tableName ");
        });
      },
    );
    return ourDb;
  }
}
