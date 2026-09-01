import 'package:flutter/material.dart';
import 'package:chaos_control/screens/projects/list/project_list_model.dart';
import 'package:chaos_control/widgets/filters/filter_section.dart';
import 'package:chaos_control/widgets/filters/filters_drawer.dart';
import 'package:provider/provider.dart';


class ProjectListFilters extends StatefulWidget {
  const ProjectListFilters({super.key});

  @override
  State<ProjectListFilters> createState() => _ProjectListFiltersState();
}

class _ProjectListFiltersState extends State<ProjectListFilters> {

  @override
  Widget build(BuildContext context) {

    final model = context.read<ProjectListModel>();
    var hasActiveFilters = context.select<ProjectListModel,bool>((model) => model.hasActiveFilters);
    var sortField = context.select<ProjectListModel,SortProjectField>((model) => model.sortField);
    var sortAscending = context.select<ProjectListModel,bool>((model) => model.sortAscending);

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
              SortProjectField.title,
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
    SortProjectField sortField,
    Function(SortProjectField) setSortField,
    bool sortAscending,
    SortProjectField field,
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



