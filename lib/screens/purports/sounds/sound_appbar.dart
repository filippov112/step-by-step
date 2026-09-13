import 'package:chaos_control/models/pur_sound.dart';
import 'package:chaos_control/screens/purports/sounds/purport_sounds_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SoundAppbar extends StatelessWidget {
  const SoundAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<PurportSoundsModel>();
    final selectedIds = context.select<PurportSoundsModel, Set<String>>(
      (m) => m.selectedIds,
    );
    final isSelectionMode = context.select<PurportSoundsModel, bool>(
      (m) => m.isSelectionMode,
    );
    final sounds = context.select<PurportSoundsModel, List<PurSound>>(
      (m) => m.sounds,
    );
    final selectedCount = selectedIds.length;
    final allCount = sounds.length;

    if (!isSelectionMode) return const SizedBox();

    Future deleteFunc(int itemCount) async {
      if (await showConfirmDialog(context) == true) {
        model.deleteAllSelected();
      }
    }

    final titleWidget = CustomText(
      'Выбрано: $selectedCount',
      expanded: true,
      size: 16,
    );

    final Iterable<Widget> selectionActions = [
      // Кнопка "Выбрать все" в режиме выделения
      IconButton(
        icon: Icon(
          selectedCount == allCount ? Icons.deselect : Icons.select_all,
        ),
        onPressed: model.toggleSelectAll,
        tooltip: 'Выбрать все',
      ),

      // Кнопка удаления выбранных
      IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () => deleteFunc(selectedCount),
        tooltip: 'Удалить выбранные',
      ),

      // Кнопка отмены выделения
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: model.clearSelection,
        tooltip: 'Отменить выделение',
      ),
    ];

    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 2),
      child: Row(children: [titleWidget, ...selectionActions]),
    );
  }
}
