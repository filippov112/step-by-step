import 'package:life_game/data/db.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

class Skill {
  // ------------ Схема ------------
  static const tn = "skills";
  
  static const cId = "_id";
  static const cTitle = "_title";
  static const cRang = "_rang";
  static const cLevel = "_level";
  static const cExperience = "_experience";
  static const cIcon = "_icon";
  static const cF = "_f";
  static const cE = "_e";
  static const cD = "_d";
  static const cC = "_c";
  static const cB = "_b";
  static const cA = "_a";
  static const cS = "_s";
  static const cSs = "_ss";
  static const cSss = "_sss";
  static const cEx = "_ex";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTitle TEXT NOT NULL, 
          $cRang INTEGER,
          $cLevel INTEGER,
          $cExperience INTEGER,
          $cIcon TEXT,
          $cF TEXT,
          $cE TEXT,
          $cD TEXT,
          $cC TEXT,
          $cB TEXT,
          $cA TEXT,
          $cS TEXT,
          $cSs TEXT,
          $cSss TEXT,
          $cEx TEXT
        );
        ''';

  // ------------ Поля ------------
  String id = "";
  String title = "";
  SkillRang rang = SkillRang.F;
  int level = 1;
  int experience = 0;
  String icon = "";
  String? f;
  String? e;
  String? d;
  String? c;
  String? b;
  String? a;
  String? s;
  String? ss;
  String? sss;
  String? ex;

  // ------------ Конструкторы ------------
  Skill({
    required this.id,
    required this.title,
    required this.rang,
    required this.level,
    required this.experience,
    required this.icon,
    this.f,
    this.e,
    this.d,
    this.c,
    this.b,
    this.a,
    this.s,
    this.ss,
    this.sss,
    this.ex,
  });

  factory Skill.create({
    required String title,
    SkillRang rang = SkillRang.F,
    int level = 1,
    int experience = 0,
    String icon = "",
    String? f,
    String? e,
    String? d,
    String? c,
    String? b,
    String? a,
    String? s,
    String? ss,
    String? sss,
    String? ex,
  }) {
    final guid = const Uuid().v4();
    return Skill(
      id: guid,
      title: title,
      rang: rang,
      level: level,
      experience: experience,
      icon: icon,
      f: f,
      e: e,
      d: d,
      c: c,
      b: b,
      a: a,
      s: s,
      ss: ss,
      sss: sss,
      ex: ex,
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,
      cTitle: title,
      cRang: rang.index,
      cLevel: level,
      cExperience: experience,
      cIcon: icon,
      cF: f,
      cE: e,
      cD: d,
      cC: c,
      cB: b,
      cA: a,
      cS: s,
      cSs: ss,
      cSss: sss,
      cEx: ex,
    };
  }

  Skill.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    rang = SkillRang.values[map[cRang] ?? 0];
    level = map[cLevel] ?? 1;
    experience = map[cExperience] ?? 0;
    icon = map[cIcon] ?? "";
    f = map[cF];
    e = map[cE];
    d = map[cD];
    c = map[cC];
    b = map[cB];
    a = map[cA];
    s = map[cS];
    ss = map[cSs];
    sss = map[cSss];
    ex = map[cEx];
  }
}

class SkillRepository {
  Database db = DB.db!;
  
  Future<List<Skill>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Skill.tn);
    return maps.map((m) => Skill.fromMap(m)).toList();
  }

  Future<Skill> insert(Skill sk) async {
    await db.insert(Skill.tn, sk.toMap());
    return sk;
  }

  Future<List<int>> insertBatch(Iterable<Skill> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Skill m in models) {
        res.add(await txn.insert(Skill.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<Skill?> get(String id) async {
    List<Map> maps = await db.query(Skill.tn, where: '${Skill.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Skill.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(String id) async {
    return await db.delete(Skill.tn, where: '${Skill.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(Skill sk) async {
    return await db.update(Skill.tn, sk.toMap(),
        where: '${Skill.cId} = ?', whereArgs: [sk.id]);
  }
}