import 'dart:async';

import 'package:chaos_control/models/enums/target_status.dart';
import 'package:chaos_control/screens/targets/detail/task_form_model.dart';
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
    final success = context.select<TaskFormModel, int>((m) => m.success);
    final date = context.select<TaskFormModel, DateTime>((m) => m.date);
    final sf = context.select<TaskFormModel,int>((m) => m.sf);


    final cardColor = Theme.of(context).cardColor;
    final focusColor = Theme.of(context).focusColor;
    final successColor = TargetStatus.destroyed.color;

    final descWidget = CustomTextInput(
      header: 'Описание',
      controller: descController,
      setText: model.setDesc,
      icon: Icons.description,
      lines: 3,
    );

    final succesWidget = Slider(
      value: success.toDouble(),
      label: 'Процент успеха:',
      min: 0,
      divisions: 100,
      max: 100,
      onChanged: (v) => model.setSuccess(v.toInt()),
    );

    final datePicker = Padding(
      padding: const EdgeInsetsGeometry.only(top: 12),
      child: CustomDateTime(
        label: 'Дата:',
        dateOnly: true,
        callback: (v) => model.setDate(v ?? DateTool.today()),
        value: date,
      ),
    );

    final successIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(TargetStatus.destroyed.icon, size: 12, color: successColor),
    );
    final successPercent = CustomText(
      '$success%',
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


    final statusWidget = Row(children: [
      successIcon,
      successPercent,
      const Expanded(child: SizedBox(),),
      spiritIcon,
      spiritFragments
    ],);

    return Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: focusColor, width: 1)),
          color: cardColor.withAlpha(150),
        ),
        child: BottomModalForm(
          title: 'Задача',
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
                  statusWidget,
                  succesWidget, 
                  descWidget, 
                  datePicker
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
