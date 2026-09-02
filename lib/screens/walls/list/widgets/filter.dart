import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/screens/walls/list/wall_list_model.dart';
import 'package:chaos_control/widgets/filters/filter_section.dart';
import 'package:chaos_control/widgets/filters/filters_drawer.dart';
import 'package:provider/provider.dart';

class TaskFilters extends StatefulWidget {
  const TaskFilters({super.key});

  @override
  State<TaskFilters> createState() => _TaskFiltersState();
}

class _TaskFiltersState extends State<TaskFilters> {
  @override
  Widget build(BuildContext context) {
    final model = context.read<WallListModel>();
    var hasActiveFilters = context.select<WallListModel, bool>(
      (model) => model.hasActiveFilters,
    );
    var filterDifficulty = context.select<WallListModel, Set<WallDiff>>(
      (model) => model.filterDifficulty,
    );
    var filterDone = context.select<WallListModel, bool>(
      (model) => model.filterDone,
    );
    var filterUndone = context.select<WallListModel, bool>(
      (model) => model.filterUndone,
    );
    var sortField = context.select<WallListModel, SortTaskField>(
      (model) => model.sortField,
    );
    var sortAscending = context.select<WallListModel, bool>(
      (model) => model.sortAscending,
    );
    final currentDateFilter = context.select<WallListModel, WallDateFilterType>(
      (model) => model.dateFilter,
    );


    var dateFilter = FilterSection(
      title: 'Дата', 
      icon: Icons.calendar_month,
      children:Column(
        children: [
          
        DropdownButtonFormField<WallDateFilterType>(
            items: [
              const DropdownMenuItem(
                value: WallDateFilterType.date,
                child: Text('По датам'),
              ),
              const DropdownMenuItem(
                value: WallDateFilterType.all,
                child: Text('Все задачи'),
              ),
            ], 
            initialValue: currentDateFilter, 
            onChanged: (v) => model.setDateFilter(v ?? WallDateFilterType.date),
          ),
      ],), 
    );


    // Сложность
    var difficultyFilter = FilterSection(
      title: 'Сложность (${filterDifficulty.length})',
      icon: Icons.build,
      children: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...WallDiff.values.map(
              (difficulty) => Padding(
                padding: EdgeInsetsGeometry.only(right: 8),
                child: FilterChip(
                  label: Text(difficulty.name),
                  selected: filterDifficulty.contains(difficulty),
                  onSelected: (_) => model.setDifficultyFilter(difficulty),
                  backgroundColor: Theme.of(context).cardColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Статус
    var statusFilter = FilterSection(
      title: 'Статус',
      icon: Icons.done,
      children: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(right: 8),
              child: FilterChip(
                label: const Text('Выполненные'),
                selected: filterDone,
                onSelected: (_) => model.toggleDoneFilter(),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.only(right: 8),
              child: FilterChip(
                label: const Text('Невыполненные'),
                selected: filterUndone,
                onSelected: (_) => model.toggleUndoneFilter(),
              ),
            ),
          ],
        ),
      ),
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
        dateFilter,
        difficultyFilter,
        statusFilter,
        sorting,
      ],
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
