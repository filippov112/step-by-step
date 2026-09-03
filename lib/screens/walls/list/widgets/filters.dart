import 'package:chaos_control/screens/walls/list/wall_list_model.dart';
import 'package:chaos_control/widgets/filters/sort_button.dart';
import 'package:chaos_control/widgets/form/checkbox.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/filters/filter_section.dart';
import 'package:chaos_control/widgets/filters/filters_drawer.dart';
import 'package:provider/provider.dart';


class WallListFilters extends StatefulWidget {
  const WallListFilters({super.key});

  @override
  State<WallListFilters> createState() => _WallListFiltersState();
}

class _WallListFiltersState extends State<WallListFilters> {

  @override
  Widget build(BuildContext context) {

    final model = context.read<WallListModel>();
    final hasActiveFilters = context.select<WallListModel,bool>((model) => model.hasActiveFilters);
    
    final groupFilterValue = context.select<WallListModel,bool>((m) => m.groupFilter);
    
    final sortField = context.select<WallListModel,SortWallField>((model) => model.sortField);
    final sortAscending = context.select<WallListModel,bool>((model) => model.sortAscending);

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
            SortButton<SortWallField>(
              sortField: sortField,
              setSortField: model.setSortField,
              sortAscending: sortAscending,
              field: SortWallField.title,
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



