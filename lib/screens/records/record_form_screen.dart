import 'dart:async';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/record.dart';
import 'package:chaos_control/screens/records/record_form_model.dart';
import 'package:chaos_control/screens/records/record_list_model.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/dialogs/bottom_modal_form.dart';
import 'package:chaos_control/widgets/form/datetime_picker.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordForm extends StatefulWidget {
  const RecordForm({super.key});

  @override
  State<StatefulWidget> createState() => RecordFormState();
}

class RecordFormState extends State<RecordForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController descController, groupController;
  late RecordFormModel model;
  late RecordListModel listModel;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    descController = TextEditingController();
    groupController = TextEditingController();
    model = context.read<RecordFormModel>();
    listModel = context.read<RecordListModel>();
    subscription = model.initStream.listen((event) => resetControllers());
  }

  @override
  void dispose() {
    subscription?.cancel();
    subscription = null;
    descController.dispose();
    groupController.dispose();
    super.dispose();
  }

  void resetControllers() {
    descController.text = model.desc;
    groupController.text = model.group;
  }

  List<int> toggleCharType(List<int> charTypes, int id) {
    if (charTypes.contains(id)) {
      return charTypes.where((el) => el != id).toList();
    } else {
      return [...charTypes, id];
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibility = context.select<RecordListModel, bool>(
      (m) => m.visibilityForm,
    );
    if (!visibility) return const SizedBox();
    final hours = context.select<RecordFormModel, int>((m) => m.hours);
    final date = context.select<RecordFormModel, DateTime>((m) => m.date);
    final charTypes = context.select<RecordFormModel, List<int>>(
      (m) => m.charTypes,
    );
    final isChallenge = context.select<RecordFormModel, bool>(
      (m) => m.challenge,
    );

    final isEditing = context.select<RecordFormModel, bool>((m) => m.isEditing);

    final cardColor = Theme.of(context).cardColor;
    final focusColor = Theme.of(context).focusColor;
    final disabledColor = Theme.of(context).disabledColor;
    final saveColor = Colors.greenAccent;
    final challengeColor = Colors.orange;


    // --------- Длительность ---------

    final hoursSlider = Slider(
      value: hours.toDouble(),
      label: 'Длительность',
      activeColor: focusColor,
      inactiveColor: focusColor.withAlpha(50),
      padding: const EdgeInsets.all(6),
      min: 0,
      divisions: 12,
      max: 12,
      showValueIndicator: ShowValueIndicator.onDrag,
      onChanged: (v) => model.setHours(v.round()),
    );
    final hoursIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(
        Icons.timer,
        shadows: [Shadow(color: focusColor, blurRadius: 6)],
        size: 15,
        color: focusColor,
      ),
    );
    final hoursValue = CustomText(
      '$hours h.',
      size: 16,
      shadow: Shadow(color: focusColor, blurRadius: 6),
      color: focusColor,
      weight: FontWeight.bold,
      padding: const EdgeInsets.only(left: 4, right: 8, bottom: 1),
    );

    // --------- SF ----------

    final spiritIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(
        Icons.local_fire_department,
        color: isChallenge ? disabledColor : challengeColor,
        shadows: [Shadow(color: isChallenge ? disabledColor : challengeColor, blurRadius: 6)],
        size: 17,
      ),
    );

    // ========== MAIN =============

    final statisticsRow = Row(
      children: [
        spiritIcon,
        hoursIcon,
        hoursValue,
        const Expanded(child: SizedBox()),
      ],
    );

    final charTypesWidget = Padding(
      padding: const EdgeInsetsGeometry.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...Characteristic.values.map(
            (ch) => IconButton(
              onPressed: () => model.setCharTypes(toggleCharType(charTypes, ch.index)),
              icon: Icon(
                ch.icon,
                shadows: charTypes.contains(ch.index)
                    ? [Shadow(color: ch.color, blurRadius: 8)]
                    : null,
                color: charTypes.contains(ch.index) ? ch.color : disabledColor,
              ),
            ),
          ),
        ],
      ),
    );

    final descWidget = CustomTextInput(
      header: 'Описание',
      controller: descController,
      setText: (v) => model.setDesc(v ?? ''),
      icon: Icons.description,
      action: null,
      lines: 3,
    );

    final groupWidget = Expanded(
      child: CustomTextInput(
        header: "Группа ('/')",
        controller: groupController,
        customValidator: ChronicleRecord.groupValidator,
        setText: (v) => model.setGroup(v ?? ''),
        icon: Icons.folder,
        lines: 1,
      ),
    );

    final datePicker = Expanded(
      child: CustomDateTime(
        dateOnly: true,
        callback: (v) => model.setDate(v ?? DateTool.today()),
        value: date,
      ),
    );

    final challengeStatusButton = IconButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          ContinuousRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
            side: BorderSide(width: 3, color: isChallenge ? challengeColor : disabledColor),
          ),
        ),
      ),
      padding: const EdgeInsets.all(14),
      color: isChallenge ? challengeColor : disabledColor,
      onPressed: model.changeChallengeStatus,
      icon: Icon(Icons.center_focus_strong),
    );

    final saveButton = IconButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          ContinuousRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
            side: BorderSide(width: 3, color: saveColor),
          ),
        ),
      ),
      padding: const EdgeInsets.all(14),
      color: saveColor,
      onPressed: () async {
        if (!(_formKey.currentState?.validate() ?? false)) return;
        await model.save();
        await listModel.loadData();
      },
      icon: Icon(isEditing ? Icons.save : Icons.add),
    );

    final closeButton = IconButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          ContinuousRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
            side: BorderSide(width: 3, color: focusColor),
          ),
        ),
      ),
      padding: const EdgeInsets.all(14),
      color: focusColor,
      onPressed: listModel.closeForm,
      icon: Icon(Icons.close),
    );

    // ==============================

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: focusColor, width: 1)),
        color: cardColor.withAlpha(150),
      ),
      child: BottomModalForm(
        formKey: _formKey,
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                statisticsRow,
                hoursSlider,
                charTypesWidget,
                descWidget,
                const SizedBox(height: 8),
                Row(
                  children: [
                    groupWidget,
                    const SizedBox(width: 8),
                    challengeStatusButton,
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    datePicker,
                    const SizedBox(width: 8),
                    saveButton,
                    const SizedBox(width: 8),
                    closeButton,
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
