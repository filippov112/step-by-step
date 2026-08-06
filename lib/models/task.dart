import 'package:life_game/data/db.dart';
import 'package:life_game/models/task/task_difficulty.dart';
import 'package:life_game/models/task/task_priority.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

// Задача
class TaskModel {
  // ------------ Схема ------------
  static const tn = "tasks";
  
  static const cId = "_id";
  static const cTitle = "_title";
  static const cDesc = "_description";
  static const cDateTime = "_datetime";
  static const cDurationPlan = "_durationplan";
  static const cDurationFact = "_durationfact";
  static const cDone = "_done";
  static const cPriority = "_priority";
  static const cDifficulty = "_difficulty";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTitle TEXT NOT NULL, 
          $cDesc TEXT, 
          $cDateTime INTEGER,
          $cDurationPlan INTEGER,
          $cDurationFact INTEGER,
          $cDone INTEGER,
          $cPriority INTEGER,
          $cDifficulty INTEGER
        );
        ''';

  // ------------ Поля ------------

  String id = "";
  String title = ""; // Заголовок задачи
  String description = ""; // Описание
  DateTime? datetime; // Дата-время планирования
  int durationPlan = 60; // Ожидаемая продолжительность (минут)
  int durationFact = 0; // Фактическая продолжительность (минут)
  bool done = false; // Статус задачи (выполнено / невыполнено)
  TaskPriority priority = TaskPriority.medium; // Приоритет
  TaskDifficulty difficulty = TaskDifficulty.medium; // Сложность

  // ------------ Конструкторы ------------
  TaskModel({
    required this.id, 
    required this.title, 
    required this.description, 
    this.datetime, 
    required this.durationPlan,
    required this.durationFact,
    required this.done,
    required this.priority,
    required this.difficulty
  });

  factory TaskModel.create({
    required String title,
    String description = "",
    DateTime? datetime,
    int durationPlan = 60,
    int durationFact = 0,
    bool done = false,
    TaskPriority priority = TaskPriority.medium,
    TaskDifficulty difficulty = TaskDifficulty.medium
  }) {
    final guid = const Uuid().v4();
    final dateKey = (datetime ?? DateTime.now()).toIso8601String().substring(0, 10);
    final id = '$dateKey|$guid';
    return TaskModel(
      id: id,
      title: title,
      description: description,
      datetime: datetime,
      durationPlan: durationPlan,
      durationFact: durationFact,
      done: done,
      priority: priority,
      difficulty: difficulty
    );
  }

  // ------------ Сериализация ------------

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cId: id,
      cTitle: title,
      cDesc: description,
      cDateTime: (datetime ?? DateTime.now()).millisecondsSinceEpoch ~/ 60000,
      cDurationPlan: durationPlan,
      cDurationFact: durationFact,
      cDone: done ? 1 : 0,
      cPriority: priority.index,
      cDifficulty: difficulty.index
    };
    return map;
  }
  TaskModel.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    description = map[cDesc];
    datetime = map[cDateTime] == null ? null : DateTime.fromMillisecondsSinceEpoch(map[cDateTime] * 60000);
    durationPlan = map[cDurationPlan];
    durationFact = map[cDurationFact];
    done = map[cDone] == 1;
    priority = allTaskPriorities[map[cPriority]];
    difficulty = allTaskDifficulties[map[cDifficulty]];
  }
}

// Базовый репозиторий задач
class TaskRepository {
  Database db = DB.db!;
  
  // Получить все
  Future<List<TaskModel>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(TaskModel.tn);
    List<TaskModel> res = [];
    for (Map m in maps) {
      res.add(TaskModel.fromMap(m));
    }
    return res;
  }

  // Вставить
  Future<TaskModel> insert(TaskModel tsk) async {
    await db.insert(TaskModel.tn, tsk.toMap());
    return tsk;
  }

  // Вставить несколько
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

  // Найти
  Future<TaskModel?> get(String id) async {
    List<Map> maps = await db.query(TaskModel.tn, where: '${TaskModel.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return TaskModel.fromMap(maps.first as Map<String,Object?>);
    }
    return null;
  }

  // Удалить
  Future<int?> delete(String id) async {
    return await db.delete(TaskModel.tn, where: '${TaskModel.cId} = ?', whereArgs: [id]);
  }

  // Обновить
  Future<int?> update(TaskModel tsk) async {
    return await db.update(TaskModel.tn, tsk.toMap(),
        where: '${TaskModel.cId} = ?', whereArgs: [tsk.id]);
  }
}

