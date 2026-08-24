import 'package:flutter/material.dart';
import 'package:life_game/models/enums/tag_type.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/classes/form/class_form_model.dart';
import 'package:life_game/widgets/common/tag_chip.dart';
import 'package:life_game/widgets/filters/tags_finder.dart';
import 'package:provider/provider.dart';

class ClassFormTags extends StatelessWidget {
  const ClassFormTags({super.key});

  void _openTagSelector(
    BuildContext context,
    List<Tag> selectedTags,
    Function(List<Tag>) setSelectedTags,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TagsFinder(
        selectedTags: selectedTags,
        onConfirm: (tags) => setSelectedTags(tags),
        type: TagType.class_
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<ClassFormModel>();
    final selectedTags = context.select<ClassFormModel, List<Tag>>(
      (model) => model.selectedTags,
    );
    final setSelectedTags = model.setSelectedTags;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Теги', style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              onPressed: () =>
                  _openTagSelector(context, selectedTags, setSelectedTags),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: selectedTags
              .map((tag) => TagChip(title: tag.title))
              .toList(),
        ),
        if (selectedTags.isEmpty)
          Text(
            'Теги не добавлены',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
      ],
    );
  }
}
