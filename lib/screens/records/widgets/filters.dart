import 'package:chaos_control/screens/records/record_list_model.dart';
import 'package:chaos_control/widgets/filters/sort_button.dart';
import 'package:chaos_control/widgets/form/checkbox.dart';
import 'package:chaos_control/widgets/form/datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/filters/filter_section.dart';
import 'package:chaos_control/widgets/filters/filters_drawer.dart';
import 'package:provider/provider.dart';

class RecordListFilters extends StatefulWidget {
  const RecordListFilters({super.key});

  @override
  State<RecordListFilters> createState() => _RecordListFiltersState();
}

class _RecordListFiltersState extends State<RecordListFilters> {
  @override
  Widget build(BuildContext context) {
    final model = context.read<RecordListModel>();
    final hasActiveFilters = context.select<RecordListModel, bool>(
      (m) => m.hasActiveFilters,
    );
    final dateBegin = context.select<RecordListModel, DateTime?>(
      (m) => m.dateBeginFilter,
    );
    final dateEnd = context.select<RecordListModel, DateTime?>(
      (m) => m.dateEndFilter,
    );
    final groupFilterValue = context.select<RecordListModel, bool>(
      (m) => m.groupFilter,
    );

    final sortField = context.select<RecordListModel, SortRecord>(
      (m) => m.sorting,
    );
    final sortAscending = context.select<RecordListModel, bool>(
      (m) => m.sortAscending,
    );

    final groupFilter = FilterSection(
      title: 'Группировка',
      icon: Icons.folder,
      children: CustomCheckbox(
        initValue: groupFilterValue,
        setValue: model.setGroupFilter,
        label: 'Объединять в группы',
      ),
    );

    // Период
    final dateFilters = FilterSection(
      title: 'Период',
      icon: Icons.calendar_month,
      children: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomDateTime(
            label: 'Начало:',
            dateOnly: true,
            callback: model.setDateBeginFilter,
            value: dateBegin,
          ),
          const SizedBox(height: 8),
          CustomDateTime(
            label: 'Конец:',
            dateOnly: true,
            callback: model.setDateEndFilter,
            value: dateEnd,
          ),
        ],
      ),
    );

    // Сортировка
    final sorting = FilterSection(
      title: 'Сортировка',
      icon: Icons.sort,
      children: Column(
        children: [
          SortButton<SortRecord>(
            sortField: sortField,
            setSortField: model.setSorting,
            sortAscending: sortAscending,
            field: SortRecord.date,
            label: 'По дате',
          ),
          const SizedBox(height: 8),
          SortButton<SortRecord>(
            sortField: sortField,
            setSortField: model.setSorting,
            sortAscending: sortAscending,
            field: SortRecord.time,
            label: 'По времени добавления',
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
      filters: [groupFilter, dateFilters, sorting],
    );
  }
}
