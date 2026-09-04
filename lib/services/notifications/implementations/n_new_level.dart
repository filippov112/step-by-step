import 'package:chaos_control/services/notifications/notification_item.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';

class NNewLevel extends NotificationItem {

  @override
  Widget getWidget() {
    return CustomText('Новый уровень: $level');
  }

  int level = 0;
}