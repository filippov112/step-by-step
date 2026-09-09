import 'dart:io';
import 'package:chaos_control/models/purport.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/models/barrier.dart';
import 'package:chaos_control/models/target.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;



class DB {
  static Database? db;

  static Future<void> dropDb() async {
    await deleteDatabase(await _getDBPath());
  }

  static Future initDb() async {
    sqfliteFfiInit();
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }
    else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      databaseFactory = databaseFactoryFfi;
    }

    db = await openDatabase(await _getDBPath(), version: 1,
      onCreate: (Database db, int version) async {

      await db.execute('PRAGMA foreign_keys = ON;');
      await db.execute(Project.init);
      await db.execute(Profile.init);
      await db.execute(Target.init);
      await db.execute(Purport.init);
      await db.execute(Barrier.init);        // зависит от Task, Skill
    });
  }

  // =======

  static Future<String> _getDBPath() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    return path;
  }
}

