import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/models/enums/wall_priority.dart';
import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';


// Стена
class Wall {

  // ------------ Схема ------------

  static const tn = "walls";
  
  static const cId = "_id";
  static const cTitle = "_title";
  static const cDesc = "_description";
  static const cStatus = "_done";
  static const cPriority = "_priority";
  static const cDifficulty = "_difficulty";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTitle TEXT NOT NULL, 
          $cDesc TEXT NOT NULL,
          $cStatus INTEGER,
          $cPriority INTEGER,
          $cDifficulty INTEGER
        );
        ''';

  // ------------ Поля ------------

  String id = "";
  String title = ""; // Заголовок
  String description = ""; // Описание
  WallStatus status = WallStatus.breaking; // Статус
  WallPriority priority = WallPriority.low; // Приоритет
  WallDiff difficulty = WallDiff.F; // Сложность

  // ------------ Конструкторы ------------

  Wall({
    required this.id, 
    required this.title, 
    required this.description, 
    required this.status,
    required this.priority,
    required this.difficulty
  });

  factory Wall.create({
    required String title,
    required String description,
    WallStatus status = WallStatus.breaking,
    WallPriority priority = WallPriority.medium,
    WallDiff difficulty = WallDiff.F
  }) {
    final guid = const Uuid().v4();
    final dateKey = (DateTime.now()).toIso8601String().substring(0, 10);
    final id = '$dateKey|$guid';
    return Wall(
      id: id,
      title: title,
      description: description,
      status: status,
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
      cStatus: status.index,
      cPriority: priority.index,
      cDifficulty: difficulty.index
    };
    return map;
  }
  Wall.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    description = map[cDesc];
    status = WallStatus.values[map[cStatus]];
    priority = WallPriority.values[map[cPriority]];
    difficulty = WallDiff.values[map[cDifficulty]];
  }
}

// Базовый репозиторий задач
class TaskRepository {
  Database db = DB.db!;
  
  // Получить все
  Future<List<Wall>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Wall.tn);
    List<Wall> res = [];
    for (Map m in maps) {
      res.add(Wall.fromMap(m));
    }
    return res;
  }

  // Вставить
  Future<Wall> insert(Wall wll) async {
    await db.insert(Wall.tn, wll.toMap());
    return wll;
  }

  // Вставить несколько
  Future<List<int>> insertBatch(Iterable<Wall> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Wall m in models) {
        res.add(
          await txn.insert(Wall.tn, m.toMap()));
      }   
    });
    return res;
  }

  // Найти
  Future<Wall?> get(String id) async {
    List<Map> maps = await db.query(Wall.tn, where: '${Wall.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Wall.fromMap(maps.first as Map<String,Object?>);
    }
    return null;
  }

  // Удалить
  Future<int?> delete(String id) async {
    return await db.delete(Wall.tn, where: '${Wall.cId} = ?', whereArgs: [id]);
  }

  // Обновить
  Future<int?> update(Wall wll) async {
    return await db.update(Wall.tn, wll.toMap(),
        where: '${Wall.cId} = ?', whereArgs: [wll.id]);
  }
}

extension WallCopyWith on Wall {
  Wall copyWith({
    String? id,
    String? title,
    String? description,
    WallStatus? status,
    WallPriority? priority,
    WallDiff? difficulty,
  }) {
    return Wall(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
