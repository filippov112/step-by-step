import 'package:life_game/data/db.dart';
import 'package:life_game/services/file_storage_service.dart';
import 'package:life_game/tools/get_age_string.dart';
import 'package:sqflite/sqflite.dart';


// Пользователь
class User {
  static const tn = "profiles";
  
  static const cId = "_id";
  static const cName = "_name";
  static const cIcon = "_icon";
  static const cBirthDate = "_dbirth";
  static const cTime = "_time";
  static const cExperience = "_exp";

  static const init = '''CREATE TABLE $tn (
          $cId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $cName TEXT NOT NULL, 
          $cIcon TEXT,
          $cBirthDate INTEGER,
          $cTime INTEGER,
          $cExperience INTEGER
        )''';

  int? id;
  String name = ""; // Никнейм
  String? icon; // Аватар
  DateTime dateBirth = DateTime(2000); // Дата рождения
  int time = 0; // Кэш времени
  int experience = 0; // Кэш опыта

  String get age => getDateIntervalString(dateBirth, DateTime.now());

  User({
    this.name = "", 
    this.icon, 
    required this.dateBirth,
    this.experience = 0,
    this.time = 0
  });

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cName: name,
      cIcon: icon,
      cBirthDate: dateBirth.millisecondsSinceEpoch ~/ (24 * 60 * 60 * 1000),
      cExperience: experience,
      cTime: time
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
    dateBirth = DateTime.fromMillisecondsSinceEpoch(map[cBirthDate] * (24 * 60 * 60 * 1000));
    experience = map[cExperience];
    time = map[cTime];
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
    await deleteIconIfSetupNull(id: id);
    return await db.delete(User.tn, where: '${User.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(User usr) async {
    await deleteIconIfSetupNull(obj: usr);
    return await db.update(User.tn, usr.toMap(),
        where: '${User.cId} = ?', whereArgs: [usr.id]);
  }

  Future deleteIconIfSetupNull({int? id, User? obj}) async {
    // Если удаление
    if (id != null) {
      var oldObject = await get();
      // Удаляем, если было
      if (oldObject != null && oldObject.icon != null) {
        await FileService.deleteOldFile(oldObject.icon);
      }
    } 
    // Если обновление
    else if (obj != null) {
      var oldObject = await get();
      // Удаляем, если было и изменилось
      if (oldObject != null && oldObject.icon != null && oldObject.icon != obj.icon) {
        await FileService.deleteOldFile(oldObject.icon);
      }
    }
  }
}

