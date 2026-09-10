import 'package:chaos_control/screens/purports/images/purport_images_model.dart';
import 'package:chaos_control/services/file_storage_service.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageAddButton extends StatelessWidget {
  const ImageAddButton({super.key});

  // Выбор изображения
  Future<bool> pickImage(BuildContext context, Function(String?) callback) async {
    try {
      final file = await FileService.pickImageFromGallery(full: true);
      if (file == null) return false;

      final savedPath = await FileService.saveImage(file);
      if (savedPath != null) {
        callback(savedPath);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<PurportImagesModel>();

    return CustomFloatingActionButton(callback: () => pickImage(context, model.addImage), tooltip: '');
  }
}