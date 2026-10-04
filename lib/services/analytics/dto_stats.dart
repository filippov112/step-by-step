import 'package:step_by_step/models/enums/characteristics.dart';

/// Модель для характеристик
class DtoStats {
  static const cP1 = 'total_1';
  static const cP2 = 'total_2';
  static const cP3 = 'total_3';
  static const cP4 = 'total_4';
  static const cP5 = 'total_5';
  static const cP6 = 'total_6';

  final CharValues chars;

  DtoStats({
    required this.chars
  });

  factory DtoStats.fromMap(Map<String, dynamic> map) {
    return DtoStats(
      chars: CharValues(values: [
        map[cP1] as int? ?? 0,
        map[cP2] as int? ?? 0,
        map[cP3] as int? ?? 0,
        map[cP4] as int? ?? 0,
        map[cP5] as int? ?? 0,
        map[cP6] as int? ?? 0,
      ]),
    );
  }
}
