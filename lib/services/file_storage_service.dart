// lib/services/file_storage_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class FileStorageService {
  // Сохраняет изображение в постоянное хранилище и возвращает новый путь
  Future<String?> saveAvatar(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final avatarDir = Directory('${appDir.path}/avatars');
      if (!await avatarDir.exists()) {
        await avatarDir.create(recursive: true);
      }
      
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newPath = '${avatarDir.path}/$fileName';
      final newFile = await imageFile.copy(newPath);
      
      return newFile.path;
    } catch (e) {
      print('Ошибка сохранения аватара: $e');
      return null;
    }
  }
  
  // Сохраняет иконку навыка
  Future<String?> saveSkillIcon(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final iconDir = Directory('${appDir.path}/skill_icons');
      if (!await iconDir.exists()) {
        await iconDir.create(recursive: true);
      }
      
      final fileName = 'skill_icon_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newPath = '${iconDir.path}/$fileName';
      final newFile = await imageFile.copy(newPath);
      
      return newFile.path;
    } catch (e) {
      print('Ошибка сохранения иконки навыка: $e');
      return null;
    }
  }

  // Сохраняет иконку достижения
  Future<String?> saveAchievementIcon(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final iconDir = Directory('${appDir.path}/achievement_icons');
      if (!await iconDir.exists()) {
        await iconDir.create(recursive: true);
      }
      
      final fileName = 'achievement_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newPath = '${iconDir.path}/$fileName';
      final newFile = await imageFile.copy(newPath);
      
      return newFile.path;
    } catch (e) {
      print('Ошибка сохранения иконки достижения: $e');
      return null;
    }
  }
  
  // Удаляет старый файл
  Future<void> deleteOldFile(String? oldPath) async {
    if (oldPath == null) return;
    try {
      final file = File(oldPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Ошибка удаления файла: $e');
    }
  }
  
  // Выбор изображения из галереи
  Future<File?> pickImageFromGallery() async {
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
      print('Ошибка выбора изображения: $e');
      return null;
    }
  }
}