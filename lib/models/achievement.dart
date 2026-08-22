import 'package:life_game/data/db.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/models/other/image.dart';
import 'package:life_game/services/file_storage_service.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

// Достижение
class Achievement {
  // ------------ Схема ------------
  static const tn = "achievements";
  
  static const cId = "_id";
  static const cTitle = "_title";
  static const cDescription = "_description";
  static const cRarity = "_rarity";
  static const cDate = "_date";
  static const cIcon = "_icon";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTitle TEXT NOT NULL, 
          $cDescription TEXT, 
          $cRarity INTEGER,
          $cDate INTEGER,
          $cIcon TEXT
        );
        ''';

  // ------------ Поля ------------
  String id = "";
  String title = "";
  String description = "";
  AchievRar rarity = AchievRar.common;
  DateTime? date;
  CustomImageData? icon;

  // ------------ Конструкторы ------------
  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.rarity,
    this.date,
    this.icon,
  });

  factory Achievement.create({
    required String title,
    String description = "",
    AchievRar rarity = AchievRar.common,
    DateTime? date,
    CustomImageData? icon,
  }) {
    final guid = const Uuid().v4();
    return Achievement(
      id: guid,
      title: title,
      description: description,
      rarity: rarity,
      date: date,
      icon: icon,
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,
      cTitle: title,
      cDescription: description,
      cRarity: rarity.index,
      cDate: date?.millisecondsSinceEpoch,
      cIcon: icon?.toJson(),
    };
  }

  Achievement.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    description = map[cDescription] ?? "";
    rarity = allAchievRar[map[cRarity] ?? 0];
    date = map[cDate] == null ? null : DateTime.fromMillisecondsSinceEpoch(map[cDate]);
    icon = map[cIcon] == null ? null : CustomImageData.fromJson(map[cIcon]);
  }
}

// Базовый репозиторий достижений
class AchievementRepository {
  Database db = DB.db!;
  
  Future<List<Achievement>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Achievement.tn);
    return maps.map((m) => Achievement.fromMap(m)).toList();
  }

  Future<Achievement> insert(Achievement ach) async {
    await db.insert(Achievement.tn, ach.toMap());
    return ach;
  }

  Future<List<int>> insertBatch(Iterable<Achievement> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Achievement m in models) {
        res.add(await txn.insert(Achievement.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<Achievement?> get(String id) async {
    List<Map> maps = await db.query(Achievement.tn, where: '${Achievement.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Achievement.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String id) async {
    await deleteIconIfSetupNull(id: id);
    return await db.delete(Achievement.tn, where: '${Achievement.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(Achievement ach) async {
    await deleteIconIfSetupNull(obj: ach);
    return await db.update(Achievement.tn, ach.toMap(),
        where: '${Achievement.cId} = ?', whereArgs: [ach.id]);
  }

  Future deleteIconIfSetupNull({String? id, Achievement? obj}) async {
    // Если удаление
    if (id != null) {
      var oldObject = await get(id);
      // Удаляем, если было
      if (oldObject != null &&
          oldObject.icon != null &&
          oldObject.icon!.isImage) {
        await FileService.deleteOldFile(oldObject.icon!.imagePath);
      }
    }
    // Если обновление
    else if (obj != null) {
      var oldObject = await get(obj.id);
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