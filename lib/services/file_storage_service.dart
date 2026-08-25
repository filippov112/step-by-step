// lib/services/file_storage_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class FileService {

  // Сохраняет иконку
  static Future<String?> saveIcon(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final iconDir = Directory('${appDir.path}/icons');
      if (!await iconDir.exists()) {
        await iconDir.create(recursive: true);
      }
      final guid = const Uuid().v7();
      final fileName = 'icon_$guid.jpg';
      final newPath = '${iconDir.path}/$fileName';
      final newFile = await imageFile.copy(newPath);
      
      return newFile.path;
    } catch (e) {
      // print('Ошибка сохранения иконки достижения: $e');
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
  
  // Выбор изображения из галереи
  static Future<File?> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
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