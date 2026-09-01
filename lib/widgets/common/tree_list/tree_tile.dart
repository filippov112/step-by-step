import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';

class CustomTreeTile<T> extends StatelessWidget {
  final TreeRecord<T> record;
  final VoidCallback? openCallback,
      selectCallback,
      deleteCallback,
      selectModeCallback;
  final bool isSelected, isSelectionMode;
  final IconData customAltIcon;

  const CustomTreeTile({
    super.key,
    required this.record,
    required this.openCallback,
    required this.selectCallback,
    required this.selectModeCallback,
    required this.deleteCallback,
    required this.isSelected,
    required this.isSelectionMode,
    required this.customAltIcon,
  });

  @override
  Widget build(BuildContext context) {
    Color? containterColor = Theme.of(
      context,
    ).colorScheme.surfaceContainerHighest.withValues(alpha: record.isFolder ? 0.3 : 0.9);
    Gradient? containterBorderColor = record.color == null
        ? null
        : LinearGradient(
            transform: GradientRotation(0.7),
            colors: [record.color!.withValues(alpha: 0.5), containterColor],
            stops: [0, 0.2],
          );
    Color titleColor = Theme.of(context).colorScheme.onPrimary;

    return isSelectionMode && record.isFolder && record.children == null ? SizedBox() : Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: containterBorderColor,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: containterColor,
        ),
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          onTap: () {
            if (isSelectionMode) {
              selectCallback?.call();
            } else {
              openCallback?.call();
            }
          },
          onLongPress: () {
            if (!isSelectionMode) {
              selectModeCallback?.call();
              selectCallback?.call();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Row(
              children: [
                // Чекбокс для выделения или статуса
                Padding(
                  padding: EdgeInsetsGeometry.only(right: 12),
                  child: isSelectionMode
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (_) => selectCallback?.call(),
                        )
                      : Padding(
                          padding: const EdgeInsetsGeometry.fromLTRB(
                            12,
                            12,
                            0,
                            12,
                          ),
                          child: CustomImageIcon(
                            record.customIconData,
                            altIcon: customAltIcon,
                            color: record.color,
                            width: 40,
                            height: 40,
                          ),
                        ),
                ),

                // Информация
                Expanded(
                  child: CustomText(
                    record.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    weight: record.isFolder ? FontWeight.w500 : FontWeight.normal,
                    color: titleColor,
                  ),
                ),

                if (isSelectionMode) ...{
                  SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    onPressed: deleteCallback,
                    tooltip: 'Удалить',
                  ),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}
