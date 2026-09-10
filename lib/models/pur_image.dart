import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/purport.dart';
import 'package:chaos_control/services/file_storage_service.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';


// Изображения-смыслы
class PurImage {
  // ------------ Схема ------------
  static const tn = "pur_images";
  
  static const cId = "_id";
  static const cPurportId = "_purport_id";
  static const cPath = "_path";
  static const cName = "_name";
  static const cDesc = "_desc";


  static const init = '''CREATE TABLE $tn (
    $cId TEXT PRIMARY KEY, 
    $cPurportId TEXT,
    $cPath TEXT,
    $cName TEXT,
    $cDesc TEXT,
    
    FOREIGN KEY ($cPurportId) REFERENCES ${Purport.tn}(${Purport.cId}) ON DELETE CASCADE
  );
  ''';

  // ------------ Поля ------------

  String id = '';
  String purportId = ''; // Смысл
  String path = ''; // Путь к файлу
  String name = ''; // Название
  String desc = ''; // Примечание

  // ------------ Конструкторы ------------

  PurImage({
    required this.id,
    required this.purportId,
    required this.path,
    required this.name,
    required this.desc
  });

  factory PurImage.create({
    required String purportId,
    required String path,
    String name = '',
    String desc = ''
  }) {
    final guid = const Uuid().v4();
    return PurImage(
      id: guid,
      purportId: purportId,
      path: path,
      name: name,
      desc: desc
    );
  }

  // ------------ Сериализация ------------
  Map<String, Object?> toMap() {
    return {
      cId: id,
      cPurportId: purportId,
      cPath: path,
      cName: name,
      cDesc: desc,
    };
  }

  PurImage.fromMap(Map map) {
    id = map[cId];
    purportId = map[cPurportId];
    path = map[cPath];
    name = map[cName];
    desc = map[cDesc];
  }
}

// Базовый репозиторий
class PurImageRepository {
  
  Future<List<PurImage>> getByPurport(String? purportId) async {
    if (purportId == null) return [];
    List<Map<String, Object?>> maps = await db.query(PurImage.tn, where: '${PurImage.cPurportId} = ?', whereArgs: [purportId]);
    return maps.map((m) => PurImage.fromMap(m)).toList();
  }

  Database db = DB.db!;

  Future<List<PurImage>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(PurImage.tn);
    return maps.map((m) => PurImage.fromMap(m)).toList();
  }

  Future<PurImage> insert(PurImage image) async {
    await db.insert(PurImage.tn, image.toMap());
    return image;
  }

  Future<PurImage?> get(String id) async {
    List<Map> maps = await db.query(
      PurImage.tn,
      where: '${PurImage.cId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return PurImage.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int> update(PurImage image) async {
    await deleteIconIfSetupNull(obj:image);
    return await db.update(
      PurImage.tn,
      image.toMap(),
      where: '${PurImage.cId} = ?',
      whereArgs: [image.id],
    );
  }

  Future<int?> delete(String id) async {
    await deleteIconIfSetupNull(id:id);
    return await db.delete(
      PurImage.tn,
      where: '${PurImage.cId} = ?',
      whereArgs: [id],
    );
  }

  Future deleteIconIfSetupNull({String? id, PurImage? obj}) async {
    // Если удаление
    if (id != null) {
      var oldObject = await get(id);
      // Удаляем, если было
      if (oldObject != null &&
          oldObject.path.isNotEmpty
        ) {
        await FileService.deleteOldFile(oldObject.path);
      }
    }
    // Если обновление
    else if (obj != null) {
      var oldObject = await get(obj.id);
      // Удаляем, если было и изменилось
      if (oldObject != null &&
          oldObject.path.isNotEmpty &&
          oldObject.path != obj.path) {
        await FileService.deleteOldFile(oldObject.path);
      }
    }
  }
}

enum TransactionType {
  add,
  remove,
  update
}