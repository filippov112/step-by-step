import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/screens/tasks/detail/task_detail_screen.dart';
import 'package:life_game/screens/tasks/form/task_form_screen.dart';
import 'package:life_game/screens/tasks/list/task_list_model.dart';
import 'package:life_game/widgets/app_bar.dart';
import 'package:life_game/widgets/custom_floating_action_button.dart';
import 'package:life_game/widgets/empty_list_screen.dart';
import 'package:life_game/widgets/filters_drawer.dart';
import 'package:life_game/widgets/menu_drawer.dart';
import 'package:life_game/widgets/search_string.dart';
import 'package:life_game/widgets/tag_chip.dart';
import 'package:life_game/widgets/tag_selector_modal.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskListModel>().loadTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskListModel>(
      builder: (context, model, child) {
        return Scaffold(
          endDrawer: _buildFiltersDrawer(context, model),
          drawer: const MenuDrawer(currentRoute: '/tasks'),
          appBar: buildAppBar<Task>(
            context,
            title: 'Задачи',
            isRootWidgetTree: false,
            isSelectionMode: model.isSelectionMode,
            selectAll: model.toggleSelectAll,
            selectedIds: model.selectedIds,
            filteredList: model.tasks,
            searchWidget: _buildSearchWidget(context, model),
            deleteSelected: model.deleteSelectedTasks,
            clearSelection: model.clearSelection,
          ),
          body: _buildBody(context, model),
          floatingActionButton: model.isSelectionMode
              ? null
              : CustomFloatingActionButton(
                  openFormCreate: _openCreateForm,
                  tooltip: 'Создать задачу',
                ),
        );
      },
    );
  }

  PreferredSizeWidget _buildSearchWidget(
    BuildContext context,
    TaskListModel model,
  ) {
    return buildSearchString(
      placeholder: 'Поиск задач...',
      controller: _searchController,
      value: model.searchQuery,
      clearCallback: model.clearSearch,
      changeCallback: model.setSearchQuery,
    );
  }

  Widget _buildBody(BuildContext context, TaskListModel model) {
    if (model.tasks.isEmpty) {
      return EmptyListScreen(
        title: 'Нет задач',
        subtitle: 'Создайте свою первую задачу, нажав на кнопку +',
        icon: Icons.task_alt_outlined,
      );
    }

    if (model.hasActiveFilters && model.tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_alt_off, size: 64, color: Theme.of(context).hintColor),
            const SizedBox(height: 16),
            Text(
              'Нет задач по заданным фильтрам',
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
      itemCount: model.tasks.length,
      itemBuilder: (context, index) {
        final task = model.tasks[index];
        return _buildTaskCard(context, model, task);
      },
    );
  }

  Widget _buildTaskCard(BuildContext context, TaskListModel model, Task task) {
    final isSelected = model.selectedIds.contains(task.id);
    final isOverdue = task.isOverdue;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: task.done
          ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
          : null,
      child: InkWell(
        onTap: () {
          if (model.isSelectionMode) {
            model.toggleSelectTask(task.id);
          } else {
            _openDetails(task);
          }
        },
        onLongPress: () {
          if (!model.isSelectionMode) {
            model.toggleSelectionMode();
            model.toggleSelectTask(task.id);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Чекбокс для выделения или статуса
              if (model.isSelectionMode)
                Checkbox(
                  value: isSelected,
                  onChanged: (_) => model.toggleSelectTask(task.id),
                )
              else
                Checkbox(
                  value: task.done,
                  onChanged: (_) => model.toggleTaskDone(task.id),
                ),
              
              // Информация о задаче
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.done ? TextDecoration.lineThrough : null,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (task.description.isNotEmpty)
                      Text(
                        task.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        _buildPriorityChip(context, task.priority),
                        _buildDifficultyChip(context, task.difficulty),
                        if (task.datetime != null)
                          _buildDateTimeChip(context, task.datetime!, isOverdue),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Индикатор просрочки
              if (isOverdue && !task.done)
                Icon(
                  Icons.warning_amber_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
              
              // Стрелка перехода
              if (!model.isSelectionMode)
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _openDetails(task),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(BuildContext context, TaskPriority priority) {

    return Chip(
      label: Text(priority.displayName),
      backgroundColor: priority.color.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: priority.color,
        fontSize: 10,
      ),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildDifficultyChip(BuildContext context, TaskDifficulty difficulty) {

    return Chip(
      label: Text(difficulty.displayName),
      backgroundColor: difficulty.color.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: difficulty.color,
        fontSize: 10,
      ),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildDateTimeChip(BuildContext context, DateTime datetime, bool isOverdue) {
    return Chip(
      label: Text(
        '${datetime.day}.${datetime.month}.${datetime.year} ${datetime.hour}:${datetime.minute.toString().padLeft(2, '0')}',
      ),
      backgroundColor: isOverdue
          ? Theme.of(context).colorScheme.error.withValues(alpha: 0.2)
          : null,
      labelStyle: TextStyle(
        fontSize: 10,
        color: isOverdue ? Theme.of(context).colorScheme.error : null,
      ),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildFiltersDrawer(BuildContext context, TaskListModel model) {
    return FiltersDrawer(
      filters: [
        // Приоритет
        _buildFilterSection(
          title: 'Приоритет',
          children: TaskPriority.values.map((priority) =>
            FilterChip(
              label: Text(priority.displayName),
              selected: model.filterPriority == priority,
              onSelected: (_) => model.setPriorityFilter(priority),
              backgroundColor: Theme.of(context).cardColor,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ).toList(),
        ),
        
        // Сложность
        _buildFilterSection(
          title: 'Сложность',
          children: TaskDifficulty.values.map((difficulty) =>
            FilterChip(
              label: Text(difficulty.displayName),
              selected: model.filterDifficulty == difficulty,
              onSelected: (_) => model.setDifficultyFilter(difficulty),
              backgroundColor: Theme.of(context).cardColor,
              selectedColor: Theme.of(context).colorScheme.primaryContainer,
            ),
          ).toList(),
        ),
        
        // Статус
        _buildFilterSection(
          title: 'Статус',
          children: [
            FilterChip(
              label: const Text('Выполненные'),
              selected: model.filterDone,
              onSelected: (_) => model.toggleDoneFilter(),
              backgroundColor: Theme.of(context).cardColor,
              selectedColor: Colors.green.withValues(alpha: 0.2),
            ),
            FilterChip(
              label: const Text('Невыполненные'),
              selected: model.filterUndone,
              onSelected: (_) => model.toggleUndoneFilter(),
              backgroundColor: Theme.of(context).cardColor,
              selectedColor: Colors.orange.withValues(alpha: 0.2),
            ),
          ],
        ),
        
        // Теги
        _buildFilterSection(
          title: 'Теги',
          children: [
            Wrap(
              spacing: 4,
              children: [
                ...model.selectedTags.map((tag) =>
                  TagChip(
                    title: tag.title,
                    callback: () {
                      final updated = List<Tag>.from(model.selectedTags);
                      updated.remove(tag);
                      model.setTagsFilter(updated);
                    },
                  ),
                ),
                TextButton.icon(
                  onPressed: _openTagSelector,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Добавить тег'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                ),
              ],
            ),
          ],
        ),
        
        // Сортировка
        _buildFilterSection(
          title: 'Сортировка',
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildSortButton(
                    context,
                    model,
                    SortField.title,
                    'По названию',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSortButton(
                    context,
                    model,
                    SortField.datetime,
                    'По дате',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSortButton(
                    context,
                    model,
                    SortField.priority,
                    'По приоритету',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSortButton(
                    context,
                    model,
                    SortField.difficulty,
                    'По сложности',
                  ),
                ),
              ],
            ),
          ],
        ),
        
        // Сброс
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextButton(
            onPressed: model.hasActiveFilters ? model.clearAllFilters : null,
            child: const Text('Сбросить все фильтры'),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Theme.of(context).hintColor,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: children,
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton(
    BuildContext context,
    TaskListModel model,
    SortField field,
    String label,
  ) {
    final isActive = model.sortField == field;
    return OutlinedButton(
      onPressed: () => model.setSortField(field),
      style: OutlinedButton.styleFrom(
        backgroundColor: isActive
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
        side: isActive
            ? BorderSide(color: Theme.of(context).colorScheme.primary)
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          if (isActive)
            Icon(
              model.sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16,
            ),
        ],
      ),
    );
  }

  void _openTagSelector() {
    final model = context.read<TaskListModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TagSelectorModal(
        selectedTags: model.selectedTags,
        onConfirm: model.setTagsFilter,
      ),
    );
  }

  void _openCreateForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskFormScreen(),
      ),
    ).then((_) => context.read<TaskListModel>().loadTasks());
  }

  void _openDetails(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(task: task),
      ),
    ).then((_) => context.read<TaskListModel>().loadTasks());
  }
}