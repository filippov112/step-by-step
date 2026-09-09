import 'package:chaos_control/screens/barriers/widgets/tile.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';


class BarrierTileFolder extends BarrierTreeTile {

  const BarrierTileFolder({
    super.key,
    required super.record,
    super.openCallback,
    super.selectCallback,
    super.selectModeCallback,
    super.deleteCallback,
    required super.isSelected,
    required super.isSelectionMode,
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
      weight: FontWeight.w500,
      color: titleColor,
    );

    // Кнопка удаления
    final deleteButtonWidget = IconButton(
      icon: const Icon(Icons.delete_outline, size: 16),
      onPressed: deleteCallback,
      tooltip: 'Удалить',
    );

    // Иконка
    final folderIconWidget = Padding(
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
    return Padding(
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
                if (!isSelectionMode) folderIconWidget,

                // Информация
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: titleWidget
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
  }
}
