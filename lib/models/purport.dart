import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/enums/purport_type.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/services/file_storage_service.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

// Смысл
class Purport {
  // ------------ Схема ------------
  static const tn = "purports";
  
  static const cId = "_id";
  static const cTitle = "_title";
  static const cDescription = "_description";
  static const cType = "_type";
  static const cDate = "_date";
  static const cIcon = "_icon";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTitle TEXT NOT NULL, 
          $cDescription TEXT, 
          $cType INTEGER,
          $cDate INTEGER,
          $cIcon TEXT
        );
        ''';

  // ------------ Поля ------------
  String id = "";
  String title = "";
  String description = "";
  PurportType type = PurportType.wealth;
  DateTime? date;
  CustomImageData? icon;

  // ------------ Конструкторы ------------
  Purport({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.date,
    this.icon,
  });

  factory Purport.create({
    required String title,
    String description = "",
    PurportType type = PurportType.wealth,
    DateTime? date,
    CustomImageData? icon,
  }) {
    final guid = const Uuid().v4();
    return Purport(
      id: guid,
      title: title,
      description: description,
      type: type,
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
      cType: type.index,
      cDate: DateTool.datetimeToDays(date),
      cIcon: icon?.toJson(),
    };
  }

  Purport.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    description = map[cDescription] ?? "";
    type = PurportType.values[map[cType] ?? 0];
    date = DateTool.joinDateTime(date: map[cDate]);
    icon = map[cIcon] == null ? null : CustomImageData.fromJson(map[cIcon]);
  }
}

// Базовый репозиторий
class PurportRepository {
  Database db = DB.db!;
  
  Future<List<Purport>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Purport.tn);
    return maps.map((m) => Purport.fromMap(m)).toList();
  }

  Future<Purport> insert(Purport pur) async {
    await db.insert(Purport.tn, pur.toMap());
    return pur;
  }

  Future<List<int>> insertBatch(Iterable<Purport> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Purport m in models) {
        res.add(await txn.insert(Purport.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<Purport?> get(String id) async {
    List<Map> maps = await db.query(Purport.tn, where: '${Purport.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Purport.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String id) async {
    await deleteIconIfSetupNull(id: id);
    return await db.delete(Purport.tn, where: '${Purport.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(Purport pur) async {
    await deleteIconIfSetupNull(obj: pur);
    return await db.update(Purport.tn, pur.toMap(),
        where: '${Purport.cId} = ?', whereArgs: [pur.id]);
  }

  Future deleteIconIfSetupNull({String? id, Purport? obj}) async {
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