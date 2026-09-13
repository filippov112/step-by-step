import 'package:chaos_control/screens/purports/sounds/purport_sounds_model.dart';
import 'package:chaos_control/services/file_storage_service.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SoundAddButton extends StatelessWidget {
  const SoundAddButton({super.key});

  // Выбор изображения
  Future<bool> pickImage(BuildContext context, Function(String?, String?) callback) async {
    try {
      final file = await FileService.pickAudioFile();
      if (file == null) return false;

      final savedPath = await FileService.saveFile(file.path, SupportedFileType.sounds);
      if (savedPath != null) {
        callback(savedPath.$1, savedPath.$2);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<PurportSoundsModel>();

    return CustomFloatingActionButton(callback: () => pickImage(context, model.add), tooltip: '');
  }
}