import 'package:life_game/data/db.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/models/tag.dart';
import 'package:sqflite/sqflite.dart';

// Привязка тега к классу
class TagClass {
  static const tn = "tag_class";
  static const cClassId = "_class_id";
  static const cTagId = "_tag_id";

  static const init = '''CREATE TABLE $tn (
          $cClassId TEXT NOT NULL, 
          $cTagId TEXT NOT NULL,
          PRIMARY KEY ($cClassId, $cTagId),
          FOREIGN KEY ($cClassId) REFERENCES ${Class.tn}(${Class.cId}) ON DELETE CASCADE,
          FOREIGN KEY ($cTagId) REFERENCES ${Tag.tn}(${Tag.cId}) ON DELETE CASCADE
        );
        ''';

  String classId = "";
  String tagId = "";

  TagClass({required this.classId, required this.tagId});

  factory TagClass.create({required String classId, required String tagId}) {
    return TagClass(classId: classId, tagId: tagId);
  }

  Map<String, Object?> toMap() {
    return {cClassId: classId, cTagId: tagId};
  }

  TagClass.fromMap(Map map) {
    classId = map[cClassId];
    tagId = map[cTagId];
  }
}

// Базовый репозиторий привязок
class TagClassRepository {
  Database db = DB.db!;
  
  Future<List<TagClass>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(TagClass.tn);
    return maps.map((m) => TagClass.fromMap(m)).toList();
  }

  Future<TagClass> insert(TagClass ta) async {
    await db.insert(TagClass.tn, ta.toMap());
    return ta;
  }

  Future<TagClass?> get(String classId, String tagId) async {
    List<Map> maps = await db.query(
      TagClass.tn, 
      where: '${TagClass.cClassId} = ? AND ${TagClass.cTagId} = ?', 
      whereArgs: [classId, tagId]
    );
    if (maps.isNotEmpty) {
      return TagClass.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String classId, String tagId) async {
    return await db.delete(
      TagClass.tn, 
      where: '${TagClass.cClassId} = ? AND ${TagClass.cTagId} = ?', 
      whereArgs: [classId, tagId]
    );
  }
}
