import 'dart:io';
import 'package:life_game/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


class DB {
  static Database? db;

  static Future<void> dropDb() async {
    // Delete the database
    await deleteDatabase(await _getDBPath());
  }

  static Future initDb() async {
    if (db != null) {
      return;
    }
    // Init ffi loader if needed.
    sqfliteFfiInit();
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      databaseFactory = databaseFactoryFfi;
    }
    // Connection
    db = await openDatabase(await _getDBPath(), version: 1,
      onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(TaskModel.init);
    });
  }


  // =======

  static Future<String> _getDBPath() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    return path;
  }
}

