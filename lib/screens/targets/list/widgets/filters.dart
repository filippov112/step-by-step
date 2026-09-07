import 'package:chaos_control/screens/targets/list/target_list_model.dart';
import 'package:chaos_control/widgets/filters/sort_button.dart';
import 'package:chaos_control/widgets/form/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/filters/filter_section.dart';
import 'package:chaos_control/widgets/filters/filters_drawer.dart';
import 'package:provider/provider.dart';


class TargetListFilters extends StatefulWidget {
  const TargetListFilters({super.key});

  @override
  State<TargetListFilters> createState() => _TargetListFiltersState();
}

class _TargetListFiltersState extends State<TargetListFilters> {

  @override
  Widget build(BuildContext context) {

    final model = context.read<TargetListModel>();
    final hasActiveFilters = context.select<TargetListModel,bool>((model) => model.hasActiveFilters);
    
    final groupFilterValue = context.select<TargetListModel,bool>((m) => m.groupFilter);
    
    final sortField = context.select<TargetListModel,SortTargetField>((model) => model.sortField);
    final sortAscending = context.select<TargetListModel,bool>((model) => model.sortAscending);

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
            SortButton<SortTargetField>(
              sortField: sortField,
              setSortField: model.setSortField,
              sortAscending: sortAscending,
              field: SortTargetField.title,
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



