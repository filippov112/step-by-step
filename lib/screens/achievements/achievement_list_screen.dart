import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/screens/achievements/achievement_list_model.dart';
import 'package:life_game/screens/achievements/widgets/achievement_details.dart';
import 'package:life_game/screens/achievements/widgets/achievement_filters.dart';
import 'package:life_game/screens/achievements/widgets/achievement_form.dart';
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

    return AppBar(
      title: const Text('Достижения'),
      actions: [
        // Фильтры
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Фильтры',
            onPressed: Scaffold.of(context).openEndDrawer,
          ) 
        ),
      ],
      bottom: buildSearchString(
        placeholder: 'Поиск достижений...', 
        controller: searchController, 
        value: searchQuery, 
        clearCallback: () { context.read<AchievementListModel>().setSearchQuery(''); searchQuery = '';},
        changeCallback: (val) { context.read<AchievementListModel>().setSearchQuery(val); searchQuery = val; },
      )
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: Theme.of(context).textTheme.bodySmall,
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
        leading: ach.icon != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(ach.icon!),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ach.rarity.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isUnlocked ? Icons.emoji_events : Icons.lock_outline,
                  color: ach.rarity.color,
                ),
              ),
        title: Text(
          ach.title,
          style: TextStyle(
            decoration: isUnlocked ? TextDecoration.lineThrough : null,
            decorationColor: Colors.green,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ach.description.isNotEmpty)
              Text(
                ach.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: ach.rarity.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ach.rarity.toString().split('.').last,
                    style: TextStyle(
                      fontSize: 10,
                      color: ach.rarity.color,
                    ),
                  ),
                ),
                if (isUnlocked)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '✓ Получено',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          isUnlocked ? Icons.check_circle : Icons.circle_outlined,
          color: isUnlocked ? Colors.green : Colors.grey,
        ),
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
    if (result == true) {
      context.read<AchievementListModel>().loadData();
    }
  }

  void _showDetails(Achievement ach) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AchievementDetails(achievement: ach),
      barrierDismissible: true,
    );
    if (result == true) {
      context.read<AchievementListModel>().loadData();
    }
  }
}