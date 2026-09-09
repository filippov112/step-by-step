import 'dart:async';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/enums/difficulty_lvl.dart';
import 'package:chaos_control/screens/barriers/bar_form_model.dart';
import 'package:chaos_control/screens/barriers/bar_list_model.dart';
import 'package:chaos_control/services/datetool.dart';
import 'package:chaos_control/services/numerictool.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/dialogs/bottom_modal_form.dart';
import 'package:chaos_control/widgets/form/datetime_picker.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarrierForm extends StatefulWidget {
  const BarrierForm({super.key});

  @override
  State<StatefulWidget> createState() => BarrierFormState();
}

class BarrierFormState extends State<BarrierForm> {
  late TextEditingController descController, groupController;
  late BarrierFormModel model;
  late BarrierListModel listModel;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    descController = TextEditingController();
    groupController = TextEditingController(); 
    model = context.read<BarrierFormModel>();
    listModel = context.read<BarrierListModel>();
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

  @override
  Widget build(BuildContext context) {
    final visibility = context.select<BarrierListModel, bool>(
      (m) => m.visibilityForm,
    );
    if (!visibility) return const SizedBox();
    final diffIndex = context.select<BarrierFormModel, int>((m) => m.diffIndex);
    final date = context.select<BarrierFormModel, DateTime>((m) => m.date);
    final sf = context.select<BarrierFormModel, int>((m) => m.sf);
    final char = context.select<BarrierFormModel, Characteristic>(
      (m) => m.characteristic,
    );

    final isEditing = context.select<BarrierFormModel, bool>(
      (m) => m.isEditing,
    );

    final cardColor = Theme.of(context).cardColor;
    final focusColor = Theme.of(context).focusColor;
    final primaryColor = Theme.of(context).primaryColor;
    final disabledColor = Theme.of(context).disabledColor;

    final diff = DifficultyLvl.values[diffIndex];

    // --------- Сложность ---------

    final diffSlider = Slider(
      value: diffIndex.toDouble(),
      label: 'Сложность',
      activeColor: diff.color,
      inactiveColor: diff.color.withAlpha(40),
      padding: const EdgeInsets.all(6),
      min: 0,
      divisions: 5,
      max: 5,
      showValueIndicator: ShowValueIndicator.onDrag,
      onChanged: (v) => model.setDiff(v.round()),
    );
    final diffIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(
        Icons.hotel_class,
        shadows: [Shadow(color: diff.color, blurRadius: 6)],
        size: 15,
        color: diff.color,
      ),
    );
    final diffRang = CustomText(
      diff.name,
      size: 16,
      shadow: Shadow(color: diff.color, blurRadius: 6),
      color: diff.color,
      weight: FontWeight.bold,
      padding: const EdgeInsets.only(left: 4, right: 8, bottom: 1),
    );
    final diffName = CustomText(
      diff.displayName,
      padding: const EdgeInsets.only(right: 8, bottom: 1),
    );

    // --------- SF ----------

    final spiritIcon = Padding(
      padding: const EdgeInsetsGeometry.only(right: 4),
      child: Icon(
        Icons.local_fire_department,
        shadows: [Shadow(color: focusColor, blurRadius: 6)],
        size: 14,
      ),
    );
    final spiritFragments = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomText(
          NumericTool.toThousandString(sf),
          size: 16,
          padding: const EdgeInsets.only(bottom: 3),
          color: focusColor,
        ),
        CustomText(
          'SF',
          size: 12,
          padding: const EdgeInsets.only(left: 2, bottom: 5),
          color: focusColor,
        ),
      ],
    );

    // ========== MAIN =============

    final statisticsRow = Row(
      children: [
        diffIcon,
        diffRang,
        diffName,
        const Expanded(child: SizedBox()),
        spiritIcon,
        spiritFragments,
      ],
    );

    final typeWidget = Padding(
      padding: const EdgeInsetsGeometry.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...Characteristic.values.map(
            (ch) => IconButton(
              onPressed: () => model.setChar(ch),
              icon: Icon(
                ch.icon,
                shadows: char == ch
                    ? [Shadow(color: ch.color, blurRadius: 8)]
                    : null,
                color: char == ch ? ch.color : disabledColor,
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
      lines: 3,
    );
    final groupWidget = CustomTextInput(
      header: 'Группа',
      controller: groupController,
      setText: (v) => model.setGroup(v ?? ''),
      icon: Icons.folder,
      lines: 1,
    );

    final datePicker = Expanded(
      child: CustomDateTime(
        dateOnly: true,
        callback: (v) => model.setDate(v ?? DateTool.today()),
        value: date,
      ),
    );

    final saveButton = InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      onTap: () async {
        await model.save();
        await listModel.loadData();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: focusColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Center(
          child: Icon(isEditing ? Icons.save : Icons.add, color: primaryColor),
        ),
      ),
    );

    final closeButton = InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      onTap: listModel.closeForm,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: primaryColor,
          border: Border.all(color: focusColor, width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Center(child: Icon(Icons.close, color: focusColor)),
      ),
    );


    // ==============================

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: focusColor, width: 1)),
        color: cardColor.withAlpha(150),
      ),
      child: BottomModalForm(
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                statisticsRow,
                diffSlider,
                typeWidget,
                descWidget,
                const SizedBox(height: 8),
                groupWidget,
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
