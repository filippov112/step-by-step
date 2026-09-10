import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/services/notifications/notification_item.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';

class NCharPoints extends NotificationItem {

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

  Characteristic char = Characteristic.control;
  int value = 0;
}