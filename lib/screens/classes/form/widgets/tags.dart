import 'package:flutter/material.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/widgets/common/tag_chip.dart';
import 'package:life_game/widgets/filters/tags_finder.dart';

Widget buildTagsSection(
  BuildContext context,
  {
    required List<Tag> selectedTags, 
    required Function(List<Tag>) setSelectedTags
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Теги',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: () => _openTagSelector(context, selectedTags, setSelectedTags),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Добавить тег'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: selectedTags.map((tag) =>
            TagChip(
              title: tag.title,
            ),
          ).toList(),
        ),
        if (selectedTags.isEmpty)
          Text(
            'Теги не добавлены',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
            ),
          ),
      ],
    );
}

void _openTagSelector(
  BuildContext context, 
  List<Tag> selectedTags, 
  Function(List<Tag>) setSelectedTags
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => TagsFinder(
      selectedTags: selectedTags,
      onConfirm: (tags) => setSelectedTags(tags),
    ),
  );
}