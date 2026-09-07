import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/services/file_storage_service.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:sqflite/sqflite.dart';

// Пользователь
class Profile {
  static const tn = "profiles";

  static const cId = "_id";
  static const cName = "_name";
  static const cIcon = "_icon";
  static const cBirthDate = "_dbirth";
  static const cSpiritFragments = "_sf";
  static const cLevel = "_lvl";
  static const cChars = "_chars";

  static const init =
      '''CREATE TABLE $tn (
          $cId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $cName TEXT NOT NULL, 
          $cIcon TEXT,
          $cBirthDate INTEGER,
          $cSpiritFragments INTEGER,
          $cLevel INTEGER,
          $cChars TEXT
        )''';

  int? id;
  String name = ""; // Никнейм
  CustomImageData? icon; // Аватар
  DateTime dateBirth = DateTime(2000); // Дата рождения
  int spiritFragments = 0; // Кэш усилий (чтобы не пересчитывать)
  int level = 1; // Кэш уровня (для уведомлений)
  Map<String,int>? chars = defaultChars(); // Характеристики

  String get age => DateTool.age(dateBirth, DateTime.now());

  static Map<String,int> defaultChars() {
    final res = <String,int>{};
    for (var c in Characteristics.values) {
      res[c.name] = 0;
    }
    return res;
  }

  Profile({
    this.name = "",
    this.icon,
    required this.dateBirth,
    this.spiritFragments = 0,
    this.level = 1,
    this.chars
  });

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cName: name,
      cIcon: icon?.toJson() ,
      cBirthDate: DateTool.datetimeToDays(dateBirth),
      cSpiritFragments: spiritFragments,
      cLevel: level,
      cChars: chars
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
    dateBirth = DateTool.joinDateTime(date: map[cBirthDate]) ?? DateTime(2000);
    spiritFragments = map[cSpiritFragments];
    level = map[cLevel];
    chars = map[cChars];
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
