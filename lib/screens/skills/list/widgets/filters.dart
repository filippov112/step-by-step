import 'package:flutter/material.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/tasks/form/widgets/skill_list_model.dart';
import 'package:life_game/widgets/common/tag_chip.dart';
import 'package:life_game/widgets/filters/filter_section.dart';
import 'package:life_game/widgets/filters/filters_drawer.dart';
import 'package:life_game/widgets/filters/tags_finder.dart';
import 'package:provider/provider.dart';

enum SortSkillField { title, rang, level }

class SkillFilters extends StatefulWidget {
  const SkillFilters({super.key});

  @override
  State<SkillFilters> createState() => _SkillFiltersState();
}

class _SkillFiltersState extends State<SkillFilters> {

  @override
  Widget build(BuildContext context) {

    final model = context.read<SkillListModel>();
    var hasActiveFilters = context.select<SkillListModel,bool>((model) => model.hasActiveFilters);
    var filterRang = context.select<SkillListModel,Set<SkillRang>>((model) => model.filterRang);
    var selectedTags = context.select<SkillListModel,List<Tag>>((model) => model.selectedTags);
    var sortField = context.select<SkillListModel,SortSkillField>((model) => model.sortField);
    var sortAscending = context.select<SkillListModel,bool>((model) => model.sortAscending);

    // Ранг
    var priorityFilter = FilterSection(
      title: 'Ранг',
      icon: Icons.star_border,
      children: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          ...SkillRang.values.map((rang) =>
            FilterChip(
              label: Text(rang.name),
              selected: filterRang.contains(rang),
              onSelected: (_) => model.setRangFilter(rang),
            ),
          ),
        ],
      ),
    );

    

    // Теги
    var tagsFilter = FilterSection(
      title: 'Теги',
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
              SortSkillField.title,
              'По названию',
            ),
            const SizedBox(height: 8),
            _buildSortButton(
              context,
              sortField,
              model.setSortField,
              sortAscending,
              SortSkillField.rang,
              'По рангу',
            ),
            const SizedBox(height: 8),
            _buildSortButton(
              context,
              sortField,
              model.setSortField,
              sortAscending,
              SortSkillField.level,
              'По уровню',
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
       priorityFilter,
       tagsFilter,
       sorting
      ],
    );
  }

  Future _openTagSelector(BuildContext context) async {
    final model = context.read<SkillListModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TagsFinder(
        selectedTags: model.selectedTags,
        onConfirm: model.setTagsFilter,
      ),
    );
  }
  
  Widget _buildSortButton(
    BuildContext context,
    SortSkillField sortField,
    Function(SortSkillField) setSortField,
    bool sortAscending,
    SortSkillField field,
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



