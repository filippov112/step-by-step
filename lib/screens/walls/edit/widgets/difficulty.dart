import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/screens/walls/edit/wall_edit_model.dart';
import 'package:provider/provider.dart';

class WallEditDifficulty extends StatelessWidget {
  const WallEditDifficulty({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDifficulty = context.select<WallEditModel, WallDiff>(
      (model) => model.difficulty,
    );
    final setDifficulty = context.read<WallEditModel>().setDifficulty;
    final radius = BorderRadius.circular(4);
    
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: WallDiff.values
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
