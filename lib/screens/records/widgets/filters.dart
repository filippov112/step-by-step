import 'package:step_by_step/models/enums/characteristics_ext.dart';
import 'package:step_by_step/models/enums/characteristics.dart';
import 'package:step_by_step/screens/records/record_list_model.dart';
import 'package:step_by_step/widgets/common/custom_text.dart';
import 'package:step_by_step/widgets/filters/sort_button.dart';
import 'package:step_by_step/widgets/form/checkbox.dart';
import 'package:step_by_step/widgets/form/datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:step_by_step/widgets/filters/filter_section.dart';
import 'package:step_by_step/widgets/filters/filters_drawer.dart';
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
    final charFilterValue = context.select<RecordListModel, Characteristic?>(
      (m) => m.charFilter,
    );
    final targetFilterValue = context.select<RecordListModel, TargetFilterType>(
      (m) => m.targetFilter,
    );
    final favoriteFilterValue = context.select<RecordListModel, FavoriteFilterType>(
      (m) => m.favoriteFilter,
    );
    

    final sortField = context.select<RecordListModel, SortRecord>(
      (m) => m.sorting,
    );
    final sortAscending = context.select<RecordListModel, bool>(
      (m) => m.sortAscending,
    );

    final focusColor = Theme.of(context).focusColor;
    final disabledColor = Theme.of(context).disabledColor;

    // Группировка
    final groupFilter = FilterSection(
      title: 'Группировка',
      icon: Icons.folder,
      children: CustomCheckbox(
        initValue: groupFilterValue,
        setValue: model.setGroupFilter,
        label: 'Объединять в группы',
      ),
    );

    // Цели
    final targetFilter = FilterSection(
      title: 'Цели',
      icon: Icons.center_focus_strong,
      children: DropdownButtonFormField<TargetFilterType>(
        items: [
          ...TargetFilterType.values.map((t) => DropdownMenuItem(
            value: t,
            child: CustomText(t.displayName),
          ),)
        ],
        initialValue: targetFilterValue,
        onChanged: (v) => model.setTargetFilter(v ?? TargetFilterType.all),
      ),
    );

    // Избранное
    final favoriteFilter = FilterSection(
      title: 'Избранные',
      icon: Icons.star,
      children: DropdownButtonFormField<FavoriteFilterType>(
        items: [
          ...FavoriteFilterType.values.map((t) => DropdownMenuItem(
            value: t,
            child: CustomText(t.displayName),
          ),)
        ],
        initialValue: favoriteFilterValue,
        onChanged: (v) => model.setFavoriteFilter(v ?? FavoriteFilterType.all),
      ),
    );

    // Характеристика
    final charFilter = FilterSection(
      title: 'Характеристика',
      icon: Icons.bar_chart,
      children: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: CharacteristicExt.values.map((type) {
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
      filters: [favoriteFilter, targetFilter, groupFilter, dateFilters, charFilter, sorting],
    );
  }
}
