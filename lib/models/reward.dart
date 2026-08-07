import 'package:life_game/data/db.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/task.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

class Reward {
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
  Reward({
    required this.id,
    required this.skillId,
    required this.taskId,
    this.date,
    required this.experience,
    required this.time,
  });

  factory Reward.create({
    required String skillId,
    required String taskId,
    DateTime? date,
    int experience = 0,
    int time = 0,
  }) {
    final guid = const Uuid().v4();
    return Reward(
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

  Reward.fromMap(Map map) {
    id = map[cId];
    skillId = map[cSkillId];
    taskId = map[cTaskId];
    date = map[cDate] == null ? null : DateTime.fromMillisecondsSinceEpoch(map[cDate]);
    experience = map[cExperience] ?? 0;
    time = map[cTime] ?? 0;
  }
}

class RewardRepository {
  Database db = DB.db!;
  
  Future<List<Reward>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Reward.tn);
    return maps.map((m) => Reward.fromMap(m)).toList();
  }

  Future<Reward> insert(Reward rw) async {
    await db.insert(Reward.tn, rw.toMap());
    return rw;
  }

  Future<List<int>> insertBatch(Iterable<Reward> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Reward m in models) {
        res.add(await txn.insert(Reward.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<Reward?> get(String id) async {
    List<Map> maps = await db.query(Reward.tn, where: '${Reward.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Reward.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String id) async {
    return await db.delete(Reward.tn, where: '${Reward.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(Reward rw) async {
    return await db.update(Reward.tn, rw.toMap(),
        where: '${Reward.cId} = ?', whereArgs: [rw.id]);
  }
}