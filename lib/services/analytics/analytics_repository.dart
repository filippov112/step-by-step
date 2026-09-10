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
  }) async {
    final conditions = <String>[];
    final args = <dynamic>[];

    if (startDate != null) {
      conditions.add('${Record.cDate} >= ?');
      args.add(startDate);
    }

    if (endDate != null) {
      conditions.add('${Record.cDate} <= ?');
      args.add(endDate);
    }

    final whereClause = conditions.isNotEmpty
        ? 'WHERE ${conditions.join(' AND ')}'
        : '';

    final query =
        '''
      SELECT 
        ${Record.cDate},
        COALESCE(SUM( ${Record.cControl} ), 0) AS ${DtoActivity.cControl},
        COALESCE(SUM( ${Record.cPerseverance} ), 0) AS ${DtoActivity.cPerseverance},
        COALESCE(SUM( ${Record.cCourage} ), 0) AS ${DtoActivity.cCourage},
        COALESCE(SUM( ${Record.cDurability} ), 0) AS ${DtoActivity.cDurability},
        COALESCE(SUM( ${Record.cCreativity} ), 0) AS ${DtoActivity.cCreativity}
      FROM ${Record.tn}
      $whereClause
      GROUP BY ${Record.cDate}
      ORDER BY ${Record.cDate} DESC
    ''';

    final result = await db.rawQuery(query, args);
    return result.map((row) => DtoActivity.fromMap(row)).toList();
  }

  // Пересчитать суммы характеристик
  Future<DtoStats?> getChars() async {
    final query =
        '''
      SELECT
        COALESCE(SUM( ${Record.cControl} ), 0) AS ${DtoStats.cControl},
        COALESCE(SUM( ${Record.cPerseverance} ), 0) AS ${DtoStats.cPerseverance},
        COALESCE(SUM( ${Record.cCourage} ), 0) AS ${DtoStats.cCourage},
        COALESCE(SUM( ${Record.cDurability} ), 0) AS ${DtoStats.cDurability},
        COALESCE(SUM( ${Record.cCreativity} ), 0) AS ${DtoStats.cCreativity}
      FROM ${Record.tn}
    ''';

    final result = await db.rawQuery(query);
    return result.map((row) => DtoStats.fromMap(row)).firstOrNull;
  }
}
