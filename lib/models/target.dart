import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';


// Цель
class Target {

  // ------------ Схема ------------

  static const tn = "targets";
  static const cId = "_id";

  static const cTitle = "_title";
  static const cGroup = "_group";
  static const cDesc = "_desc";
  static const cFavorite = "_favorite";
  static const cProjectId = "_project_id";

  static const cControl = "_c1";
  static const cPerseverance = "_c2";
  static const cCourage = "_c3";
  static const cDurability = "_c4";
  static const cCreativity = "_c5";

  static const init = '''CREATE TABLE $tn (
    $cId TEXT PRIMARY KEY, 
    $cTitle TEXT NOT NULL, 
    $cGroup TEXT,
    $cDesc TEXT NOT NULL,
    $cFavorite INTEGER,
    $cProjectId TEXT,

    $cControl INTEGER,
    $cPerseverance INTEGER,
    $cCourage INTEGER,
    $cDurability INTEGER,
    $cCreativity INTEGER,

    FOREIGN KEY ($cProjectId) REFERENCES ${Project.tn}(${Project.cId}) ON DELETE CASCADE
  );
  ''';

  // ------------ Поля ------------

  String id = "";
  String title = ""; // Заголовок
  String group = ""; // Группа
  String desc = ""; // Формулировка
  bool favorite = false; // Избранное
  String? projectId; // Связанный проект

  int control = 20;
  int perseverance = 20;
  int courage = 20;
  int durability = 20;
  int creativity = 20;

  // ------------ Конструкторы ------------

  Target({
    required this.id, 
    required this.title, 
    required this.group,
    required this.desc, 
    required this.favorite,
    required this.projectId,
    required this.control,
    required this.perseverance,
    required this.courage,
    required this.durability,
    required this.creativity
  });

  factory Target.create({
    required String title,
    required String desc,
    String group = '',
    bool favorite = false,
    String? projectId,
    int control = 20,
    int perseverance = 20,
    int courage = 20,
    int durability = 20,
    int creativity = 20
  }) {
    final guid = const Uuid().v4();
    final dateCreated = DateTool.today();
    final dateKey = dateCreated.toIso8601String().substring(0, 10);
    final id = '$dateKey|$guid';

    return Target(
      id: id,
      title: title,
      desc: desc,
      group: group,
      favorite: favorite,
      projectId: projectId,

      control: control,
      perseverance: perseverance,
      courage: courage,
      durability: durability,
      creativity: creativity
    );
  }

  Map<Characteristics,int> get chars => <Characteristics,int>{
    Characteristics.control: control,
    Characteristics.perseverance: perseverance,
    Characteristics.courage: courage,
    Characteristics.durability: durability,
    Characteristics.creativity: creativity
  };

  // ------------ Сериализация ------------

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cId: id,
      cTitle: title,
      cDesc: desc,
      cGroup: group,
      cFavorite: favorite ? 1 : 0,
      cProjectId: projectId,

      cControl: control,
      cPerseverance: perseverance,
      cCourage: courage,
      cDurability: durability,
      cCreativity: creativity
    };
    return map;
  }
  Target.fromMap(Map map) {
    id = map[cId];
    title = map[cTitle];
    desc = map[cDesc];
    group = map[cGroup];
    favorite = map[cFavorite] == 1;
    projectId = map[cProjectId];

    control = map[cControl];
    perseverance = map[cPerseverance];
    courage = map[cCourage];
    durability = map[cDurability];
    creativity = map[cCreativity];
  }
}

// Базовый репозиторий
class TargetRepository {
  Database db = DB.db!;
  
  // Получить все
  Future<List<Target>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Target.tn);
    List<Target> res = [];
    for (Map m in maps) {
      res.add(Target.fromMap(m));
    }
    return res;
  }

  // Получить по проекту
  Future<List<Target>> getByProject(String projectId) async {
    List<Map<String, Object?>> maps = await db.query(Target.tn, where: '${Target.cProjectId} = ?', whereArgs: [projectId]);
    List<Target> res = [];
    for (Map m in maps) {
      res.add(Target.fromMap(m));
    }
    return res;
  }

  // Вставить
  Future<Target> insert(Target trg) async {
    await db.insert(Target.tn, trg.toMap());
    return trg;
  }

  // Вставить несколько
  Future<List<int>> insertBatch(Iterable<Target> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Target m in models) {
        res.add(
          await txn.insert(Target.tn, m.toMap()));
      }   
    });
    return res;
  }

  // Найти
  Future<Target?> get(String id) async {
    List<Map> maps = await db.query(Target.tn, where: '${Target.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Target.fromMap(maps.first as Map<String,Object?>);
    }
    return null;
  }

  // Удалить
  Future<int?> delete(String id) async {
    return await db.delete(Target.tn, where: '${Target.cId} = ?', whereArgs: [id]);
  }

  // Обновить
  Future<int?> update(Target t) async {
    return await db.update(Target.tn, t.toMap(),
        where: '${Target.cId} = ?', whereArgs: [t.id]);
  }
}