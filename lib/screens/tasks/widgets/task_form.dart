import 'dart:async';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/enums/task_status.dart';
import 'package:chaos_control/screens/tasks/task_form_model.dart';
import 'package:chaos_control/screens/targets/detail/target_detail_model.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/dialogs/bottom_modal_form.dart';
import 'package:chaos_control/widgets/form/datetime_picker.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetDetailTaskForm extends StatefulWidget {
  const TargetDetailTaskForm({super.key});

  @override
  State<StatefulWidget> createState() => TargetDetailTaskFormState();
}

class TargetDetailTaskFormState extends State<TargetDetailTaskForm> {
  late TextEditingController descController;
  late TaskFormModel model;
  late TargetDetailModel detailModel;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    descController = TextEditingController();
    model = context.read<TaskFormModel>();
    detailModel = context.read<TargetDetailModel>();
    subscription = model.initStream.listen((event) => resetControllers());
  }

  @override
  void dispose() {
    subscription?.cancel();
    subscription = null;
    descController.dispose();
    super.dispose();
  }

  void resetControllers() {
    descController.text = model.desc ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final visibility = context.select<TargetDetailModel, bool>(
      (m) => m.visibilityTaskForm,
    );
    if (!visibility) return const SizedBox();
    final time = context.select<TaskFormModel, int>((m) => m.time);
    final diff = context.select<TaskFormModel, int>((m) => m.diff);
    final date = context.select<TaskFormModel, DateTime>((m) => m.date);
    final sf = context.select<TaskFormModel, int>((m) => m.sf);
    final currentChars = context
        .select<TaskFormModel, Map<Characteristics, int>?>(
          (m) => m.task?.chars,
        );
    final activeChars = context
        .select<TaskFormModel, Map<Characteristics, int>?>(
          (m) => m.activeChars,
        );
    final status = context.select<TaskFormModel, TaskStatus>((m) => m.status);
    final isEditing = context.select<TaskFormModel, bool>((m) => m.isEditing);

    final cardColor = Theme.of(context).cardColor;
    final focusColor = Theme.of(context).focusColor;
    final dividerColor = Theme.of(context).dividerColor;
    final timeColor = Colors.greenAccent;
    final diffColor = Colors.amber;

    // --------- Время ---------

    final timeSlider = Slider(
      value: time.toDouble(),
      label: 'Трудозатраты',
      activeColor: timeColor,
      inactiveColor: timeColor.withAlpha(40),
      padding: const EdgeInsets.all(6),
      min: 0,
      divisions: 13,
      max: 12,
      showValueIndicator: ShowValueIndicator.onDrag,
      onChanged: (v) => model.setTime(v.toInt()),
    );
    final timeIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(Icons.timelapse, size: 14, color: timeColor),
    );
    final timeValue = CustomText(
      '$time h.',
      size: 16,
      padding: const EdgeInsets.only(bottom: 3),
      color: timeColor,
    );

    // ------ Концентрация ---------

    final diffSlider = Slider(
      value: diff.toDouble(),
      padding: const EdgeInsets.all(6),
      label: 'Концентрация',
      activeColor: diffColor,
      inactiveColor: diffColor.withAlpha(40),
      min: 0,
      divisions: 101,
      max: 100,
      onChanged: (v) => model.setDiff(v.toInt()),
    );
    final diffIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(Icons.handyman, size: 14, color: diffColor),
    );
    final diffValue = CustomText(
      '$diff %',
      size: 16,
      padding: const EdgeInsets.only(bottom: 3),
      color: diffColor,
    );

    // --------- SF ----------

    final spiritIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(Icons.local_fire_department, size: 14),
    );
    final spiritFragments = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomText(
          '$sf',
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

    // ========== MAIN =============

    final currentCharsRow = Padding(
      padding: const EdgeInsetsGeometry.all(2),
      child: Row(
        children: [
          if (currentChars == null || status == TaskStatus.plan)
            Expanded(child: Container(height: 4, color: dividerColor)),
          if (currentChars != null)
            ...Characteristics.values.map(
              (ch) => Expanded(
                flex: currentChars[ch] ?? 0,
                child: Container(height: 4, color: ch.color),
              ),
            ),
        ],
      ),
    );
    final activeCharsRow = Padding(
      padding: const EdgeInsetsGeometry.all(2),
      child: Row(
        children: [
          if (activeChars == null || sf == 0)
            Expanded(child: Container(height: 4, color: dividerColor)),
          if (activeChars != null)
            ...Characteristics.values.map(
              (ch) => Expanded(
                flex: activeChars[ch] ?? 0,
                child: Container(height: 4, color: ch.color),
              ),
            ),
        ],
      ),
    );

    final statisticsRow = Row(
      children: [
        timeIcon,
        timeValue,
        const SizedBox(width: 8),
        diffIcon,
        diffValue,
        const Expanded(child: SizedBox()),
        spiritIcon,
        spiritFragments,
      ],
    );

    final descWidget = CustomTextInput(
      header: 'Описание',
      controller: descController,
      setText: model.setDesc,
      icon: Icons.description,
      lines: 3,
    );

    final datePicker = Expanded(
      child: CustomDateTime(
        label: 'Дата:',
        dateOnly: true,
        callback: (v) => model.setDate(v ?? DateTool.today()),
        value: date,
      ),
    );

    final statusButton = InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      onTap: model.changeStatus,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: status.color.withAlpha(50),
          border: Border.all(width: 1, color: status.color),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Center(child: Icon(status.icon, color: status.color)),
      ),
    );

    final typeRow = Padding(
      padding: const EdgeInsetsGeometry.only(top: 12),
      child: Row(
        children: [datePicker, const SizedBox(width: 8), statusButton],
      ),
    );

    // ==============================

    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: focusColor, width: 1)),
          color: cardColor.withAlpha(150),
        ),
        child: BottomModalForm(
          title: 'Задача',
          confirmIcon: isEditing ? Icons.save : Icons.add,
          confirmCallback: () async {
            await model.save();
            await detailModel.saveTask();
          },
          closeCallback: detailModel.closeTaskForm,
          children: [
            Padding(
              padding: const EdgeInsetsGeometry.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  currentCharsRow,
                  activeCharsRow,
                  statisticsRow,
                  diffSlider,
                  timeSlider,
                  const SizedBox(height: 14),
                  descWidget,
                  typeRow,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
