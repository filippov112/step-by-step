import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/services/file_storage_service.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
// Класс
class Class {
  static const tn = "classes";
  static const cId = "_id";
  static const cTitle = "_title";
  static const cDescription = "_description";
  static const cIcon = "_icon";
  static const cExperience = "_exp";
  static const cTime = "_time";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY,
          $cTitle TEXT NOT NULL,
          $cDescription TEXT NOT NULL,
          $cIcon TEXT,
          $cTime INTEGER,
          $cExperience INTEGER
        );
        ''';

  String id = "";
  String title = ""; // Название
  String description = ""; // Описание
  CustomImageData? icon; // Иконка
  int experience = 0; // Кэш опыта
  int time = 0; // Кэш времени

  Class({
    required this.id,
    required this.title,
    required this.description,
    required this.experience,
    required this.time,
    this.icon,
  });

  factory Class.create({
    required String title,
    String? description,
    CustomImageData? icon,
    int experience = 0,
    int time = 0
  }) {
    final guid = const Uuid().v4();
    return Class(
      id: guid,
      title: title,
      description: description ?? '',
      icon: icon,
      experience: experience,
      time: time
    );
  }

  Map<String, Object?> toMap() {
    return {
      cId: id,
      cTitle: title,
      cDescription: description,
      cIcon: icon?.toJson(),
      cExperience: experience,
      cTime: time
    };
  }

  Class.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    description = map[cDescription];
    icon = map[cIcon] == null ? null : CustomImageData.fromJson(map[cIcon]);
    experience = map[cExperience];
    time = map[cTime];
  }
}

// Репозиторий классов
class ClassRepository {
  Database db = DB.db!;

  Future<List<Class>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Class.tn);
    return maps.map((m) => Class.fromMap(m)).toList();
  }

  Future<Class> insert(Class classObj) async {
    await db.insert(Class.tn, classObj.toMap());
    return classObj;
  }

  Future<Class?> get(String id) async {
    List<Map> maps = await db.query(
      Class.tn,
      where: '${Class.cId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Class.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int> update(Class classObj) async {
    await deleteIconIfSetupNull(obj:classObj);
    return await db.update(
      Class.tn,
      classObj.toMap(),
      where: '${Class.cId} = ?',
      whereArgs: [classObj.id],
    );
  }

  Future<int?> delete(String id) async {
    await deleteIconIfSetupNull(id:id);
    return await db.delete(
      Class.tn,
      where: '${Class.cId} = ?',
      whereArgs: [id],
    );
  }

  Future deleteIconIfSetupNull({String? id, Class? obj}) async {
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