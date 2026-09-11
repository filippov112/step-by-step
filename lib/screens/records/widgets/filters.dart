import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/models/enums/difficulty_lvl.dart';
import 'package:chaos_control/screens/profile/detail/widgets/activity.dart';
import 'package:chaos_control/screens/records/record_list_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
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
    final diffFilterValue = context.select<RecordListModel, DifficultyLvl?>(
      (m) => m.diffFilter,
    );
    final charFilterValue = context.select<RecordListModel, Characteristic?>(
      (m) => m.charFilter,
    );

    final sortField = context.select<RecordListModel, SortRecord>(
      (m) => m.sorting,
    );
    final sortAscending = context.select<RecordListModel, bool>(
      (m) => m.sortAscending,
    );

    final focusColor = Theme.of(context).focusColor;
    final disabledColor = Theme.of(context).disabledColor;

    final groupFilter = FilterSection(
      title: 'Группировка',
      icon: Icons.folder,
      children: CustomCheckbox(
        initValue: groupFilterValue,
        setValue: model.setGroupFilter,
        label: 'Объединять в группы',
      ),
    );

    final charFilter = FilterSection(
      title: 'Характеристика',
      icon: Icons.bar_chart,
      children: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ActivityType.values.map((type) {
            final color = charFilterValue == type.characteristic
                ? type.characteristic?.color ?? focusColor
                : disabledColor;
            final shadows = charFilterValue == type.characteristic
                ? [Shadow(color: color, blurRadius: 18)]
                : null;
            return IconButton(
              icon: Icon(type.icon, color: color, shadows: shadows),
              onPressed: () => model.setCharFilter(type.characteristic),
            );
          }).toList(),
        ),
      ),
    );

    final diffFilter = FilterSection(
      title: 'Сложность',
      icon: Icons.hotel_class,
      children: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: CustomText(
                'All',
                color: diffFilterValue == null ? focusColor : disabledColor,
                weight: FontWeight.bold,
              ),
              onPressed: () => model.setDiffFilter(null),
            ),
            ...DifficultyLvl.values.map((lvl) {
              final color = diffFilterValue == lvl ? lvl.color : disabledColor;
              return IconButton(
                icon: CustomText(
                  lvl.name,
                  color: color,
                  weight: FontWeight.bold,
                ),
                onPressed: () => model.setDiffFilter(lvl),
              );
            }),
          ],
        ),
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
      filters: [groupFilter, dateFilters, charFilter, diffFilter, sorting],
    );
  }
}
