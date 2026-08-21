import 'package:flutter/material.dart';
import 'package:life_game/screens/classes/detail/class_detail_model.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

class ClassDetailDesc extends StatelessWidget {
  const ClassDetailDesc({super.key});

  @override
  Widget build(BuildContext context) {
    var description = context.select<ClassDetailModel, String>(
      (model) => model.record.description,
    );

    if (description.isNotEmpty) {
      return Container(
        height: 150,
        padding: EdgeInsets.only(bottom: 16),
        child: ListView(
          children: [
            CustomText(
              description,
              lines: null,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      );
    }

    return const SizedBox();
  }
}
