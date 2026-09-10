import 'package:chaos_control/screens/purports/create/purport_create_screen.dart';
import 'package:chaos_control/screens/purports/list/purport_list_model.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurportListAddButton extends StatelessWidget {
  const PurportListAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<PurportListModel>();

    return CustomFloatingActionButton(
      callback: () => _create(context, model.loadData),
      tooltip: 'Добавить смысл',
    );
  }

  void _create(BuildContext context, VoidCallback loadCallback) {
    final group = context.read<PurportListModel>().listModel.currentAddress;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: PurportCreateScreen(group: group),
          ),
        );
      },
    ).then((_) {
      if (context.mounted) loadCallback();
    });
  }
}
