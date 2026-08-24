import 'package:flutter/material.dart';
import 'package:life_game/models/enums/tag_type.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/tasks/list/task_list_model.dart';
import 'package:life_game/widgets/common/tag_chip.dart';
import 'package:life_game/widgets/filters/filter_section.dart';
import 'package:life_game/widgets/filters/filters_drawer.dart';
import 'package:life_game/widgets/filters/tags_finder.dart';
import 'package:provider/provider.dart';


class TaskFilters extends StatefulWidget {
  const TaskFilters({super.key});

  @override
  State<TaskFilters> createState() => _TaskFiltersState();
}

class _TaskFiltersState extends State<TaskFilters> {

  @override
  Widget build(BuildContext context) {

    final model = context.read<TaskListModel>();
    var hasActiveFilters = context.select<TaskListModel,bool>((model) => model.hasActiveFilters);
    var filterDifficulty = context.select<TaskListModel,Set<TaskDifficulty>>((model) => model.filterDifficulty);
    var filterDone =  context.select<TaskListModel,bool>((model) => model.filterDone);
    var filterUndone = context.select<TaskListModel,bool>((model) => model.filterUndone);
    var filterPriority = context.select<TaskListModel,Set<TaskPriority>>((model) => model.filterPriority);
    var selectedTags = context.select<TaskListModel,List<Tag>>((model) => model.selectedTags);
    var sortField = context.select<TaskListModel,SortTaskField>((model) => model.sortField);
    var sortAscending = context.select<TaskListModel,bool>((model) => model.sortAscending);

    // Приоритет
    var priorityFilter = FilterSection(
      title: 'Приоритет',
      icon: Icons.priority_high,
      children: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          ...TaskPriority.values.map((priority) =>
            FilterChip(
              label: Text(priority.displayName),
              selected: filterPriority.contains(priority),
              onSelected: (_) => model.setPriorityFilter(priority),
            ),
          ),
        ],
      ),
    );

    // Сложность
    var difficultyFilter = FilterSection(
      title: 'Сложность',
      icon: Icons.build,
      children: Wrap(
        spacing: 4,
        runSpacing: 4,
        alignment: WrapAlignment.start,
        children: [
          ...TaskDifficulty.values.map((difficulty) =>
            FilterChip(
              
              label: Text(difficulty.displayName),
              selected: filterDifficulty.contains(difficulty),
              onSelected: (_) => model.setDifficultyFilter(difficulty),
              backgroundColor: Theme.of(context).cardColor,
            ),
          ),
        ],
      ),
    );

    // Статус
    var statusFilter = FilterSection(
      title: 'Статус',
      icon: Icons.done,
      children: Wrap(
        spacing: 4,
        runSpacing: 4,
        alignment: WrapAlignment.start,
        children: [
          FilterChip(
            label: const Text('Выполненные'),
            selected: filterDone,
            onSelected: (_) => model.toggleDoneFilter(),
          ),
          FilterChip(
            label: const Text('Невыполненные'),
            selected: filterUndone,
            onSelected: (_) => model.toggleUndoneFilter(),
          ),
        ],
      ),
    );

    // Теги
    var tagsFilter = FilterSection(
      title: 'Теги',
      icon: Icons.tag,
      children:
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...selectedTags.map((tag) =>
                    TagChip(
                      title: tag.title,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8,),
            IconButton(
              onPressed: () =>_openTagSelector(context),
              icon: const Icon(Icons.add, size: 16),
            ),
          ],
        )
    );
    
    // Сортировка
    var sorting = FilterSection(
      title: 'Сортировка',
      icon: Icons.sort,
      children: Column(
          children: [
            _buildSortButton(
              context,
              sortField,
              model.setSortField,
              sortAscending,
              SortTaskField.title,
              'По названию',
            ),
            const SizedBox(height: 8),
            _buildSortButton(
              context,
              sortField,
              model.setSortField,
              sortAscending,
              SortTaskField.datetime,
              'По дате',
            ),
            const SizedBox(height: 8),
            _buildSortButton(
              context,
              sortField,
              model.setSortField,
              sortAscending,
              SortTaskField.priority,
              'По приоритету',
            ),
            const SizedBox(height: 8),
            _buildSortButton(
              context,
              sortField,
              model.setSortField,
              sortAscending,
              SortTaskField.difficulty,
              'По сложности',
            ),
          ],
        ),
    );

    return FiltersDrawer(
      // Сброс
      buttons: ElevatedButton(
        onPressed: hasActiveFilters ? model.clearAllFilters : null,
        child: const Text('Сбросить все фильтры'),
      ),
      filters: [
       priorityFilter,
       difficultyFilter,
       statusFilter,
       tagsFilter,
       sorting
      ],
    );
  }

  void _openTagSelector(BuildContext context) {
    final model = context.read<TaskListModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TagsFinder(
        selectedTags: model.selectedTags,
        onConfirm: model.setTagsFilter,
        type: TagType.task
      ),
    );
  }
  
  Widget _buildSortButton(
    BuildContext context,
    SortTaskField sortField,
    Function(SortTaskField) setSortField,
    bool sortAscending,
    SortTaskField field,
    String label,
  ) {
    final isActive = sortField == field;
    return OutlinedButton(
      onPressed: () => setSortField(field),
      style: OutlinedButton.styleFrom(
        backgroundColor: isActive
            ? Theme.of(context).colorScheme.primaryContainer
            : null,
        side: isActive
            ? BorderSide(color: Theme.of(context).colorScheme.primary)
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          if (isActive)
            Icon(
              sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16,
            ),
        ],
      ),
    );
  }
}



