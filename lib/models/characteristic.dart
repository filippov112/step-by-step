import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/class.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
// Характеристика класса
class Characteristic {
  static const tn = "characteristics";
  static const cId = "_id";
  static const cClassId = "_class_id";
  static const cName = "_name";
  static const cValue = "_value";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY,
          $cClassId TEXT NOT NULL,
          $cName TEXT NOT NULL,
          $cValue INTEGER NOT NULL DEFAULT 0,
          FOREIGN KEY ($cClassId) REFERENCES ${Class.tn}(${Class.cId}) ON DELETE CASCADE
        );
        ''';

  String id = "";
  String classId = ""; // Класс
  String name = ""; // Название
  int value = 0; // Базовое значение

  Characteristic({
    required this.id,
    required this.classId,
    required this.name,
    this.value = 0,
  });

  factory Characteristic.create({
    required String classId,
    required String name,
    int value = 0,
  }) {
    final guid = const Uuid().v4();
    return Characteristic(
      id: guid,
      classId: classId,
      name: name,
      value: value,
    );
  }

  Map<String, Object?> toMap() {
    return {
      cId: id,
      cClassId: classId,
      cName: name,
      cValue: value,
    };
  }

  Characteristic.fromMap(Map map) {
    id = map[cId];
    classId = map[cClassId];
    name = map[cName];
    value = map[cValue];
  }
}

// Репозиторий характеристик
class CharacteristicRepository {
  Database db = DB.db!;

  Future<List<Characteristic>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Characteristic.tn);
    return maps.map((m) => Characteristic.fromMap(m)).toList();
  }

  Future<List<Characteristic>> getByClassId(String classId) async {
    List<Map<String, Object?>> maps = await db.query(
      Characteristic.tn,
      where: '${Characteristic.cClassId} = ?',
      whereArgs: [classId],
    );
    return maps.map((m) => Characteristic.fromMap(m)).toList();
  }

  Future<Characteristic> insert(Characteristic characteristic) async {
    await db.insert(Characteristic.tn, characteristic.toMap());
    return characteristic;
  }

  Future<Characteristic?> get(String id) async {
    List<Map> maps = await db.query(
      Characteristic.tn,
      where: '${Characteristic.cId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Characteristic.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int> update(Characteristic characteristic) async {
    return await db.update(
      Characteristic.tn,
      characteristic.toMap(),
      where: '${Characteristic.cId} = ?',
      whereArgs: [characteristic.id],
    );
  }

  Future<int?> delete(String id) async {
    return await db.delete(
      Characteristic.tn,
      where: '${Characteristic.cId} = ?',
      whereArgs: [id],
    );
  }

  Future<int?> deleteByClassId(String classId) async {
    return await db.delete(
      Characteristic.tn,
      where: '${Characteristic.cClassId} = ?',
      whereArgs: [classId],
    );
  }
}