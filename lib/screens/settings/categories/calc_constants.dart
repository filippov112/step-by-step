import 'package:chaos_control/screens/settings/setting_list_model.dart';
import 'package:chaos_control/screens/settings/widgets/scaffold.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsCalcConstants extends StatefulWidget {
  const SettingsCalcConstants({super.key});

  @override
  State<SettingsCalcConstants> createState() => _SettingsCalcConstantsState();
}

class _SettingsCalcConstantsState extends State<SettingsCalcConstants> {
  late final SettingListModel model;
  late final TextEditingController req1Controller,
      koefController,
      charReqController;

  @override
  void initState() {
    super.initState();
    model = context.read<SettingListModel>();
    model.loadData();
    req1Controller = TextEditingController(text: model.req1.toString());
    koefController = TextEditingController(text: model.koef.toString());
    charReqController = TextEditingController(text: model.charReq.toString());
  }

  void cancel() {
    model.cancel();
    req1Controller.text = model.req1.toString();
    koefController.text = model.koef.toString();
    charReqController.text = model.charReq.toString();
  }

  @override
  void dispose() {
    req1Controller.dispose();
    koefController.dispose();
    charReqController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final req1Widget = CustomTextInput(
      header: 'Требование 1 уровня',
      controller: req1Controller,
      setText: (v) => model.setReq1(int.tryParse(v ?? '0') ?? 0),
      type: TextInputType.number,
    );

    final koefWidget = CustomTextInput(
      header: 'Коэффициент увеличения требований к уровню',
      controller: koefController,
      setText: (v) => model.setKoef(double.tryParse(v ?? '0') ?? 0),
      type: TextInputType.numberWithOptions(decimal: true),
    );

    final charReqWidget = CustomTextInput(
      header: 'Требование для получения 1 очка характеристик',
      controller: charReqController,
      setText: (v) => model.setCharReq(int.tryParse(v ?? '0') ?? 0),
      type: TextInputType.number,
    );

    return SettingsScaffold(
      title: 'Константы расчетов',
      cancelCallback: cancel,
      children: [
        req1Widget,
        const SizedBox(height: 16),
        koefWidget,
        const SizedBox(height: 16),
        charReqWidget,
      ],
    );
  }
}
