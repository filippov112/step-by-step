import 'package:chaos_control/models/record.dart';
import 'package:chaos_control/models/enums/characteristics.dart';
import 'package:chaos_control/services/datetool.dart';

/// Модель для агрегированных данных по дате
class DtoActivity {
  static const cHappiness = 'total_1';
  static const cPerseverance = 'total_2';
  static const cCourage = 'total_3';
  static const cDurability = 'total_4';
  static const cPotencial = 'total_5';

  final int date;
  final int happiness, diligence, strategy, durability, potencial;
  int get totalExperience => happiness + diligence + strategy + durability + potencial;

  DateTime? get dateTime => DateTool.joinDateTime(date: date);

  DtoActivity({
    required this.date,

    required this.happiness,
    required this.diligence,
    required this.strategy,
    required this.durability,
    required this.potencial,
  });

  int getChar(Characteristic? ch) {
    if (ch == null) return totalExperience;
    switch (ch) {
      case Characteristic.happiness:
        return happiness;
      case Characteristic.diligence:
        return diligence;
      case Characteristic.strategy:
        return strategy;
      case Characteristic.durability:
        return durability;
      case Characteristic.potencial:
        return potencial;
    }
  }

  factory DtoActivity.fromMap(Map<String, dynamic> map) {
    return DtoActivity(
      date: map[ChronicleRecord.cDate] as int,

      happiness: map[cHappiness] as int? ?? 0,
      diligence: map[cPerseverance] as int? ?? 0,
      strategy: map[cCourage] as int? ?? 0,
      durability: map[cDurability] as int? ?? 0,
      potencial: map[cPotencial] as int? ?? 0,
    );
  }
}
