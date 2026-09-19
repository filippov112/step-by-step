
import 'package:chaos_control/services/sound_service.dart';
import 'package:flutter/material.dart';

abstract class NotificationItem {
  Widget getWidget();
  SoundType soundType = SoundType.recordOrPurport;
}

