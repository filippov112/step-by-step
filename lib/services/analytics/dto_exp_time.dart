import 'package:chaos_control/models/task_reward.dart';
import 'package:chaos_control/tools/datetime.dart';

/// Модель для агрегированных данных по дате
class DtoExpTime {
  static const cTime = 'total_time';
  static const cExp = 'total_exp';

  final int date;
  final int totalTime;
  final int totalExperience;

  DateTime? get dateTime => DateTool.joinDateTime(date: date);

  DtoExpTime({
    required this.date,
    required this.totalTime,
    required this.totalExperience,
  });

  factory DtoExpTime.fromMap(Map<String, dynamic> map) {
    return DtoExpTime(
      date: map[TaskReward.cDate] as int,
      totalTime: map[cExp] as int? ?? 0,
      totalExperience: map[cTime] as int? ?? 0,
    );
  }
}
