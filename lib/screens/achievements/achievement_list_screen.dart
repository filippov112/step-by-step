import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/screens/achievements/achievement_list_model.dart';
import 'package:life_game/screens/achievements/widgets/achievement_details.dart';
import 'package:life_game/screens/achievements/widgets/achievement_filters.dart';
import 'package:life_game/screens/achievements/widgets/achievement_form.dart';
import 'package:life_game/widgets/common/custom_image_icon.dart';
import 'package:life_game/widgets/common/custom_text.dart';
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

  String searchQuery = '';
  var searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AchievementListModel>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {

    var viewModel = context.read<AchievementListModel>();
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: const MainMenuDrawer(),
      endDrawer: AchievementFilters(
        selectedTags: viewModel.selectedTags,
        onConfirm: (tags) {
          viewModel.clearTagFilters();
          for (var tag in tags) {
            viewModel.toggleTagFilter(tag);
          }
        },
      ),
      body: Consumer<AchievementListModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.filteredAchievements.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.filteredAchievements.isEmpty) {
            return EmptyListScreen(
              title: "Достижения не найдены", 
              subtitle: "Создайте своё первое достижение", 
              icon: Icons.emoji_events_outlined
              );
          }

          // Группируем достижения
          final unlocked = viewModel.filteredAchievements
              .where((a) => a.date != null)
              .toList();
          final locked = viewModel.filteredAchievements
              .where((a) => a.date == null)
              .toList();

          return RefreshIndicator(
            onRefresh: () => viewModel.loadData(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (locked.isNotEmpty) ...[
                  _buildSectionHeader('Не получены', locked.length),
                  ...locked.map((ach) => _buildAchievementCard(ach)),
                ],
                if (locked.isNotEmpty && unlocked.isNotEmpty)
                  const SizedBox(height: 8),
                if (unlocked.isNotEmpty) ...[
                  _buildSectionHeader('Получены', unlocked.length),
                  ...unlocked.map((ach) => _buildAchievementCard(ach)),
                ],
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: MainBottomMenu(),
      floatingActionButton: CustomFloatingActionButton(openFormCreate: _showCreateForm, tooltip: "Добавить достижение")
    );
  }

  PreferredSizeWidget _buildAppBar() {

    return buildMainAppBar<Achievement>(
      context,
      title: 'Достижения',
      isRootWidgetTree: true,
      isSelectionMode: false,
      selectAll: (){},
      selectedIds: [],
      filteredList: [],
      searchWidget:  PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SearchString(
          placeholder: 'Поиск достижений...', 
          controller: searchController, 
          value: searchQuery, 
          clearCallback: () { context.read<AchievementListModel>().setSearchQuery(''); searchQuery = '';},
          changeCallback: (val) { context.read<AchievementListModel>().setSearchQuery(val); searchQuery = val; },
        )
      ),
      deleteSelected: (){},
      clearSelection: (){},
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CustomText(
            title,
            weight: FontWeight.bold,
            size: 16,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomText(
              count.toString(), size: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Achievement ach) {
    final isUnlocked = ach.date != null;
    
    return Card(

      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        iconColor: Theme.of(context).focusColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CustomImageIcon(
          ach.icon,
          icon: isUnlocked ? Icons.emoji_events : Icons.lock_outline,
          width: 40,
          height: 40,
          color: ach.rarity.color.withValues(alpha: 0.2)
        ),
        title: CustomText(
          ach.title,
          size: 15,
          lines: 2,
        ),
        trailing: Container(child:Icon(
          isUnlocked ? Icons.check_circle : Icons.circle_outlined,
        ),),
        onTap: () => _showDetails(ach),
      ),
    );
  }

  void _showCreateForm() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const AchievementForm(),
      barrierDismissible: true,
    );
    if (result == true && context.mounted) {
      context.read<AchievementListModel>().loadData();
    }
  }

  void _showDetails(Achievement ach) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AchievementDetails(achievement: ach),
      barrierDismissible: true,
    );
    if (context.mounted) {
      context.read<AchievementListModel>().loadData();
    }
  }
}