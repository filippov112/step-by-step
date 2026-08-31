import 'package:flutter/material.dart';
import 'package:chaos_control/screens/landmarks/list/achievement_list_model.dart';
import 'package:chaos_control/screens/landmarks/form/achievement_form_screen.dart';
import 'package:chaos_control/screens/landmarks/list/widgets/filters.dart';
import 'package:chaos_control/screens/landmarks/list/widgets/tile.dart';
import 'package:chaos_control/widgets/common/app_bar_list.dart';
import 'package:chaos_control/screens/home/widgets/left_menu.dart';
import 'package:chaos_control/screens/home/widgets/bottom_menu.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:chaos_control/widgets/common/empty_list_screen.dart';
import 'package:chaos_control/widgets/common/search_string.dart';
import 'package:provider/provider.dart';


class AchievementListScreen extends StatefulWidget {
  const AchievementListScreen({super.key});

  @override
  State<AchievementListScreen> createState() => _AchievementListScreenState();
}

class _AchievementListScreenState extends State<AchievementListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late AchievementListModel model;
  @override
  void initState() {
    super.initState();
    model = context.read<AchievementListModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.loadAchievements();
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

          appBar: ListAppBar(
              title: 'Достижения',
              selectionParams: SelectionParams(
                isSelectionMode: model.isSelectionMode,
                selectAll: model.toggleSelectAll,
                selectedItemsCount: model.selectedIds.length,
                allItemsCount: model.achievements.length,
                deleteSelected: model.deleteSelectedAchievements,
                clearSelection: model.clearSelection,
              ),
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
    ).then((_) { if (context.mounted) model.loadAchievements(); });
  }
}