import 'package:flutter/material.dart';
import 'package:life_game/models/enums/tag_type.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/classes/list/class_list_model.dart';
import 'package:life_game/widgets/common/tag_chip.dart';
import 'package:life_game/widgets/filters/filter_section.dart';
import 'package:life_game/widgets/filters/filters_drawer.dart';
import 'package:life_game/widgets/filters/tags_finder.dart';
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
    var selectedTags = context.select<ClassListModel,List<Tag>>((model) => model.selectedTags);
    var sortField = context.select<ClassListModel,SortClassField>((model) => model.sortField);
    var sortAscending = context.select<ClassListModel,bool>((model) => model.sortAscending);

    // Теги
    var tagsFilter = FilterSection(
      title: 'Теги (${selectedTags.length})',
      icon: Icons.tag,
      children:
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  ...selectedTags.map((tag) =>
                    TagChip(
                      title: tag.title,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8,),
            IconButton(
              onPressed: () =>_openTagSelector(context),
              icon: const Icon(Icons.add, size: 16),
            ),
          ],
        )
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
       tagsFilter,
       sorting
      ],
    );
  }

  Future _openTagSelector(BuildContext context) async {
    final model = context.read<ClassListModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TagsFinder(
        selectedTags: model.selectedTags,
        onConfirm: model.setTagsFilter,
        type: TagType.class_
      ),
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



