import 'package:chaos_control/models/record.dart';
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
  final int control, diligence, strategy, durability, creativity;
  int get totalExperience => control + diligence + strategy + durability + creativity;

  DateTime? get dateTime => DateTool.joinDateTime(date: date);

  DtoActivity({
    required this.date,

    required this.control,
    required this.diligence,
    required this.strategy,
    required this.durability,
    required this.creativity,
  });

  int getChar(Characteristic? ch) {
    if (ch == null) return totalExperience;
    switch (ch) {
      case Characteristic.control:
        return control;
      case Characteristic.diligence:
        return diligence;
      case Characteristic.strategy:
        return strategy;
      case Characteristic.durability:
        return durability;
      case Characteristic.creativity:
        return creativity;
    }
  }

  factory DtoActivity.fromMap(Map<String, dynamic> map) {
    return DtoActivity(
      date: map[ChronicleRecord.cDate] as int,

      control: map[cControl] as int? ?? 0,
      diligence: map[cPerseverance] as int? ?? 0,
      strategy: map[cCourage] as int? ?? 0,
      durability: map[cDurability] as int? ?? 0,
      creativity: map[cCreativity] as int? ?? 0,
    );
  }
}
