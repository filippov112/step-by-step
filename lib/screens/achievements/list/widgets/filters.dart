import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/achiev_rar.dart';
import 'package:chaos_control/models/enums/tag_type.dart';
import 'package:chaos_control/models/tag.dart';
import 'package:chaos_control/screens/achievements/list/achievement_list_model.dart';
import 'package:chaos_control/widgets/common/tag_chip.dart';
import 'package:chaos_control/widgets/filters/filter_section.dart';
import 'package:chaos_control/widgets/filters/filters_drawer.dart';
import 'package:chaos_control/widgets/filters/tags_finder.dart';
import 'package:provider/provider.dart';

class AchievementFilters extends StatefulWidget {
  const AchievementFilters({super.key});

  @override
  State<AchievementFilters> createState() => _AchievementFiltersState();
}

class _AchievementFiltersState extends State<AchievementFilters> {
  @override
  Widget build(BuildContext context) {
    final model = context.read<AchievementListModel>();
    var hasActiveFilters = context.select<AchievementListModel, bool>(
      (model) => model.hasActiveFilters,
    );
    var filterRarity = context.select<AchievementListModel, Set<AchievRar>>(
      (model) => model.filterRarity,
    );
    var filterStatus = context
        .select<AchievementListModel, Set<FilterStatusValue>>(
          (model) => model.filterStatus,
        );
    var selectedTags = context.select<AchievementListModel, List<Tag>>(
      (model) => model.selectedTags,
    );
    var sortField = context.select<AchievementListModel, SortAchievementField>(
      (model) => model.sortField,
    );
    var sortAscending = context.select<AchievementListModel, bool>(
      (model) => model.sortAscending,
    );

    // Редкость
    var rarityFilter = FilterSection(
      title: 'Редкость (${filterRarity.length})',
      icon: Icons.star_border,
      children: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...AchievRar.values.map(
              (rarity) => Padding(
                padding: EdgeInsetsGeometry.only(right: 8),
                child: FilterChip(
                  label: Text(rarity.displayName),
                  selected: filterRarity.contains(rarity),
                  onSelected: (_) => model.setRarityFilter(rarity),
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
            ...FilterStatusValue.values.map(
              (status) => Padding(
                padding: EdgeInsetsGeometry.only(right: 8),
                child: FilterChip(
                  label: Text(
                    status == FilterStatusValue.received
                        ? 'Получены'
                        : 'Заблокированы',
                  ),
                  selected: filterStatus.contains(status),
                  onSelected: (_) => model.setStatusFilter(status),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Теги
    var tagsFilter = FilterSection(
      title: 'Теги (${selectedTags.length})',
      icon: Icons.tag,
      children: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...selectedTags.map((tag) => TagChip(title: tag.title)),
              ],
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: () => _openTagSelector(context),
            icon: const Icon(Icons.add, size: 16),
          ),
        ],
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
            SortAchievementField.title,
            'По названию',
          ),
          const SizedBox(height: 8),
          _buildSortButton(
            context,
            sortField,
            model.setSortField,
            sortAscending,
            SortAchievementField.rarity,
            'По редкости',
          ),
          const SizedBox(height: 8),
          _buildSortButton(
            context,
            sortField,
            model.setSortField,
            sortAscending,
            SortAchievementField.datetime,
            'По дате получения',
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
      filters: [rarityFilter, statusFilter, tagsFilter, sorting],
    );
  }

  Future _openTagSelector(BuildContext context) async {
    final model = context.read<AchievementListModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TagsFinder(
        selectedTags: model.selectedTags,
        onConfirm: model.setTagsFilter,
        type: TagType.achievement,
      ),
    );
  }

  Widget _buildSortButton(
    BuildContext context,
    SortAchievementField sortField,
    Function(SortAchievementField) setSortField,
    bool sortAscending,
    SortAchievementField field,
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
