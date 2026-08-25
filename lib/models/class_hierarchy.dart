import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/class.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
// Иерархия классов
class ClassHierarchy {
  static const tn = "class_hierarchy";
  static const cParentId = "_parent_id";
  static const cChildId = "_child_id";

  static const init = '''CREATE TABLE $tn (
          $cParentId TEXT NOT NULL,
          $cChildId TEXT NOT NULL,
          PRIMARY KEY ($cParentId, $cChildId),
          FOREIGN KEY ($cParentId) REFERENCES ${Class.tn}(${Class.cId}) ON DELETE CASCADE,
          FOREIGN KEY ($cChildId) REFERENCES ${Class.tn}(${Class.cId}) ON DELETE CASCADE
        );
        ''';

  String parentId = "";
  String childId = "";

  ClassHierarchy({required this.parentId, required this.childId});

  Map<String, Object?> toMap() {
    return {cParentId: parentId, cChildId: childId};
  }

  ClassHierarchy.fromMap(Map map) {
    parentId = map[cParentId];
    childId = map[cChildId];
  }
}

// Репозиторий иерархии классов
class ClassHierarchyRepository {
  Database db = DB.db!;

  Future<List<ClassHierarchy>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(ClassHierarchy.tn);
    return maps.map((m) => ClassHierarchy.fromMap(m)).toList();
  }

  Future<List<ClassHierarchy>> getByParentId(String parentId) async {
    List<Map<String, Object?>> maps = await db.query(
      ClassHierarchy.tn,
      where: '${ClassHierarchy.cParentId} = ?',
      whereArgs: [parentId],
    );
    return maps.map((m) => ClassHierarchy.fromMap(m)).toList();
  }

  Future<List<ClassHierarchy>> getByChildId(String childId) async {
    List<Map<String, Object?>> maps = await db.query(
      ClassHierarchy.tn,
      where: '${ClassHierarchy.cChildId} = ?',
      whereArgs: [childId],
    );
    return maps.map((m) => ClassHierarchy.fromMap(m)).toList();
  }

  Future<ClassHierarchy> insert(ClassHierarchy hierarchy) async {
    await db.insert(ClassHierarchy.tn, hierarchy.toMap());
    return hierarchy;
  }

  Future<ClassHierarchy?> get(String parentId, String childId) async {
    List<Map> maps = await db.query(
      ClassHierarchy.tn,
      where: '${ClassHierarchy.cParentId} = ? AND ${ClassHierarchy.cChildId} = ?',
      whereArgs: [parentId, childId],
    );
    if (maps.isNotEmpty) {
      return ClassHierarchy.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String parentId, String childId) async {
    return await db.delete(
      ClassHierarchy.tn,
      where: '${ClassHierarchy.cParentId} = ? AND ${ClassHierarchy.cChildId} = ?',
      whereArgs: [parentId, childId],
    );
  }
}