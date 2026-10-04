import 'package:step_by_step/models/record.dart';
import 'package:step_by_step/screens/records/widgets/tile.dart';
import 'package:step_by_step/services/numerictool.dart';
import 'package:step_by_step/widgets/common/custom_image_icon.dart';
import 'package:step_by_step/widgets/common/custom_text.dart';
import 'package:step_by_step/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';

class RecordTileFolder extends RecordTreeTile {
  const RecordTileFolder({
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

  int getSumHours(List<TreeRecord<ChronicleRecord>>? records) {
    int sum = 0;
    if (records == null) return sum;
    for (var r in records) {
      sum += r.object?.chars.hours ?? 0;
    }
    return sum;
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
      weight: FontWeight.w500,
      color: titleColor,
    );

    // Суммарное число часов по каталогу
    final hoursWidget = record.children == null ? null : Row(
      children: [
        Icon(
          Icons.timer,
          size: 12,
          shadows: [Shadow(color: focusColor, blurRadius: 12)],
        ),
        const SizedBox(width: 4),
        CustomText('${NumericTool.toThousandString(getSumHours(record.children))} h.', color: focusColor, size: 11,),
      ],
    );

    // Кол-во записей в каталоге
    final countWidget = record.children == null ? null : CustomText('(${record.children?.length ?? 0})');

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
    return (record.children == null && isSelectionMode) ? SizedBox() : Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: containterBorderColor,
          borderRadius: bRadius,
          border: isSelected ? Border.all(color:focusColor, width: 1) : null,
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
                        padding: EdgeInsets.only(left:12, right: 12, top: 12), 
                        child: titleWidget
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(left:12, right: 12, top:2),
                        child: hoursWidget,
                      ),
                      const SizedBox(height: 12,)
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsetsGeometry.only(top:12, bottom:14, right: 12),
                  child: countWidget,
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
