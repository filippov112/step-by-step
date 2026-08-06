import 'dart:math';

import 'package:life_game/data/db.dart';
import 'package:life_game/services/get_age_string.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class UserProfileModel {
  static const tn = "profiles";
  static const cId = "_id";
  static const cName = "_name";
  static const cIcon = "_icon";
  static const cBirthDate = "_dbirth";

  static const cMana = "_mana";
  static const cMaxMana = "_maxmana";
  static const cLevel = "_level";
  static const cExperience = "_exp";
  static const cManaRegeneration = "_manaregen";
  static const cIntelligence = "_intel";
  static const cStrength = "_strength";
  static const cHealth = "_health";
  static const cEndurance = "_endurance";

  static const init = '''CREATE TABLE $tn (
          $cId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $cName TEXT NOT NULL, 
          $cIcon TEXT,
          $cBirthDate DATETIME,

          $cMana INTEGER,
          $cMaxMana INTEGER,
          $cLevel INTEGER,
          $cExperience INTEGER,

          $cManaRegeneration INTEGER,
          $cIntelligence INTEGER,
          $cStrength INTEGER,
          $cHealth INTEGER,
          $cEndurance INTEGER
        )''';

  int? id;
  String name = "";
  String? icon;
  DateTime dateBirth = DateTime(2000);

  int mana = 10; // текущая мана
  int maxMana = 10;
  int level = 1; // уровень
  int experience = 0; // свободный опыт

  int manaRegeneration = 1; // скорость восстановления маны
  int intelligence = 0;
  int strength = 0;
  int health = 0;
  int endurance = 0;

  String get age => getAgeString(dateBirth);
  int get maxExperience => (10 * pow(1.2, level)).round();  // опыт до следующего уровня

  UserProfileModel({
    this.name = "", 
    this.icon, 
    required this.dateBirth,
  
    this.mana = 10,
    this.maxMana = 10,
    this.experience = 0,
    this.level = 1,
    this.manaRegeneration = 1,
    this.intelligence = 0,
    this.strength = 0,
    this.health = 0,
    this.endurance = 0
  });

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cName: name,
      cIcon: icon ?? "",
      cBirthDate: dateBirth.millisecondsSinceEpoch,

      cMana: mana,
      cMaxMana: maxMana,
      cExperience: experience,
      cLevel: level,
      cManaRegeneration: manaRegeneration,
      cIntelligence: intelligence,
      cStrength: strength,
      cHealth: health,
      cEndurance: endurance
    };
    if (id != null) {
      map[cId] = id;
    }
    return map;
  }

  UserProfileModel.fromMap(Map map) {
    id = map[cId];
    name = map[cName];
    icon = map[cIcon];
    dateBirth = DateTime.fromMillisecondsSinceEpoch(map[cBirthDate]);

    mana = map[cMana];
    maxMana = map[cMaxMana];
    experience = map[cExperience];
    level = map[cLevel];
    manaRegeneration = map[cManaRegeneration];
    intelligence = map[cIntelligence];
    strength = map[cStrength];
    health = map[cHealth];
    endurance = map[cEndurance];
  }

}


class UserProfileProvider {
  Database db = DB.db!;

  Future<UserProfileModel> insert(UserProfileModel tsk) async {
    tsk.id = await db.insert(UserProfileModel.tn, tsk.toMap());
    return tsk;
  }

  Future<List<int>> insertBatch(Iterable<UserProfileModel> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (UserProfileModel m in models) {
        res.add(
          await txn.insert(UserProfileModel.tn, m.toMap()));
      }
      
    });
    return res;
  }

  Future<UserProfileModel?> get() async {
    List<Map> maps = await db.query(UserProfileModel.tn);
    if (maps.isNotEmpty) {
      return UserProfileModel.fromMap(maps.first as Map<String,Object?>);
    }
    return null;
  }

  Future<int?> delete(int id) async {
    return await db.delete(UserProfileModel.tn, where: '${UserProfileModel.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(UserProfileModel tsk) async {
    return await db.update(UserProfileModel.tn, tsk.toMap(),
        where: '${UserProfileModel.cId} = ?', whereArgs: [tsk.id]);
  }
}

