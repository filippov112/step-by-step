import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:provider/provider.dart';

class WallDetailChangeStatusButton extends StatelessWidget {
  const WallDetailChangeStatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<WallDetailModel>();
    final status = context.select<WallDetailModel, WallStatus>(
      (model) => model.wall.status,
    );
    
    return FloatingActionButton(
      onPressed: model.changeStatus,
      tooltip: 'Изменить статус',
      backgroundColor: status.color,
      child: Icon(
        status.icon,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
