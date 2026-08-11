import 'package:life_game/data/db.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/enums/tag_type.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/task.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

class Tag {
  // ------------ Схема ------------
  static const tn = "tags";
  
  static const cId = "_id";
  static const cTitle = "_title";
  static const cType = "_type";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTitle TEXT NOT NULL, 
          $cType INTEGER
        );
        ''';

  // ------------ Поля ------------
  String id = "";
  String title = "";
  TagType type = TagType.common;

  // ------------ Конструкторы ------------
  Tag({
    required this.id,
    required this.title,
    required this.type,
  });

  factory Tag.create({
    required String title,
    TagType type = TagType.common,
  }) {
    final guid = const Uuid().v4();
    return Tag(
      id: guid,
      title: title,
      type: type,
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,
      cTitle: title,
      cType: type.index,
    };
  }

  Tag.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    type = TagType.values[map[cType] ?? 0];
  }
}

extension TagCopyWith on Tag {
  Tag copyWith({
    String? id,
    String? title,
    TagType? type,
  }) {
    return Tag(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
    );
  }
}

class TagRepository {
  Database db = DB.db!;
  
  Future<List<Tag>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Tag.tn);
    return maps.map((m) => Tag.fromMap(m)).toList();
  }

  Future<Tag> insert(Tag tag) async {
    await db.insert(Tag.tn, tag.toMap());
    return tag;
  }

  Future<List<int>> insertBatch(Iterable<Tag> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Tag m in models) {
        res.add(await txn.insert(Tag.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<Tag?> get(String id) async {
    List<Map> maps = await db.query(Tag.tn, where: '${Tag.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Tag.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String id) async {
    return await db.delete(Tag.tn, where: '${Tag.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(Tag tag) async {
    return await db.update(Tag.tn, tag.toMap(),
        where: '${Tag.cId} = ?', whereArgs: [tag.id]);
  }
}

// ------------ TagSkill ------------
class TagSkill {
  static const tn = "tag_skills";
  static const cSkillId = "_skill_id";
  static const cTagId = "_tag_id";

  static const init = '''CREATE TABLE $tn (
          $cSkillId TEXT NOT NULL, 
          $cTagId TEXT NOT NULL,
          PRIMARY KEY ($cSkillId, $cTagId),
          FOREIGN KEY ($cSkillId) REFERENCES ${Skill.tn}(${Skill.cId}) ON DELETE CASCADE,
          FOREIGN KEY ($cTagId) REFERENCES ${Tag.tn}(${Tag.cId}) ON DELETE CASCADE
        );
        ''';

  String skillId = "";
  String tagId = "";

  TagSkill({required this.skillId, required this.tagId});

  factory TagSkill.create({required String skillId, required String tagId}) {
    return TagSkill(skillId: skillId, tagId: tagId);
  }

  Map<String, Object?> toMap() {
    return {cSkillId: skillId, cTagId: tagId};
  }

  TagSkill.fromMap(Map map) {
    skillId = map[cSkillId];
    tagId = map[cTagId];
  }
}

class TagSkillRepository {
  Database db = DB.db!;
  
  Future<List<TagSkill>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(TagSkill.tn);
    return maps.map((m) => TagSkill.fromMap(m)).toList();
  }

  Future<TagSkill> insert(TagSkill ts) async {
    await db.insert(TagSkill.tn, ts.toMap());
    return ts;
  }

  Future<TagSkill?> get(String skillId, String tagId) async {
    List<Map> maps = await db.query(
      TagSkill.tn, 
      where: '${TagSkill.cSkillId} = ? AND ${TagSkill.cTagId} = ?', 
      whereArgs: [skillId, tagId]
    );
    if (maps.isNotEmpty) {
      return TagSkill.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String skillId, String tagId) async {
    return await db.delete(
      TagSkill.tn, 
      where: '${TagSkill.cSkillId} = ? AND ${TagSkill.cTagId} = ?', 
      whereArgs: [skillId, tagId]
    );
  }
}

// ------------ TagAchievement ------------
class TagAchievement {
  static const tn = "tag_achievements";
  static const cAchievementId = "_achievement_id";
  static const cTagId = "_tag_id";

  static const init = '''CREATE TABLE $tn (
          $cAchievementId TEXT NOT NULL, 
          $cTagId TEXT NOT NULL,
          PRIMARY KEY ($cAchievementId, $cTagId),
          FOREIGN KEY ($cAchievementId) REFERENCES ${Achievement.tn}(${Achievement.cId}) ON DELETE CASCADE,
          FOREIGN KEY ($cTagId) REFERENCES ${Tag.tn}(${Tag.cId}) ON DELETE CASCADE
        );
        ''';

  String achievementId = "";
  String tagId = "";

  TagAchievement({required this.achievementId, required this.tagId});

  factory TagAchievement.create({required String achievementId, required String tagId}) {
    return TagAchievement(achievementId: achievementId, tagId: tagId);
  }

  Map<String, Object?> toMap() {
    return {cAchievementId: achievementId, cTagId: tagId};
  }

  TagAchievement.fromMap(Map map) {
    achievementId = map[cAchievementId];
    tagId = map[cTagId];
  }
}

class TagAchievementRepository {
  Database db = DB.db!;
  
  Future<List<TagAchievement>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(TagAchievement.tn);
    return maps.map((m) => TagAchievement.fromMap(m)).toList();
  }

  Future<TagAchievement> insert(TagAchievement ta) async {
    await db.insert(TagAchievement.tn, ta.toMap());
    return ta;
  }

  Future<TagAchievement?> get(String achievementId, String tagId) async {
    List<Map> maps = await db.query(
      TagAchievement.tn, 
      where: '${TagAchievement.cAchievementId} = ? AND ${TagAchievement.cTagId} = ?', 
      whereArgs: [achievementId, tagId]
    );
    if (maps.isNotEmpty) {
      return TagAchievement.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String achievementId, String tagId) async {
    return await db.delete(
      TagAchievement.tn, 
      where: '${TagAchievement.cAchievementId} = ? AND ${TagAchievement.cTagId} = ?', 
      whereArgs: [achievementId, tagId]
    );
  }
}

// ------------ TagTask ------------
class TagTask {
  static const tn = "tag_tasks";
  static const cTaskId = "_task_id";
  static const cTagId = "_tag_id";

  static const init = '''CREATE TABLE $tn (
          $cTaskId TEXT NOT NULL, 
          $cTagId TEXT NOT NULL,
          PRIMARY KEY ($cTaskId, $cTagId),
          FOREIGN KEY ($cTaskId) REFERENCES ${Task.tn}(${Task.cId}) ON DELETE CASCADE,
          FOREIGN KEY ($cTagId) REFERENCES ${Tag.tn}(${Tag.cId}) ON DELETE CASCADE
        );
        ''';

  String taskId = "";
  String tagId = "";

  TagTask({required this.taskId, required this.tagId});

  factory TagTask.create({required String taskId, required String tagId}) {
    return TagTask(taskId: taskId, tagId: tagId);
  }

  Map<String, Object?> toMap() {
    return {cTaskId: taskId, cTagId: tagId};
  }

  TagTask.fromMap(Map map) {
    taskId = map[cTaskId];
    tagId = map[cTagId];
  }
}

class TagTaskRepository {
  Database db = DB.db!;
  List<TagTask>? _cache;
  bool _cacheDirty = true;
  
  Future<List<TagTask>> getAll() async {
    if (_cache != null && !_cacheDirty) {
      return _cache!;
    }
    List<Map<String, Object?>> maps = await db.query(TagTask.tn);
    _cache = maps.map((m) => TagTask.fromMap(m)).toList();
    _cacheDirty = false;
    return _cache!;
  }
  
  // Синхронный метод для быстрого доступа к кешу
  List<TagTask> getAllSync() {
    if (_cache == null) {
      // Если кеша нет, загружаем синхронно (только для чтения из кеша)
      throw Exception('Cache not initialized. Call getAll() first.');
    }
    return _cache!;
  }
  
  Future<TagTask> insert(TagTask tt) async {
    await db.insert(TagTask.tn, tt.toMap());
    _cacheDirty = true;
    return tt;
  }
  
  Future<TagTask?> get(String taskId, String tagId) async {
    List<Map> maps = await db.query(
      TagTask.tn, 
      where: '${TagTask.cTaskId} = ? AND ${TagTask.cTagId} = ?', 
      whereArgs: [taskId, tagId]
    );
    if (maps.isNotEmpty) {
      return TagTask.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String taskId, String tagId) async {
    _cacheDirty = true;
    return await db.delete(
      TagTask.tn, 
      where: '${TagTask.cTaskId} = ? AND ${TagTask.cTagId} = ?', 
      whereArgs: [taskId, tagId]
    );
  }
  
  // Метод для удаления всех тегов задачи
  Future<int?> deleteByTaskId(String taskId) async {
    _cacheDirty = true;
    return await db.delete(
      TagTask.tn, 
      where: '${TagTask.cTaskId} = ?', 
      whereArgs: [taskId]
    );
  }
}