import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/achievement.dart';
import 'package:life_game/models/enums/achiev_rar.dart';
import 'package:life_game/screens/achievements/achievement_list_model.dart';
import 'package:life_game/screens/achievements/widgets/achievement_details.dart';
import 'package:life_game/screens/achievements/widgets/achievement_form.dart';
import 'package:life_game/screens/achievements/widgets/tag_selector_modal.dart';
import 'package:life_game/widgets/app_drawer.dart';
import 'package:life_game/widgets/bottom_menu.dart';
import 'package:life_game/widgets/custom_floating_action_button.dart';
import 'package:provider/provider.dart';


class AchievementListScreen extends StatefulWidget {
  const AchievementListScreen({super.key});

  @override
  State<AchievementListScreen> createState() => _AchievementListScreenState();
}

class _AchievementListScreenState extends State<AchievementListScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AchievementListModel>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: const AppDrawer(),
      body: Consumer<AchievementListModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.filteredAchievements.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.filteredAchievements.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 80,
                    color: Theme.of(context).hintColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Нет достижений',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Создайте своё первое достижение',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _showCreateForm,
                    icon: const Icon(Icons.add),
                    label: const Text('Создать достижение'),
                  ),
                ],
              ),
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
      bottomNavigationBar: BottomMenu(),
      floatingActionButton: CustomFloatingActionButton(openFormCreate: _showCreateForm, tooltip: "Добавить достижение")
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Достижения'),
      actions: [
        // Фильтр по статусу
        PopupMenuButton<String>(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Фильтр',
          onSelected: (value) {
            final viewModel = context.read<AchievementListModel>();
            switch (value) {
              case 'all':
                viewModel.toggleUnlockedFilter();
                if (viewModel.showUnlockedOnly) {
                  viewModel.toggleUnlockedFilter();
                }
                break;
              case 'unlocked':
                viewModel.toggleUnlockedFilter();
                break;
              case 'locked':
                viewModel.toggleLockedFilter();
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'all',
              child: Text('Все'),
            ),
            const PopupMenuItem(
              value: 'unlocked',
              child: Text('Только полученные'),
            ),
            const PopupMenuItem(
              value: 'locked',
              child: Text('Только не полученные'),
            ),
          ],
        ),
        // Фильтр по тегам
        IconButton(
          icon: Consumer<AchievementListModel>(
            builder: (context, viewModel, child) {
              return Badge(
                isLabelVisible: viewModel.selectedTags.isNotEmpty,
                label: Text(viewModel.selectedTags.length.toString()),
                child: const Icon(Icons.local_offer),
              );
            },
          ),
          tooltip: 'Фильтр по тегам',
          onPressed: _showTagFilter,
        ),
        // Поиск
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: 'Поиск',
          onPressed: _showSearch,
        ),
        const SizedBox(width: 8),
      ],
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

  void _showTagFilter() async {
    final viewModel = context.read<AchievementListModel>();
    await showDialog(
      context: context,
      builder: (context) => TagSelectorModal(
        selectedTags: viewModel.selectedTags,
        onConfirm: (tags) {
          viewModel.clearTagFilters();
          for (var tag in tags) {
            viewModel.toggleTagFilter(tag);
          }
        },
      ),
    );
  }

  void _showSearch() {
    final viewModel = context.read<AchievementListModel>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Поиск достижений'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Введите название или описание...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            viewModel.setSearchQuery(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              viewModel.setSearchQuery('');
              Navigator.of(context).pop();
            },
            child: const Text('Очистить'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}