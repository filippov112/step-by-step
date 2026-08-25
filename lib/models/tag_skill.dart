import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/skill.dart';
import 'package:chaos_control/models/tag.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
// Привязка тега к навыку
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

// Базовый репозиторий привязок
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
