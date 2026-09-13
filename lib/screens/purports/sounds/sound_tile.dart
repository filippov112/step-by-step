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
    final isCurrent = context.select<AudioPlayerService,bool>((m) => m.current?.id == sound.id);

    final bRadius = const BorderRadius.all(Radius.circular(16));
    Color? containterColor = Theme.of(
      context,
    ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.9);

    final focusColor = Theme.of(context).focusColor;
    Color titleColor = Theme.of(context).colorScheme.onPrimary;

    void select() {
      model.toggleSelect(sound.id);
    }

    void play() {
      player.playFile(sound, model.sounds);
    }

    void edit() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SoundEditForm(sound: sound)),
      );
    }

    // Иконка
    final iconWidget = Padding(
      padding: const EdgeInsetsGeometry.only(top: 12, bottom: 12),
      child: CustomImageIcon(
        CustomImageData.fromIcon(isCurrent ? Icons.play_arrow : Icons.music_note),
        altIcon: Icons.music_note,
        width: 40,
        height: 40,
      ),
    );

    // Чекбокс выделения записи
    final checkboxWidget = isSelectionMode
        ? Padding(
            padding: const EdgeInsetsGeometry.only(right: 12),
            child: Checkbox(
              value: selectedImages.contains(sound.id),
              onChanged: (_) => model.toggleSelect(sound.id),
            ),
          )
        : null;

    // Редактировать
    final editButton = IconButton(icon: Icon(Icons.edit), onPressed: edit);

    // Название
    final titleWidget = CustomText(
      sound.title,
      size: 17,
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      overflow: TextOverflow.ellipsis,
      color: titleColor,
    );

    // Артист
    final artistWidget = CustomText(
      sound.artist ?? '',
      size: 12,
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      overflow: TextOverflow.ellipsis,
      color: focusColor.withAlpha(120),
    );

    // Итоговая карточка
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: bRadius,
          border: isCurrent ? Border.all(color: focusColor, width: 1) : null,
          color: containterColor,
        ),
        child: InkWell(
          borderRadius: bRadius,
          onTap: isSelectionMode ? select : play,
          onLongPress: select,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                editButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
