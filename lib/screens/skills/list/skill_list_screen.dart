import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/screens/skills/detail/skill_detail_screen.dart';
import 'package:life_game/screens/skills/form/skill_form_screen.dart';
import 'package:life_game/screens/skills/list/skill_list_model.dart';
import 'package:life_game/screens/skills/list/widgets/tags_modal_widget.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:life_game/widgets/custom_floating_action_button.dart';
import 'package:provider/provider.dart';
import 'package:life_game/widgets/app_drawer.dart';
import 'package:life_game/widgets/bottom_menu.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/enums/skill_rang.dart';

class SkillListScreen extends StatefulWidget {
  const SkillListScreen({super.key});

  @override
  State<SkillListScreen> createState() => _SkillListScreenState();
}

class _SkillListScreenState extends State<SkillListScreen> {
  late SkillListModel _viewModel;
  String _searchQuery = '';
  List<Tag> _selectedFilters = [];

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
            // Кнопка фильтрации по тегам
            Consumer<SkillListModel>(
              builder: (context, viewModel, child) {
                return Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => _showTagsFilterModal(context),
                      tooltip: 'Фильтр по тегам',
                    ),
                    if (_selectedFilters.isNotEmpty)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            _selectedFilters.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
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
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
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
            // Отображение выбранных фильтров
            if (_selectedFilters.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedFilters.length,
                  itemBuilder: (context, index) {
                    final tag = _selectedFilters[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: SoloLevelingTheme.navyBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tag.title,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilters.remove(tag);
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
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
                  if (_selectedFilters.isNotEmpty) {
                    filteredSkills = filteredSkills.where((skill) {
                      final skillTags = viewModel.getSkillTags(skill.id);
                      return _selectedFilters.every((filter) => skillTags.contains(filter));
                    }).toList();
                  }
                  
                  if (filteredSkills.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_border, size: 64),
                          const SizedBox(height: 16),
                          const Text(
                            'Навыки не найдены',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isNotEmpty || _selectedFilters.isNotEmpty
                                ? 'Попробуйте изменить параметры поиска'
                                : 'Создайте свой первый навык',
                            style: TextStyle(color: SoloLevelingTheme.steelBlue),
                          ),
                          if (_searchQuery.isEmpty && _selectedFilters.isEmpty) ...[
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
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: _buildSkillIcon(skill.icon),
                          title: Padding(
                            padding:EdgeInsetsGeometry.only(bottom: 10), 
                            child: Text(
                              skill.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: SoloLevelingTheme.paleBlue),
                            )
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: skill.rang.color.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      skill.rang.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: skill.rang.color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: SoloLevelingTheme.steelBlue.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${skill.level} LVL',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: SoloLevelingTheme.paleBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (tags.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 2,
                                  children: tags.map((tag) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: SoloLevelingTheme.steelBlue,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        tag.title,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: SoloLevelingTheme.glowBlue,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                              const SizedBox(height: 8),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: SoloLevelingTheme.steelBlue,),
                                onPressed: () => _navigateToForm(context, skill: skill),
                                tooltip: 'Редактировать',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: SoloLevelingTheme.steelBlue,),
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
        floatingActionButton: CustomFloatingActionButton(openFormCreate: () => _navigateToForm(context), tooltip: "Добавить навык"),
      ),
    );
  }

  Future<void> _showTagsFilterModal(BuildContext context) async {
    final result = await showTagsModal(
      context,
      allTags: _viewModel.allTags,
      selectedTags: _selectedFilters,
    );
    
    if (result != null) {
      setState(() {
        _selectedFilters = result;
      });
    }
  }

  Widget _buildSkillIcon(String iconPath) {
    if (iconPath.isEmpty) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: SoloLevelingTheme.steelBlue.withAlpha(80),
        ),
        child: const Icon(Icons.star_border, color: SoloLevelingTheme.steelBlue),
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
                color: SoloLevelingTheme.steelBlue.withAlpha(80),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.broken_image, color: SoloLevelingTheme.steelBlue,),
            );
          },
        ),
      );
    } catch (e) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: SoloLevelingTheme.steelBlue.withAlpha(80),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image_not_supported, color: SoloLevelingTheme.steelBlue),
      );
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