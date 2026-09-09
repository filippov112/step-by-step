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
    final chars = context.select<TargetEditModel, Map<Characteristic, int>?>(
      (model) => model.chars,
    );
    final chars10000 = context.select<TargetEditModel, Map<Characteristic, int>?>(
      (model) => model.chars10000,
    );

    // Блок "Распределение опыта"
    final charsBlock = CustomCardBlock(
      icon: Icons.bar_chart,
      title: 'Распределение',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(color: Theme.of(context).dividerColor,),
          ...Characteristic.values.map(
            (c) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
                  child:Row(children: [
                  Icon(c.icon, color: c.color, size: 14,),
                  CustomText(c.displayName, expanded: true, size: 12, padding: const EdgeInsets.only(left: 12),),
                  CustomText('${(chars10000?[c] ?? 0).toDouble() / 100} %', weight: FontWeight.bold),
                ],),),
                Slider(
                  value: (chars?[c])?.toDouble() ?? 0,
                  padding: const EdgeInsets.all(6),
                  min: 0,
                  thumbColor: c.color,
                  activeColor: c.color,
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