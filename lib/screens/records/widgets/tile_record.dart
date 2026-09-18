import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/record.dart';
import 'package:chaos_control/screens/records/widgets/tile.dart';
import 'package:chaos_control/screens/records/widgets/view.dart';
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
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    final challengeColor = Colors.orange;
    final favoriteColor = Colors.amberAccent;

    final selectCheckbox = isSelectionMode && record.object != null
        ? Checkbox(value: isSelected, onChanged: (v) => _onTap())
        : null;

    // -------- Дата -----------

    final dateWidget = CustomText(
      DateTool.shortDateFormat(record.object?.date),
      color: focusColor,
      expanded: true,
      align: TextAlign.center,
      size: 12,
      padding: const EdgeInsets.only(bottom: 2),
    );

    // --------- Длительность ---------

    final hoursIcon = Icon(
      Icons.timer,
      shadows: record.object == null
          ? null
          : [Shadow(color: focusColor, blurRadius: 15)],
      size: 15,
      color: focusColor,
    );
    final hoursCount = CustomText(
      '${(record.object?.hours ?? 0)} h.',
      size: 14,
      weight: const FontWeight(500),
      padding: const EdgeInsets.only(left: 4, right: 8, bottom: 1),
    );

    // ------ Типы характеристик ---------

    final charTypesIcons = record.object?.charTypes.map(
      (type) => Padding(
        padding: const EdgeInsetsGeometry.only(right: 4),
        child: Icon(
          Characteristic.values[type].icon,
          shadows: record.object == null
              ? null
              : [
                  Shadow(
                    color: Characteristic.values[type].color,
                    blurRadius: 15,
                  ),
                ],
          size: 15,
          color: Characteristic.values[type].color,
        ),
      ),
    );

    // ------ Испытание ---------

    final challengeIcon = (record.object?.challenge ?? false)
        ? Padding(
            padding: const EdgeInsetsGeometry.only(right: 4),
            child: Icon(
              Icons.center_focus_strong,
              shadows: [Shadow(color: challengeColor, blurRadius: 15)],
              size: 15,
              color: challengeColor,
            ),
          )
        : null;

    // ------ Избранное ---------

    final favoriteIcon = (record.object?.favorite ?? false)
        ? Padding(
            padding: const EdgeInsetsGeometry.only(right: 4),
            child: Icon(
              Icons.star,
              shadows: [Shadow(color: favoriteColor, blurRadius: 15)],
              size: 15,
              color: favoriteColor,
            ),
          )
        : null;

    // ====== MAIN =========

    final header = Row(
      children: [
        Expanded(
          child: Wrap(
            children: [?selectCheckbox, ?challengeIcon, ...?charTypesIcons],
          ),
        ),
        dateWidget,
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [?favoriteIcon, hoursIcon, hoursCount],
          ),
        ),
      ],
    );

    final descWidget = CustomText(
      record.object?.description ?? '',
      padding: const EdgeInsets.all(8),
      overflow: TextOverflow.visible,
      shadow: Shadow(
        color: Theme.of(context).colorScheme.onPrimary,
        blurRadius: 3,
      ),
      expanded: true,
      lines: 3,
    );

    final detailButton =  isSelectionMode ? null : IconButton(
      color: onPrimaryColor.withAlpha(50),
      icon: Icon(Icons.info),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => RecordView(
          record:
              record.object ?? ChronicleRecord.create(date: DateTool.today()),
        ),
      ),
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
            Row(children: [descWidget, ?detailButton]),
          ],
        ),
      ),
    );
  }
}
