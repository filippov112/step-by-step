import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/tag_type.dart';
import 'package:chaos_control/models/tag.dart';
import 'package:chaos_control/screens/skills/form/skill_form_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:chaos_control/widgets/common/tag_chip.dart';
import 'package:chaos_control/widgets/filters/tags_finder.dart';
import 'package:provider/provider.dart';


class SkillFormTags extends StatelessWidget {
  const SkillFormTags({super.key});

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
        type: TagType.skill
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final selectedTags = context.select<SkillFormModel,List<Tag>>((model) => model.selectedTags);
    final setSelectedTags = context.read<SkillFormModel>().setSelectedTags;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText('Теги', size: 18, weight: FontWeight.bold),
            IconButton(
              onPressed: () => _openTagSelector(context, selectedTags, setSelectedTags),
              icon: const Icon(Icons.add, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (selectedTags.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Center(
              child: CustomText(
                'Теги не выбраны',
                color: Theme.of(context).dividerColor,
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                selectedTags.map((tag) {
                  return TagChip(title: tag.title);
                }).toList(),
          ),
        if (selectedTags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomText(
                    'Выбрано тегов: ${selectedTags.length}',
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
  
}
