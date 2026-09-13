import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/services/file_storage_service.dart';
import 'package:sqflite/sqflite.dart';

// Пользователь
class Profile {
  static const tn = "profiles";

  static const cId = "_id";
  static const cName = "_name";
  static const cIcon = "_icon";
  
  static const cHappiness = "_c1";
  static const cDiligence = "_c2";
  static const cStrategy = "_c3";
  static const cDurability = "_c4";
  static const cPotencial = "_c5";

  static const cBHappiness = "_cb1";
  static const cBDiligence = "_cb2";
  static const cBStrategy = "_cb3";
  static const cBDurability = "_cb4";
  static const cBPotencial = "_cb5";

  static const init =
      '''CREATE TABLE $tn (
          $cId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $cName TEXT NOT NULL, 
          $cIcon TEXT,
          
          $cHappiness INTEGER,
          $cDiligence INTEGER,
          $cStrategy INTEGER,
          $cDurability INTEGER,
          $cPotencial INTEGER,

          $cBHappiness INTEGER,
          $cBDiligence INTEGER,
          $cBStrategy INTEGER,
          $cBDurability INTEGER,
          $cBPotencial INTEGER
        )''';

  int? id;
  String name = ""; // Никнейм
  CustomImageData? icon; // Аватар

  // Кэш
  int happiness = 0;
  int diligence = 0;
  int strategy = 0;
  int durability = 0;
  int potencial = 0;
  
  // Базовые значения
  int happinessBase = 0;
  int diligenceBase = 0;
  int strategyBase = 0;
  int durabilityBase = 0;
  int potencialBase = 0;

  int get spiritFragments => happiness + diligence + strategy + durability + potencial;

  Profile({
    this.name = "",
    this.icon,
    
    this.happiness = 0,
    this.diligence = 0,
    this.strategy = 0,
    this.durability = 0,
    this.potencial = 0,

    this.happinessBase = 0,
    this.diligenceBase = 0,
    this.strategyBase = 0,
    this.durabilityBase = 0,
    this.potencialBase = 0
  });

  Map<Characteristic,int> get chars => <Characteristic,int>{
    Characteristic.happiness: happiness,
    Characteristic.diligence: diligence,
    Characteristic.strategy: strategy,
    Characteristic.durability: durability,
    Characteristic.potencial: potencial
  };

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cName: name,
      cIcon: icon?.toJson(),
      
      cHappiness: happiness,
      cDiligence: diligence,
      cStrategy: strategy,
      cDurability: durability,
      cPotencial: potencial,

      cBHappiness: happinessBase,
      cBDiligence: diligenceBase,
      cBStrategy: strategyBase,
      cBDurability: durabilityBase,
      cBPotencial: potencialBase,
    };
    if (id != null) {
      map[cId] = id;
    }
    return map;
  }

  Profile.fromMap(Map map) {
    id = map[cId];
    name = map[cName];
    icon = map[cIcon] == null ? null : CustomImageData.fromJson(map[cIcon]);
   
    happiness = map[cHappiness];
    diligence = map[cDiligence];
    strategy = map[cStrategy];
    durability = map[cDurability];
    potencial = map[cPotencial];

    happinessBase = map[cBHappiness];
    diligenceBase = map[cBDiligence];
    strategyBase = map[cBStrategy];
    durabilityBase = map[cBDurability];
    potencialBase = map[cBPotencial];
  }

  void setChars(Map<Characteristic, int> newUserChars) {
    happiness = newUserChars[Characteristic.happiness] ?? 0;
    diligence = newUserChars[Characteristic.diligence] ?? 0;
    strategy = newUserChars[Characteristic.strategy] ?? 0;
    durability = newUserChars[Characteristic.durability] ?? 0;
    potencial = newUserChars[Characteristic.potencial] ?? 0;
  }
}

// Базовый репозиторий пользователей
class ProfileRepository {
  Database db = DB.db!;

  Future<Profile> insert(Profile tsk) async {
    tsk.id = await db.insert(Profile.tn, tsk.toMap());
    return tsk;
  }

  Future<List<int>> insertBatch(Iterable<Profile> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (Profile m in models) {
        res.add(await txn.insert(Profile.tn, m.toMap()));
      }
    });
    return res;
  }

  Future<Profile?> get() async {
    List<Map> maps = await db.query(Profile.tn);
    if (maps.isNotEmpty) {
      return Profile.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int?> delete(int id) async {
    await deleteIconIfSetupNull(id: id);
    return await db.delete(Profile.tn, where: '${Profile.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(Profile usr) async {
    await deleteIconIfSetupNull(obj: usr);
    return await db.update(
      Profile.tn,
      usr.toMap(),
      where: '${Profile.cId} = ?',
      whereArgs: [usr.id],
    );
  }

  Future deleteIconIfSetupNull({int? id, Profile? obj}) async {
    // Если удаление
    if (id != null) {
      var oldObject = await get();
      // Удаляем, если было
      if (oldObject != null &&
          oldObject.icon != null &&
          oldObject.icon!.isImage) {
        await FileService.deleteOldFile(oldObject.icon!.imagePath);
      }
    }
    // Если обновление
    else if (obj != null) {
      var oldObject = await get();
      // Удаляем, если было и изменилось
      if (oldObject != null &&
          oldObject.icon != null &&
          oldObject.icon!.imagePath != obj.icon?.imagePath &&
          oldObject.icon!.isImage) {
        await FileService.deleteOldFile(oldObject.icon!.imagePath);
      }
    }
  }
}
