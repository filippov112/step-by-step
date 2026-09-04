import 'package:chaos_control/models/attempt.dart';
import 'package:chaos_control/services/datetool.dart';

/// Модель для агрегированных данных по дате
class DtoActivity {
  static const cExp = 'total_exp';

  final int date;
  final int totalExperience;

  DateTime? get dateTime => DateTool.joinDateTime(date: date);

  DtoActivity({
    required this.date,
    required this.totalExperience,
  });

  factory DtoActivity.fromMap(Map<String, dynamic> map) {
    return DtoActivity(
      date: map[Attempt.cDate] as int,
      totalExperience: map[cExp] as int? ?? 0,
    );
  }
}
