import 'package:flutter/material.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/screens/skills/form/skill_form_screen.dart';
import 'package:life_game/screens/skills/list/skill_list_model.dart';
import 'package:life_game/screens/skills/list/widgets/filters.dart';
import 'package:life_game/screens/skills/list/widgets/skill_tile.dart';
import 'package:life_game/widgets/common/custom_floating_action_button.dart';
import 'package:life_game/widgets/common/empty_list_screen.dart';
import 'package:life_game/widgets/common/search_string.dart';
import 'package:life_game/widgets/common/app_bar_list.dart';
import 'package:provider/provider.dart';
import 'package:life_game/screens/home/widgets/left_menu.dart';
import 'package:life_game/screens/home/widgets/bottom_menu.dart';

class SkillListScreen extends StatefulWidget {
  const SkillListScreen({super.key});

  @override
  State<SkillListScreen> createState() => _SkillListScreenState();
}

class _SkillListScreenState extends State<SkillListScreen> {
  final TextEditingController _searchController = TextEditingController();
  SkillListModel model = SkillListModel();

  @override
  void initState() {
    super.initState();
    model = context.read<SkillListModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.loadSkills();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ListAppBar(
          title: 'Навыки',
          selectionParams: SelectionParams(
              isSelectionMode:model.isSelectionMode , 
              selectAll:model.toggleSelectAll , 
              selectedItemsCount:model.selectedIds.length , 
              allItemsCount:model.skills.length, 
              deleteSelected:model.deleteSelectedSkills, 
              clearSelection:model.clearSelection
            ),
          searchWidget: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: SearchString(
              placeholder: 'Поиск навыков...',
              controller: _searchController,
              value: model.searchQuery,
              clearCallback: model.clearSearch,
              changeCallback: model.setSearchQuery,
            )
          ),
        ),
      body: _buildBody(context, model),
      floatingActionButton: model.isSelectionMode
          ? null
          : CustomFloatingActionButton(
              openFormCreate: _openCreateForm,
              tooltip: 'Создать задачу',
            ),
      bottomNavigationBar: MainBottomMenu(),
    
      endDrawer: SkillFilters(),
      drawer: const MainMenuDrawer(),
    );
  
  }

  Widget _buildBody(BuildContext context, SkillListModel model) {
    if (model.skills.isEmpty) {
      return EmptyListScreen(
        title: 'Нет навыков',
        subtitle: 'Создайте свой первый навык, нажав на кнопку +',
        icon: Icons.star_border,
      );
    }
    if (model.hasActiveFilters && model.skills.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_alt_off, size: 64, color: Theme.of(context).hintColor),
            const SizedBox(height: 16),
            Text(
              'Нет навыков по заданным фильтрам',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: model.clearAllFilters,
              child: const Text('Сбросить фильтры'),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: model.skills.length,
      itemBuilder: (context, index) {
        final skill = model.skills[index];
        return SkillTile(
          model: model, 
          skill: skill, 
        );
      },
    );
  }

  void _openCreateForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SkillFormScreen(),
      ),
    ).then((_) { if (context.mounted) context.read<SkillListModel>().loadSkills(); });
  }
}