// lib/widgets/tag_selector_modal.dart
import 'package:flutter/material.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/achievements/achievement_list_model.dart';
import 'package:provider/provider.dart';

class TagSelectorModal extends StatefulWidget {
  final List<Tag> selectedTags;
  final Function(List<Tag>) onConfirm;

  const TagSelectorModal({
    Key? key,
    required this.selectedTags,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<TagSelectorModal> createState() => _TagSelectorModalState();
}

class _TagSelectorModalState extends State<TagSelectorModal> {
  List<Tag> _selectedTags = [];
  String _searchQuery = '';
  List<Tag> _filteredTags = [];

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTags);
    _filteredTags = _getAllTags();
  }

  List<Tag> _getAllTags() {
    final viewModel = context.read<AchievementListModel>();
    return viewModel.allTags;
  }

  void _applyFilter() {
    final allTags = _getAllTags();
    if (_searchQuery.isEmpty) {
      _filteredTags = allTags;
    } else {
      _filteredTags = allTags.where((tag) =>
        tag.title.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    setState(() {});
  }

  void _toggleTag(Tag tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          children: [
            // Заголовок
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Выбор тегов',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedTags.clear();
                          });
                        },
                        child: Text('Очистить'),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          widget.onConfirm(_selectedTags);
                          Navigator.of(context).pop();
                        },
                        child: Text('Готово'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Поиск
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Поиск тегов...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onChanged: (value) {
                  _searchQuery = value;
                  _applyFilter();
                },
              ),
            ),
            // Выбранные теги
            if (_selectedTags.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedTags.map((tag) => Chip(
                    label: Text(tag.title),
                    onDeleted: () => _toggleTag(tag),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  )).toList(),
                ),
              ),
            const Divider(),
            // Список тегов
            Expanded(
              child: _filteredTags.isEmpty
                  ? const Center(child: Text('Теги не найдены'))
                  : ListView.builder(
                      itemCount: _filteredTags.length,
                      itemBuilder: (context, index) {
                        final tag = _filteredTags[index];
                        final isSelected = _selectedTags.contains(tag);
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (_) => _toggleTag(tag),
                          title: Text(tag.title),
                          secondary: Icon(
                            Icons.tag,
                            color: isSelected 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}