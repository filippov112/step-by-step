import 'package:chaos_control/screens/purports/detail/widgets/tab_detail.dart';
import 'package:chaos_control/screens/purports/detail/widgets/tab_images.dart';
import 'package:chaos_control/screens/purports/detail/widgets/tab_sounds.dart';
import 'package:flutter/material.dart';

class PurportDetailTabs extends StatelessWidget {
  final TabController controller;

  const PurportDetailTabs({super.key, required this.controller});

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
              Tab(text: 'Детали', height: 40,),
              Tab(text: 'Фото', height: 40,),
              Tab(text: 'Аудио', height: 40,),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: const [
                PurportDetailDetailTab(),
                PurportDetailTabImages(),
                PurportDetailTabSounds(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
