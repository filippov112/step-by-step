import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/record.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';

class RecordView extends StatelessWidget {
  final ChronicleRecord record;

  const RecordView({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(context).dividerColor;
    final focusColor = Theme.of(context).focusColor;
    final challengeColor = Colors.orange;
    final favoriteColor = Colors.amberAccent;

    // -------- Дата -----------

    final dateWidget = CustomText(
      DateTool.shortDateFormat(record.date),
      color: focusColor,
      expanded: true,
      align: TextAlign.center,
      size: 12,
      padding: const EdgeInsets.only(bottom: 2),
    );

    // --------- Длительность ---------

    final hoursIcon = Icon(
      Icons.timer,
      shadows: [Shadow(color: focusColor, blurRadius: 15)],
      size: 15,
      color: focusColor,
    );
    final hoursCount = CustomText(
      '${record.hours} h.',
      size: 14,
      weight: const FontWeight(500),
      padding: const EdgeInsets.only(left: 4, right: 8, bottom: 1),
    );

    // ------ Типы характеристик ---------

    final charTypesIcons = record.charTypes.map(
      (type) => Padding(
        padding: const EdgeInsetsGeometry.only(right: 4),
        child: Icon(
          Characteristic.values[type].icon,
          shadows: [
            Shadow(color: Characteristic.values[type].color, blurRadius: 15),
          ],
          size: 15,
          color: Characteristic.values[type].color,
        ),
      ),
    );

    // ------ Испытание ---------

    final challengeIcon = record.challenge
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

    final favoriteIcon = record.favorite
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

    final header = Padding(
      padding: const EdgeInsetsGeometry.all(12),
      child: Row(
        children: [
          Expanded(child: Wrap(children: [?challengeIcon, ...charTypesIcons])),
          dateWidget,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [?favoriteIcon, hoursIcon, hoursCount],
            ),
          ),
        ],
      ),
    );

    final descWidget = Expanded(
      child: SingleChildScrollView(
        child: CustomText(
          record.description,
          padding: const EdgeInsets.all(8),
          overflow: TextOverflow.visible,
          shadow: Shadow(
            color: Theme.of(context).colorScheme.onPrimary,
            blurRadius: 3,
          ),
          lines: null,
        ),
      ),
    );

    final buttonRow = Padding(
      padding: const EdgeInsetsGeometry.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 8),
      child: Dialog(
        insetPadding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            Divider(color: dividerColor, height: 2),
            descWidget,
            Divider(color: dividerColor, height: 2),
            buttonRow,
          ],
        ),
      ),
    );
  }
}
