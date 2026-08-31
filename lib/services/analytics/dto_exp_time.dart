import 'package:chaos_control/models/wall_reward.dart';
import 'package:chaos_control/tools/datetime.dart';

/// Модель для агрегированных данных по дате
class DtoExpTime {
  static const cExp = 'total_exp';

  final int date;
  final int totalExperience;

  DateTime? get dateTime => DateTool.joinDateTime(date: date);

  DtoExpTime({
    required this.date,
    required this.totalExperience,
  });

  factory DtoExpTime.fromMap(Map<String, dynamic> map) {
    return DtoExpTime(
      date: map[Reward.cDate] as int,
      totalExperience: map[cExp] as int? ?? 0,
    );
  }
}
