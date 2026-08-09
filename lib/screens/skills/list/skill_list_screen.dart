// lib/screens/skills/skill_list_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/screens/skills/detail/skill_detail_screen.dart';
import 'package:life_game/screens/skills/form/skill_form_screen.dart';
import 'package:life_game/screens/skills/list/skill_list_model.dart';
import 'package:provider/provider.dart';
import 'package:life_game/widgets/app_drawer.dart';
import 'package:life_game/widgets/bottom_menu.dart';
import 'package:life_game/models/tag.dart';

class SkillListScreen extends StatefulWidget {
  const SkillListScreen({super.key});

  @override
  State<SkillListScreen> createState() => _SkillListScreenState();
}

class _SkillListScreenState extends State<SkillListScreen> {
  late SkillListModel _viewModel;
  String _searchQuery = '';
  Tag? _selectedTag;

  @override
  void initState() {
    super.initState();
    _viewModel = SkillListModel();
    _viewModel.loadSkills();
    _viewModel.loadTags();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Навыки'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _navigateToForm(context),
              tooltip: 'Создать навык',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _viewModel.loadSkills(),
              tooltip: 'Обновить',
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Поиск навыков...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),
        ),
        drawer: const AppDrawer(currentRoute: '/skills'),
        body: Column(
          children: [
            // Фильтр по тегам
            Consumer<SkillListModel>(
              builder: (context, viewModel, child) {
                if (viewModel.allTags.isEmpty) return const SizedBox();
                
                return Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.allTags.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildFilterChip(
                          label: 'Все',
                          isSelected: _selectedTag == null,
                          onSelected: () {
                            setState(() {
                              _selectedTag = null;
                            });
                          },
                        );
                      }
                      final tag = viewModel.allTags[index - 1];
                      return _buildFilterChip(
                        label: tag.title,
                        isSelected: _selectedTag == tag,
                        onSelected: () {
                          setState(() {
                            _selectedTag = _selectedTag == tag ? null : tag;
                          });
                        },
                      );
                    },
                  ),
                );
              },
            ),
            
            // Список навыков
            Expanded(
              child: Consumer<SkillListModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (viewModel.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                          const SizedBox(height: 16),
                          Text(
                            viewModel.error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => viewModel.loadSkills(),
                            child: const Text('Попробовать снова'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  // Фильтрация
                  var filteredSkills = viewModel.skills;
                  
                  // Поиск по названию
                  if (_searchQuery.isNotEmpty) {
                    filteredSkills = filteredSkills.where((skill) =>
                      skill.title.toLowerCase().contains(_searchQuery.toLowerCase())
                    ).toList();
                  }
                  
                  // Фильтр по тегам
                  if (_selectedTag != null) {
                    filteredSkills = filteredSkills.where((skill) {
                      return viewModel.getSkillTags(skill.id).contains(_selectedTag);
                    }).toList();
                  }
                  
                  if (filteredSkills.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_border, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          const Text(
                            'Навыки не найдены',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isNotEmpty || _selectedTag != null
                                ? 'Попробуйте изменить параметры поиска'
                                : 'Создайте свой первый навык',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          if (_searchQuery.isEmpty && _selectedTag == null) ...[
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => _navigateToForm(context),
                              icon: const Icon(Icons.add),
                              label: const Text('Создать навык'),
                            ),
                          ],
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredSkills.length,
                    itemBuilder: (context, index) {
                      final skill = filteredSkills[index];
                      final tags = viewModel.getSkillTags(skill.id);
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: ListTile(
                          leading: _buildSkillIcon(skill.icon),
                          title: Text(
                            skill.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _getRangColor(skill.rang).withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Ранг ${skill.rang.name}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _getRangColor(skill.rang),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Ур. ${skill.level}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (tags.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 2,
                                  children: tags.map((tag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        tag.title,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _navigateToForm(context, skill: skill),
                                tooltip: 'Редактировать',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDelete(context, skill.id),
                                tooltip: 'Удалить',
                              ),
                            ],
                          ),
                          onTap: () => _navigateToDetail(context, skill.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomMenu(),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        backgroundColor: Colors.grey.shade200,
        selectedColor: Colors.blue.shade100,
        showCheckmark: false,
      ),
    );
  }

  Widget _buildSkillIcon(String iconPath) {
    if (iconPath.isEmpty) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.star_border, color: Colors.grey),
      );
    }
    
    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(iconPath),
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.broken_image, color: Colors.grey),
            );
          },
        ),
      );
    } catch (e) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }
  }

  Color _getRangColor(SkillRang rang) {
    switch (rang) {
      case SkillRang.F:
        return Colors.grey;
      case SkillRang.E:
        return Colors.blueGrey;
      case SkillRang.D:
        return Colors.blue;
      case SkillRang.C:
        return Colors.green;
      case SkillRang.B:
        return Colors.lime;
      case SkillRang.A:
        return Colors.orange;
      case SkillRang.S:
        return Colors.red;
      case SkillRang.SS:
        return Colors.purple;
      case SkillRang.SSS:
        return Colors.deepPurple;
      case SkillRang.EX:
        return Colors.amber;
    }
  }

  void _confirmDelete(BuildContext context, String skillId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление навыка'),
        content: const Text('Вы уверены, что хотите удалить этот навык?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _viewModel.deleteSkill(skillId).then((success) {
                if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_viewModel.error ?? 'Ошибка удаления'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _navigateToForm(BuildContext context, {Skill? skill}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillFormScreen(skill: skill),
      ),
    ).then((result) {
      if (result == true) {
        _viewModel.loadSkills();
      }
    });
  }

  void _navigateToDetail(BuildContext context, String skillId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillDetailScreen(skillId: skillId),
      ),
    );
  }
}