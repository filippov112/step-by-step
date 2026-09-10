import 'package:chaos_control/screens/records/record_list_model.dart';
import 'package:chaos_control/widgets/filters/sort_button.dart';
import 'package:chaos_control/widgets/form/checkbox.dart';
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
    final hasActiveFilters = context.select<RecordListModel,bool>((model) => model.hasActiveFilters);
    
    final groupFilterValue = context.select<RecordListModel,bool>((m) => m.groupFilter);
    
    final sortField = context.select<RecordListModel,SortRecord>((model) => model.sorting);
    final sortAscending = context.select<RecordListModel,bool>((model) => model.sortAscending);

    final groupFilter = FilterSection(
      title: 'Группировка',
      icon: Icons.folder,
      children: CustomCheckbox(
        initValue: groupFilterValue, 
        setValue: model.setGroupFilter, 
        label: 'Объединять в группы'
      )
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
        groupFilter,
        sorting
      ],
    );
  }
}



