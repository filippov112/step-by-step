import 'package:chaos_control/models/enums/target_status.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/targets/detail/target_detail_model.dart';
import 'package:provider/provider.dart';

class TargetDetailChangeStatusButton extends StatelessWidget {
  const TargetDetailChangeStatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<TargetDetailModel>();
    final status = context.select<TargetDetailModel, TargetStatus>(
      (model) => model.target.status,
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
