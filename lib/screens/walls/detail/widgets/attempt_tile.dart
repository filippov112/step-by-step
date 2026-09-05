import 'package:chaos_control/models/attempt.dart';
import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:chaos_control/screens/walls/detail/attempt_form_model.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/common/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallDetailAttemptTile extends StatelessWidget {
  final Attempt attempt;
  const WallDetailAttemptTile({super.key, required this.attempt});

  @override
  Widget build(BuildContext context) {
    final formModel = context.read<AttemptFormModel>();
    final tabModel = context.read<WallDetailModel>();
    final isSelectionMode = context.select<WallDetailModel,bool>((m) => m.isSelectionMode);
    final selectedIds = context.select<WallDetailModel,Set<String>>((m) => m.selectedIds);
    final isSelectedAttempt = context.select<WallDetailModel,bool>((m) => m.editionAttempt?.id == attempt.id);

    final successColor = Color.lerp(WallStatus.retreated.color, WallStatus.destroyed.color, attempt.success.toDouble() / 100);
    final dividerColor = Theme.of(context).dividerColor;
    final focusColor = Theme.of(context).focusColor;

    final selectCheckbox = isSelectionMode ? Checkbox(value: selectedIds.contains(attempt.id), onChanged: (_) => tabModel.toggleSelect(attempt.id)) : null;
    final dateWidget = CustomText(
      DateTool.shortDateFormat(attempt.date), expanded: true, color: focusColor, size: 12, padding: const EdgeInsets.only(bottom: 2),
      );
    final successIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(WallStatus.destroyed.icon, size: 12, color: successColor),
    );
    final successPercent = CustomText(
      '${attempt.success}%',
      size: 16,
      padding: const EdgeInsets.only(bottom: 3),
      color: successColor,
    );
    final spiritIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(Icons.local_fire_department, size: 14),
    );
    final spiritFragments = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomText(
          '${attempt.spiritFragments}',
          size: 16,
          padding: const EdgeInsets.only(bottom: 3),
          color: focusColor,
        ),
        CustomText(
          'SF',
          size: 12,
          padding: const EdgeInsets.only(left: 2, bottom: 5, right: 16),
          color: focusColor,
        ),
      ],
    );


    final header = Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ?selectCheckbox,
                dateWidget,
                spiritIcon,
                spiritFragments,
                successIcon,
                successPercent,
              ],
            );
    final descWidget = CustomText(attempt.description);

    void select() {
      tabModel.toggleSelect(attempt.id);
    }

    void edit() {
      formModel.initAttempt(
        attempt,
        tabModel.wall,
        tabModel.attempts.length,
      );
      tabModel.openForm(attempt);
    }

    return Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 8),
      child: CustomTile(
        borderRadius: 12,
        borderColor: isSelectedAttempt ? focusColor : dividerColor,
        padding: 8,
        longPressCallback: select,
        callback: isSelectionMode ? select : edit,
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
