
import 'package:flutter/material.dart';

enum NotificationType { getReward, skillLvlUp, classLvlUp, profileLvlUp }

abstract class NotificationItem {
  final NotificationType type;

  Widget getWidget();

  NotificationItem({
    required this.type,
  });
}

