import 'package:chaos_control/models/enums/wall_difficulty.dart';
import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:chaos_control/tools/datetool.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallDetailDetailTab extends StatelessWidget {
  const WallDetailDetailTab({super.key});

  @override
  Widget build(BuildContext context) {
    var target = context.select<WallDetailModel, String>(
      (model) => model.wall.target,
    );
    var diff = context.select<WallDetailModel, WallDiff>(
      (model) => model.wall.difficulty,
    );
    var created = context.select<WallDetailModel, DateTime?>(
      (model) => model.wall.created,
    );
    var destroyed = context.select<WallDetailModel, DateTime?>(
      (model) => model.wall.destroyed,
    );

    final targetWidget = target.isEmpty
        ? null
        : CustomCardBlock(
            icon: Icons.center_focus_weak_rounded,
            title: 'Цель',
            child: CustomText(
              target,
              lines: null,
              overflow: TextOverflow.visible,
            ),
          );

    final diffWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomText('Уровень сложности:'),
        CustomText(diff.name, color: diff.color, weight: FontWeight.bold),
      ],
    );

    final createdWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomText('Создана:'),
        CustomText(DateTool.fullDateFormat(created), weight: FontWeight.bold),
      ],
    );

    final destroyedWidget = destroyed == null
        ? null
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText('Разрушена:', color: WallStatus.destroyed.color),
              CustomText(
                DateTool.fullDateFormat(destroyed),
                weight: FontWeight.bold,
                color: WallStatus.destroyed.color,
              ),
            ],
          );

    final otherInfoWidget = CustomCardBlock(
      child: Padding(
        padding: const EdgeInsetsGeometry.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [diffWidget, createdWidget, ?destroyedWidget],
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.all(12),
      child: ListView(children: [?targetWidget, otherInfoWidget]),
    );
  }
}
