import 'package:life_game/data/db.dart';
import 'package:life_game/models/task/task_difficulty.dart';
import 'package:life_game/models/task/task_priority.dart';
import 'package:life_game/models/task/task_status.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

class TaskModel {
  static const tn = "tasks";
  static const tnChild = "taskschild";
  static const cId = "_id";

  static const cTitle = "_title";
  static const cDesc = "_description";

  static const cDateStart = "_start";
  static const cDateDeadline = "_deadline";
  static const cDateEnd = "_end";

  static const cStatus = "_status";
  static const cPriority = "_priority";
  static const cDifficulty = "_difficulty";

  static const cParent = "_parent";
  static const cChild = "_child";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTitle TEXT NOT NULL, 
          $cDesc TEXT, 
          $cDateStart DATETIME,
          $cDateDeadline DATETIME,
          $cDateEnd DATETIME,
          $cStatus INTEGER,
          $cPriority INTEGER,
          $cDifficulty INTEGER
        );

        CREATE TABLE $tnChild (
          $cChild TEXT NOT NULL,
          $cParent TEXT NOT NULL,
          PRIMARY KEY ($cParent, $cChild)
          FOREIGN KEY ($cChild) REFERENCES $tn($cId) ON DELETE CASCADE
          FOREIGN KEY ($cParent) REFERENCES $tn($cId) ON DELETE CASCADE
        );
        ''';

  String id = "";

  String title = "";
  String description = "";

  DateTime? dateStart;
  DateTime? dateDead;
  DateTime? dateEnd;
  
  TaskStatus status = TaskStatus.wait;
  TaskPriority priority = TaskPriority.medium;
  TaskDifficulty difficulty = TaskDifficulty.medium;

  // TaskModel? parent;


  TaskModel({
    required this.id, 
    required this.title, 
    required this.description, 
    this.dateStart, 
    this.dateDead,
    this.dateEnd,
    required this.status,
    required this.priority,
    required this.difficulty,
    // this.parent
  });
  factory TaskModel.create({
    required String title,
    String description = "",
    DateTime? dateStart,
    DateTime? dateDead,
    DateTime? dateEnd,
    TaskStatus status = TaskStatus.wait,
    TaskPriority priority = TaskPriority.medium,
    TaskDifficulty difficulty = TaskDifficulty.medium,
    // TaskModel? parent
  }) {
    final guid = const Uuid().v4(); // Генерируем GUID
    final dateKey = (dateStart ?? DateTime.now()).toIso8601String().substring(0, 10);
    final id = '$dateKey|$guid'; // Составной ID
    return TaskModel(
      id: id,
      title: title,
      description: description,
      dateStart: dateStart,
      dateDead: dateDead,
      dateEnd: dateEnd,
      status: status,
      priority: priority,
      difficulty: difficulty,
      // parent: parent
    );
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cId: id,
      cTitle: title,
      cDesc: description,
      cDateStart: dateStart == null ? DateTime.now().millisecondsSinceEpoch : dateStart!.microsecondsSinceEpoch,
      cDateDeadline: dateDead == null ? DateTime.now().millisecondsSinceEpoch : dateDead!.microsecondsSinceEpoch,
      cDateEnd: dateEnd == null ? DateTime.now().millisecondsSinceEpoch : dateEnd!.microsecondsSinceEpoch,
      cStatus: status.index,
      cPriority: priority.index,
      cDifficulty: difficulty.index,
      // cParent: parent?.id
    };
    return map;
  }
  TaskModel.fromMap(
    Map map, 
    TaskModel? parent
    ) {
    id = map[cId];
    title = map[cTitle];
    description = map[cDesc];
    dateStart = map[cDateStart] == null ? null : DateTime.fromMillisecondsSinceEpoch(map[cDateStart]);
    dateStart = map[cDateStart] == null ? null : DateTime.fromMillisecondsSinceEpoch(map[cDateStart]);
    dateStart = map[cDateStart] == null ? null : DateTime.fromMillisecondsSinceEpoch(map[cDateStart]);
    description = map[cDesc];
    description = map[cDesc];
    description = map[cDesc];
    // parent = parent;
  }
}


class TaskProvider {
  Database db = DB.db!;
  
  Future<List<TaskModel>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(TaskModel.tn);
    List<TaskModel> res = [];
    for (Map m in maps) {
      TaskModel? parentTask;
      // if (m[TaskModel.cParent] != null)
      // {
      //   parentTask = maps.where((task) => task[TaskModel.cId] == m[TaskModel.cParent]).first as TaskModel?;
      // }
      res.add(TaskModel.fromMap(m, parentTask));
    }
    return res;
  }

  Future<TaskModel> insert(TaskModel tsk) async {
    await db.insert(TaskModel.tn, tsk.toMap());
    return tsk;
  }

  Future<List<int>> insertBatch(Iterable<TaskModel> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (TaskModel m in models) {
        res.add(
          await txn.insert(TaskModel.tn, m.toMap()));
      }   
    });
    return res;
  }

  Future<TaskModel?> get(String id) async {
    List<Map> maps = await db.query(TaskModel.tn, where: '${TaskModel.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      TaskModel? parentTask;
      // if (maps.first[TaskModel.cParent] != null)
      // {
      //   parentTask = await get(maps.first[TaskModel.cParent]);
      // }
      return TaskModel.fromMap(maps.first as Map<String,Object?>, parentTask);
    }
    return null;
  }

  Future<int?> delete(String id) async {
    return await db.delete(TaskModel.tn, where: '${TaskModel.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(TaskModel tsk) async {
    return await db.update(TaskModel.tn, tsk.toMap(),
        where: '${TaskModel.cId} = ?', whereArgs: [tsk.id]);
  }
}

