import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/enums/task_status.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/models/target.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/services/spirit_calculator.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';


// Задача
class Task {
  // ------------ Схема ------------
  static const tn = "tasks";
  
  static const cId = "_id";
  static const cTargetId = "_target_id";
  static const cTime = "_time";
  static const cDiff = "_diff";
  static const cDescription = "_description";
  static const cDate = "_date";
  static const cStatus = "_done";

  static const cControl = "_c1";
  static const cPerseverance = "_c2";
  static const cCourage = "_c3";
  static const cDurability = "_c4";
  static const cCreativity = "_c5";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTargetId TEXT,
          $cTime INTEGER,
          $cDiff INTEGER,
          $cDescription TEXT,
          $cDate INTEGER,
          $cStatus INTEGER,

          $cControl INTEGER,
          $cPerseverance INTEGER,
          $cCourage INTEGER,
          $cDurability INTEGER,
          $cCreativity INTEGER,

          FOREIGN KEY ($cTargetId) REFERENCES ${Target.tn}(${Target.cId}) ON DELETE CASCADE
        );
        ''';

  // ------------ Поля ------------

  String id = '';
  String targetId = ''; // Цель
  int time = 0; // Трудозатраты
  int diff = 0; // Степень концентрации
  String description = ""; // Описание
  DateTime date = DateTool.today(); // Дата
  TaskStatus status = TaskStatus.done; // Статус

  int control = 0;
  int perseverance = 0;
  int courage = 0;
  int durability = 0;
  int creativity = 0;

  // ------------ Конструкторы ------------

  Task({
    required this.id,
    required this.targetId,
    required this.time,
    required this.diff,
    required this.description,
    required this.date,
    required this.status,

    required this.control,
    required this.perseverance,
    required this.courage,
    required this.durability,
    required this.creativity
  });

  factory Task.create({
    required String targetId,
    int time = 0,
    int diff = 0,
    String? description,
    required DateTime date,
    TaskStatus status = TaskStatus.done,
    
    int control = 0,
    int perseverance = 0,
    int courage = 0,
    int durability = 0,
    int creativity = 0
  }) {
    final guid = const Uuid().v4();
    return Task(
      id: guid,
      targetId: targetId,
      time: time,
      diff: diff,
      description: description ?? '',
      date: date,
      status: status,

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

  int get spiritFragments => control + perseverance + courage + durability + creativity;


  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,
      cTargetId: targetId,
      cTime: time,
      cDiff: diff,
      cDescription: description,
      cDate: DateTool.datetimeToDays(date),
      cStatus: status.index,

      cControl: control,
      cPerseverance: perseverance,
      cCourage: courage,
      cDurability: durability,
      cCreativity: creativity
    };
  }

  Task.fromMap(Map map) {
    id = map[cId];
    targetId = map[cTargetId];
    time = map[cTime];
    diff = map[cDiff];
    description = map[cDescription];
    date = DateTool.joinDateTime(date: map[cDate]) ?? DateTool.today();
    status = TaskStatus.values[map[cStatus]];
    
    control = map[cControl];
    perseverance = map[cPerseverance];
    courage = map[cCourage];
    durability = map[cDurability];
    creativity = map[cCreativity];
  }
}

// Базовый репозиторий
class TaskRepository {
  Database db = DB.db!;
  final classRepo = ProjectRepository();
  final userRepo = ProfileRepository();
  
  Future<List<Task>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Task.tn);
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<List<Task>> getByTarget(String? targetId) async {
    if (targetId == null) return [];
    List<Map<String, Object?>> maps = await db.query(Task.tn, where: '${Task.cTargetId} = ?', whereArgs: [targetId]);
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<List<Task>> getByProject(String projectId) async {
    List<Map<String, Object?>> maps = await db.rawQuery('''
      SELECT at.* FROM ${Target.tn} w JOIN ${Task.tn} at ON w.${Target.cProjectId} = ? AND at.${Task.cTargetId} = w.${Target.cId}
    ''', [projectId]);
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<Task?> get(String id) async {
    List<Map> maps = await db.query(Task.tn, where: '${Task.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Task.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  // ----------- Изменения ----------------

  Future<Task> insert(Task rw) async {
    await _updateProfile(TransactionType.add, rw);
    await db.insert(Task.tn, rw.toMap());
    return rw;
  }

  Future<List<int>> insertBatch(Iterable<Task> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Task m in models) {
        await _updateProfile(TransactionType.add, m);
        res.add(await txn.insert(Task.tn, m.toMap()));
      }
    });
    return res;
  }

  Future delete(String id) async {
    var rw = await get(id);
    if (rw == null) return;
    await _updateProfile(TransactionType.remove, rw);
    await db.delete(Task.tn, where: '${Task.cId} = ?', whereArgs: [id]);
  }

  Future update(Task rw) async {
    await _updateProfile(TransactionType.update, rw);
    return await db.update(Task.tn, rw.toMap(),
        where: '${Task.cId} = ?', whereArgs: [rw.id]);
  }

  // ---------------------------------------

  // Рассчитать дельту
  Future<Map<Characteristics,int>> _getDelta(TransactionType type, Task rw) async {
    
    final deltaChars = <Characteristics,int>{};
    final chars = rw.chars;
    var oldChars = type == TransactionType.update ? (await get(rw.id))?.chars : null;
    
    for (var ch in Characteristics.values) {

      int result = 0;
      switch (type) {
        case TransactionType.update: {
          
          result = (chars[ch] ?? 0) - (oldChars?[ch] ?? 0);
        }
        case TransactionType.add: {
          result = chars[ch] ?? 0;
        }
        case TransactionType.remove: {
          result = - (chars[ch] ?? 0);
        }
      }
      deltaChars[ch] = result;
    }
    return deltaChars;
  }

  // Добавить дельту к пользователю
  Future _updateProfile(TransactionType type, Task rw) async {
    final user = await userRepo.get();
    if (user == null) return;
    final deltaChars = await _getDelta(type, rw);

    final userChars = user.chars;
    
    final newUserChars = <Characteristics,int>{};
    for (var ch in Characteristics.values) {
      newUserChars[ch] = (userChars[ch] ?? 0) + (deltaChars[ch] ?? 0);
    }
    await SpiritCalculator.checkNotifications(userChars, newUserChars);
    user.setChars(newUserChars);
    await userRepo.update(user);
  }
}

enum TransactionType {
  add,
  remove,
  update
}