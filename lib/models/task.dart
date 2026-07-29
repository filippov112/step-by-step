import 'package:life_game/data/db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class TaskModel {
  static const tn = "tasks";
  static const cId = "_id";
  static const cTitle = "title";
  static const cDesc = "description";
  static const cDate = "dtime";
  static const cExp = "exp";

  static const init = '''CREATE TABLE $tn (
          $cId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $cTitle TEXT NOT NULL, 
          $cDesc TEXT, 
          $cExp INTEGER, 
          $cDate DATETIME
        )''';

  int? id;
  String title = "";
  String? description;
  DateTime dateTime = DateTime(0,0,0,8);
  int exp = 0;

  TaskModel({this.id, required this.title, this.description, required this.dateTime, required this.exp});

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cTitle: title,
      cDesc: description ?? "",
      cDate: dateTime.millisecondsSinceEpoch,
      cExp: exp
    };
    if (id != null) {
      map[cId] = id;
    }
    return map;
  }

  TaskModel.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    description = map[cDesc];
    dateTime = DateTime.fromMillisecondsSinceEpoch(map[cDate]);
    exp = map[cExp];
  }
}


class TaskProvider {
  Database db = DB.db!;
  

  Future<List<TaskModel>> getAllTasks() async {
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
    tsk.id = await db.insert(TaskModel.tn, tsk.toMap());
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

  Future<TaskModel?> getTask(int id) async {
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

  Future<int?> delete(int id) async {
    return await db.delete(TaskModel.tn, where: '${TaskModel.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(TaskModel tsk) async {
    return await db.update(TaskModel.tn, tsk.toMap(),
        where: '${TaskModel.cId} = ?', whereArgs: [tsk.id]);
  }
}

