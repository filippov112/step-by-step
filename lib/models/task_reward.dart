import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/class.dart';
import 'package:chaos_control/models/class_skill.dart';
import 'package:chaos_control/models/skill.dart';
import 'package:chaos_control/models/task.dart';
import 'package:chaos_control/models/user.dart';
import 'package:chaos_control/services/exp_calculator.dart';
import 'package:chaos_control/tools/datetime.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';


// Награда (опыт и время)
class TaskReward {
  // ------------ Схема ------------
  static const tn = "rewards";
  
  static const cId = "_id";
  static const cSkillId = "_skill_id";
  static const cTaskId = "_task_id";
  static const cClassId = "_class_id";
  static const cDate = "_date";
  static const cExperience = "_experience";
  static const cTime = "_time";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cSkillId TEXT, 
          $cTaskId TEXT,
          $cClassId TEXT,
          $cDate INTEGER,
          $cExperience INTEGER,
          $cTime INTEGER,
          FOREIGN KEY ($cSkillId) REFERENCES ${Skill.tn}(${Skill.cId}) ON DELETE CASCADE,
          FOREIGN KEY ($cTaskId) REFERENCES ${Task.tn}(${Task.cId}) ON DELETE CASCADE,
          FOREIGN KEY ($cClassId) REFERENCES ${Class.tn}(${Class.cId}) ON DELETE CASCADE
        );
        ''';

  // ------------ Поля ------------
  String id = "";
  String? skillId;
  String? taskId;
  String? classId;
  
  DateTime? date;
  int experience = 0;
  int time = 0;

  // ------------ Конструкторы ------------
  TaskReward({
    required this.id,
    this.skillId,
    this.taskId,
    this.classId,
    this.date,
    required this.experience,
    required this.time,
  });

  factory TaskReward.create({
    String? skillId,
    String? taskId,
    String? classId,
    DateTime? date,
    int experience = 0,
    int time = 0,
  }) {
    final guid = const Uuid().v4();
    return TaskReward(
      id: guid,
      skillId: skillId,
      taskId: taskId,
      classId: classId,
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
      cClassId: classId,
      cDate: DateTool.datetimeToDays(date),
      cExperience: experience,
      cTime: time,
    };
  }

  TaskReward.fromMap(Map map) {
    id = map[cId];
    skillId = map[cSkillId];
    taskId = map[cTaskId];
    classId = map[cClassId];
    date = DateTool.joinDateTime(date: map[cDate]);
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
      classId: classId,
      date: date,
      experience: experience,
      time: time
    );
  }
}

// Базовый репозиторий наград за задачи
class TaskRewardRepository {
  Database db = DB.db!;
  final skillRepo = SkillRepository();
  final classSkillRepo = ClassSkillRepository();
  final classRepo = ClassRepository();
  final userRepo = UserRepository();
  
  Future<List<TaskReward>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(TaskReward.tn);
    return maps.map((m) => TaskReward.fromMap(m)).toList();
  }

  Future<TaskReward?> get(String id) async {
    List<Map> maps = await db.query(TaskReward.tn, where: '${TaskReward.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return TaskReward.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  // ----------- Изменения ----------------

  Future<TaskReward> insert(TaskReward rw) async {
    await _updateSkill(TransactionType.add, rw);
    await _updateClass(TransactionType.add, rw);
    await db.insert(TaskReward.tn, rw.toMap());
    return rw;
  }

  Future<List<int>> insertBatch(Iterable<TaskReward> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (TaskReward m in models) {
        await _updateSkill(TransactionType.add, m);
        await _updateClass(TransactionType.add, m);
        res.add(await txn.insert(TaskReward.tn, m.toMap()));
      }
    });
    return res;
  }

  Future delete(String id) async {
    var rw = await get(id);
    if (rw == null) return;
    await _updateSkill(TransactionType.remove, rw);
    await _updateClass(TransactionType.remove, rw);
    await db.delete(TaskReward.tn, where: '${TaskReward.cId} = ?', whereArgs: [id]);
  }

  Future update(TaskReward rw) async {
    await _updateSkill(TransactionType.update, rw);
    await _updateClass(TransactionType.update, rw);
    return await db.update(TaskReward.tn, rw.toMap(),
        where: '${TaskReward.cId} = ?', whereArgs: [rw.id]);
  }

  // ---------------------------------------

  // Обновить кэш навыка (+ связанных классов, + персонажа)
  // Инициировать проверку уровней и уведомления
  Future _updateSkill(TransactionType type, TaskReward rw) async {
    if (rw.skillId == null) return;

    var delts = await _getDeltaExpTime(type, rw);
    int deltaExp = delts.$1;
    int deltaTime = delts.$2;

    var skill = await skillRepo.get(rw.skillId!);
    skill?.time += deltaTime;
    skill?.experience += deltaExp;
    if (skill == null) return;
    await skillRepo.update(skill);
    ExpCalculator.recalcLevelSkill(skill);

    List<ClassSkill> classSkills = await classSkillRepo.getBySkillId(skill.id);
    for (var cs in classSkills) {
      var cls = await classRepo.get(cs.classId);
      if (cls == null) continue;
      await __updateClass(cls, deltaExp, deltaTime);
    }

    await _updateUser(deltaExp, deltaTime);
  }

  // Обновить кэш класса (+ персонажа)
  // Инициировать проверку уровней и уведомления
  Future _updateClass(TransactionType type, TaskReward rw) async {
    if (rw.classId == null) return;

    var delts = await _getDeltaExpTime(type, rw);
    int deltaExp = delts.$1;
    int deltaTime = delts.$2;
    
    var cls = await classRepo.get(rw.classId!);
    if (cls == null) return;
    await __updateClass(cls, deltaExp, deltaTime);
  }

  // Рассчитать дельту
  Future<(int,int)> _getDeltaExpTime(TransactionType type, TaskReward rw) async {
    int deltaExp = 0;
    int deltaTime = 0;
    
    switch (type) {
      case TransactionType.update: {
        var oldRecord = await get(rw.id);
        deltaExp = rw.experience - (oldRecord?.experience ?? 0);
        deltaTime = rw.time - (oldRecord?.time ?? 0);
      }
      case TransactionType.add: {
        deltaExp = rw.experience;
        deltaTime = rw.time;
      }
      case TransactionType.remove: {
        deltaExp = - rw.experience;
        deltaTime = - rw.time;
      }
    }
    return (deltaExp, deltaTime);
  }
  // Добавить дельту к классу
  Future __updateClass(Class cls, int deltaExp, int deltaTime) async {
    cls.experience += deltaExp;
    cls.time += deltaTime;
    await classRepo.update(cls);
    ExpCalculator.recalcLevelClass(cls);
  }
  // Добавить дельту к пользователю
  Future _updateUser(int deltaExp, int deltaTime) async {
    var user = await userRepo.get();
    user?.experience += deltaExp;
    user?.time += deltaTime;
    if (user == null) return;
    await userRepo.update(user);
    ExpCalculator.recalcLevelUser(user);
  }
}

enum TransactionType {
  add,
  remove,
  update
}