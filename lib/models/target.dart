import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/enums/target_difficulty.dart';
import 'package:chaos_control/models/enums/target_status.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';


// Цель
class Target {

  // ------------ Схема ------------

  static const tn = "targets";
  static const cId = "_id";

  static const cTitle = "_title";
  static const cGroup = "_group";
  static const cDesc = "_desc";
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
    $cDesc TEXT NOT NULL,
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
  String desc = ""; // Формулировка
  bool favorite = false; // Избранное
  TargetStatus status = TargetStatus.breaking; // Статус
  DateTime? created = DateTime.now(); // Дата создания
  DateTime? destroyed; // Дата разрушения
  TargetDiff difficulty = TargetDiff.F; // Сложность
  String? projectId; // Связанный проект

  // ------------ Конструкторы ------------

  Target({
    required this.id, 
    required this.title, 
    required this.group,
    required this.desc, 
    required this.favorite,
    required this.status,
    required this.created,
    required this.destroyed,
    required this.difficulty,
    required this.projectId
  });

  factory Target.create({
    required String title,
    required String desc,
    String group = '',
    bool favorite = false,
    TargetStatus status = TargetStatus.breaking,
    DateTime? created,
    DateTime? destroyed,
    TargetDiff difficulty = TargetDiff.F,
    String? projectId
  }) {
    final guid = const Uuid().v4();
    final dateCreated = created ?? DateTool.today();
    final dateKey = dateCreated.toIso8601String().substring(0, 10);
    final id = '$dateKey|$guid';

    return Target(
      id: id,
      title: title,
      desc: desc,
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
      cDesc: desc,
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
  Target.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    desc = map[cDesc];
    group = map[cGroup];
    favorite = map[cFavorite] == 1;
    status = TargetStatus.values[map[cStatus]];
    created = DateTool.joinDateTime(date: map[cCreated]);
    destroyed = DateTool.joinDateTime(date: map[cDestroyed]);
    difficulty = TargetDiff.values[map[cDifficulty]];
    projectId = map[cProjectId];
  }
}

// Базовый репозиторий
class TargetRepository {
  Database db = DB.db!;
  
  // Получить все
  Future<List<Target>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Target.tn);
    List<Target> res = [];
    for (Map m in maps) {
      res.add(Target.fromMap(m));
    }
    return res;
  }

  // Получить по проекту
  Future<List<Target>> getByProject(String projectId) async {
    List<Map<String, Object?>> maps = await db.query(Target.tn, where: '${Target.cProjectId} = ?', whereArgs: [projectId]);
    List<Target> res = [];
    for (Map m in maps) {
      res.add(Target.fromMap(m));
    }
    return res;
  }

  // Вставить
  Future<Target> insert(Target trg) async {
    await db.insert(Target.tn, trg.toMap());
    return trg;
  }

  // Вставить несколько
  Future<List<int>> insertBatch(Iterable<Target> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Target m in models) {
        res.add(
          await txn.insert(Target.tn, m.toMap()));
      }   
    });
    return res;
  }

  // Найти
  Future<Target?> get(String id) async {
    List<Map> maps = await db.query(Target.tn, where: '${Target.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Target.fromMap(maps.first as Map<String,Object?>);
    }
    return null;
  }

  // Удалить
  Future<int?> delete(String id) async {
    return await db.delete(Target.tn, where: '${Target.cId} = ?', whereArgs: [id]);
  }

  // Обновить
  Future<int?> update(Target t) async {
    return await db.update(Target.tn, t.toMap(),
        where: '${Target.cId} = ?', whereArgs: [t.id]);
  }
}