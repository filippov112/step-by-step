import 'package:chaos_control/models/pur_image.dart';
import 'package:chaos_control/screens/purports/images/purport_images_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImagesAppbar extends StatelessWidget {
  const ImagesAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<PurportImagesModel>();
    final selectedIds = context.select<PurportImagesModel, Set<String>>(
      (m) => m.selectedIds,
    );
    final isSelectionMode = context.select<PurportImagesModel, bool>(
      (m) => m.isSelectionMode,
    );
    final images = context.select<PurportImagesModel, List<PurImage>>(
      (m) => m.images,
    );
    final selectedCount = selectedIds.length;
    final allCount = images.length;

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
