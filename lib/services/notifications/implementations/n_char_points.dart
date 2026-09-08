import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/services/notifications/notification_item.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';

class NCharPoints extends NotificationItem {

  @override
  Widget getWidget() {
    return CustomText('${char.displayName}: +$value');
  }

  Characteristics char = Characteristics.control;
  int value = 0;
}