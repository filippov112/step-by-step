import 'package:chaos_control/models/attempt.dart';
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
      date: map[Attempt.cDate] as int,
      totalExperience: map[cExp] as int? ?? 0,
    );
  }
}
