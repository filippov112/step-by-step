// lib/services/file_storage_service.dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

enum SupportedFileType { images, sounds }

class FileService {

  // Сохраняет файл
  static Future<(String, String)?> saveFile(String? sourcePath, SupportedFileType type) async {
    try {
      if (sourcePath == null) throw 'Файл не найден';
      final appDir = await getApplicationDocumentsDirectory();
      final audioDir = Directory(p.join(appDir.path, type.name));
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }

      final guid = const Uuid().v7();
      final name = p.basenameWithoutExtension(sourcePath);
      final ext = p.extension(sourcePath);
      final fileName = '${type.name}_$guid.$ext';
      final destPath = p.join(audioDir.path, fileName);
  
      await File(sourcePath).copy(destPath);
      return (name, destPath);
    } catch (e) {
      return null;
    }
  }
  
  // Удаляет старый файл
  static Future deleteOldFile(String? oldPath) async {
    if (oldPath == null) return;
    try {
      final file = File(oldPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // print('Ошибка удаления файла: $e');
    }
  }

  // Загрузка аудио
  static Future<PlatformFile?> pickAudioFile() async {
    if (!await _requestAudioPermission()) return null;
    final result = await FilePicker.pickFiles(
      type: FileType.audio,
    );
    return result.first;
  }
  static Future<bool> _requestAudioPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.audio.request();
      return status.isGranted;
    }
    return true;
  }
  
  // Загрузка изображения
  static Future<File?> pickImageFromGallery({bool full = false}) async {
    try {
      final ImagePicker picker = ImagePicker();
      late XFile? image;
      if (full) {
        image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      } else {
        image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 512,
          maxHeight: 512,
          imageQuality: 85,
        );
      }
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      // print('Ошибка выбора изображения: $e');
      return null;
    }
  }
}