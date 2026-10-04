import 'package:step_by_step/models/enums/characteristics.dart';
import 'package:step_by_step/services/notifications/notification_item.dart';
import 'package:step_by_step/services/sound_service.dart';
import 'package:step_by_step/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';

class NCharPoints extends NotificationItem {

  NCharPoints() {
    soundType = SoundType.statsUp;
  }

  @override
  Widget getWidget() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
        Icon(char.icon, color: char.color),
        CustomText(char.displayName, padding: EdgeInsets.only(left: 8),),
      ],),
      CustomText('+$value', weight: FontWeight.bold, size: 18,)
    ],);
  }

  Characteristic char = Characteristic.knowledge;
  int value = 0;

}