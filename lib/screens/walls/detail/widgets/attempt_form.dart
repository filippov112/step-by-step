import 'dart:async';

import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:chaos_control/screens/walls/detail/attempt_form_model.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/dialogs/bottom_modal_form.dart';
import 'package:chaos_control/widgets/form/datetime_picker.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallDetailAttemptForm extends StatefulWidget {
  const WallDetailAttemptForm({super.key});

  @override
  State<StatefulWidget> createState() => WallDetailAttemptFormState();
}

class WallDetailAttemptFormState extends State<WallDetailAttemptForm> {
  late TextEditingController descController;
  late AttemptFormModel model;
  late WallDetailModel detailModel;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    descController = TextEditingController();
    model = context.read<AttemptFormModel>();
    detailModel = context.read<WallDetailModel>();
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
    final visibility = context.select<WallDetailModel, bool>(
      (m) => m.visibilityAttemptForm,
    );
    if (!visibility) return const SizedBox();
    final success = context.select<AttemptFormModel, int>((m) => m.success);
    final date = context.select<AttemptFormModel, DateTime>((m) => m.date);
    final sf = context.select<AttemptFormModel,int>((m) => m.sf);


    final cardColor = Theme.of(context).cardColor;
    final focusColor = Theme.of(context).focusColor;
    final successColor = WallStatus.destroyed.color;

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
      child: Icon(WallStatus.destroyed.icon, size: 12, color: successColor),
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
          title: 'Попытка',
          confirmCallback: () async {
            await model.save();
            await detailModel.saveAttempt();
          },
          closeCallback: detailModel.closeAttemptForm,
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
