import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/targets/list/target_list_model.dart';
import 'package:chaos_control/screens/targets/list/widgets/select_project_dialog.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetListBottomFilters extends StatelessWidget {
  const TargetListBottomFilters({super.key});

  Future _openProjectDialog(
    BuildContext context,
    Function(Project?) callback,
  ) async {
    final selectedProject = await showDialog<Project?>(
      context: context,
      builder: (context) => const TargetListSelectProjectDialog(),
    );
    callback.call(selectedProject);
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<TargetListModel>();

    final projectFilter = context.select<TargetListModel, Project?>(
      (m) => m.projectFilter,
    );
    final setProjectFilter = model.setProjectFilter;

    final favoriteFilterValue = context.select<TargetListModel, bool>(
      (m) => m.favoriteFilter,
    );
    final setFavoriteFilter = model.setFavoriteFilter;

    final cardColor = Theme.of(context).cardColor.withAlpha(180);
    final focusColor = Theme.of(context).focusColor;
    final projectName = projectFilter == null
        ? 'Все проекты'
        : projectFilter.title;
    final favoriteColor = favoriteFilterValue
        ? Theme.of(context).focusColor.withAlpha(180)
        : Theme.of(context).focusColor.withAlpha(40);

    final selectProjectWidget = InkWell(
      onTap: () => _openProjectDialog(context, setProjectFilter),
      child: Container(
        decoration: BoxDecoration(color: cardColor),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              projectName,
              size: 17,
              align: TextAlign.left,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: focusColor,
            ),
          ],
        ),
      ),
    );

    final favoriteWidget = Container(
      width: 56,
      color: cardColor,
      child: InkWell(
        onTap: () => setFavoriteFilter(!favoriteFilterValue),
        child: Center(
          child: Icon(Icons.star, color: favoriteColor, size: 24),
        ),
      ),
    );

    final d = Container(color: focusColor, 
    width: 1,
    // width: 3,
    );

    return SizedBox(height:56,

    child:Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: selectProjectWidget),
        d,
        favoriteWidget,
      ],
    ));
  }
}
