import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/walls/edit/wall_edit_model.dart';
import 'package:provider/provider.dart';

class WallCreateStatus extends StatelessWidget {
  const WallCreateStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select<WallEditModel, WallStatus>(
      (model) => model.status,
    );
    final setStatus = context.read<WallEditModel>().setStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: WallStatus.values
              .map(
                (value) => Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(right: 8),
                    child: InkWell(
                      onTap: () => setStatus(value),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: status == value
                            ? value.color
                            : value.color.withAlpha(50),
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
        ),
      ],
    );
  }
}
