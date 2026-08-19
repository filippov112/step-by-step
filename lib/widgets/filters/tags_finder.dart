// lib/widgets/tag_selector_modal.dart
import 'package:flutter/material.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/widgets/common/tag_chip.dart';

// Форма поиска и выбора тегов для фильтров и форм связанных с тегами сущностей (достижения, навыки, задачи)
class TagsFinder extends StatefulWidget {
  final List<Tag> selectedTags;
  final Function(List<Tag>) onConfirm;

  const TagsFinder({
    super.key,
    required this.selectedTags,
    required this.onConfirm,
  });

  @override
  State<TagsFinder> createState() => _TagsFinderState();
}

class _TagsFinderState extends State<TagsFinder> {
  List<Tag> _selectedTags = [];
  String _searchQuery = '';
  List<Tag> _filteredTags = [];
  final TagRepository _tagRepo = TagRepository();
  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTags);
    _getAllTags().then((v) => setState(() => _filteredTags = v));
  }

  Future<List<Tag>> _getAllTags() async {
    return await _tagRepo.getAll();
  }

  Future _applyFilter() async {
    final allTags = await _getAllTags();
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
      if (_selectedTags.map((el) => el.id).contains(tag.id)) {
        _selectedTags.removeWhere((el) => el.id == tag.id);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        children: [
          // Поиск
          Padding(
            padding: const EdgeInsets.all(16),
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
              padding: const EdgeInsets.fromLTRB(16,0,16,8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedTags.map((tag) => TagChip(title: tag.title)).toList(),
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
                      final isSelected = _selectedTags.map((t) => t.id).contains(tag.id);
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (_) => _toggleTag(tag),
                        title: Text(tag.title),
                        secondary: Icon(
                          Icons.tag,
                          color: isSelected 
                              ? Theme.of(context).focusColor 
                              : Theme.of(context).dividerColor,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    },
                  ),
          ),
        
          Padding(padding:EdgeInsetsGeometry.all(16), child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex:1,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedTags.clear();
                    });
                  },
                  child: Text('Очистить'),
                ),
              ),
              
              const SizedBox(width: 8),
              
              Expanded(
                flex:1,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onConfirm(_selectedTags);
                    Navigator.of(context).pop();
                  },
                  child: Text('Готово'),
                ),
              ),
            ],
          ),
          ),
        ],
      ),
    );
    
  }
}