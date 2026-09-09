import 'package:chaos_control/screens/barriers/bar_list_model.dart';
import 'package:chaos_control/widgets/filters/sort_button.dart';
import 'package:chaos_control/widgets/form/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/filters/filter_section.dart';
import 'package:chaos_control/widgets/filters/filters_drawer.dart';
import 'package:provider/provider.dart';


class BarrierListFilters extends StatefulWidget {
  const BarrierListFilters({super.key});

  @override
  State<BarrierListFilters> createState() => _BarrierListFiltersState();
}

class _BarrierListFiltersState extends State<BarrierListFilters> {

  @override
  Widget build(BuildContext context) {

    final model = context.read<BarrierListModel>();
    final hasActiveFilters = context.select<BarrierListModel,bool>((model) => model.hasActiveFilters);
    
    final groupFilterValue = context.select<BarrierListModel,bool>((m) => m.groupFilter);
    
    final sortField = context.select<BarrierListModel,SortBarrier>((model) => model.sorting);
    final sortAscending = context.select<BarrierListModel,bool>((model) => model.sortAscending);

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
            SortButton<SortBarrier>(
              sortField: sortField,
              setSortField: model.setSorting,
              sortAscending: sortAscending,
              field: SortBarrier.date,
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



