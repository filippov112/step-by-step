// lib/widgets/tag_selector_modal.dart
import 'package:flutter/material.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/achievements/achievement_list_model.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:life_game/widgets/filters/tags_finder.dart';
import 'package:provider/provider.dart';

class AchievementFilters extends StatefulWidget {
  final List<Tag> selectedTags;
  final Function(List<Tag>) onConfirm;

  const AchievementFilters({
    super.key,
    required this.selectedTags,
    required this.onConfirm,
  });

  @override
  State<AchievementFilters> createState() => _AchievementFiltersState();
}

class _AchievementFiltersState extends State<AchievementFilters> {

  
  @override
  Widget build(BuildContext context) {

    final viewModel = context.read<AchievementListModel>();
    var statusFilterValue = context.select<AchievementListModel,String?>((model) => model.statusFilterValue);

    var statusFilter = Padding(
      padding: EdgeInsetsGeometry.fromLTRB(16,16,16,0), 
      child:DropdownButtonFormField(
        items: [
          const DropdownMenuItem(
            value: 'all',
            child: CustomText('Все'),
          ),
          const DropdownMenuItem(
            value: 'unlocked',
            child: CustomText('Полученные'),
          ),
          const DropdownMenuItem(
            value: 'locked',
            child: CustomText('Закрытые'),
          ),
        ], 
        initialValue: statusFilterValue ?? 'all', 
        onChanged: (String? value) {  
          viewModel.statusFilterValue = value;
        },
      ),
    );

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          statusFilter,

          TagsFinder(
            selectedTags: widget.selectedTags, 
            onConfirm: (tags) => {
              viewModel.toggleStatusFilter(),
              widget.onConfirm.call(tags)
            }
          ),
        ],
      )
    );
  }
}