import 'package:life_game/data/db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

class TaskModel {
  static const tn = "tasks";
  static const cId = "_id";
  static const cTitle = "_title";
  static const cDesc = "_description";
  static const cDate = "_dtime";
  static const cExp = "_exp";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTitle TEXT NOT NULL, 
          $cDesc TEXT, 
          $cExp INTEGER, 
          $cDate DATETIME
        )''';

  String id = "";
  String title = "";
  String description = "";
  DateTime? dateTime;
  int exp = 0;

  TaskModel({
    required this.id, 
    required this.title, 
    required this.description, 
    this.dateTime, 
    required this.exp
  });
  factory TaskModel.create({
    required String title,
    String description = "",
    DateTime? dateTime,
    int exp = 0,
  }) {
    final guid = const Uuid().v4(); // Генерируем GUID
    final dateKey = ((dateTime ?? DateTime.now) as DateTime).toIso8601String().substring(0, 10);
    final id = '$dateKey|$guid'; // Составной ID
    return TaskModel(
      id: id,
      title: title,
      description: description,
      dateTime: dateTime,
      exp: exp
    );
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cId: id,
      cTitle: title,
      cDesc: description,
      cDate: ((dateTime ?? DateTime.now) as DateTime).millisecondsSinceEpoch,
      cExp: exp
    };
    return map;
  }
  TaskModel.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    description = map[cDesc];
    dateTime = map[cDate] == null ? null : DateTime.fromMillisecondsSinceEpoch(map[cDate]);
    exp = map[cExp];
  }
}


class TaskProvider {
  Database db = DB.db!;
  
  Future<List<TaskModel>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(TaskModel.tn,
        columns: [
          TaskModel.cId, 
          TaskModel.cTitle, 
          TaskModel.cDesc, 
          TaskModel.cDate, 
          TaskModel.cExp
          ]
        );
    List<TaskModel> res = [];
    for (Map m in maps) {
      res.add(TaskModel.fromMap(m));
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
    List<Map> maps = await db.query(TaskModel.tn,
        columns: [
          TaskModel.cId, 
          TaskModel.cTitle, 
          TaskModel.cDesc, 
          TaskModel.cDate, 
          TaskModel.cExp
          ],
        where: '${TaskModel.cId} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return TaskModel.fromMap(maps.first as Map<String,Object?>);
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

