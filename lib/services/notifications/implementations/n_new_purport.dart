import 'package:step_by_step/screens/home/modules.dart';
import 'package:step_by_step/services/notifications/notification_item.dart';
import 'package:step_by_step/services/sound_service.dart';
import 'package:step_by_step/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NNewPurport extends NotificationItem {

  NNewPurport() {
    soundType = SoundType.recordOrPurport;
  }

  @override
  Widget getWidget() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
        Icon(AppModule.chronicle.icon),
        CustomText('Смысл добавлен!', padding: EdgeInsets.only(left: 8),),
      ],),
    ],);
  }
}