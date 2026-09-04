import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:chaos_control/screens/walls/detail/widgets/attempt_tab.dart';
import 'package:chaos_control/screens/walls/detail/widgets/detail_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WallDetailTabs extends StatelessWidget {
  final TabController controller;

  const WallDetailTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

    final model = context.read<WallDetailModel>();

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
              Tab(text: 'Попытки', height: 40,),
              Tab(text: 'Детали', height: 40,),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: const [
                WallDetailAttemptTab(),
                WallDetailDetailTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
