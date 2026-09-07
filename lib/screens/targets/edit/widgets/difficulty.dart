import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/target_difficulty.dart';
import 'package:chaos_control/screens/targets/edit/target_edit_model.dart';
import 'package:provider/provider.dart';

class TargetEditDifficulty extends StatelessWidget {
  const TargetEditDifficulty({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDifficulty = context.select<TargetEditModel, TargetDiff>(
      (model) => model.difficulty,
    );
    final setDifficulty = context.read<TargetEditModel>().setDifficulty;
    final radius = BorderRadius.circular(4);
    
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: TargetDiff.values
              .map(
                (value) => Padding(
                  padding: EdgeInsetsGeometry.only(right: 4),
                  child: InkWell(
                    borderRadius: radius,
                    onTap: () => setDifficulty(value),
                    child: Container(
                      width: 50,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        color: selectedDifficulty == value
                            ? value.color
                            : value.color.withAlpha(50),
                      ),
                      child: Center(
                        child: CustomText(
                          value.name,
                          size: 18,
                          color: selectedDifficulty == value
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
      );
  }
}
