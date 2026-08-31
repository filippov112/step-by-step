import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/class.dart';
import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/services/exp_calculator.dart';
import 'package:chaos_control/tools/datetime.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';


// Награда
class Reward {
  // ------------ Схема ------------
  static const tn = "rewards";
  
  static const cId = "_id";
  static const cTaskId = "_task_id";
  static const cDate = "_date";
  static const cEfforts = "_efforts";

  static const init = '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cTaskId TEXT,
          $cDate INTEGER,
          $cEfforts INTEGER,
          FOREIGN KEY ($cTaskId) REFERENCES ${Wall.tn}(${Wall.cId}) ON DELETE CASCADE
        );
        ''';

  // ------------ Поля ------------
  String id = "";
  String? taskId;
  DateTime? date;
  int efforts = 0;

  // ------------ Конструкторы ------------
  Reward({
    required this.id,
    this.taskId,
    this.date,
    required this.efforts,
  });

  factory Reward.create({
    String? taskId,
    DateTime? date,
    int efforts = 0,
  }) {
    final guid = const Uuid().v4();
    return Reward(
      id: guid,
      taskId: taskId,
      date: date,
      efforts: efforts,
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,
      cTaskId: taskId,
      cDate: DateTool.datetimeToDays(date),
      cEfforts: efforts,
    };
  }

  Reward.fromMap(Map map) {
    id = map[cId];
    taskId = map[cTaskId];
    date = DateTool.joinDateTime(date: map[cDate]);
    efforts = map[cEfforts] ?? 0;
  }
}

extension RewardCopyWith on Reward {
  Reward copyWith({
    String? taskId,
  }) {
    return Reward(
      taskId: taskId ?? this.taskId,
      id: id,
      date: date,
      efforts: efforts,
    );
  }
}

// Базовый репозиторий наград
class RewardRepository {
  Database db = DB.db!;
  final classRepo = ClassRepository();
  final userRepo = ProfileRepository();
  
  Future<List<Reward>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(Reward.tn);
    return maps.map((m) => Reward.fromMap(m)).toList();
  }

  Future<Reward?> get(String id) async {
    List<Map> maps = await db.query(Reward.tn, where: '${Reward.cId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Reward.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  // ----------- Изменения ----------------

  Future<Reward> insert(Reward rw) async {
    await _updateProfile(TransactionType.add, rw);
    await db.insert(Reward.tn, rw.toMap());
    return rw;
  }

  Future<List<int>> insertBatch(Iterable<Reward> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Reward m in models) {
        await _updateProfile(TransactionType.add, m);
        res.add(await txn.insert(Reward.tn, m.toMap()));
      }
    });
    return res;
  }

  Future delete(String id) async {
    var rw = await get(id);
    if (rw == null) return;
    await _updateProfile(TransactionType.remove, rw);
    await db.delete(Reward.tn, where: '${Reward.cId} = ?', whereArgs: [id]);
  }

  Future update(Reward rw) async {
    await _updateProfile(TransactionType.update, rw);
    return await db.update(Reward.tn, rw.toMap(),
        where: '${Reward.cId} = ?', whereArgs: [rw.id]);
  }

  // ---------------------------------------

  // Рассчитать дельту
  Future<int> _getDelta(TransactionType type, Reward rw) async {
    int result = 0;
    switch (type) {
      case TransactionType.update: {
        var oldRecord = await get(rw.id);
        result = rw.efforts - (oldRecord?.efforts ?? 0);
      }
      case TransactionType.add: {
        result = rw.efforts;
      }
      case TransactionType.remove: {
        result = - rw.efforts;
      }
    }
    return result;
  }

  // Добавить дельту к пользователю
  Future _updateProfile(TransactionType type, Reward rw) async {
    var deltaEfforts = await _getDelta(type, rw);
    var user = await userRepo.get();
    user?.efforts += deltaEfforts;
    if (user == null) return;
    await userRepo.update(user);
    SpiritCalculator.recalcLevelUser(user);
  }
}

enum TransactionType {
  add,
  remove,
  update
}