import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_tile.dart';
import 'package:flutter/material.dart';

class WallTreeFabric implements TreeTileFabric<Wall, WallTreeTile> {
  @override
  WallTreeTile create({
    required TreeRecord<Wall> record,
    VoidCallback? openCallback,
    VoidCallback? selectCallback,
    VoidCallback? deleteCallback,
    VoidCallback? selectModeCallback,
    bool? isSelected,
    bool? isSelectionMode,
    IconData? customAltIcon,
  }) {
    return WallTreeTile(
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

class WallTreeTile extends StatelessWidget {
  final TreeRecord<Wall> record;
  final VoidCallback? openCallback,
      selectCallback,
      deleteCallback,
      selectModeCallback;
  final bool isSelected, isSelectionMode;

  const WallTreeTile({
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
    Color titleColor = Theme.of(context).colorScheme.onPrimary;

    // Чекбокс выделения записи
    final selectCheckboxWidget = Checkbox(
      value: isSelected,
      onChanged: (_) => selectCallback?.call(),
    );

    // Название
    final titleWidget = CustomText(
      record.name ?? '',
      padding: EdgeInsets.only(right: 8),
      expanded: true,
      overflow: TextOverflow.ellipsis,
      weight: record.isFolder ? FontWeight.w500 : FontWeight.normal,
      color: titleColor,
    );

    // Кнопка удаления
    final deleteButtonWidget = IconButton(
      icon: const Icon(Icons.delete_outline, size: 16),
      onPressed: deleteCallback,
      tooltip: 'Удалить',
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
                if (isSelectionMode)
                  Padding(
                    padding: EdgeInsetsGeometry.only(right: 12),
                    child: selectCheckboxWidget,
                  ),

                // Информация
                titleWidget,

                if (isSelectionMode) ...{
                  SizedBox(width: 8),
                  deleteButtonWidget,
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
