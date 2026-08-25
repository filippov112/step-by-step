import 'package:life_game/data/db.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/tools/datetime.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';


// Задача
class Task {

  // ------------ Схема ------------

  static const tn = "tasks";
  
  static const cId = "_id";
  static const cTitle = "_title";
  static const cDesc = "_description";
  static const cDate = "_date";
  static const cTime = "_time";
  static const cDone = "_done";
  static const cPriority = "_priority";
  static const cDifficulty = "_difficulty";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTitle TEXT NOT NULL, 
          $cDesc TEXT NOT NULL, 
          $cDate INTEGER,
          $cTime INTEGER,
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
  bool done = false; // Статус задачи (выполнено / невыполнено)
  TaskPriority priority = TaskPriority.medium; // Приоритет
  TaskDifficulty difficulty = TaskDifficulty.medium; // Сложность

  // ------------ Конструкторы ------------

  Task({
    required this.id, 
    required this.title, 
    required this.description, 
    this.datetime, 
    required this.done,
    required this.priority,
    required this.difficulty
  });

  factory Task.create({
    required String title,
    required String description,
    DateTime? datetime,
    bool done = false,
    TaskPriority priority = TaskPriority.medium,
    TaskDifficulty difficulty = TaskDifficulty.medium
  }) {
    final guid = const Uuid().v4();
    final dateKey = (datetime ?? DateTime.now()).toIso8601String().substring(0, 10);
    final id = '$dateKey|$guid';
    return Task(
      id: id,
      title: title,
      description: description,
      datetime: datetime,
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
      cDate: DateTool.datetimeToDays(datetime),
      cTime: DateTool.datetimeToTimeMinutes(datetime),
      cDone: done ? 1 : 0,
      cPriority: priority.index,
      cDifficulty: difficulty.index
    };
    return map;
  }
  Task.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    description = map[cDesc];
    datetime = DateTool.joinDateTime(date:map[cDate], time:map[cTime]);
    done = map[cDone] == 1;
    priority = allTaskPriorities[map[cPriority]];
    difficulty = allTaskDifficulties[map[cDifficulty]];
  }
}

// Базовый репозиторий задач
class TaskRepository {
  Database db = DB.db!;
  
  // Получить все
  Future<List<Task>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Task.tn);
    List<Task> res = [];
    for (Map m in maps) {
      res.add(Task.fromMap(m));
    }
    return res;
  }

  // Вставить
  Future<Task> insert(Task tsk) async {
    await db.insert(Task.tn, tsk.toMap());
    return tsk;
  }

  // Вставить несколько
  Future<List<int>> insertBatch(Iterable<Task> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Task m in models) {
        res.add(
          await txn.insert(Task.tn, m.toMap()));
      }   
    });
    return res;
  }

  // Найти
  Future<Task?> get(String id) async {
    List<Map> maps = await db.query(Task.tn, where: '${Task.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first as Map<String,Object?>);
    }
    return null;
  }

  // Удалить
  Future<int?> delete(String id) async {
    return await db.delete(Task.tn, where: '${Task.cId} = ?', whereArgs: [id]);
  }

  // Обновить
  Future<int?> update(Task tsk) async {
    return await db.update(Task.tn, tsk.toMap(),
        where: '${Task.cId} = ?', whereArgs: [tsk.id]);
  }
}

extension TaskCopyWith on Task {
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? datetime,
    bool? done,
    TaskPriority? priority,
    TaskDifficulty? difficulty,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      datetime: datetime ?? this.datetime,
      done: done ?? this.done,
      priority: priority ?? this.priority,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

extension TaskHelpers on Task {
  bool get isOverdue => !done && datetime != null && datetime!.isBefore(DateTime.now());
}