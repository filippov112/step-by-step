import 'package:chaos_control/models/enums/task_status.dart';
import 'package:chaos_control/models/task.dart';
import 'package:chaos_control/screens/tasks/task_form_model.dart';
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

    final timeColor = Colors.greenAccent;
    final diffColor = Colors.amber;
    final dividerColor = Theme.of(context).dividerColor;
    final focusColor = Theme.of(context).focusColor;


    final selectCheckbox = isSelectionMode ? Checkbox(value: selectedIds.contains(task.id), onChanged: (_) => tabModel.toggleSelect(task.id)) : null;
    
    // -------- Дата и статус -----------
    
    final statusIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(task.status.icon, size: 12, color: task.status.color),
    );
    final dateWidget = CustomText(
      DateTool.shortDateFormat(task.date), expanded: true, color: task.status.color, size: 12, padding: const EdgeInsets.only(bottom: 2),
    );

    
    // --------- Время ---------

    final timeIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(Icons.timelapse, size: 12, color: timeColor),
    );
    final timeValue = CustomText(
      '${task.time} h.',
      size: 14,
      padding: const EdgeInsets.only(bottom: 3),
      color: timeColor,
    );

    // ------ Концентрация ---------

    final diffIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(Icons.handyman, size: 12, color: diffColor),
    );
    final diffValue = CustomText(
      '${task.diff} %',
      size: 14,
      padding: const EdgeInsets.only(bottom: 3),
      color: diffColor,
    );
    
    // ----------- SF ------------
    
    final spiritIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(Icons.local_fire_department, size: 12),
    );
    final spiritValue = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomText(
          '${task.spiritFragments}',
          size: 14,
          padding: const EdgeInsets.only(bottom: 3),
          color: focusColor,
        ),
        CustomText(
          'SF',
          size: 10,
          padding: const EdgeInsets.only(left: 2, bottom: 3),
          color: focusColor,
        ),
      ],
    );


    final header = Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ?selectCheckbox,
                statusIcon,
                dateWidget,
                spiritIcon,
                spiritValue,
                const SizedBox(width: 12,),
                timeIcon,
                timeValue,
                const SizedBox(width: 12,),
                diffIcon,
                diffValue
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
