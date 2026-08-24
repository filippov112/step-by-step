import 'package:life_game/data/db.dart';
import 'package:life_game/models/enums/tag_type.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';
// Тег
class Tag {
  // ------------ Схема ------------
  static const tn = "tags";
  
  static const cId = "_id";
  static const cTitle = "_title";
  static const cType = "_type";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTitle TEXT NOT NULL, 
          $cType INTEGER
        );
        ''';

  // ------------ Поля ------------
  String id = "";
  String title = "";
  TagType type = TagType.common;

  // ------------ Конструкторы ------------
  Tag({
    required this.id,
    required this.title,
    required this.type,
  });

  factory Tag.create({
    required String title,
    TagType type = TagType.common,
  }) {
    final guid = const Uuid().v4();
    return Tag(
      id: guid,
      title: title,
      type: type,
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,
      cTitle: title,
      cType: type.index,
    };
  }

  Tag.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    type = TagType.values[map[cType] ?? 0];
  }
}

extension TagCopyWith on Tag {
  Tag copyWith({
    String? id,
    String? title,
    TagType? type,
  }) {
    return Tag(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
    );
  }
}

// Базовый репозиторий тегов
class TagRepository {
  Database db = DB.db!;
  
  Future<List<Tag>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Tag.tn);
    return maps.map((m) => Tag.fromMap(m)).toList();
  }
  Future<List<Tag>> getByType(TagType type) async {
    List<Map> maps = await db.query(Tag.tn, where: '${Tag.cType} = ?', whereArgs: [type.index]);
    return maps.map((m) => Tag.fromMap(m)).toList();
  }

  Future<Tag> insert(Tag tag) async {
    await db.insert(Tag.tn, tag.toMap());
    return tag;
  }

  Future<List<int>> insertBatch(Iterable<Tag> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Tag m in models) {
        res.add(await txn.insert(Tag.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<Tag?> get(String id) async {
    List<Map> maps = await db.query(Tag.tn, where: '${Tag.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Tag.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String id) async {
    return await db.delete(Tag.tn, where: '${Tag.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(Tag tag) async {
    return await db.update(Tag.tn, tag.toMap(),
        where: '${Tag.cId} = ?', whereArgs: [tag.id]);
  }
}
