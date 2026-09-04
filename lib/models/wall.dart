import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';


// Стена
class Wall {

  // ------------ Схема ------------

  static const tn = "walls";
  static const cId = "_id";

  static const cTitle = "_title";
  static const cGroup = "_group";
  static const cTarget = "_target";
  static const cFavorite = "_favorite";
  static const cStatus = "_status";
  static const cCreated = "_created";
  static const cDestroyed = "_destroyed";
  static const cDifficulty = "_difficulty";
  static const cProjectId = "_project_id";

  static const init = '''CREATE TABLE $tn (
    $cId TEXT PRIMARY KEY, 
    $cTitle TEXT NOT NULL, 
    $cGroup TEXT,
    $cTarget TEXT NOT NULL,
    $cFavorite INTEGER,
    $cStatus INTEGER,
    $cCreated INTEGER,
    $cDestroyed INTEGER,
    $cDifficulty INTEGER,
    $cProjectId TEXT,
    FOREIGN KEY ($cProjectId) REFERENCES ${Project.tn}(${Project.cId}) ON DELETE CASCADE
  );
  ''';

  // ------------ Поля ------------

  String id = "";
  String title = ""; // Заголовок
  String group = ""; // Группа
  String target = ""; // Цель
  bool favorite = false; // Избранное
  WallStatus status = WallStatus.breaking; // Статус
  DateTime? created = DateTime.now(); // Дата создания
  DateTime? destroyed; // Дата разрушения
  WallDiff difficulty = WallDiff.F; // Сложность
  String? projectId; // Связанный проект

  // ------------ Конструкторы ------------

  Wall({
    required this.id, 
    required this.title, 
    required this.group,
    required this.target, 
    required this.favorite,
    required this.status,
    required this.created,
    required this.destroyed,
    required this.difficulty,
    required this.projectId
  });

  factory Wall.create({
    required String title,
    required String target,
    String group = '',
    bool favorite = false,
    WallStatus status = WallStatus.breaking,
    DateTime? created,
    DateTime? destroyed,
    WallDiff difficulty = WallDiff.F,
    String? projectId
  }) {
    final guid = const Uuid().v4();
    final dateCreated = created ?? DateTool.today();
    final dateKey = dateCreated.toIso8601String().substring(0, 10);
    final id = '$dateKey|$guid';

    return Wall(
      id: id,
      title: title,
      target: target,
      group: group,
      favorite: favorite,
      status: status,
      created: dateCreated,
      destroyed: destroyed,
      difficulty: difficulty,
      projectId: projectId
    );
  }

  // ------------ Сериализация ------------

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cId: id,
      cTitle: title,
      cTarget: target,
      cGroup: group,
      cFavorite: favorite ? 1 : 0,
      cStatus: status.index,
      cCreated: DateTool.datetimeToDays(created),
      cDestroyed: DateTool.datetimeToDays(destroyed),
      cDifficulty: difficulty.index,
      cProjectId: projectId
    };
    return map;
  }
  Wall.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    target = map[cTarget];
    group = map[cGroup];
    favorite = map[cFavorite] == 1;
    status = WallStatus.values[map[cStatus]];
    created = DateTool.joinDateTime(date: map[cCreated]);
    destroyed = DateTool.joinDateTime(date: map[cDestroyed]);
    difficulty = WallDiff.values[map[cDifficulty]];
    projectId = map[cProjectId];
  }
}

// Базовый репозиторий задач
class WallRepository {
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
    String? target,
    String? group,
    bool? favorite,
    WallStatus? status,
    DateTime? created,
    DateTime? destroyed,
    WallDiff? difficulty,
    String? projectId
  }) {
    return Wall(
      id: id ?? this.id,
      title: title ?? this.title,
      target: target ?? this.target,
      group: group ?? this.group,
      favorite: favorite ?? this.favorite,
      status: status ?? this.status,
      created: created ?? this.created,
      destroyed: destroyed ?? this.destroyed,
      difficulty: difficulty ?? this.difficulty,
      projectId: projectId ?? this.projectId
    );
  }
}
