/// Модель для характеристик
class DtoStats {
  static const cControl = 'total_1';
  static const cPerseverance = 'total_2';
  static const cCourage = 'total_3';
  static const cDurability = 'total_4';
  static const cCreativity = 'total_5';

  final int control, diligence, strategy, durability, creativity;

  DtoStats({
    required this.control,
    required this.diligence,
    required this.strategy,
    required this.durability,
    required this.creativity,
  });

  factory DtoStats.fromMap(Map<String, dynamic> map) {
    return DtoStats(
      control: map[cControl] as int? ?? 0,
      diligence: map[cPerseverance] as int? ?? 0,
      strategy: map[cCourage] as int? ?? 0,
      durability: map[cDurability] as int? ?? 0,
      creativity: map[cCreativity] as int? ?? 0,
    );
  }
}
