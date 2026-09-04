import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/walls/form/wall_form_model.dart';
import 'package:provider/provider.dart';

class WallFormStatus extends StatelessWidget {
  const WallFormStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select<WallFormModel, WallStatus>(
      (model) => model.status,
    );
    final setStatus = context.read<WallFormModel>().setStatus;

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
