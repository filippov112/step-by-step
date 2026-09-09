import 'package:chaos_control/models/barrier.dart';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/services/datetool.dart';

/// Модель для агрегированных данных по дате
class DtoActivity {
  static const cControl = 'total_1';
  static const cPerseverance = 'total_2';
  static const cCourage = 'total_3';
  static const cDurability = 'total_4';
  static const cCreativity = 'total_5';

  final int date;
  final int control, perseverance, courage, durability, creativity;
  int get totalExperience => control + perseverance + courage + durability + creativity;

  DateTime? get dateTime => DateTool.joinDateTime(date: date);

  DtoActivity({
    required this.date,

    required this.control,
    required this.perseverance,
    required this.courage,
    required this.durability,
    required this.creativity,
  });

  int getChar(Characteristic ch) {
      switch (ch) {
        case Characteristic.control:
          return control;
        case Characteristic.perseverance:
          return perseverance;
        case Characteristic.courage:
          return courage;
        case Characteristic.durability:
          return durability;
        case Characteristic.creativity:
          return creativity;
      }
    }

  factory DtoActivity.fromMap(Map<String, dynamic> map) {
    return DtoActivity(
      date: map[Barrier.cDate] as int,

      control: map[cControl] as int? ?? 0,
      perseverance: map[cPerseverance] as int? ?? 0,
      courage: map[cCourage] as int? ?? 0,
      durability: map[cDurability] as int? ?? 0,
      creativity: map[cCreativity] as int? ?? 0,
    );
  }
}
