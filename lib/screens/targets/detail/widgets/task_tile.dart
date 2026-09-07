import 'package:chaos_control/models/task.dart';
import 'package:chaos_control/models/enums/target_status.dart';
import 'package:chaos_control/screens/targets/detail/task_form_model.dart';
import 'package:chaos_control/screens/targets/detail/target_detail_model.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/common/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetDetailTaskTile extends StatelessWidget {
  final Task task;
  const TargetDetailTaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final formModel = context.read<TaskFormModel>();
    final tabModel = context.read<TargetDetailModel>();
    final isSelectionMode = context.select<TargetDetailModel,bool>((m) => m.isSelectionMode);
    final selectedIds = context.select<TargetDetailModel,Set<String>>((m) => m.selectedIds);
    final isSelectedTask = context.select<TargetDetailModel,bool>((m) => m.editionTask?.id == task.id);

    final successColor = Color.lerp(TargetStatus.retreated.color, TargetStatus.destroyed.color, task.success.toDouble() / 100);
    final dividerColor = Theme.of(context).dividerColor;
    final focusColor = Theme.of(context).focusColor;

    final selectCheckbox = isSelectionMode ? Checkbox(value: selectedIds.contains(task.id), onChanged: (_) => tabModel.toggleSelect(task.id)) : null;
    final dateWidget = CustomText(
      DateTool.shortDateFormat(task.date), expanded: true, color: focusColor, size: 12, padding: const EdgeInsets.only(bottom: 2),
      );
    final successIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(TargetStatus.destroyed.icon, size: 12, color: successColor),
    );
    final successPercent = CustomText(
      '${task.success}%',
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
          '${task.spiritFragments}',
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
    final descWidget = CustomText(task.description);

    void select() {
      tabModel.toggleSelect(task.id);
    }

    void edit() {
      formModel.initTask(
        task,
        tabModel.target,
        tabModel.tasks.length,
      );
      tabModel.openForm(task);
    }

    return Padding(
      padding: const EdgeInsetsGeometry.only(bottom: 8),
      child: CustomTile(
        borderRadius: 12,
        borderColor: isSelectedTask ? focusColor : dividerColor,
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
