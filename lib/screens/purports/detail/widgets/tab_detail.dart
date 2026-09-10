import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/purports/detail/purport_detail_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class PurportDetailDetailTab extends StatelessWidget {
  const PurportDetailDetailTab({super.key});

  @override
  Widget build(BuildContext context) {
    
    var desc = context.select<PurportDetailModel, String?>(
      (model) => model.purport?.description,
    );

    final focusColor = Theme.of(context).focusColor;

    // Суть
    final descWidget = desc?.isEmpty ?? true
        ? null
        : CustomCardBlock(
            borderColor: focusColor,
            icon: Icons.description,
            title: 'Суть',
            child: CustomText(
              desc ?? '',
              lines: null,
              overflow: TextOverflow.visible,
            ),
          );
      
    return Container(
      padding: EdgeInsets.all(12),
      child: ListView(children: [?descWidget]),
    );
  }
}
