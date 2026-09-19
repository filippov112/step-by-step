import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/services/file_storage_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

// Смысл
class Purport {

  // ------------ Схема ------------

  static const tn = "purports";
  static const cId = "_id";

  static const cTitle = "_title";
  static const cDescription = "_description";
  static const cGroup = "_group";
  static const cIcon = "_icon";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 

          $cTitle TEXT NOT NULL, 
          $cIcon TEXT,
          $cDescription TEXT,
          $cGroup TEXT
        );
        ''';

  // ------------ Поля ------------
  String id = "";

  String title = ""; // Заголовок
  String description = ""; // Описание
  String group = ""; // Группа
  CustomImageData? icon; // Иконка

  // ------------ Конструкторы ------------

  Purport({
    required this.id,
    required this.title,
    required this.group,
    required this.description,
    this.icon,
  });

  factory Purport.create({
    required String title,
    String description = "",
    String group = "",
    CustomImageData? icon,
  }) {
    final guid = const Uuid().v4();
    return Purport(
      id: guid,
      icon: icon,
      title: title,
      description: description,
      group: group
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,
      cIcon: icon?.toJson(),
      cTitle: title,
      cDescription: description,
      cGroup: group
    };
  }

  Purport.fromMap(Map map) {
    id = map[cId];
    icon = map[cIcon] == null ? null : CustomImageData.fromJson(map[cIcon]);
    title = map[cTitle];
    description = map[cDescription] ?? "";
    group = map[cGroup];
  }

  // ------- Другое ---------

  static String? groupValidator(String? text) {
    if (text == null || text.isEmpty) return null;
    var parts = text.split('/');
    if (parts.any((e) => e.isEmpty)) return 'Части группы не могут быть пустыми';
    return null;
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
    await deleteIconIfSetupNull(id:id);
    return await db.delete(Purport.tn, where: '${Purport.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(Purport pur) async {
    await deleteIconIfSetupNull(obj:pur);
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