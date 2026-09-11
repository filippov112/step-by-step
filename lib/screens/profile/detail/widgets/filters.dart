import 'package:chaos_control/screens/profile/detail/profile_detail_model.dart';
import 'package:chaos_control/widgets/common/search_string.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/filters/filter_section.dart';
import 'package:chaos_control/widgets/filters/filters_drawer.dart';
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

    final StatPeriod selectedPeriod = context
        .select<ProfileDetailModel, StatPeriod>(
          (model) => model.selectedPeriod,
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
      children: DropdownButtonFormField<StatPeriod>(
        items: [
          const DropdownMenuItem(
            value: StatPeriod.threeMonth,
            child: Text('3 месяца'),
          ),
          const DropdownMenuItem(
            value: StatPeriod.oneMonth,
            child: Text('1 месяц'),
          ),
          const DropdownMenuItem(
            value: StatPeriod.oneWeek,
            child: Text('1 неделя'),
          ),
          const DropdownMenuItem(
            value: StatPeriod.oneDay,
            child: Text('1 день'),
          ),
        ],
        initialValue: selectedPeriod,
        onChanged: (v) => setPeriodFilter(v ?? StatPeriod.oneMonth),
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
