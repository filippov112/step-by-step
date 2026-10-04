import 'package:step_by_step/screens/profile/detail/profile_detail_model.dart';
import 'package:step_by_step/widgets/common/custom_text.dart';
import 'package:step_by_step/widgets/common/search_string.dart';
import 'package:flutter/material.dart';
import 'package:step_by_step/widgets/filters/filter_section.dart';
import 'package:step_by_step/widgets/filters/filters_drawer.dart';
import 'package:provider/provider.dart';

class ProfileDetailFilters extends StatefulWidget {
  const ProfileDetailFilters({super.key});

  @override
  State<ProfileDetailFilters> createState() => _ProfileDetailFiltersState();
}

class _ProfileDetailFiltersState extends State<ProfileDetailFilters> {
  late TextEditingController searchController;
  late ProfileDetailModel model;

  @override
  void initState() {
    super.initState();
    model = context.read<ProfileDetailModel>();
    searchController = TextEditingController(text: model.groupFilter);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = context.select<ProfileDetailModel, bool>(
      (model) => model.hasActiveFilters,
    );
    final groupFilterValue = context.select<ProfileDetailModel, String>(
      (m) => m.groupFilter,
    );

    final PeriodFilterType selectedPeriod = context
        .select<ProfileDetailModel, PeriodFilterType>(
          (model) => model.periodFilter,
        );
    final setPeriodFilter = context.read<ProfileDetailModel>().setPeriodFilter;

    final groupFilter = FilterSection(
      title: 'Группа',
      icon: Icons.folder,
      children: SearchString(
        controller: searchController,
        value: groupFilterValue,
        changeCallback: model.setGroupFilter,
      ),
    );

    final periodFilter = FilterSection(
      title: 'Глубина анализа',
      icon: Icons.calendar_month,
      children: DropdownButtonFormField<PeriodFilterType>(
        items: [ ...PeriodFilterType.values.map((p) => DropdownMenuItem(
            value: p,
            child: CustomText(p.displayName),
          ),)
        ],
        initialValue: selectedPeriod,
        onChanged: (v) => setPeriodFilter(v ?? PeriodFilterType.oneMonth),
      ),
    );

    return FiltersDrawer(
      // Сброс
      buttons: ElevatedButton(
        onPressed: hasActiveFilters ? () { searchController.clear(); model.clearAllFilters(); } : null,
        child: const Text('Сбросить все фильтры'),
      ),
      filters: [groupFilter, periodFilter],
    );
  }
}
