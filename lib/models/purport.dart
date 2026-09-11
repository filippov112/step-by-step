import 'package:chaos_control/data/db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

// Смысл
class Purport {

  // ------------ Схема ------------

  static const tn = "purports";
  static const cId = "_id";

  static const cTitle = "_title";
  static const cDescription = "_description";
  static const cGroup = "_group";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 

          $cTitle TEXT NOT NULL, 
          $cDescription TEXT,
          $cGroup TEXT
        );
        ''';

  // ------------ Поля ------------
  String id = "";

  String title = "";
  String description = "";
  String group = "";

  // ------------ Конструкторы ------------
  Purport({
    required this.id,
    required this.title,
    required this.group,
    required this.description
  });

  factory Purport.create({
    required String title,
    String description = "",
    String group = ""
  }) {
    final guid = const Uuid().v4();
    return Purport(
      id: guid,

      title: title,
      description: description,
      group: group
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,

      cTitle: title,
      cDescription: description,
      cGroup: group
    };
  }

  Purport.fromMap(Map map) {
    id = map[cId];

    title = map[cTitle];
    description = map[cDescription] ?? "";
    group = map[cGroup];
  }
}

// Базовый репозиторий
class PurportRepository {
  Database db = DB.db!;
  
  Future<List<Purport>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Purport.tn);
    return maps.map((m) => Purport.fromMap(m)).toList();
  }

  Future<Purport> insert(Purport pur) async {
    await db.insert(Purport.tn, pur.toMap());
    return pur;
  }

  Future<List<int>> insertBatch(Iterable<Purport> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Purport m in models) {
        res.add(await txn.insert(Purport.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<Purport?> get(String id) async {
    List<Map> maps = await db.query(Purport.tn, where: '${Purport.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Purport.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String id) async {
    return await db.delete(Purport.tn, where: '${Purport.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(Purport pur) async {
    return await db.update(Purport.tn, pur.toMap(),
        where: '${Purport.cId} = ?', whereArgs: [pur.id]);
  }
}