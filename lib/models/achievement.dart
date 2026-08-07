import 'package:life_game/data/db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

class Achievement {
  // ------------ Схема ------------
  static const tn = "achievements";
  
  static const cId = "_id";
  static const cTitle = "_title";
  static const cDescription = "_description";
  static const cDate = "_date";
  static const cIcon = "_icon";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTitle TEXT NOT NULL, 
          $cDescription TEXT, 
          $cDate INTEGER,
          $cIcon TEXT
        );
        ''';

  // ------------ Поля ------------
  String id = "";
  String title = "";
  String description = "";
  DateTime? date;
  String? icon;

  // ------------ Конструкторы ------------
  Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.date,
    this.icon,
  });

  factory Achievement.create({
    required String title,
    String description = "",
    DateTime? date,
    String? icon,
  }) {
    final guid = const Uuid().v4();
    return Achievement(
      id: guid,
      title: title,
      description: description,
      date: date,
      icon: icon,
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,
      cTitle: title,
      cDescription: description,
      cDate: date?.millisecondsSinceEpoch,
      cIcon: icon,
    };
  }

  Achievement.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    description = map[cDescription] ?? "";
    date = map[cDate] == null ? null : DateTime.fromMillisecondsSinceEpoch(map[cDate]);
    icon = map[cIcon];
  }
}

class AchievementRepository {
  Database db = DB.db!;
  
  Future<List<Achievement>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Achievement.tn);
    return maps.map((m) => Achievement.fromMap(m)).toList();
  }

  Future<Achievement> insert(Achievement ach) async {
    await db.insert(Achievement.tn, ach.toMap());
    return ach;
  }

  Future<List<int>> insertBatch(Iterable<Achievement> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Achievement m in models) {
        res.add(await txn.insert(Achievement.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<Achievement?> get(String id) async {
    List<Map> maps = await db.query(Achievement.tn, where: '${Achievement.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Achievement.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String id) async {
    return await db.delete(Achievement.tn, where: '${Achievement.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(Achievement ach) async {
    return await db.update(Achievement.tn, ach.toMap(),
        where: '${Achievement.cId} = ?', whereArgs: [ach.id]);
  }
}