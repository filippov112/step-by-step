import 'package:life_game/data/db.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/models/skill.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
// Связь навыка с классом
class ClassSkill {
  static const tn = "class_skills";
  static const cSkillId = "_skill_id";
  static const cClassId = "_class_id";

  static const init = '''CREATE TABLE $tn (
          $cSkillId TEXT NOT NULL,
          $cClassId TEXT NOT NULL,
          PRIMARY KEY ($cSkillId, $cClassId),
          FOREIGN KEY ($cSkillId) REFERENCES ${Skill.tn}(${Skill.cId}) ON DELETE CASCADE,
          FOREIGN KEY ($cClassId) REFERENCES ${Class.tn}(${Class.cId}) ON DELETE CASCADE
        );
        ''';

  String skillId = "";
  String classId = "";

  ClassSkill({required this.skillId, required this.classId});

  factory ClassSkill.create({
    required String skillId,
    required String classId,
  }) {
    return ClassSkill(skillId: skillId, classId: classId);
  }

  Map<String, Object?> toMap() {
    return {cSkillId: skillId, cClassId: classId};
  }

  ClassSkill.fromMap(Map map) {
    skillId = map[cSkillId];
    classId = map[cClassId];
  }
}

// Репозиторий связей классов и навыков
class ClassSkillRepository {
  Database db = DB.db!;

  Future<List<ClassSkill>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(ClassSkill.tn);
    return maps.map((m) => ClassSkill.fromMap(m)).toList();
  }

  Future<List<ClassSkill>> getBySkillId(String skillId) async {
    List<Map<String, Object?>> maps = await db.query(
      ClassSkill.tn,
      where: '${ClassSkill.cSkillId} = ?',
      whereArgs: [skillId],
    );
    return maps.map((m) => ClassSkill.fromMap(m)).toList();
  }

  Future<List<ClassSkill>> getByClassId(String classId) async {
    List<Map<String, Object?>> maps = await db.query(
      ClassSkill.tn,
      where: '${ClassSkill.cClassId} = ?',
      whereArgs: [classId],
    );
    return maps.map((m) => ClassSkill.fromMap(m)).toList();
  }

  Future<ClassSkill> insert(ClassSkill classSkill) async {
    await db.insert(ClassSkill.tn, classSkill.toMap());
    return classSkill;
  }

  Future<ClassSkill?> get(String skillId, String classId) async {
    List<Map> maps = await db.query(
      ClassSkill.tn,
      where: '${ClassSkill.cSkillId} = ? AND ${ClassSkill.cClassId} = ?',
      whereArgs: [skillId, classId],
    );
    if (maps.isNotEmpty) {
      return ClassSkill.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String skillId, String classId) async {
    return await db.delete(
      ClassSkill.tn,
      where: '${ClassSkill.cSkillId} = ? AND ${ClassSkill.cClassId} = ?',
      whereArgs: [skillId, classId],
    );
  }
}