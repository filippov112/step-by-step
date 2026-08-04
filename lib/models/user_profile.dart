import 'package:life_game/data/db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class UserProfileModel {
  static const tn = "profiles";
  static const cId = "_id";
  static const cName = "_name";
  static const cIcon = "_icon";
  static const dBirth = "_dbirth";

  static const init = '''CREATE TABLE $tn (
          $cId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $cName TEXT NOT NULL, 
          $cIcon TEXT,
          $dBirth DATETIME
        )''';

  int? id;
  String name = "";
  String? icon;
  DateTime dateBirth = DateTime(2000);

  UserProfileModel({this.name = "", this.icon, required this.dateBirth});

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      cName: name,
      cIcon: icon ?? "",
      dBirth: dateBirth.millisecondsSinceEpoch
    };
    if (id != null) {
      map[cId] = id;
    }
    return map;
  }

  UserProfileModel.fromMap(Map map) {
    id = map[cId];
    name = map[cName];
    icon = map[cIcon];
    dateBirth = DateTime.fromMillisecondsSinceEpoch(map[dBirth]);
  }
}


class UserProfileProvider {
  Database db = DB.db!;

  Future<UserProfileModel> insert(UserProfileModel tsk) async {
    tsk.id = await db.insert(UserProfileModel.tn, tsk.toMap());
    return tsk;
  }

  Future<List<int>> insertBatch(Iterable<UserProfileModel> models) async {
    List<int> res = [];
    await db.transaction((txn) async {
      for (UserProfileModel m in models) {
        res.add(
          await txn.insert(UserProfileModel.tn, m.toMap()));
      }
      
    });
    return res;
  }

  Future<UserProfileModel?> get() async {
    List<Map> maps = await db.query(UserProfileModel.tn);
    if (maps.isNotEmpty) {
      return UserProfileModel.fromMap(maps.first as Map<String,Object?>);
    }
    return null;
  }

  Future<int?> delete(int id) async {
    return await db.delete(UserProfileModel.tn, where: '${UserProfileModel.cId} = ?', whereArgs: [id]);
  }

  Future<int?> update(UserProfileModel tsk) async {
    return await db.update(UserProfileModel.tn, tsk.toMap(),
        where: '${UserProfileModel.cId} = ?', whereArgs: [tsk.id]);
  }
}

