import 'package:life_game/data/db.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/task.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';
// Награда за задачу (опыт и время, привязанные к некоторому навыку)
class TaskReward {
  // ------------ Схема ------------
  static const tn = "rewards";
  
  static const cId = "_id";
  static const cSkillId = "_skill_id";
  static const cTaskId = "_task_id";
  static const cDate = "_date";
  static const cExperience = "_experience";
  static const cTime = "_time";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cSkillId TEXT NOT NULL, 
          $cTaskId TEXT NOT NULL,
          $cDate INTEGER,
          $cExperience INTEGER,
          $cTime INTEGER,
          FOREIGN KEY ($cSkillId) REFERENCES ${Skill.tn}(${Skill.cId}) ON DELETE CASCADE,
          FOREIGN KEY ($cTaskId) REFERENCES ${Task.tn}(${Task.cId}) ON DELETE CASCADE
        );
        ''';

  // ------------ Поля ------------
  String id = "";
  String skillId = "";
  String taskId = "";
  DateTime? date;
  int experience = 0;
  int time = 0;

  // ------------ Конструкторы ------------
  TaskReward({
    required this.id,
    required this.skillId,
    required this.taskId,
    this.date,
    required this.experience,
    required this.time,
  });

  factory TaskReward.create({
    required String skillId,
    required String taskId,
    DateTime? date,
    int experience = 0,
    int time = 0,
  }) {
    final guid = const Uuid().v4();
    return TaskReward(
      id: guid,
      skillId: skillId,
      taskId: taskId,
      date: date,
      experience: experience,
      time: time,
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,
      cSkillId: skillId,
      cTaskId: taskId,
      cDate: date?.millisecondsSinceEpoch,
      cExperience: experience,
      cTime: time,
    };
  }

  TaskReward.fromMap(Map map) {
    id = map[cId];
    skillId = map[cSkillId];
    taskId = map[cTaskId];
    date = map[cDate] == null ? null : DateTime.fromMillisecondsSinceEpoch(map[cDate]);
    experience = map[cExperience] ?? 0;
    time = map[cTime] ?? 0;
  }
}

extension RewardCopyWith on TaskReward {
  TaskReward copyWith({
    String? taskId,
  }) {
    return TaskReward(
      taskId: taskId ?? this.taskId,
      id: id,
      skillId: skillId,
      date: date,
      experience: experience,
      time: time
    );
  }
}

// Базовый репозиторий наград за задачи
class TaskRewardRepository {
  Database db = DB.db!;
  
  Future<List<TaskReward>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(TaskReward.tn);
    return maps.map((m) => TaskReward.fromMap(m)).toList();
  }

  Future<TaskReward> insert(TaskReward rw) async {
    await db.insert(TaskReward.tn, rw.toMap());
    return rw;
  }

  Future<List<int>> insertBatch(Iterable<TaskReward> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (TaskReward m in models) {
        res.add(await txn.insert(TaskReward.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<TaskReward?> get(String id) async {
    List<Map> maps = await db.query(TaskReward.tn, where: '${TaskReward.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return TaskReward.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String id) async {
    return await db.delete(TaskReward.tn, where: '${TaskReward.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(TaskReward rw) async {
    return await db.update(TaskReward.tn, rw.toMap(),
        where: '${TaskReward.cId} = ?', whereArgs: [rw.id]);
  }
}