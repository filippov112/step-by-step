import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/services/spirit_calculator.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';


// Попытка
class Attempt {
  // ------------ Схема ------------
  static const tn = "attempts";
  
  static const cId = "_id";
  static const cWallId = "_wall_id";
  static const cSuccess = "_success";
  static const cDescription = "_description";
  static const cDate = "_date";
  static const cSpiritFragments = "_sf";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cWallId TEXT,
          $cSuccess INTEGER,
          $cDescription TEXT,
          $cDate INTEGER,
          $cSpiritFragments INTEGER,
          FOREIGN KEY ($cWallId) REFERENCES ${Wall.tn}(${Wall.cId}) ON DELETE CASCADE
        );
        ''';

  // ------------ Поля ------------
  String id = '';
  String wallId = ''; // Стена
  int success = 0; // Процент успеха
  String description = ""; // Описание
  DateTime date = DateTool.today(); // Дата
  int spiritFragments = 0; // Фрагменты духа

  // ------------ Конструкторы ------------

  Attempt({
    required this.id,
    required this.wallId,
    required this.success,
    required this.description,
    required this.date,
    required this.spiritFragments,
  });

  factory Attempt.create({
    required String wallId,
    int success = 0,
    String? description,
    required DateTime date,
    int efforts = 0,
  }) {
    final guid = const Uuid().v4();
    return Attempt(
      id: guid,
      wallId: wallId,
      success: success,
      description: description ?? '',
      date: date,
      spiritFragments: efforts,
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,
      cWallId: wallId,
      cSuccess: success,
      cDescription: description,
      cDate: DateTool.datetimeToDays(date),
      cSpiritFragments: spiritFragments,
    };
  }

  Attempt.fromMap(Map map) {
    id = map[cId];
    wallId = map[cWallId];
    success = map[cSuccess];
    description = map[cDescription];
    date = DateTool.joinDateTime(date: map[cDate]) ?? DateTool.today();
    spiritFragments = map[cSpiritFragments] ?? 0;
  }
}

extension RewardCopyWith on Attempt {
  Attempt copyWith({
    String? wallId,
  }) {
    return Attempt(
      wallId: wallId ?? this.wallId,
      success: success,
      description: description,
      id: id,
      date: date,
      spiritFragments: spiritFragments,
    );
  }
}

// Базовый репозиторий
class AttemptRepository {
  Database db = DB.db!;
  final classRepo = ProjectRepository();
  final userRepo = ProfileRepository();
  
  Future<List<Attempt>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Attempt.tn);
    return maps.map((m) => Attempt.fromMap(m)).toList();
  }

  Future<List<Attempt>> getByWall(String? wallId) async {
    if (wallId == null) return [];
    List<Map<String, Object?>> maps = await db.query(Attempt.tn, where: '${Attempt.cWallId} = ?', whereArgs: [wallId]);
    return maps.map((m) => Attempt.fromMap(m)).toList();
  }

  Future<List<Attempt>> getByProject(String projectId) async {
    List<Map<String, Object?>> maps = await db.rawQuery('''
      SELECT at.* FROM ${Wall.tn} w JOIN ${Attempt.tn} at ON w.${Wall.cProjectId} = ? AND at.${Attempt.cWallId} = w.${Wall.cId}
    ''', [projectId]);
    return maps.map((m) => Attempt.fromMap(m)).toList();
  }

  Future<Attempt?> get(String id) async {
    List<Map> maps = await db.query(Attempt.tn, where: '${Attempt.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Attempt.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  // ----------- Изменения ----------------

  Future<Attempt> insert(Attempt rw) async {
    await _updateProfile(TransactionType.add, rw);
    await db.insert(Attempt.tn, rw.toMap());
    return rw;
  }

  Future<List<int>> insertBatch(Iterable<Attempt> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Attempt m in models) {
        await _updateProfile(TransactionType.add, m);
        res.add(await txn.insert(Attempt.tn, m.toMap()));
      }
    });
    return res;
  }

  Future delete(String id) async {
    var rw = await get(id);
    if (rw == null) return;
    await _updateProfile(TransactionType.remove, rw);
    await db.delete(Attempt.tn, where: '${Attempt.cId} = ?', whereArgs: [id]);
  }

  Future update(Attempt rw) async {
    await _updateProfile(TransactionType.update, rw);
    return await db.update(Attempt.tn, rw.toMap(),
        where: '${Attempt.cId} = ?', whereArgs: [rw.id]);
  }

  // ---------------------------------------

  // Рассчитать дельту
  Future<int> _getDelta(TransactionType type, Attempt rw) async {
    int result = 0;
    switch (type) {
      case TransactionType.update: {
        var oldRecord = await get(rw.id);
        result = rw.spiritFragments - (oldRecord?.spiritFragments ?? 0);
      }
      case TransactionType.add: {
        result = rw.spiritFragments;
      }
      case TransactionType.remove: {
        result = - rw.spiritFragments;
      }
    }
    return result;
  }

  // Добавить дельту к пользователю
  Future _updateProfile(TransactionType type, Attempt rw) async {
    var deltaEfforts = await _getDelta(type, rw);
    var user = await userRepo.get();
    user?.spiritFragments += deltaEfforts;
    if (user == null) return;
    await userRepo.update(user);
    await SpiritCalculator.recalcLevelUser(user);
  }
}

enum TransactionType {
  add,
  remove,
  update
}