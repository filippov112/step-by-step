import 'package:chaos_control/models/target.dart';
import 'package:chaos_control/screens/targets/list/target_list_model.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetTreeFabric implements TreeTileFabric<Target, TargetTreeTile> {
  @override
  TargetTreeTile create({
    required TreeRecord<Target> record,
    VoidCallback? openCallback,
    VoidCallback? selectCallback,
    VoidCallback? deleteCallback,
    VoidCallback? selectModeCallback,
    bool? isSelected,
    bool? isSelectionMode,
    IconData? customAltIcon,
  }) {
    return TargetTreeTile(
      record: record,
      isSelected: isSelected ?? false,
      isSelectionMode: isSelectionMode ?? false,
      openCallback: openCallback,
      selectCallback: selectCallback,
      selectModeCallback: selectModeCallback,
      deleteCallback: deleteCallback,
    );
  }
}

class TargetTreeTile extends StatelessWidget {
  final TreeRecord<Target> record;
  final VoidCallback? openCallback,
      selectCallback,
      deleteCallback,
      selectModeCallback;
  final bool isSelected, isSelectionMode;

  const TargetTreeTile({
    super.key,
    required this.record,
    this.openCallback,
    this.selectCallback,
    this.selectModeCallback,
    this.deleteCallback,
    required this.isSelected,
    required this.isSelectionMode,
  });

  void _onTap() {
    if (isSelectionMode) {
      selectCallback?.call();
    } else {
      openCallback?.call();
    }
  }

  void _onLongPress() {
    if (!isSelectionMode) {
      selectModeCallback?.call();
      selectCallback?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bRadius = const BorderRadius.all(Radius.circular(16));
    final tasks = context.select<TargetListModel, Map<String, int>>(
      (m) => m.tasks,
    );

    Color? containterColor = Theme.of(context)
        .colorScheme
        .surfaceContainerHighest
        .withValues(alpha: record.isFolder ? 0.3 : 0.9);
    Gradient? containterBorderColor = record.color == null
        ? null
        : LinearGradient(
            transform: GradientRotation(0.7),
            colors: [record.color!.withValues(alpha: 0.5), containterColor],
            stops: [0, 0.2],
          );
    final titleColor = Theme.of(context).colorScheme.onPrimary;
    final focusColor = Theme.of(context).focusColor;

    // Чекбокс выделения записи
    final selectCheckboxWidget = Checkbox(
      value: isSelected,
      onChanged: (_) => selectCallback?.call(),
    );

    // Название
    final titleWidget = CustomText(
      record.name ?? '',
      size: 17,
      overflow: TextOverflow.ellipsis,
      padding: const EdgeInsets.only(bottom: 3),
      weight: record.isFolder ? FontWeight.w500 : FontWeight.normal,
      color: titleColor,
    );

    // Кнопка удаления
    final deleteButtonWidget = IconButton(
      icon: const Icon(Icons.delete_outline, size: 16),
      onPressed: deleteCallback,
      tooltip: 'Удалить',
    );

    final favoriteWidget = (record.object?.favorite ?? false)
        ? Icon(Icons.star, size: 18, color: focusColor.withAlpha(120),)
        : null;

    // Иконка
    final folderIconWidget = !record.isFolder
        ? null
        : Padding(
            padding: const EdgeInsetsGeometry.fromLTRB(12, 12, 0, 12),
            child: CustomImageIcon(
              record.customIconData,
              altIcon: Icons.folder,
              color: focusColor,
              width: 40,
              height: 40,
            ),
          );

    // Итоговая карточка
    final card = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: containterBorderColor,
          borderRadius: bRadius,
          color: containterColor,
        ),
        child: InkWell(
          borderRadius: bRadius,
          onTap: _onTap,
          onLongPress: _onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                // Чекбокс для выделения или статуса
                if (isSelectionMode) selectCheckboxWidget,

                // Иконка каталога
                if (!isSelectionMode) ?folderIconWidget,

                // Информация
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Expanded(child:titleWidget), ?favoriteWidget],
                        ),
                      ),
                    ],
                  ),
                ),

                if (isSelectionMode) ...{
                  deleteButtonWidget,
                  SizedBox(width: 12),
                },
              ],
            ),
          ),
        ),
      ),
    );

    return isSelectionMode && record.isFolder && record.children == null
        ? SizedBox()
        : card;
  }
}
