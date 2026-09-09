import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/enums/difficulty_lvl.dart';
import 'package:chaos_control/models/enums/task_status.dart';
import 'package:chaos_control/models/barrier.dart';
import 'package:chaos_control/screens/tasks/task_form_model.dart';
import 'package:chaos_control/screens/targets/detail/target_detail_model.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/common/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetDetailTaskTile extends StatelessWidget {
  final Barrier task;
  const TargetDetailTaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final formModel = context.read<TaskFormModel>();
    final tabModel = context.read<TargetDetailModel>();
    final isSelectionMode = context.select<TargetDetailModel, bool>(
      (m) => m.isSelectionMode,
    );
    final selectedIds = context.select<TargetDetailModel, Set<String>>(
      (m) => m.selectedIds,
    );
    final isSelectedTask = context.select<TargetDetailModel, bool>(
      (m) => m.editionTask?.id == task.id,
    );

    final timeColor = Colors.greenAccent;
    final diffColor = Colors.amber;
    final dividerColor = Theme.of(context).dividerColor;
    final focusColor = Theme.of(context).focusColor;

    final selectCheckbox = isSelectionMode
        ? Checkbox(
            value: selectedIds.contains(task.id),
            onChanged: (_) => tabModel.toggleSelect(task.id),
          )
        : null;

    // -------- Дата и статус -----------

    final dateIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(Icons.calendar_month, size: 12, color: focusColor),
    );
    final dateWidget = CustomText(
      DateTool.shortDateFormat(task.date),
      color: focusColor,
      size: 12,
      padding: const EdgeInsets.only(bottom: 2),
    );
    final dateRow = Expanded(child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [dateIcon, dateWidget]));

    // --------- Сложность ---------

    final diffRang = CustomText(
      task.difficulty.name,
      size: 16,
      shadow: Shadow(color: task.difficulty.color, blurRadius: 6),
      color: task.difficulty.color,
      weight: FontWeight.bold,
      padding: const EdgeInsets.only(left: 4, right: 8, bottom: 1),
    );

    // ------ Тип ---------

    final typeIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(
        task.char.icon,
        shadows: [Shadow(color: task.char.color, blurRadius: 6)],
        size: 15,
        color: task.char.color,
      ),
    );

    // ====== MAIN =========

    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [?selectCheckbox, typeIcon, dateRow, diffRang],
    );
    final descWidget = CustomText(task.description);

    void select() {
      tabModel.toggleSelect(task.id);
    }

    void edit() {
      formModel.initTask(task, tabModel.target, tabModel.tasks.length);
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
