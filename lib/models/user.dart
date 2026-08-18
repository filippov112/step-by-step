import 'dart:math';
import 'package:life_game/data/db.dart';
import 'package:life_game/tools/get_age_string.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
// Пользователь
class User {
  static const tn = "profiles";
  static const cId = "_id";
  static const cName = "_name";
  static const cIcon = "_icon";
  static const cBirthDate = "_dbirth";

  static const cLevel = "_level";
  static const cExperience = "_exp";

  static const init = '''CREATE TABLE $tn (
          $cId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $cName TEXT NOT NULL, 
          $cIcon TEXT,
          $cBirthDate INTEGER,

          $cLevel INTEGER,
          $cExperience INTEGER
        )''';

  int? id;
  String name = "";
  String? icon;
  DateTime dateBirth = DateTime(2000);

  int level = 1; // уровень
  int experience = 0; // свободный опыт

  String get age => getDateIntervalString(dateBirth, DateTime.now());
  int get maxExperience => (10 * pow(1.2, level)).round();  // опыт до следующего уровня

  User({
    this.name = "", 
    this.icon, 
    required this.dateBirth,
  
    this.experience = 0,
    this.level = 1
  });

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cName: name,
      cIcon: icon ?? "",
      cBirthDate: dateBirth.millisecondsSinceEpoch ~/ 60000,

      cExperience: experience,
      cLevel: level
    };
    if (id != null) {
      map[cId] = id;
    }
    return map;
  }

  User.fromMap(Map map) {
    id = map[cId];
    name = map[cName];
    icon = map[cIcon];
    dateBirth = DateTime.fromMillisecondsSinceEpoch(map[cBirthDate] * 60000);

    experience = map[cExperience];
    level = map[cLevel];
  }
}

// Базовый репозиторий пользователей
class UserRepository {
  Database db = DB.db!;

  Future<User> insert(User tsk) async {
    tsk.id = await db.insert(User.tn, tsk.toMap());
    return tsk;
  }

  Future<List<int>> insertBatch(Iterable<User> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (User m in models) {
        res.add(
          await txn.insert(User.tn, m.toMap()));
      }
      
    });
    return res;
  }

  Future<User?> get() async {
    List<Map> maps = await db.query(User.tn);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first as Map<String,Object?>);
    }
    return null;
  }

  Future<int?> delete(int id) async {
    return await db.delete(User.tn, where: '${User.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(User tsk) async {
    return await db.update(User.tn, tsk.toMap(),
        where: '${User.cId} = ?', whereArgs: [tsk.id]);
  }
}

