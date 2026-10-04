import 'package:step_by_step/services/notifications/notification_item.dart';
import 'package:step_by_step/services/numerictool.dart';
import 'package:step_by_step/services/sound_service.dart';
import 'package:step_by_step/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';

class NNewLevel extends NotificationItem {

  NNewLevel() {
    soundType = SoundType.levelUp;
  }

  @override
  Widget getWidget() {
    return Column(children: [
      CustomText('Level Up!'),
      CustomText(NumericTool.toThousandString(level), weight: FontWeight.bold, size: 24,)
    ],);
  }

  int level = 0;
}