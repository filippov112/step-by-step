import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/services/file_storage_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

// Проект
class Project {
  static const tn = "projects";
  static const cId = "_id";

  static const cTitle = "_title";
  static const cGroup = "_group";
  static const cTarget = "_target";
  static const cHidden = "_hidden";
  static const cIcon = "_icon";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY,
          $cTitle TEXT NOT NULL,
          $cGroup TEXT NOT NULL,
          $cIcon TEXT,
          $cTarget TEXT NOT NULL,
          $cHidden INTEGER
        );
        ''';

  String id = "";
  String title = ""; // Название
  String target = ""; // Цель
  String group = ""; // Группа
  bool hidden = false; // Скрыт
  CustomImageData? icon; // Иконка

  Project({
    required this.id,
    required this.title,
    required this.target,
    required this.hidden,
    required this.group,
    this.icon,
  });

  factory Project.create({
    required String title,
    String? target,
    CustomImageData? icon,
    String group = "",
    bool hidden = false
  }) {
    final guid = const Uuid().v4();
    return Project(
      id: guid,
      title: title,
      target: target ?? '',
      icon: icon,
      group: group,
      hidden: hidden
    );
  }

  Map<String, Object?> toMap() {
    return {
      cId: id,
      cTitle: title,
      cTarget: target,
      cIcon: icon?.toJson(),
      cHidden: hidden ? 1 : 0,
      cGroup: group
    };
  }

  Project.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    target = map[cTarget];
    icon = map[cIcon] == null ? null : CustomImageData.fromJson(map[cIcon]);
    hidden = map[cHidden] == 1;
    group = map[cGroup];
  }
}

// Репозиторий
class ProjectRepository {
  Database db = DB.db!;

  Future<List<Project>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Project.tn);
    return maps.map((m) => Project.fromMap(m)).toList();
  }

  Future<Project> insert(Project classObj) async {
    await db.insert(Project.tn, classObj.toMap());
    return classObj;
  }

  Future<Project?> get(String id) async {
    List<Map> maps = await db.query(
      Project.tn,
      where: '${Project.cId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Project.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int> update(Project classObj) async {
    await deleteIconIfSetupNull(obj:classObj);
    return await db.update(
      Project.tn,
      classObj.toMap(),
      where: '${Project.cId} = ?',
      whereArgs: [classObj.id],
    );
  }

  Future<int?> delete(String id) async {
    await deleteIconIfSetupNull(id:id);
    return await db.delete(
      Project.tn,
      where: '${Project.cId} = ?',
      whereArgs: [id],
    );
  }

  Future deleteIconIfSetupNull({String? id, Project? obj}) async {
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