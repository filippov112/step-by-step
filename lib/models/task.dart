import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/enums/task_status.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/models/target.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/services/spirit_calculator.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';


// Задача
class Task {
  // ------------ Схема ------------
  static const tn = "tasks";
  
  static const cId = "_id";
  static const cTargetId = "_target_id";
  static const cSuccess = "_success";
  static const cDescription = "_description";
  static const cDate = "_date";
  static const cSpiritFragments = "_sf";
  static const cStatus = "_done";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTargetId TEXT,
          $cSuccess INTEGER,
          $cDescription TEXT,
          $cDate INTEGER,
          $cSpiritFragments INTEGER,
          $cStatus INTEGER,
          FOREIGN KEY ($cTargetId) REFERENCES ${Target.tn}(${Target.cId}) ON DELETE CASCADE
        );
        ''';

  // ------------ Поля ------------

  String id = '';
  String targetId = ''; // Цель
  int success = 0; // Процент успеха
  String description = ""; // Описание
  DateTime date = DateTool.today(); // Дата
  TaskStatus status = TaskStatus.done; // Статус
  int spiritFragments = 0; // Фрагменты духа

  // ------------ Конструкторы ------------

  Task({
    required this.id,
    required this.targetId,
    required this.success,
    required this.description,
    required this.date,
    required this.status,
    required this.spiritFragments,
  });

  factory Task.create({
    required String targetId,
    int success = 0,
    String? description,
    required DateTime date,
    int efforts = 0,
    TaskStatus status = TaskStatus.done
  }) {
    final guid = const Uuid().v4();
    return Task(
      id: guid,
      targetId: targetId,
      success: success,
      description: description ?? '',
      date: date,
      status: status,
      spiritFragments: efforts,
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,
      cTargetId: targetId,
      cSuccess: success,
      cDescription: description,
      cDate: DateTool.datetimeToDays(date),
      cStatus: status.index,
      cSpiritFragments: spiritFragments,
    };
  }

  Task.fromMap(Map map) {
    id = map[cId];
    targetId = map[cTargetId];
    success = map[cSuccess];
    description = map[cDescription];
    date = DateTool.joinDateTime(date: map[cDate]) ?? DateTool.today();
    status = TaskStatus.values[map[cStatus]];
    spiritFragments = map[cSpiritFragments] ?? 0;
  }
}

// Базовый репозиторий
class TaskRepository {
  Database db = DB.db!;
  final classRepo = ProjectRepository();
  final userRepo = ProfileRepository();
  
  Future<List<Task>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Task.tn);
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<List<Task>> getByTarget(String? targetId) async {
    if (targetId == null) return [];
    List<Map<String, Object?>> maps = await db.query(Task.tn, where: '${Task.cTargetId} = ?', whereArgs: [targetId]);
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<List<Task>> getByProject(String projectId) async {
    List<Map<String, Object?>> maps = await db.rawQuery('''
      SELECT at.* FROM ${Target.tn} w JOIN ${Task.tn} at ON w.${Target.cProjectId} = ? AND at.${Task.cTargetId} = w.${Target.cId}
    ''', [projectId]);
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<Task?> get(String id) async {
    List<Map> maps = await db.query(Task.tn, where: '${Task.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  // ----------- Изменения ----------------

  Future<Task> insert(Task rw) async {
    await _updateProfile(TransactionType.add, rw);
    await db.insert(Task.tn, rw.toMap());
    return rw;
  }

  Future<List<int>> insertBatch(Iterable<Task> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Task m in models) {
        await _updateProfile(TransactionType.add, m);
        res.add(await txn.insert(Task.tn, m.toMap()));
      }
    });
    return res;
  }

  Future delete(String id) async {
    var rw = await get(id);
    if (rw == null) return;
    await _updateProfile(TransactionType.remove, rw);
    await db.delete(Task.tn, where: '${Task.cId} = ?', whereArgs: [id]);
  }

  Future update(Task rw) async {
    await _updateProfile(TransactionType.update, rw);
    return await db.update(Task.tn, rw.toMap(),
        where: '${Task.cId} = ?', whereArgs: [rw.id]);
  }

  // ---------------------------------------

  // Рассчитать дельту
  Future<int> _getDelta(TransactionType type, Task rw) async {
    int result = 0;
    switch (type) {
      case TransactionType.update: {
        var oldRecord = await get(rw.id);
        result = rw.spiritFragments - (oldRecord?.spiritFragments ?? 0);
      }
      case TransactionType.add: {
        result = rw.spiritFragments;
      }
      case TransactionType.remove: {
        result = - rw.spiritFragments;
      }
    }
    return result;
  }

  // Добавить дельту к пользователю
  Future _updateProfile(TransactionType type, Task rw) async {
    var deltaEfforts = await _getDelta(type, rw);
    var user = await userRepo.get();
    user?.spiritFragments += deltaEfforts;
    if (user == null) return;
    await userRepo.update(user);
    await SpiritCalculator.recalcLevelUser(user);
  }
}

enum TransactionType {
  add,
  remove,
  update
}