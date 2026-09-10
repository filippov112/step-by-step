import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/enums/difficulty_lvl.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/services/spirit_calculator.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';

// Запись
class ChronicleRecord {
  // ------------ Схема ------------
  static const tn = "records";

  static const cId = "_id";
  static const cGroup = "_group";
  static const cDiffLvl = "_diff";
  static const cCharacteristic = "_char";
  static const cDescription = "_description";
  static const cDate = "_date";
  static const cTime = "_time";

  static const cControl = "_c1";
  static const cPerseverance = "_c2";
  static const cCourage = "_c3";
  static const cDurability = "_c4";
  static const cCreativity = "_c5";

  static const init =
      '''CREATE TABLE $tn (
          $cId TEXT PRIMARY KEY, 
          $cGroup TEXT,
          $cCharacteristic INTEGER,
          $cDiffLvl INTEGER,
          $cDescription TEXT,
          $cDate INTEGER,
          $cTime INTEGER,

          $cControl INTEGER,
          $cPerseverance INTEGER,
          $cCourage INTEGER,
          $cDurability INTEGER,
          $cCreativity INTEGER
        );
        ''';

  // ------------ Поля ------------

  String id = '';
  
  String description = ""; // Описание
  Characteristic char = Characteristic.perseverance; // Характеристика
  DifficultyLvl difficulty = DifficultyLvl.F; // Уровень сложности
  DateTime date = DateTool.today(); // Дата
  int time = 0;
  String group = ""; // Группа

  int control = 0;
  int perseverance = 0;
  int courage = 0;
  int durability = 0;
  int creativity = 0;

  // ------------ Конструкторы ------------

  ChronicleRecord({
    required this.id,

    required this.description,
    required this.group,
    required this.char,
    required this.difficulty,
    required this.date,
    required this.time,

    required this.control,
    required this.perseverance,
    required this.courage,
    required this.durability,
    required this.creativity,
  });

  factory ChronicleRecord.create({
    String group = '',
    Characteristic char = Characteristic.perseverance,
    DifficultyLvl difficulty = DifficultyLvl.F,
    String description = '',
    required DateTime date,
    int time = 0,

    int control = 0,
    int perseverance = 0,
    int courage = 0,
    int durability = 0,
    int creativity = 0,
  }) {
    final guid = const Uuid().v4();
    return ChronicleRecord(
      id: guid,

      group: group,
      char: char,
      difficulty: difficulty,
      description: description,
      date: date,
      time: time,

      control: control,
      perseverance: perseverance,
      courage: courage,
      durability: durability,
      creativity: creativity,
    );
  }

  Map<Characteristic, int> get chars => <Characteristic, int>{
    Characteristic.control: control,
    Characteristic.perseverance: perseverance,
    Characteristic.courage: courage,
    Characteristic.durability: durability,
    Characteristic.creativity: creativity,
  };

  int get spiritFragments =>
      control + perseverance + courage + durability + creativity;

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,

      cGroup: group,
      cCharacteristic: char.index,
      cDiffLvl: difficulty.index,
      cDescription: description,
      cDate: DateTool.datetimeToDays(date),
      cTime: time,

      cControl: control,
      cPerseverance: perseverance,
      cCourage: courage,
      cDurability: durability,
      cCreativity: creativity,
    };
  }

  ChronicleRecord.fromMap(Map map) {
    id = map[cId];
    
    description = map[cDescription];
    group = map[cGroup];
    char = Characteristic.values[map[cCharacteristic]];
    difficulty = DifficultyLvl.values[map[cDiffLvl]];
    date = DateTool.joinDateTime(date: map[cDate]) ?? DateTool.today();
    time = map[cTime];

    control = map[cControl];
    perseverance = map[cPerseverance];
    courage = map[cCourage];
    durability = map[cDurability];
    creativity = map[cCreativity];
  }
}

// Базовый репозиторий
class RecordRepository {
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
    await SpiritCalculator.checkNotifications(userChars, newUserChars);
    user.setChars(newUserChars);
    await userRepo.update(user);
  }
}

enum TransactionType { add, remove, update }
