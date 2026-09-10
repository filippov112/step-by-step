import 'package:chaos_control/services/notifications/notification_item.dart';
import 'package:chaos_control/services/numerictool.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';

class NNewLevel extends NotificationItem {

  @override
  Widget getWidget() {
    return Column(children: [
      CustomText('Level Up!'),
      CustomText(NumericTool.toThousandString(level), weight: FontWeight.bold, size: 24,)
    ],);
  }

  int level = 0;
}