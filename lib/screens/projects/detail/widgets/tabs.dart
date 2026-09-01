import 'package:chaos_control/screens/projects/detail/widgets/info_tab.dart';
import 'package:chaos_control/screens/projects/detail/widgets/walls_tab.dart';
import 'package:flutter/material.dart';

class ProjectDetailTabs extends StatelessWidget {
  final TabController controller;

  const ProjectDetailTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).focusColor,
            dividerColor: Theme.of(context).dividerColor,
            indicatorColor: Theme.of(context).focusColor,
            controller: controller,
            tabs: const [
              Tab(text: 'Стены', height: 40,),
              Tab(text: 'Цели', height: 40,),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: const [
                ProjectDetailWallsTab(),
                ProjectDetailInfoTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
