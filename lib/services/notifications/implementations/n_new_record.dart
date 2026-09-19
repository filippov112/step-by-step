import 'package:chaos_control/screens/home/modules.dart';
import 'package:chaos_control/services/notifications/notification_item.dart';
import 'package:chaos_control/services/sound_service.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NNewRecord extends NotificationItem {

  NNewRecord() {
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
        CustomText(isUpdate ? 'Запись обновлена!' : 'Запись добавлена!', padding: EdgeInsets.only(left: 8),),
      ],),
    ],);
  }

  bool isUpdate = false;
}