// Привязка скрипта к уже созданным через него задачам
import 'package:life_game/data/db.dart';
import 'package:life_game/models/script.dart';
import 'package:life_game/models/task.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
class ScriptTask {
  // ------------ Схема ------------
  static const tn = "script_tasks";
  
  static const cScriptId = "_script_id";
  static const cTaskId = "_task_id";
  static const cDate = "_date";

  static const init = '''CREATE TABLE $tn (
          $cScriptId TEXT NOT NULL, 
          $cTaskId TEXT NOT NULL,
          $cDate INTEGER,
          PRIMARY KEY ($cScriptId, $cTaskId),
          FOREIGN KEY ($cScriptId) REFERENCES ${Script.tn}(${Script.cId}) ON DELETE CASCADE,
          FOREIGN KEY ($cTaskId) REFERENCES ${Task.tn}(${Task.cId}) ON DELETE CASCADE
        );
        ''';

  // ------------ Поля ------------
  String scriptId = "";
  String taskId = "";
  DateTime date = DateTime.now();

  // ------------ Конструкторы ------------
  ScriptTask({
    required this.scriptId,
    required this.taskId,
    required this.date,
  });

  factory ScriptTask.create({
    required String scriptId,
    required String taskId,
    DateTime? date,
  }) {
    return ScriptTask(
      scriptId: scriptId,
      taskId: taskId,
      date: date ?? DateTime.now(),
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cScriptId: scriptId,
      cTaskId: taskId,
      cDate: date.millisecondsSinceEpoch,
    };
  }

  ScriptTask.fromMap(Map map) {
    scriptId = map[cScriptId];
    taskId = map[cTaskId];
    date = DateTime.fromMillisecondsSinceEpoch(map[cDate]);
  }
}

// Базовый репозиторий привязок
class ScriptTaskRepository {
  
  Database db = DB.db!;
  
  Future<List<ScriptTask>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(ScriptTask.tn);
    return maps.map((m) => ScriptTask.fromMap(m)).toList();
  }

  Future<ScriptTask> insert(ScriptTask st) async {
    await db.insert(ScriptTask.tn, st.toMap());
    return st;
  }

  Future<List<int>> insertBatch(Iterable<ScriptTask> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (ScriptTask m in models) {
        res.add(await txn.insert(ScriptTask.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<ScriptTask?> get(String scriptId, String taskId) async {
    List<Map> maps = await db.query(
      ScriptTask.tn, 
      where: '${ScriptTask.cScriptId} = ? AND ${ScriptTask.cTaskId} = ?', 
      whereArgs: [scriptId, taskId]
    );
    if (maps.isNotEmpty) {
      return ScriptTask.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String scriptId, String taskId) async {
    return await db.delete(
      ScriptTask.tn, 
      where: '${ScriptTask.cScriptId} = ? AND ${ScriptTask.cTaskId} = ?', 
      whereArgs: [scriptId, taskId]
    );
  }

  Future<int?> update(ScriptTask st) async {
    return await db.update(
      ScriptTask.tn, 
      st.toMap(),
      where: '${ScriptTask.cScriptId} = ? AND ${ScriptTask.cTaskId} = ?', 
      whereArgs: [st.scriptId, st.taskId]
    );
  }
}