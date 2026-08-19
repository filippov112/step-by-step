import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/screens/achievements/list/achievement_list_model.dart';
import 'package:life_game/screens/achievements/form/achievement_form_screen.dart';
import 'package:life_game/screens/achievements/list/widgets/filters.dart';
import 'package:life_game/screens/achievements/list/widgets/tile.dart';
import 'package:life_game/widgets/main/main_app_bar.dart';
import 'package:life_game/widgets/main/main_menu_drawer.dart';
import 'package:life_game/widgets/main/main_bottom_menu.dart';
import 'package:life_game/widgets/common/custom_floating_action_button.dart';
import 'package:life_game/widgets/common/empty_list_screen.dart';
import 'package:life_game/widgets/common/search_string.dart';
import 'package:provider/provider.dart';


class AchievementListScreen extends StatefulWidget {
  const AchievementListScreen({super.key});

  @override
  State<AchievementListScreen> createState() => _AchievementListScreenState();
}

class _AchievementListScreenState extends State<AchievementListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AchievementListModel>().loadAchievements();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementListModel>(
      builder: (context, model, child) {
        return Scaffold(

          appBar: buildMainAppBar<Achievement>(
              context,
              title: 'Достижения',
              isRootWidgetTree: true,
              isSelectionMode: model.isSelectionMode,
              selectAll: model.toggleSelectAll,
              selectedIds: model.selectedIds,
              filteredList: model.achievements,
              searchWidget: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: SearchString(
                  placeholder: 'Поиск достижений...',
                  controller: _searchController,
                  value: model.searchQuery,
                  clearCallback: model.clearSearch,
                  changeCallback: model.setSearchQuery,
                )
              ),
              deleteSelected: model.deleteSelectedAchievements,
              clearSelection: model.clearSelection,
            ),
          body: _buildBody(context, model),
          floatingActionButton: model.isSelectionMode
              ? null
              : CustomFloatingActionButton(
                  openFormCreate: _openCreateForm,
                  tooltip: 'Создать достижение',
                ),
          bottomNavigationBar: MainBottomMenu(),
        
          endDrawer: AchievementFilters(),
          drawer: const MainMenuDrawer(),
        );
      }
    );
  }

  Widget _buildBody(BuildContext context, AchievementListModel model) {
    if (model.achievements.isEmpty) {
      return EmptyListScreen(
        title: 'Нет достижений',
        subtitle: 'Добавьте достижение, нажав на кнопку +',
        icon: Icons.diamond,
      );
    }
    if (model.hasActiveFilters && model.achievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_alt_off, size: 64, color: Theme.of(context).hintColor),
            const SizedBox(height: 16),
            Text(
              'Нет достижений по заданным фильтрам',
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
      itemCount: model.achievements.length,
      itemBuilder: (context, index) {
        final achievement = model.achievements[index];
        return AchievementTile(
          model: model, 
          achi: achievement, 
        );
      },
    );
  }

  void _openCreateForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AchievementFormScreen(),
      ),
    ).then((_) { if (context.mounted) context.read<AchievementListModel>().loadAchievements(); });
  }
}