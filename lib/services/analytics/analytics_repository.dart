import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/barrier.dart';
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
      conditions.add('${Barrier.cDate} >= ?');
      args.add(startDate);
    }

    if (endDate != null) {
      conditions.add('${Barrier.cDate} <= ?');
      args.add(endDate);
    }

    final whereClause = conditions.isNotEmpty
        ? 'WHERE ${conditions.join(' AND ')}'
        : '';

    final query =
        '''
      SELECT 
        ${Barrier.cDate},
        COALESCE(SUM( ${Barrier.cControl} ), 0) AS ${DtoActivity.cControl},
        COALESCE(SUM( ${Barrier.cPerseverance} ), 0) AS ${DtoActivity.cPerseverance},
        COALESCE(SUM( ${Barrier.cCourage} ), 0) AS ${DtoActivity.cCourage},
        COALESCE(SUM( ${Barrier.cDurability} ), 0) AS ${DtoActivity.cDurability},
        COALESCE(SUM( ${Barrier.cCreativity} ), 0) AS ${DtoActivity.cCreativity}
      FROM ${Barrier.tn}
      $whereClause
      GROUP BY ${Barrier.cDate}
      ORDER BY ${Barrier.cDate} DESC
    ''';

    final result = await db.rawQuery(query, args);
    return result.map((row) => DtoActivity.fromMap(row)).toList();
  }

  // Пересчитать суммы характеристик
  Future<DtoStats?> getChars() async {
    final query =
        '''
      SELECT
        COALESCE(SUM( ${Barrier.cControl} ), 0) AS ${DtoStats.cControl},
        COALESCE(SUM( ${Barrier.cPerseverance} ), 0) AS ${DtoStats.cPerseverance},
        COALESCE(SUM( ${Barrier.cCourage} ), 0) AS ${DtoStats.cCourage},
        COALESCE(SUM( ${Barrier.cDurability} ), 0) AS ${DtoStats.cDurability},
        COALESCE(SUM( ${Barrier.cCreativity} ), 0) AS ${DtoStats.cCreativity}
      FROM ${Barrier.tn}
    ''';

    final result = await db.rawQuery(query);
    return result.map((row) => DtoStats.fromMap(row)).firstOrNull;
  }
}
