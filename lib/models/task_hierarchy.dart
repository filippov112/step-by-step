import 'package:life_game/data/db.dart';
import 'package:life_game/models/task.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Иерархия задач
class TaskHierarchy {

  // ------------ Схема ------------

  static const tn = "taskschild";
  static const tnTasks = "tasks";
  
  static const cId = "_id";
  static const cParent = "_parent";
  static const cChild = "_child";

  static const init = '''
        CREATE TABLE $tn (
          $cChild TEXT NOT NULL,
          $cParent TEXT NOT NULL,
          PRIMARY KEY ($cParent, $cChild)
          FOREIGN KEY ($cChild) REFERENCES $tnTasks($cId) ON DELETE CASCADE
          FOREIGN KEY ($cParent) REFERENCES $tnTasks($cId) ON DELETE CASCADE
        );
        ''';

  // ------------ Поля ------------

  String parentId = ""; // Задача-родитель
  String childId = ""; // Задача-потомок
  
  // ------------ Конструкторы ------------

  TaskHierarchy({
    required this.parentId, 
    required this.childId, 
  });

  // ------------ Сериализация ------------

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cParent: parentId,
      cChild: childId,
    };
    return map;
  }
  TaskHierarchy.fromMap(Map map) {
    parentId = map[cParent];
    childId = map[cChild];
  }
}

// Базовый репозиторий иерархии задач
class TaskHierarchyRepository {
  Database db = DB.db!;
  
  // Получить дочерние задачи
  Future<List<Task>> getByParent(String parentId) async {
    List<Map<String, Object?>> maps = await db.rawQuery('''
      SELECT t.* 
      FROM ${Task.tn} t 
      JOIN ${TaskHierarchy.tn} th 
        ON th.${TaskHierarchy.cChild} = t.${Task.cId} AND th.${TaskHierarchy.cParent} = ?;
    ''', [parentId, ]);
    List<Task> res = [];
    for (Map m in maps) {
      res.add(Task.fromMap(m));
    }
    return res;
  }

  // Вставить несколько
  Future insertBatch(Iterable<TaskHierarchy> items) async {
    await db.transaction((txn) async {
      for (TaskHierarchy m in items) {
        await txn.insert(TaskHierarchy.tn, m.toMap());
      }   
    });
  }

  // Удалить несколько дочерних
  Future deleteChildsBatch(Iterable<TaskHierarchy> items) async {
    await db.transaction((txn) async {
      for (TaskHierarchy m in items) {
        await txn.delete(TaskHierarchy.tn, where: '${TaskHierarchy.cChild} = ? AND ${TaskHierarchy.cParent} = ?', whereArgs: [m.childId, m.parentId]);
      }   
    });
  }
}

