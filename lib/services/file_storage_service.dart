import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileStorageService {
  // Сохраняет изображение в постоянное хранилище и возвращает новый путь
  Future<String?> saveAvatar(File imageFile) async {
    try {
      // Получаем директорию для документов приложения
      final appDir = await getApplicationDocumentsDirectory();
      
      // Создаем папку для аватаров (если её нет)
      final avatarDir = Directory('${appDir.path}/avatars');
      if (!await avatarDir.exists()) {
        await avatarDir.create(recursive: true);
      }
      
      // Генерируем уникальное имя файла
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newPath = '${avatarDir.path}/$fileName';
      
      // Копируем файл
      final newFile = await imageFile.copy(newPath);
      
      return newFile.path;
    } catch (e) {
      print('Ошибка сохранения аватара: $e');
      return null;
    }
  }
  
  // Удаляет старый аватар (опционально)
  Future<void> deleteOldAvatar(String? oldPath) async {
    if (oldPath == null) return;
    try {
      final file = File(oldPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Ошибка удаления старого аватара: $e');
    }
  }
}