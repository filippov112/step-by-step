import 'package:step_by_step/data/db.dart';
import 'package:step_by_step/models/enums/characteristics.dart';
import 'package:step_by_step/models/other/image.dart';
import 'package:step_by_step/services/file_storage_service.dart';
import 'package:sqflite/sqflite.dart';

// Пользователь
class Profile {
  static const tn = "profiles";

  static const cId = "_id";
  static const cName = "_name";
  static const cIcon = "_icon";
  
  static const cChars = "_chars";
  static const cBaseChars = "_basechars";

  static const init =
      '''CREATE TABLE $tn (
          $cId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $cName TEXT NOT NULL, 
          $cIcon TEXT,
          $cChars TEXT,
          $cBaseChars TEXT
        )''';

  int? id;
  String name = ""; // Никнейм
  CustomImageData? icon; // Аватар
  CharValues chars = CharValues(); // Кэш
  CharValues baseChars = CharValues(); // Базовые хар-ки

  Profile({
    this.name = "",
    this.icon,
    required this.chars,
    required this.baseChars
  });

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cName: name,
      cIcon: icon?.toJson(),
      cChars: chars.toJson(),
      cBaseChars: baseChars.toJson(),
    };
    if (id != null) {
      map[cId] = id;
    }
    return map;
  }

  Profile.fromMap(Map map) {
    id = map[cId];
    name = map[cName];
    icon = map[cIcon] == null ? null : CustomImageData.fromJson(map[cIcon]);
    chars = map[cChars] == null ? CharValues() : CharValues.fromJson(map[cChars]);
    baseChars = map[cBaseChars] == null ? CharValues() : CharValues.fromJson(map[cBaseChars]);
  }
}

// Базовый репозиторий пользователей
class ProfileRepository {
  Database db = DB.db!;

  Future<Profile> insert(Profile tsk) async {
    tsk.id = await db.insert(Profile.tn, tsk.toMap());
    return tsk;
  }

  Future<List<int>> insertBatch(Iterable<Profile> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Profile m in models) {
        res.add(await txn.insert(Profile.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<Profile?> get() async {
    List<Map> maps = await db.query(Profile.tn);
    if (maps.isNotEmpty) {
      return Profile.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(int id) async {
    await deleteIconIfSetupNull(id: id);
    return await db.delete(Profile.tn, where: '${Profile.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(Profile usr) async {
    await deleteIconIfSetupNull(obj: usr);
    return await db.update(
      Profile.tn,
      usr.toMap(),
      where: '${Profile.cId} = ?',
      whereArgs: [usr.id],
    );
  }

  Future deleteIconIfSetupNull({int? id, Profile? obj}) async {
    // Если удаление
    if (id != null) {
      var oldObject = await get();
      // Удаляем, если было
      if (oldObject != null &&
          oldObject.icon != null &&
          oldObject.icon!.isImage) {
        await FileService.deleteOldFile(oldObject.icon!.imagePath);
      }
    }
    // Если обновление
    else if (obj != null) {
      var oldObject = await get();
      // Удаляем, если было и изменилось
      if (oldObject != null &&
          oldObject.icon != null &&
          oldObject.icon!.imagePath != obj.icon?.imagePath &&
          oldObject.icon!.isImage) {
        await FileService.deleteOldFile(oldObject.icon!.imagePath);
      }
    }
  }
}
