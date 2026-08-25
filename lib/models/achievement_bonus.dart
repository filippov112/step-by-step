import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/achievement.dart';
import 'package:chaos_control/models/characteristic.dart';
import 'package:chaos_control/models/enums/bonus_type.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Бонус к характеристике за достижение
class AchievementBonus {
  static const tn = "achievement_bonuses";
  static const cId = "_id";
  static const cAchievementId = "_achievement_id";
  static const cCharacteristicId = "_characteristic_id";
  static const cType = "_type";
  static const cValue = "_value";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY,
          $cAchievementId TEXT NOT NULL, 
          $cCharacteristicId TEXT NOT NULL,
          $cType TEXT NOT NULL,
          $cValue INTEGER NOT NULL DEFAULT 1,
          FOREIGN KEY ($cAchievementId) REFERENCES ${Achievement.tn}(${Achievement.cId}) ON DELETE CASCADE,
          FOREIGN KEY ($cCharacteristicId) REFERENCES ${Characteristic.tn}(${Characteristic.cId}) ON DELETE CASCADE
        );
        ''';

  String id = "";
  String achievementId = ""; // Достижение
  String characteristicId = ""; // Характеристика
  BonusType type = BonusType.constant; // Тип бонуса (процентная прибавка / константа)
  int value = 1; // Значение

  AchievementBonus({
    required this.id,
    required this.achievementId,
    required this.characteristicId,
    this.type = BonusType.constant,
    this.value = 1,
  });

  factory AchievementBonus.create({
    required String achievementId,
    required String characteristicId,
    BonusType type = BonusType.constant,
    int value = 1,
  }) {
    final guid = const Uuid().v4();
    return AchievementBonus(
      id: guid,
      achievementId: achievementId,
      characteristicId: characteristicId,
      type: type,
      value: value,
    );
  }

  Map<String, Object?> toMap() {
    return {
      cId: id,
      cAchievementId: achievementId,
      cCharacteristicId: characteristicId,
      cType: type.name,
      cValue: value,
    };
  }

  AchievementBonus.fromMap(Map map) {
    id = map[cId];
    achievementId = map[cAchievementId];
    characteristicId = map[cCharacteristicId];
    type = BonusType.values.firstWhere(
      (e) => e.name == map[cType],
      orElse: () => BonusType.constant,
    );
    value = map[cValue];
  }
}

// Репозиторий бонусов достижений
class AchievementBonusRepository {
  Database db = DB.db!;

  Future<List<AchievementBonus>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(AchievementBonus.tn);
    return maps.map((m) => AchievementBonus.fromMap(m)).toList();
  }

  Future<List<AchievementBonus>> getByAchievementId(String achievementId) async {
    List<Map<String, Object?>> maps = await db.query(
      AchievementBonus.tn,
      where: '${AchievementBonus.cAchievementId} = ?',
      whereArgs: [achievementId],
    );
    return maps.map((m) => AchievementBonus.fromMap(m)).toList();
  }

  Future<AchievementBonus> insert(AchievementBonus bonus) async {
    await db.insert(AchievementBonus.tn, bonus.toMap());
    return bonus;
  }

  Future<AchievementBonus?> get(String id) async {
    List<Map> maps = await db.query(
      AchievementBonus.tn,
      where: '${AchievementBonus.cId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return AchievementBonus.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int> update(AchievementBonus bonus) async {
    return await db.update(
      AchievementBonus.tn,
      bonus.toMap(),
      where: '${AchievementBonus.cId} = ?',
      whereArgs: [bonus.id],
    );
  }

  Future<int?> delete(String id) async {
    return await db.delete(
      AchievementBonus.tn,
      where: '${AchievementBonus.cId} = ?',
      whereArgs: [id],
    );
  }

  Future<int?> deleteByAchievementId(String achievementId) async {
    return await db.delete(
      AchievementBonus.tn,
      where: '${AchievementBonus.cAchievementId} = ?',
      whereArgs: [achievementId],
    );
  }
}