import 'package:flutter/material.dart';
import 'package:life_game/models/tag.dart';

class TagsSelectorWidget extends StatelessWidget {
  final List<Tag> allTags;
  final List<Tag> selectedTags;
  final Function(Tag) onToggleTag;
  
  const TagsSelectorWidget({
    super.key,
    required this.allTags,
    required this.selectedTags,
    required this.onToggleTag,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Теги',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (allTags.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Center(
              child: Text(
                'Нет доступных тегов',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: allTags.map((tag) {
              final isSelected = selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag.title),
                selected: isSelected,
                onSelected: (_) => onToggleTag(tag),
                backgroundColor: Colors.grey.shade200,
                selectedColor: Colors.blue.shade100,
                showCheckmark: true,
                avatar: isSelected
                    ? const Icon(Icons.check, size: 16)
                    : null,
              );
            }).toList(),
          ),
        if (selectedTags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Выбрано тегов: ${selectedTags.length}',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 12,
                    ),
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