import 'package:chaos_control/models/enums/target_status.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/targets/edit/target_edit_model.dart';
import 'package:provider/provider.dart';

class TargetEditStatus extends StatelessWidget {
  const TargetEditStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select<TargetEditModel, TargetStatus>(
      (model) => model.status,
    );
    final setStatus = context.read<TargetEditModel>().setStatus;

    final radius = BorderRadius.circular(8);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: TargetStatus.values
          .map(
            (value) => Expanded(
              child: Padding(
                padding: EdgeInsetsGeometry.only(right: 8),
                child: InkWell(
                  borderRadius: radius,
                  onTap: () => setStatus(value),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      color: status == value
                        ? value.color
                        : value.color.withAlpha(50),
                    ),
                    child: Icon(
                      value.icon,
                      color: status == value
                          ? Theme.of(context).canvasColor
                          : value.color,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
