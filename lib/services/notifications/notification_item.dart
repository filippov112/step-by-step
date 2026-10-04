
import 'package:step_by_step/services/sound_service.dart';
import 'package:flutter/material.dart';

abstract class NotificationItem {
  Widget getWidget();
  SoundType soundType = SoundType.recordOrPurport;
}

