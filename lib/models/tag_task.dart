import 'package:life_game/data/db.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/task.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
// Привязка тега к задаче
class TagTask {
  static const tn = "tag_tasks";
  static const cTaskId = "_task_id";
  static const cTagId = "_tag_id";

  static const init = '''CREATE TABLE $tn (
          $cTaskId TEXT NOT NULL, 
          $cTagId TEXT NOT NULL,
          PRIMARY KEY ($cTaskId, $cTagId),
          FOREIGN KEY ($cTaskId) REFERENCES ${Task.tn}(${Task.cId}) ON DELETE CASCADE,
          FOREIGN KEY ($cTagId) REFERENCES ${Tag.tn}(${Tag.cId}) ON DELETE CASCADE
        );
        ''';

  String taskId = "";
  String tagId = "";

  TagTask({required this.taskId, required this.tagId});

  factory TagTask.create({required String taskId, required String tagId}) {
    return TagTask(taskId: taskId, tagId: tagId);
  }

  Map<String, Object?> toMap() {
    return {cTaskId: taskId, cTagId: tagId};
  }

  TagTask.fromMap(Map map) {
    taskId = map[cTaskId];
    tagId = map[cTagId];
  }
}

// Базовый репозиторий привязок
class TagTaskRepository {
  Database db = DB.db!;
  List<TagTask>? _cache;
  bool _cacheDirty = true;
  
  Future<List<TagTask>> getAll() async {
    if (_cache != null && !_cacheDirty) {
      return _cache!;
    }
    List<Map<String, Object?>> maps = await db.query(TagTask.tn);
    _cache = maps.map((m) => TagTask.fromMap(m)).toList();
    _cacheDirty = false;
    return _cache!;
  }
  
  // Синхронный метод для быстрого доступа к кешу
  List<TagTask> getAllSync() {
    if (_cache == null) {
      // Если кеша нет, загружаем синхронно (только для чтения из кеша)
      throw Exception('Cache not initialized. Call getAll() first.');
    }
    return _cache!;
  }
  
  Future<TagTask> insert(TagTask tt) async {
    await db.insert(TagTask.tn, tt.toMap());
    _cacheDirty = true;
    return tt;
  }
  
  Future<TagTask?> get(String taskId, String tagId) async {
    List<Map> maps = await db.query(
      TagTask.tn, 
      where: '${TagTask.cTaskId} = ? AND ${TagTask.cTagId} = ?', 
      whereArgs: [taskId, tagId]
    );
    if (maps.isNotEmpty) {
      return TagTask.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String taskId, String tagId) async {
    _cacheDirty = true;
    return await db.delete(
      TagTask.tn, 
      where: '${TagTask.cTaskId} = ? AND ${TagTask.cTagId} = ?', 
      whereArgs: [taskId, tagId]
    );
  }
  
  // Метод для удаления всех тегов задачи
  Future<int?> deleteByTaskId(String taskId) async {
    _cacheDirty = true;
    return await db.delete(
      TagTask.tn, 
      where: '${TagTask.cTaskId} = ?', 
      whereArgs: [taskId]
    );
  }
}