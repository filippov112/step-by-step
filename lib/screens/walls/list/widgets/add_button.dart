import 'package:chaos_control/screens/walls/form/wall_form_screen.dart';
import 'package:chaos_control/screens/walls/list/wall_list_model.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallListAddButton extends StatelessWidget {
  const WallListAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<WallListModel>();

    return  CustomFloatingActionButton(
      openFormCreate: () => _create(context, model.loadData),
      tooltip: 'Новая стена',
    );
  }

  void _create(BuildContext context, VoidCallback loadCallback) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WallFormScreen()),
    ).then((_) {
      if (context.mounted) loadCallback();
    });
  }
}