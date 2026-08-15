import 'package:life_game/data/db.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
// Класс
class Class {
  static const tn = "classes";
  static const cId = "_id";
  static const cName = "_name";
  static const cDescription = "_description";
  static const cIcon = "_icon";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY,
          $cName TEXT NOT NULL,
          $cDescription TEXT NOT NULL,
          $cIcon TEXT
        );
        ''';

  String id = "";
  String name = ""; // Название
  String description = ""; // Описание
  String? icon; // Иконка

  Class({
    required this.id,
    required this.name,
    required this.description,
    this.icon,
  });

  factory Class.create({
    required String id,
    required String name,
    required String description,
    String? icon,
  }) {
    return Class(
      id: id,
      name: name,
      description: description,
      icon: icon,
    );
  }

  Map<String, Object?> toMap() {
    return {
      cId: id,
      cName: name,
      cDescription: description,
      cIcon: icon,
    };
  }

  Class.fromMap(Map map) {
    id = map[cId];
    name = map[cName];
    description = map[cDescription];
    icon = map[cIcon];
  }
}

// Репозиторий классов
class ClassRepository {
  Database db = DB.db!;

  Future<List<Class>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Class.tn);
    return maps.map((m) => Class.fromMap(m)).toList();
  }

  Future<Class> insert(Class classObj) async {
    await db.insert(Class.tn, classObj.toMap());
    return classObj;
  }

  Future<Class?> get(String id) async {
    List<Map> maps = await db.query(
      Class.tn,
      where: '${Class.cId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Class.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int> update(Class classObj) async {
    return await db.update(
      Class.tn,
      classObj.toMap(),
      where: '${Class.cId} = ?',
      whereArgs: [classObj.id],
    );
  }

  Future<int?> delete(String id) async {
    return await db.delete(
      Class.tn,
      where: '${Class.cId} = ?',
      whereArgs: [id],
    );
  }
}