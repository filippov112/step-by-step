import 'package:life_game/data/db.dart';
import 'package:life_game/models/enums/script_type.dart';
import 'package:life_game/models/task.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

class Script {
  // ------------ Схема ------------
  static const tn = "scripts";
  
  static const cId = "_id";
  static const cTitle = "_title";
  static const cStatus = "_status";
  static const cType = "_type";
  static const cJsonParameters = "_json_parameters";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTitle TEXT NOT NULL, 
          $cStatus INTEGER,
          $cType INTEGER,
          $cJsonParameters TEXT
        );
        ''';

  // ------------ Поля ------------
  String id = "";
  String title = "";
  bool status = false;
  ScriptType type = ScriptType.everyXDay;
  String jsonParameters = "";

  // ------------ Конструкторы ------------
  Script({
    required this.id,
    required this.title,
    required this.status,
    required this.type,
    required this.jsonParameters,
  });

  factory Script.create({
    required String title,
    bool status = false,
    ScriptType type = ScriptType.everyXDay,
    String jsonParameters = "",
  }) {
    final guid = const Uuid().v4();
    return Script(
      id: guid,
      title: title,
      status: status,
      type: type,
      jsonParameters: jsonParameters,
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,
      cTitle: title,
      cStatus: status ? 1 : 0,
      cType: type.index,
      cJsonParameters: jsonParameters,
    };
  }

  Script.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    status = map[cStatus] == 1;
    type = ScriptType.values[map[cType]];
    jsonParameters = map[cJsonParameters] ?? "";
  }
}

class ScriptRepository {
  Database db = DB.db!;
  
  Future<List<Script>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Script.tn);
    return maps.map((m) => Script.fromMap(m)).toList();
  }

  Future<Script> insert(Script scr) async {
    await db.insert(Script.tn, scr.toMap());
    return scr;
  }

  Future<List<int>> insertBatch(Iterable<Script> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Script m in models) {
        res.add(await txn.insert(Script.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<Script?> get(String id) async {
    List<Map> maps = await db.query(Script.tn, where: '${Script.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Script.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String id) async {
    return await db.delete(Script.tn, where: '${Script.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(Script scr) async {
    return await db.update(Script.tn, scr.toMap(),
        where: '${Script.cId} = ?', whereArgs: [scr.id]);
  }
}

// ------------ ScriptTask ------------
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