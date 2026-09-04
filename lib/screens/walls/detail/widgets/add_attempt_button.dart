import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallDetailAddAttemptButton extends StatelessWidget {
  const WallDetailAddAttemptButton({super.key,});

  @override
  Widget build(BuildContext context) {
    final model = context.read<WallDetailModel>();

    return FloatingActionButton(
      onPressed: model.openCreateForm,
      tooltip: 'Добавить попытку',
      backgroundColor: Theme.of(context).focusColor,
      child: Icon(Icons.sports_martial_arts, color: Theme.of(context).primaryColor),
    );
  }
}
