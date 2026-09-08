import 'package:flutter/material.dart';
import 'package:chaos_control/models/enums/purport_type.dart';
import 'package:chaos_control/screens/purports/list/purport_list_model.dart';
import 'package:chaos_control/widgets/filters/filter_section.dart';
import 'package:chaos_control/widgets/filters/filters_drawer.dart';
import 'package:provider/provider.dart';

class PurportListFilters extends StatefulWidget {
  const PurportListFilters({super.key});

  @override
  State<PurportListFilters> createState() => _PurportListFiltersState();
}

class _PurportListFiltersState extends State<PurportListFilters> {
  @override
  Widget build(BuildContext context) {
    final model = context.read<PurportListModel>();
    var hasActiveFilters = context.select<PurportListModel, bool>(
      (model) => model.hasActiveFilters,
    );
    var filterRarity = context.select<PurportListModel, Set<PurportType>>(
      (model) => model.filterRarity,
    );
    var filterStatus = context
        .select<PurportListModel, Set<FilterStatusValue>>(
          (model) => model.filterStatus,
        );
    var sortField = context.select<PurportListModel, SortPurportField>(
      (model) => model.sortField,
    );
    var sortAscending = context.select<PurportListModel, bool>(
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
            ...PurportType.values.map(
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
            SortPurportField.title,
            'По названию',
          ),
          const SizedBox(height: 8),
          _buildSortButton(
            context,
            sortField,
            model.setSortField,
            sortAscending,
            SortPurportField.rarity,
            'По редкости',
          ),
          const SizedBox(height: 8),
          _buildSortButton(
            context,
            sortField,
            model.setSortField,
            sortAscending,
            SortPurportField.datetime,
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
      filters: [rarityFilter, statusFilter, sorting],
    );
  }


  Widget _buildSortButton(
    BuildContext context,
    SortPurportField sortField,
    Function(SortPurportField) setSortField,
    bool sortAscending,
    SortPurportField field,
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
