import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/enums/difficulty_lvl.dart';
import 'package:chaos_control/screens/records/widgets/tile.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/common/custom_tile.dart';
import 'package:flutter/material.dart';

class RecordTileRecord extends RecordTreeTile {
  const RecordTileRecord({
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
    final dividerColor = Theme.of(context).dividerColor;
    final focusColor = Theme.of(context).focusColor;

    final selectCheckbox = isSelectionMode && record.object != null
        ? Checkbox(value: isSelected, onChanged: (v) => _onTap())
        : null;

    // -------- Дата и статус -----------

    final dateIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(Icons.calendar_month, size: 12, color: focusColor),
    );
    final dateWidget = CustomText(
      DateTool.shortDateFormat(record.object?.date),
      color: focusColor,
      size: 12,
      padding: const EdgeInsets.only(bottom: 2),
    );
    final dateRow = Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [dateIcon, dateWidget],
      ),
    );

    // --------- Сложность ---------

    final diffRang = CustomText(
      record.object?.difficulty.name ?? '',
      size: 16,
      shadow: record.object == null
          ? null
          : Shadow(color: record.object!.difficulty.color, blurRadius: 6),
      color: record.object?.difficulty.color,
      weight: FontWeight.bold,
      padding: const EdgeInsets.only(left: 4, right: 8, bottom: 1),
    );

    // ------ Тип ---------

    final typeIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(
        record.object?.char.icon,
        shadows: record.object == null
            ? null
            : [Shadow(color: record.object!.char.color, blurRadius: 6)],
        size: 15,
        color: record.object?.char.color,
      ),
    );

    // ====== MAIN =========

    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [?selectCheckbox, typeIcon, dateRow, diffRang],
    );
    final descWidget = CustomText(
      record.object?.description ?? '',
      padding: const EdgeInsets.all(8),
      overflow: TextOverflow.visible,
      shadow: Shadow(color: Theme.of(context).colorScheme.onPrimary, blurRadius: 3),
      lines: null,
    );

    return Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 8),
      child: CustomTile(
        borderRadius: 12,
        borderColor: isSelected ? focusColor : dividerColor,
        padding: 8,
        longPressCallback: _onLongPress,
        callback: _onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            Divider(color: dividerColor, height: 2),
            descWidget,
          ],
        ),
      ),
    );
  }
}
