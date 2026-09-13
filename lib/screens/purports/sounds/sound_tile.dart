import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/models/pur_sound.dart';
import 'package:chaos_control/screens/purports/sounds/purport_sounds_model.dart';
import 'package:chaos_control/screens/purports/sounds/sound_edit_form.dart';
import 'package:chaos_control/services/audio/audio_player.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SoundTile extends StatelessWidget {
  final PurSound sound;
  const SoundTile({super.key, required this.sound});

  @override
  Widget build(BuildContext context) {
    final model = context.read<PurportSoundsModel>();
    final player = context.read<AudioPlayerService>();
    final isSelectionMode = context.select<PurportSoundsModel, bool>(
      (m) => m.isSelectionMode,
    );
    final selectedImages = context.select<PurportSoundsModel, Set<String>>(
      (m) => m.selectedIds,
    );

    final bRadius = const BorderRadius.all(Radius.circular(16));
    Color? containterColor = Theme.of(
      context,
    ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.9);

    final dividerColor = Theme.of(context).dividerColor;
    Color titleColor = Theme.of(context).colorScheme.onPrimary;

    
    void select() {
      model.toggleSelect(sound.id);
    }

    void play() {
      player.playFile(sound.path);
    }

    void edit() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SoundEditForm(sound: sound)),
      );
    }

    // Иконка
    final iconWidget = Padding(
      padding: const EdgeInsetsGeometry.fromLTRB(12, 12, 0, 12),
      child: CustomImageIcon(
        CustomImageData.fromIcon(Icons.music_note),
        altIcon: Icons.music_note,
        width: 40,
        height: 40,
      ),
    );

    // Чекбокс выделения записи
    final checkboxWidget = isSelectionMode
        ? Checkbox(
            value: selectedImages.contains(sound.id),
            onChanged: (_) => model.toggleSelect(sound.id),
          )
        : null;

    // Редактировать
    final editButton = IconButton(icon: Icon(Icons.edit), onPressed: edit,);

    // Название
    final titleWidget = CustomText(
      sound.title,
      size: 17,
      expanded: true,
      padding: const EdgeInsets.all(12),
      overflow: TextOverflow.ellipsis,
      color: titleColor,
    );

    // Артист
    final artistWidget = CustomText(
      sound.artist ?? '',
      size: 12,
      expanded: true,
      padding: const EdgeInsets.all(12),
      overflow: TextOverflow.ellipsis,
      color: dividerColor,
    );

    // Итоговая карточка
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: bRadius,
          color: containterColor,
        ),
        child: InkWell(
          borderRadius: bRadius,
          onTap: isSelectionMode ? select : play,
          onLongPress: select,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                // Чекбокс для выделения или статуса
                ?checkboxWidget,

                // Иконка
                iconWidget,

                // Информация
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [titleWidget, artistWidget],
                  ),
                ),

                // Редактировать
                editButton
              ],
            ),
          ),
        ),
      ),
    );
  }
}
