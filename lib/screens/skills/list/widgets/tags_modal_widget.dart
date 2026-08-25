// lib/screens/skills/widgets/tags_modal_widget.dart
import 'package:flutter/material.dart';
import 'package:chaos_control/models/tag.dart';

class TagsModalWidget extends StatefulWidget {
  final List<Tag> allTags;
  final List<Tag> selectedTags;
  
  const TagsModalWidget({
    super.key,
    required this.allTags,
    required this.selectedTags,
  });

  @override
  State<TagsModalWidget> createState() => _TagsModalWidgetState();
}

class _TagsModalWidgetState extends State<TagsModalWidget> {
  late List<Tag> _tempSelectedTags;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tempSelectedTags = List.from(widget.selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    final filteredTags = widget.allTags.where((tag) =>
      tag.title.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();

    return Dialog(
      insetPadding: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Заголовок
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Выбор тегов',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Row(
                  children: [
                    Text(
                      'Выбрано: ${_tempSelectedTags.length}',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(), // Используем Navigator.of(context).pop()
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Поиск
            TextField(
              decoration: InputDecoration(
                hintText: 'Поиск тегов...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Список тегов
            Expanded(
              child: filteredTags.isEmpty
                  ? Center(
                      child: Text(
                        'Теги не найдены'
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredTags.length,
                      itemBuilder: (context, index) {
                        final tag = filteredTags[index];
                        final isSelected = _tempSelectedTags.contains(tag);
                        
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                _tempSelectedTags.add(tag);
                              } else {
                                _tempSelectedTags.remove(tag);
                              }
                            });
                          },
                          title: Text(tag.title),
                          secondary: Container(
                            width: 4,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isSelected ? Theme.of(context).focusColor : Theme.of(context).dividerColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                        );
                      },
                    ),
            ),

            // Кнопки
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _tempSelectedTags.clear();
                  });
                },
                child: const Text('Очистить'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(_tempSelectedTags);
                    },
                    icon: const Icon(Icons.save),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Метод для вызова модального окна
Future<List<Tag>?> showTagsModal(
  BuildContext context, {
  required List<Tag> allTags,
  required List<Tag> selectedTags,
}) {
  return showDialog<List<Tag>>(
    context: context,
    barrierDismissible: true, // Разрешаем закрытие по клику вне диалога
    builder: (BuildContext context) {
      return TagsModalWidget(
        allTags: allTags,
        selectedTags: selectedTags
      );
    },
  );
}