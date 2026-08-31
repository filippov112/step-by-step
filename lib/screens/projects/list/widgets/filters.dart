import 'package:flutter/material.dart';
import 'package:chaos_control/screens/projects/list/class_list_model.dart';
import 'package:chaos_control/widgets/filters/filter_section.dart';
import 'package:chaos_control/widgets/filters/filters_drawer.dart';
import 'package:provider/provider.dart';


class ClassFilters extends StatefulWidget {
  const ClassFilters({super.key});

  @override
  State<ClassFilters> createState() => _ClassFiltersState();
}

class _ClassFiltersState extends State<ClassFilters> {

  @override
  Widget build(BuildContext context) {

    final model = context.read<ClassListModel>();
    var hasActiveFilters = context.select<ClassListModel,bool>((model) => model.hasActiveFilters);
    var sortField = context.select<ClassListModel,SortClassField>((model) => model.sortField);
    var sortAscending = context.select<ClassListModel,bool>((model) => model.sortAscending);

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
              SortClassField.title,
              'По названию',
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
       sorting
      ],
    );
  }

  
  Widget _buildSortButton(
    BuildContext context,
    SortClassField sortField,
    Function(SortClassField) setSortField,
    bool sortAscending,
    SortClassField field,
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



