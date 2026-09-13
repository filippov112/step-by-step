/// Модель для характеристик
class DtoStats {
  static const cHappiness = 'total_1';
  static const cDiligence = 'total_2';
  static const cIntellection = 'total_3';
  static const cDurability = 'total_4';
  static const cPotencial = 'total_5';

  final int happiness, diligence, intellection, durability, potencial;

  DtoStats({
    required this.happiness,
    required this.diligence,
    required this.intellection,
    required this.durability,
    required this.potencial,
  });

  factory DtoStats.fromMap(Map<String, dynamic> map) {
    return DtoStats(
      happiness: map[cHappiness] as int? ?? 0,
      diligence: map[cDiligence] as int? ?? 0,
      intellection: map[cIntellection] as int? ?? 0,
      durability: map[cDurability] as int? ?? 0,
      potencial: map[cPotencial] as int? ?? 0,
    );
  }
}
