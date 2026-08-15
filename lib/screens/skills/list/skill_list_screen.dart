import 'package:flutter/material.dart';
import 'package:life_game/screens/skills/detail/skill_detail_screen.dart';
import 'package:life_game/screens/skills/form/skill_form_screen.dart';
import 'package:life_game/screens/skills/list/skill_list_model.dart';
import 'package:life_game/screens/skills/list/widgets/skill_tile.dart';
import 'package:life_game/screens/skills/list/widgets/tags_modal_widget.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:life_game/widgets/common/custom_floating_action_button.dart';
import 'package:life_game/widgets/common/empty_list_screen.dart';
import 'package:life_game/widgets/common/search_string.dart';
import 'package:provider/provider.dart';
import 'package:life_game/widgets/main/main_menu_drawer.dart';
import 'package:life_game/widgets/main/main_bottom_menu.dart';
import 'package:life_game/models/tag.dart';

class SkillListScreen extends StatefulWidget {
  const SkillListScreen({super.key});

  @override
  State<SkillListScreen> createState() => _SkillListScreenState();
}

class _SkillListScreenState extends State<SkillListScreen> {
  late SkillListModel _viewModel;
  String _searchQuery = '';
  List<Tag> _selectedFilters = [];
  var searchController = TextEditingController();

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
                      onPressed: () => _openFilters(context),
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
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: SearchString(
              placeholder: 'Поиск навыков...',
              controller: searchController, 
              value: _searchQuery, 
              clearCallback: () { 
                setState(() {
                  _searchQuery = '';
                });
              }, 
              changeCallback: (value) { 
                setState(() {
                  _searchQuery = value;
                });
              }
            )
          ),
        ),
        drawer: const MainMenuDrawer(currentRoute: '/skills'),
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
                    return EmptyListScreen(
                      subtitle: _searchQuery.isNotEmpty || _selectedFilters.isNotEmpty
                        ? 'Попробуйте изменить параметры поиска'
                        : 'Создайте свой первый навык',
                      title: 'Навыки не найдены',
                      icon: Icons.star_border,
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredSkills.length,
                    itemBuilder: (context, index) {
                      final skill = filteredSkills[index];
                      final tags = viewModel.getSkillTags(skill.id);
                      
                      return SkillTile(skill: skill, tags: tags, openDetails: () => _navigateToDetail(context, skill.id),);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: const MainBottomMenu(),
        floatingActionButton: CustomFloatingActionButton(openFormCreate: () => _navigateToForm(context), tooltip: "Добавить навык"),
      ),
    );
  }


  // Открыть фильтры
  Future<void> _openFilters(BuildContext context) async {
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

  // Добавить навык
  void _navigateToForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillFormScreen(),
      ),
    ).then((result) {
      if (result == true) {
        _viewModel.loadSkills();
      }
    });
  }

  // Открыть навык
  void _navigateToDetail(BuildContext context, String skillId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillDetailScreen(skillId: skillId),
      ),
    ).then((_) {
      _viewModel.loadSkills();
    });
  }
}