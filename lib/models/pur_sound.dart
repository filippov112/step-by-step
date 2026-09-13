import 'dart:typed_data';

import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/purport.dart';
import 'package:chaos_control/services/file_storage_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';

// Аудио-смыслы
class PurSound {
  // ------------ Схема ------------
  static const tn = "pur_images";
  
  static const cId = "_id";
  static const cPurportId = "_purport_id";
  static const cPath = "_path";
  static const cTitle = "_title";
  static const cArtist = "_artist";
  static const cDuration = "_duration";
  static const cArtwork = "_artwork";

  static const init = '''CREATE TABLE $tn (
    $cId TEXT PRIMARY KEY, 
    $cPurportId TEXT,
    $cPath TEXT,
    $cTitle TEXT,
    $cArtist TEXT,
    $cDuration INTEGER,
    $cArtwork TEXT,
    
    FOREIGN KEY ($cPurportId) REFERENCES ${Purport.tn}(${Purport.cId}) ON DELETE CASCADE
  );
  ''';

  // ------------ Поля ------------

  final String id;
  final String purportId;
  final String path;         // Путь к файлу
  String title;
  String? artist;
  final Duration? duration;
  final Uint8List? artwork;  // Обложка

  // ------------ Конструкторы ------------

  PurSound({
    required this.id,
    required this.purportId,
    required this.path,
    required this.title,
    this.artist,
    this.duration,
    this.artwork,
  });

  factory PurSound.create({
    required String purportId,
    required String path,         // Путь к файлу
    required String title,
    String? artist = '',
    Duration? duration,
    Uint8List? artwork,
  }) {
    final guid = const Uuid().v4();
    return PurSound(
      id: guid,
      purportId: purportId,
      path: path,
      title: title,
      artist: artist,
      duration: duration,
      artwork: artwork
    );
  }

  // ------------ Сериализация ------------

  Map<String, Object?> toMap() => {
        cId: id,
        cPath: path,
        cPurportId: purportId,
        cTitle: title,
        cArtist: artist,
        cDuration: duration?.inMilliseconds,
        cArtwork: artwork,
      };

  factory PurSound.fromMap(Map map) => PurSound(
        id: map[cId] as String,
        path: map[cPath] as String,
        purportId: map[cPurportId],
        title: map[cTitle] as String,
        artist: map[cArtist] as String?,
        duration: map[cDuration] != null
            ? Duration(milliseconds: map[cDuration] as int)
            : null,
        artwork: map[cArtwork] as Uint8List?,
      );
}

// Базовый репозиторий
class PurSoundRepository {
  
  Future<List<PurSound>> getByPurport(String? purportId) async {
    if (purportId == null) return [];
    List<Map<String, Object?>> maps = await db.query(PurSound.tn, where: '${PurSound.cPurportId} = ?', whereArgs: [purportId]);
    return maps.map((m) => PurSound.fromMap(m)).toList();
  }

  Database db = DB.db!;

  Future<List<PurSound>> getAll() async {
    List<Map<String, Object?>> maps = await db.query(PurSound.tn);
    return maps.map((m) => PurSound.fromMap(m)).toList();
  }

  Future<PurSound> insert(PurSound image) async {
    await db.insert(PurSound.tn, image.toMap());
    return image;
  }

  Future<PurSound?> get(String id) async {
    List<Map> maps = await db.query(
      PurSound.tn,
      where: '${PurSound.cId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return PurSound.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int> update(PurSound image) async {
    await deleteIconIfSetupNull(obj:image);
    return await db.update(
      PurSound.tn,
      image.toMap(),
      where: '${PurSound.cId} = ?',
      whereArgs: [image.id],
    );
  }

  Future<int?> delete(String id) async {
    await deleteIconIfSetupNull(id:id);
    return await db.delete(
      PurSound.tn,
      where: '${PurSound.cId} = ?',
      whereArgs: [id],
    );
  }

  Future deleteIconIfSetupNull({String? id, PurSound? obj}) async {
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