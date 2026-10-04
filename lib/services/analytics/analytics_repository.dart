import 'package:step_by_step/data/db.dart';
import 'package:step_by_step/models/enums/characteristics.dart';
import 'package:step_by_step/models/record.dart';
import 'package:step_by_step/services/analytics/dto_activity.dart';
import 'package:step_by_step/services/analytics/dto_stats.dart';
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
        COALESCE(SUM( ${CharValues.cP1} ), 0) AS ${DtoActivity.cP1},
        COALESCE(SUM( ${CharValues.cP2} ), 0) AS ${DtoActivity.cP2},
        COALESCE(SUM( ${CharValues.cP3} ), 0) AS ${DtoActivity.cP3},
        COALESCE(SUM( ${CharValues.cP4} ), 0) AS ${DtoActivity.cP4},
        COALESCE(SUM( ${CharValues.cP5} ), 0) AS ${DtoActivity.cP5},
        COALESCE(SUM( ${CharValues.cP6} ), 0) AS ${DtoActivity.cP6}
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
        COALESCE(SUM( ${CharValues.cP1} ), 0) AS ${DtoStats.cP1},
        COALESCE(SUM( ${CharValues.cP2} ), 0) AS ${DtoStats.cP2},
        COALESCE(SUM( ${CharValues.cP3} ), 0) AS ${DtoStats.cP3},
        COALESCE(SUM( ${CharValues.cP4} ), 0) AS ${DtoStats.cP4},
        COALESCE(SUM( ${CharValues.cP5} ), 0) AS ${DtoStats.cP5},
        COALESCE(SUM( ${CharValues.cP6} ), 0) AS ${DtoStats.cP6}
      FROM ${ChronicleRecord.tn}
    ''';

    final result = await db.rawQuery(query);
    return result.map((row) => DtoStats.fromMap(row)).firstOrNull;
  }
}
