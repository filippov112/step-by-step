import 'package:step_by_step/models/record.dart';
import 'package:step_by_step/models/enums/characteristics.dart';
import 'package:step_by_step/services/datetool.dart';

/// Модель для агрегированных данных по дате
class DtoActivity {
  static const cP1 = 'total_1';
  static const cP2 = 'total_2';
  static const cP3 = 'total_3';
  static const cP4 = 'total_4';
  static const cP5 = 'total_5';
  static const cP6 = 'total_6';

  final int date;
  CharValues chars;
  DateTime? get dateTime => DateTool.joinDateTime(date: date);

  DtoActivity({
    required this.date,
    required this.chars
  });

  int getChar(Characteristic? ch) {
    if (ch == null) return chars.hours;
    return chars.map[ch] ?? 0;
  }

  factory DtoActivity.fromMap(Map<String, dynamic> map) {
    return DtoActivity(
      date: map[ChronicleRecord.cDate] as int,

      chars: CharValues(values: [
        map[cP1] as int? ?? 0,
        map[cP2] as int? ?? 0,
        map[cP3] as int? ?? 0,
        map[cP4] as int? ?? 0,
        map[cP5] as int? ?? 0,
        map[cP6] as int? ?? 0
      ])
    );
  }
}
