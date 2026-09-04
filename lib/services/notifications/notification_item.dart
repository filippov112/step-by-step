
import 'package:flutter/material.dart';

enum NotificationType { getReward, skillLvlUp, classLvlUp, profileLvlUp }

abstract class NotificationItem {
  Widget getWidget();
}

