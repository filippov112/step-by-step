import 'package:chaos_control/screens/records/record_form_model.dart';
import 'package:chaos_control/screens/records/record_list_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordListOpenButton extends StatelessWidget {
  const RecordListOpenButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<RecordListModel>();
    final formModel = context.read<RecordFormModel>();

    return FloatingActionButton(
      onPressed: () { model.openForm(null); formModel.init(null, model.listModel.currentAddress); },
      tooltip: 'Добавить запись',
      child: Icon(Icons.edit_note, color: Theme.of(context).primaryColor),
    );
  }

}
