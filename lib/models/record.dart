import 'dart:convert';

import 'package:step_by_step/data/db.dart';
import 'package:step_by_step/models/enums/characteristics.dart';
import 'package:step_by_step/models/profile.dart';
import 'package:step_by_step/services/hours_calculator.dart';
import 'package:step_by_step/services/datetool.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';

// Запись
class ChronicleRecord {
  // ------------ Схема ------------
  static const tn = "records";

  static const cId = "_id";
  static const cDescription = "_description";
  static const cGroup = "_group";
  static const cTarget = "_target";
  static const cFavorite = "_favorite";

  static const cDate = "_date";
  static const cTime = "_time";
  
  static const cCharTypes = "_charTypes";
  static const cHours = "_hours";

  static const init =
      '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cGroup TEXT,
          $cCharTypes TEXT,
          $cHours INTEGER,
          $cDescription TEXT,
          $cDate INTEGER,
          $cTime INTEGER,
          $cTarget INTEGER,
          $cFavorite INTEGER,

          ${CharValues.cP1} INTEGER,
          ${CharValues.cP2} INTEGER,
          ${CharValues.cP3} INTEGER,
          ${CharValues.cP4} INTEGER,
          ${CharValues.cP5} INTEGER,
          ${CharValues.cP6} INTEGER
        );
        ''';

  // ------------ Поля ------------

  String id = '';
  
  String description = ""; // Описание
  String group = ""; // Группа
  bool target = false; // Цель
  bool favorite = false; // Избранное

  DateTime date = DateTool.today(); // Дата
  int time = 0; // Время (только для сортировки)

  List<int> charTypes = []; // Типы хар-к
  int hours = 0; // Продолжительность
  CharValues chars = CharValues(); // Хар-ки

  // ------------ Конструкторы ------------

  ChronicleRecord({
    required this.id,

    required this.description,
    required this.group,
    required this.charTypes,
    required this.hours,
    required this.date,
    required this.time,
    required this.target,
    required this.favorite,
    required this.chars,
  });

  factory ChronicleRecord.create({
    String group = '',
    List<int>? char,
    int hours = 0,
    String description = '',
    required DateTime date,
    int time = 0,
    bool target = false,
    bool favorite = false,
    CharValues? chars,
  }) {
    final guid = const Uuid().v4();
    return ChronicleRecord(
      id: guid,

      group: group,
      charTypes: char ?? [],
      hours: hours,
      description: description,
      date: date,
      time: time,
      target: target,
      favorite: favorite,
      chars: chars ?? CharValues(),
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,

      cGroup: group,
      cCharTypes: jsonEncode(charTypes),
      cHours: hours,
      cDescription: description,
      cDate: DateTool.datetimeToDays(date),
      cTime: time,
      cTarget: target ? 1 : 0,
      cFavorite: favorite ? 1 : 0,

      CharValues.cP1: chars.p1,
      CharValues.cP2: chars.p2,
      CharValues.cP3: chars.p3,
      CharValues.cP4: chars.p4,
      CharValues.cP5: chars.p5,
      CharValues.cP6: chars.p6,
    };
  }

  ChronicleRecord.fromMap(Map map) {
    id = map[cId];
    
    description = map[cDescription];
    group = map[cGroup];
    charTypes = map[cCharTypes] == null ? [] : List<int>.from(jsonDecode(map[cCharTypes]));
    hours = map[cHours];
    date = DateTool.joinDateTime(date: map[cDate]) ?? DateTool.today();
    time = map[cTime];
    target = map[cTarget] == 1;
    favorite = map[cFavorite] == 1;

    chars = CharValues(values: [
      map[CharValues.cP1] as int? ?? 0, 
      map[CharValues.cP2] as int? ?? 0, 
      map[CharValues.cP3] as int? ?? 0, 
      map[CharValues.cP4] as int? ?? 0, 
      map[CharValues.cP5] as int? ?? 0, 
      map[CharValues.cP6] as int? ?? 0,
    ]);
  }

  // ------- Другое ---------

  static String? groupValidator(String? text) {
    if (text == null || text.isEmpty) return null;
    var parts = text.split('/');
    if (parts.any((e) => e.isEmpty)) return 'Части группы не могут быть пустыми';
    return null;
  }
}

// Базовый репозиторий
class RecordRepository {
  final HoursCalculator calculator;
  RecordRepository(this.calculator);
  Database db = DB.db!;
  final userRepo = ProfileRepository();

  Future<List<ChronicleRecord>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(ChronicleRecord.tn);
    return maps.map((m) => ChronicleRecord.fromMap(m)).toList();
  }

  Future<ChronicleRecord?> get(String id) async {
    List<Map> maps = await db.query(
      ChronicleRecord.tn,
      where: '${ChronicleRecord.cId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return ChronicleRecord.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  /// Получить по датам
  Future<List<ChronicleRecord>> getAllByDate({
    int? startDate,
    int? endDate,
  }) async {
    final conditions = <String>[];
    final args = <dynamic>[];

    if (startDate != null) {
      conditions.add('${ChronicleRecord.cDate} >= ?');
      args.add(startDate);
    }
    if (endDate != null) {
      conditions.add('${ChronicleRecord.cDate} <= ?');
      args.add(endDate);
    }
    final whereClause = conditions.isNotEmpty
        ? 'WHERE ${conditions.join(' AND ')}'
        : '';
    final query =
        '''
      SELECT 
        *
      FROM ${ChronicleRecord.tn}
      $whereClause
    ''';
    final result = await db.rawQuery(query, args);
    return result.map((row) => ChronicleRecord.fromMap(row)).toList();
  }

  // ----------- Изменения ----------------

  Future<ChronicleRecord> insert(ChronicleRecord rw) async {
    await _updateProfile(TransactionType.add, rw);
    await db.insert(ChronicleRecord.tn, rw.toMap());
    return rw;
  }

  Future<List<int>> insertBatch(Iterable<ChronicleRecord> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (ChronicleRecord m in models) {
        await _updateProfile(TransactionType.add, m);
        res.add(await txn.insert(ChronicleRecord.tn, m.toMap()));
      }
    });
    return res;
  }

  Future delete(String id) async {
    var rw = await get(id);
    if (rw == null) return;
    await _updateProfile(TransactionType.remove, rw);
    await db.delete(ChronicleRecord.tn, where: '${ChronicleRecord.cId} = ?', whereArgs: [id]);
  }

  Future update(ChronicleRecord rw) async {
    await _updateProfile(TransactionType.update, rw);
    return await db.update(
      ChronicleRecord.tn,
      rw.toMap(),
      where: '${ChronicleRecord.cId} = ?',
      whereArgs: [rw.id],
    );
  }

  // ---------------------------------------

  // Рассчитать дельту
  Future<Map<Characteristic, int>> _getDelta(
    TransactionType type,
    ChronicleRecord rw,
  ) async {
    final deltaChars = <Characteristic, int>{};
    final chars = rw.chars;
    var oldChars = type == TransactionType.update
        ? (await get(rw.id))?.chars
        : null;

    for (var ch in Characteristic.values) {
      int result = 0;
      switch (type) {
        case TransactionType.update:
          {
            result = (chars.map[ch] ?? 0) - (oldChars?.map[ch] ?? 0);
          }
        case TransactionType.add:
          {
            result = chars.map[ch] ?? 0;
          }
        case TransactionType.remove:
          {
            result = -(chars.map[ch] ?? 0);
          }
      }
      deltaChars[ch] = result;
    }
    return deltaChars;
  }

  // Добавить дельту к пользователю
  Future _updateProfile(TransactionType type, ChronicleRecord rw) async {
    final user = await userRepo.get();
    if (user == null) return;
    final deltaChars = await _getDelta(type, rw);

    final userChars = user.chars;

    final newUserChars = <Characteristic, int>{};
    for (var ch in Characteristic.values) {
      newUserChars[ch] = (userChars.map[ch] ?? 0) + (deltaChars[ch] ?? 0);
    }
    calculator.checkNotifications(userChars.map, newUserChars);
    user.chars.setChars(newUserChars);
    await userRepo.update(user);
  }
}

enum TransactionType { add, remove, update }
