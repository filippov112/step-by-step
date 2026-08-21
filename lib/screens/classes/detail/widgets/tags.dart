import 'package:flutter/material.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/classes/detail/class_detail_model.dart';
import 'package:life_game/widgets/common/tag_chip.dart';
import 'package:provider/provider.dart';

class ClassDetailTags extends StatelessWidget {
  const ClassDetailTags({super.key});

  @override
  Widget build(BuildContext context) {
    var tags = context.select<ClassDetailModel, List<Tag>>(
      (model) => model.tags,
    );

    if (tags.isNotEmpty) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tags.map((tag) => TagChip(title: tag.title)).toList(),
      );
    }
    return const SizedBox();
  }
}
