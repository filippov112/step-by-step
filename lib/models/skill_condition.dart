import 'package:life_game/data/db.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/tools/datetime.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';
// Условие повышения ранга навыка
class SkillCondition {
  // ------------ Схема ------------
  static const tn = "skill_conditions";
  
  static const cId = "_id";
  static const cRang = "_rang";
  static const cSkillId = "_skill_id";
  static const cDescription = "_description";
  static const cDate = "_date";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cRang INTEGER NOT NULL, 
          $cSkillId TEXT NOT NULL,
          $cDescription TEXT,
          $cDate INTEGER,
          FOREIGN KEY ($cSkillId) REFERENCES ${Skill.tn}(${Skill.cId}) ON DELETE CASCADE
        );
        ''';

  // ------------ Поля ------------
  String id = "";
  SkillRang rang = SkillRang.F;
  String skillId = "";
  String description = "";
  DateTime? date;

  // ------------ Конструкторы ------------
  SkillCondition({
    required this.id,
    required this.rang,
    required this.skillId,
    required this.description,
    this.date,
  });

  factory SkillCondition.create({
    required SkillRang rang,
    required String skillId,
    String description = "",
    DateTime? date,
  }) {
    final guid = const Uuid().v4();
    return SkillCondition(
      id: guid,
      rang: rang,
      skillId: skillId,
      description: description,
      date: date,
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,
      cRang: rang.index,
      cSkillId: skillId,
      cDescription: description,
      cDate: DateTool.datetimeToDays(date),
    };
  }

  SkillCondition.fromMap(Map map) {
    id = map[cId];
    rang = SkillRang.values[map[cRang]];
    skillId = map[cSkillId];
    description = map[cDescription] ?? "";
    date = DateTool.joinDateTime(date: map[cDate]);
  }
}

// Базовый репозиторий условий повышения ранга навыков
class SkillConditionRepository {
  Database db = DB.db!;
  
  Future<List<SkillCondition>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(SkillCondition.tn);
    return maps.map((m) => SkillCondition.fromMap(m)).toList();
  }

  Future<SkillCondition> insert(SkillCondition sc) async {
    await db.insert(SkillCondition.tn, sc.toMap());
    return sc;
  }

  Future<List<int>> insertBatch(Iterable<SkillCondition> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (SkillCondition m in models) {
        res.add(await txn.insert(SkillCondition.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<SkillCondition?> get(String id) async {
    List<Map> maps = await db.query(SkillCondition.tn, where: '${SkillCondition.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return SkillCondition.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String id) async {
    return await db.delete(SkillCondition.tn, where: '${SkillCondition.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(SkillCondition sc) async {
    return await db.update(SkillCondition.tn, sc.toMap(),
        where: '${SkillCondition.cId} = ?', whereArgs: [sc.id]);
  }
}