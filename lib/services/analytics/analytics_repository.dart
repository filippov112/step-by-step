import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/record.dart';
import 'package:chaos_control/services/analytics/dto_activity.dart';
import 'package:chaos_control/services/analytics/dto_stats.dart';
import 'package:sqflite/sqflite.dart';

/// Репозиторий для аналитических запросов
class AnalyticsRepository {
  Database get db => DB.db!;

  // ================ БАЗОВЫЕ ЗАПРОСЫ ================

  /// Получить агрегированные данные по дням
  Future<List<DtoActivity>> getDailyExpTime({
    int? startDate,
    int? endDate,
    String? pattern,
  }) async {
    final conditions = <String>[];
    final args = <dynamic>[];

    if (startDate != null) {
      conditions.add('${ChronicleRecord.cDate} >= ?');
      args.add(startDate);
    }

    if (endDate != null) {
      conditions.add('${ChronicleRecord.cDate} <= ?');
      args.add(endDate);
    }

    if (pattern != null && pattern.isNotEmpty) {
      conditions.add('${ChronicleRecord.cGroup} LIKE ?');
      args.add('$pattern%');
    }

    final whereClause = conditions.isNotEmpty
        ? 'WHERE ${conditions.join(' AND ')}'
        : '';

    final query =
        '''
      SELECT 
        ${ChronicleRecord.cDate},
        COALESCE(SUM( ${ChronicleRecord.cHappiness} ), 0) AS ${DtoActivity.cHappiness},
        COALESCE(SUM( ${ChronicleRecord.cDiligence} ), 0) AS ${DtoActivity.cDiligence},
        COALESCE(SUM( ${ChronicleRecord.cIntellection} ), 0) AS ${DtoActivity.cIntellection},
        COALESCE(SUM( ${ChronicleRecord.cDurability} ), 0) AS ${DtoActivity.cDurability},
        COALESCE(SUM( ${ChronicleRecord.cPotencial} ), 0) AS ${DtoActivity.cPotencial}
      FROM ${ChronicleRecord.tn}
      $whereClause
      GROUP BY ${ChronicleRecord.cDate}
      ORDER BY ${ChronicleRecord.cDate} DESC
    ''';

    final result = await db.rawQuery(query, args);
    return result.map((row) => DtoActivity.fromMap(row)).toList();
  }

  // Пересчитать суммы характеристик
  Future<DtoStats?> getChars() async {
    final query =
        '''
      SELECT
        COALESCE(SUM( ${ChronicleRecord.cHappiness} ), 0) AS ${DtoStats.cHappiness},
        COALESCE(SUM( ${ChronicleRecord.cDiligence} ), 0) AS ${DtoStats.cDiligence},
        COALESCE(SUM( ${ChronicleRecord.cIntellection} ), 0) AS ${DtoStats.cIntellection},
        COALESCE(SUM( ${ChronicleRecord.cDurability} ), 0) AS ${DtoStats.cDurability},
        COALESCE(SUM( ${ChronicleRecord.cPotencial} ), 0) AS ${DtoStats.cPotencial}
      FROM ${ChronicleRecord.tn}
    ''';

    final result = await db.rawQuery(query);
    return result.map((row) => DtoStats.fromMap(row)).firstOrNull;
  }
}
