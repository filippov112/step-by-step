import 'package:chaos_control/widgets/filters/sort_button.dart';
import 'package:chaos_control/widgets/form/checkbox.dart';
import 'package:flutter/material.dart';
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
    final hasActiveFilters = context.select<PurportListModel,bool>((model) => model.hasActiveFilters);
    
    final groupFilterValue = context.select<PurportListModel,bool>((m) => m.groupFilter);
    
    final sortField = context.select<PurportListModel,SortPurportField>((model) => model.sortField);
    final sortAscending = context.select<PurportListModel,bool>((model) => model.sortAscending);

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
            SortButton<SortPurportField>(
              sortField: sortField,
              setSortField: model.setSortField,
              sortAscending: sortAscending,
              field: SortPurportField.title,
              label: 'По названию',
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