import 'dart:io';
import 'package:chaos_control/themes/solo_leveling_theme.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
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
      PermissionStatus status;
      // Android 13 (API 33) и выше используют Permission.audio
      if (await _getAndroidVersion() >= 33) {
        status = await Permission.audio.request();
      } else {
        // Android 12 и ниже используют Permission.storage (READ_EXTERNAL_STORAGE)
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
    return true;
  }

  static Future<int> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      return info.version.sdkInt;
    }
    return 0;
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
        if (!Platform.isAndroid && !Platform.isIOS) {
          return File(image.path);
        }
        var croppedFile = await ImageCropper().cropImage(
          compressFormat: ImageCompressFormat.png,
          compressQuality: 100,
          sourcePath: image.path,
          
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Обрезка',
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              toolbarColor: SoloLevelingTheme.back1,
              statusBarLight: false,
              navBarLight: false,
              toolbarWidgetColor: SoloLevelingTheme.text1,
              backgroundColor: SoloLevelingTheme.back2,
              cropFrameColor: SoloLevelingTheme.back2,
              activeControlsWidgetColor: SoloLevelingTheme.active1,
              dimmedLayerColor: SoloLevelingTheme.back1
            ),
            IOSUiSettings(
              title: 'Обрезка',
            ),
          ],
        );
        if (croppedFile != null) {
          return File(croppedFile.path);
        }
        return null;
      }
      return null;
    } catch (e) {
      print('Ошибка выбора изображения: $e');
      return null;
    }
  }


}