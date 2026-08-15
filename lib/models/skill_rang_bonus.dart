import 'package:life_game/data/db.dart';
import 'package:life_game/models/characteristic.dart';
import 'package:life_game/models/enums/bonus_type.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/models/skill.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
// Бонусное значение характеристики от ранга навыка
class SkillRangBonus {
  static const tn = "skill_rang_bonuses";
  static const cId = "_id";
  static const cSkillId = "_skill_id";
  static const cRang = "_rang";
  static const cCharacteristicId = "_characteristic_id";
  static const cType = "_type";
  static const cBaseValue = "_base_value";
  static const cDeltaValue = "_delta_value";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY,
          $cSkillId TEXT NOT NULL,
          $cRang TEXT NOT NULL,
          $cCharacteristicId TEXT NOT NULL,
          $cType TEXT NOT NULL,
          $cBaseValue INTEGER NOT NULL DEFAULT 1,
          $cDeltaValue INTEGER NOT NULL DEFAULT 1,
          FOREIGN KEY ($cSkillId) REFERENCES ${Skill.tn}(${Skill.cId}) ON DELETE CASCADE,
          FOREIGN KEY ($cCharacteristicId) REFERENCES ${Characteristic.tn}(${Characteristic.cId}) ON DELETE CASCADE
        );
        ''';

  String id = "";
  String skillId = ""; // Навык
  SkillRang rang = SkillRang.F; // Ранг навыка
  String characteristicId = ""; // Характеристика
  BonusType type = BonusType.constant; // Тип бонуса (процентная прибавка / константа)
  int baseValue = 1; // Базовое значение первого уровня
  int deltaValue = 1; // Бонус за каждый уровень

  SkillRangBonus({
    required this.id,
    required this.skillId,
    this.rang = SkillRang.F,
    required this.characteristicId,
    this.type = BonusType.constant,
    this.baseValue = 1,
    this.deltaValue = 1,
  });

  factory SkillRangBonus.create({
    required String id,
    required String skillId,
    SkillRang rang = SkillRang.F,
    required String characteristicId,
    BonusType type = BonusType.constant,
    int baseValue = 1,
    int deltaValue = 1,
  }) {
    return SkillRangBonus(
      id: id,
      skillId: skillId,
      rang: rang,
      characteristicId: characteristicId,
      type: type,
      baseValue: baseValue,
      deltaValue: deltaValue,
    );
  }

  Map<String, Object?> toMap() {
    return {
      cId: id,
      cSkillId: skillId,
      cRang: rang.name,
      cCharacteristicId: characteristicId,
      cType: type.name,
      cBaseValue: baseValue,
      cDeltaValue: deltaValue,
    };
  }

  SkillRangBonus.fromMap(Map map) {
    id = map[cId];
    skillId = map[cSkillId];
    rang = SkillRang.values.firstWhere(
      (e) => e.name == map[cRang],
      orElse: () => SkillRang.F,
    );
    characteristicId = map[cCharacteristicId];
    type = BonusType.values.firstWhere(
      (e) => e.name == map[cType],
      orElse: () => BonusType.constant,
    );
    baseValue = map[cBaseValue];
    deltaValue = map[cDeltaValue];
  }

  // Вспомогательный метод для расчета значения бонуса на уровне
  int getValueForLevel(int level) {
    return baseValue + deltaValue * (level - 1);
  }
}

// Репозиторий бонусов рангов навыков
class SkillRangBonusRepository {
  Database db = DB.db!;

  Future<List<SkillRangBonus>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(SkillRangBonus.tn);
    return maps.map((m) => SkillRangBonus.fromMap(m)).toList();
  }

  Future<List<SkillRangBonus>> getBySkillId(String skillId) async {
    List<Map<String, Object?>> maps = await db.query(
      SkillRangBonus.tn,
      where: '${SkillRangBonus.cSkillId} = ?',
      whereArgs: [skillId],
    );
    return maps.map((m) => SkillRangBonus.fromMap(m)).toList();
  }

  Future<List<SkillRangBonus>> getByCharacteristicId(
    String characteristicId,
  ) async {
    List<Map<String, Object?>> maps = await db.query(
      SkillRangBonus.tn,
      where: '${SkillRangBonus.cCharacteristicId} = ?',
      whereArgs: [characteristicId],
    );
    return maps.map((m) => SkillRangBonus.fromMap(m)).toList();
  }

  Future<SkillRangBonus> insert(SkillRangBonus bonus) async {
    await db.insert(SkillRangBonus.tn, bonus.toMap());
    return bonus;
  }

  Future<SkillRangBonus?> get(String id) async {
    List<Map> maps = await db.query(
      SkillRangBonus.tn,
      where: '${SkillRangBonus.cId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return SkillRangBonus.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int> update(SkillRangBonus bonus) async {
    return await db.update(
      SkillRangBonus.tn,
      bonus.toMap(),
      where: '${SkillRangBonus.cId} = ?',
      whereArgs: [bonus.id],
    );
  }

  Future<int?> delete(String id) async {
    return await db.delete(
      SkillRangBonus.tn,
      where: '${SkillRangBonus.cId} = ?',
      whereArgs: [id],
    );
  }

  Future<int?> deleteBySkillId(String skillId) async {
    return await db.delete(
      SkillRangBonus.tn,
      where: '${SkillRangBonus.cSkillId} = ?',
      whereArgs: [skillId],
    );
  }
}