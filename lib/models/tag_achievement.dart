import 'package:life_game/data/db.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/tag.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


// Привязка тега к достижению
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

// Базовый репозиторий привязок
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
