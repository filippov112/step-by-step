import 'package:chaos_control/screens/targets/detail/target_detail_model.dart';
import 'package:chaos_control/screens/targets/detail/widgets/tasks_tab.dart';
import 'package:chaos_control/screens/targets/detail/widgets/detail_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetDetailTabs extends StatelessWidget {
  final TabController controller;

  const TargetDetailTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

    final model = context.read<TargetDetailModel>();

    return Expanded(
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).focusColor,
            dividerColor: Theme.of(context).dividerColor,
            indicatorColor: Theme.of(context).focusColor,
            controller: controller,
            onTap: model.changeTabIndex,
            tabs: const [
              Tab(text: 'Задачи', height: 40,),
              Tab(text: 'Детали', height: 40,),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: const [
                TargetDetailTaskTab(),
                TargetDetailDetailTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
