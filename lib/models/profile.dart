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
  
  static const cControl = "_c1";
  static const cPerseverance = "_c2";
  static const cCourage = "_c3";
  static const cDurability = "_c4";
  static const cCreativity = "_c5";

  static const init =
      '''CREATE TABLE $tn (
          $cId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $cName TEXT NOT NULL, 
          $cIcon TEXT,
          
          $cControl INTEGER,
          $cPerseverance INTEGER,
          $cCourage INTEGER,
          $cDurability INTEGER,
          $cCreativity INTEGER
        )''';

  int? id;
  String name = ""; // Никнейм
  CustomImageData? icon; // Аватар
  
  int control = 0;
  int perseverance = 0;
  int courage = 0;
  int durability = 0;
  int creativity = 0;

  int get spiritFragments => control + perseverance + courage + durability + creativity;


  Profile({
    this.name = "",
    this.icon,
    
    this.control = 0,
    this.perseverance = 0,
    this.courage = 0,
    this.durability = 0,
    this.creativity = 0
  });

  Map<Characteristic,int> get chars => <Characteristic,int>{
    Characteristic.control: control,
    Characteristic.perseverance: perseverance,
    Characteristic.courage: courage,
    Characteristic.durability: durability,
    Characteristic.creativity: creativity
  };

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cName: name,
      cIcon: icon?.toJson(),
      
      cControl: control,
      cPerseverance: perseverance,
      cCourage: courage,
      cDurability: durability,
      cCreativity: creativity
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
   
    control = map[cControl];
    perseverance = map[cPerseverance];
    courage = map[cCourage];
    durability = map[cDurability];
    creativity = map[cCreativity];
  }

  void setChars(Map<Characteristic, int> newUserChars) {
    control = newUserChars[Characteristic.control] ?? 0;
    perseverance = newUserChars[Characteristic.perseverance] ?? 0;
    courage = newUserChars[Characteristic.courage] ?? 0;
    durability = newUserChars[Characteristic.durability] ?? 0;
    creativity = newUserChars[Characteristic.creativity] ?? 0;
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
