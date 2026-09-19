import 'dart:convert';

import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/services/hours_calculator.dart';
import 'package:chaos_control/services/datetool.dart';
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
  
  static const cCharTypes = "_chars";
  static const cHours = "_hours";

  static const cHappiness = "_c1";
  static const cDiligence = "_c2";
  static const cIntellection = "_c3";
  static const cDurability = "_c4";
  static const cPotencial = "_c5";

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

          $cHappiness INTEGER,
          $cDiligence INTEGER,
          $cIntellection INTEGER,
          $cDurability INTEGER,
          $cPotencial INTEGER
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

  List<int> charTypes = []; // Характеристики
  int hours = 0; // Продолжительность

  // Хар-ки
  int happiness = 0;
  int diligence = 0;
  int intellection = 0;
  int durability = 0;
  int potencial = 0;

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

    required this.happiness,
    required this.diligence,
    required this.intellection,
    required this.durability,
    required this.potencial,
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

    int happiness = 0,
    int diligence = 0,
    int intellection = 0,
    int durability = 0,
    int potencial = 0,
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

      happiness: happiness,
      diligence: diligence,
      intellection: intellection,
      durability: durability,
      potencial: potencial,
    );
  }

  // ------- Методы ------------

  Map<Characteristic, int> get chars => <Characteristic, int>{
    Characteristic.happiness: happiness,
    Characteristic.diligence: diligence,
    Characteristic.intellection: intellection,
    Characteristic.durability: durability,
    Characteristic.potencial: potencial,
  };

  void clearChars() {
    happiness = 0;
    diligence = 0;
    intellection = 0;
    durability = 0;
    potencial = 0;
  }

  int get hoursFull =>
      happiness + diligence + intellection + durability + potencial;

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

      cHappiness: happiness,
      cDiligence: diligence,
      cIntellection: intellection,
      cDurability: durability,
      cPotencial: potencial,
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

    happiness = map[cHappiness];
    diligence = map[cDiligence];
    intellection = map[cIntellection];
    durability = map[cDurability];
    potencial = map[cPotencial];
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
            result = (chars[ch] ?? 0) - (oldChars?[ch] ?? 0);
          }
        case TransactionType.add:
          {
            result = chars[ch] ?? 0;
          }
        case TransactionType.remove:
          {
            result = -(chars[ch] ?? 0);
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
      newUserChars[ch] = (userChars[ch] ?? 0) + (deltaChars[ch] ?? 0);
    }
    calculator.checkNotifications(userChars, newUserChars);
    user.setChars(newUserChars);
    await userRepo.update(user);
  }
}

enum TransactionType { add, remove, update }
