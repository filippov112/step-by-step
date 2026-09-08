import 'package:flutter/material.dart';
import 'package:chaos_control/screens/purports/detail/purport_details_model.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class PurportDetailDesc extends StatelessWidget {
  const PurportDetailDesc({super.key});

  @override
  Widget build(BuildContext context) {
    var description = context.select<PurportDetailsModel, String>(
      (model) => model.purport.description,
    );

    return CustomCardBlock(
      child: Column(
        children: [
          if (description.isNotEmpty) ...{
            CustomText(
              description,
              lines: null,
              overflow: TextOverflow.visible,
            ),
          },
        ],
      ),
    );
  }
}
