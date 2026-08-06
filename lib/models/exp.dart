import 'package:life_game/data/db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

class ExpModel {
  static const tn = "experience";
  static const cId = "_id";
  // Числовые значения
  static const cExp = "_exp";
  static const cTime = "_time";
  static const cKarma = "_karma";
  // Привязки
  static const cGroup = "_group"; // Группа характеристик
  static const cProject = "_project"; // Проект
  static const cTask = "_task"; // Задача
  // Учитывается (если проставлена дата)
  static const cDate = "_date";
  

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cGroup TEXT, 
          $cProject TEXT, 
          $cTask TEXT,
          $cExp INTEGER,
          $cTime INTEGER,
          $cKarma INTEGER, 
          $cDate INTEGER
        )''';

  String id = "";
  String? group;
  String? project;
  String? task;
  int exp = 0;
  int time = 0;
  int karma = 0;
  DateTime? date;

  ExpModel({
    required this.id,
    this.group, 
    this.project, 
    this.task,
    this.exp = 0,
    this.time = 0,
    this.karma = 0,
    this.date,
  });

  // --- Фабрика для создания НОВОЙ задачи ---
  factory ExpModel.create({
    String? group, 
    String? project, 
    String? task,
    int exp = 0,
    int time = 0,
    int karma = 0,
    DateTime? date
  }) {
    final guid = const Uuid().v4(); // Генерируем GUID
    final dateKey = DateTime.now().toIso8601String().substring(0, 10); // "2026-08-04"
    final id = '$dateKey|$guid'; // Составной ID
    
    return ExpModel(
      id: id,
      group: group,
      project: project,
      task: task,
      exp: exp,
      time: time,
      karma: karma,
      date: date
    );
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cId: id,
      cGroup: group,
      cProject: project,
      cTask: task,
      cExp: exp,
      cTime: time,
      cKarma: karma,
      cDate: (date ?? DateTime.now()).millisecondsSinceEpoch ~/ 60000
    };
    return map;
  }
  ExpModel.fromMap(Map map) {
    id = map[cId];
    group = map[cGroup];
    project = map[cProject];
    task = map[cTask];
    exp = map[cExp];
    time = map[cTime];
    karma = map[cKarma];
    date = map[cDate] == null ? null : DateTime.fromMillisecondsSinceEpoch(map[cDate] * 60000);
  }
}


class ExpProvider {
  Database db = DB.db!;
  
  Future<List<ExpModel>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(ExpModel.tn);
    List<ExpModel> res = [];
    for (Map m in maps) {
      res.add(ExpModel.fromMap(m));
    }
    return res;
  }

  Future<ExpModel> insert(ExpModel tsk) async {
    await db.insert(ExpModel.tn, tsk.toMap());
    return tsk;
  }

  Future<List<int>> insertBatch(Iterable<ExpModel> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (ExpModel m in models) {
        res.add(
          await txn.insert(ExpModel.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<ExpModel?> get(String id) async {
    List<Map> maps = await db.query(ExpModel.tn, where: '${ExpModel.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return ExpModel.fromMap(maps.first as Map<String,Object?>);
    }
    return null;
  }

  Future<int?> delete(String id) async {
    return await db.delete(ExpModel.tn, where: '${ExpModel.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(ExpModel tsk) async {
    return await db.update(ExpModel.tn, tsk.toMap(),
        where: '${ExpModel.cId} = ?', whereArgs: [tsk.id]);
  }
}

