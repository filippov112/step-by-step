import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/screens/targets/edit/target_edit_model.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetEditChars extends StatelessWidget {
  const TargetEditChars({super.key});

  @override
  Widget build(BuildContext context) {

    // final focusColor = Theme.of(context).focusColor;
    final model = context.read<TargetEditModel>();
    final chars = context.select<TargetEditModel, Map<Characteristics, int>?>(
      (model) => model.chars,
    );
    final chars100 = context.select<TargetEditModel, Map<Characteristics, int>?>(
      (model) => model.chars100,
    );

    // Блок "Распределение опыта"
    final charsBlock = CustomCardBlock(
      icon: Icons.bar_chart,
      title: 'Распределение',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...Characteristics.values.map(
            (c) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  Icon(c.icon, color: c.color),
                  CustomText(c.displayName, expanded: true),
                  CustomText('${chars100?[c]} %', weight: FontWeight.bold),
                ],),
                Slider(
                  value: (chars?[c])?.toDouble() ?? 0,
                  padding: const EdgeInsets.all(6),
                  min: 0,
                  thumbColor: c.color,
                  divisions: 101,
                  max: 100,
                  onChanged: (v) => model.setChars(c, v.toInt()),
                )
                
              ],
            ),
          ),
        ],
      ),
    );

    return charsBlock;
  }
  
}