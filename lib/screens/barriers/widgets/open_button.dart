import 'package:chaos_control/screens/barriers/bar_form_model.dart';
import 'package:chaos_control/screens/barriers/bar_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarrierListOpenButton extends StatelessWidget {
  const BarrierListOpenButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<BarrierListModel>();
    final formModel = context.read<BarrierFormModel>();

    return FloatingActionButton(
      onPressed: () { model.openForm(null); formModel.init(null); },
      tooltip: 'Добавить запись',
      backgroundColor: Theme.of(context).focusColor,
      child: Icon(Icons.edit_note, color: Theme.of(context).primaryColor),
    );
  }

}
