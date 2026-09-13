import 'package:chaos_control/screens/purports/detail/widgets/tab_detail.dart';
import 'package:chaos_control/screens/purports/detail/widgets/tab_images.dart';
import 'package:chaos_control/screens/purports/detail/widgets/tab_sounds.dart';
import 'package:chaos_control/screens/purports/images/purport_images_model.dart';
import 'package:chaos_control/screens/purports/sounds/purport_sounds_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurportDetailTabs extends StatelessWidget {
  final TabController controller;

  const PurportDetailTabs({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

    final imagesCount = context.select<PurportImagesModel,int>((m) => m.images.length);
    final soundsCount = context.select<PurportSoundsModel,int>((m) => m.sounds.length);

    return Expanded(
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).focusColor,
            dividerColor: Theme.of(context).dividerColor,
            indicatorColor: Theme.of(context).focusColor,
            controller: controller,
            tabs: [
              Tab(text: 'Детали', height: 40,),
              Tab(text: 'Фото ($imagesCount)', height: 40,),
              Tab(text: 'Аудио ($soundsCount)', height: 40,),
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
