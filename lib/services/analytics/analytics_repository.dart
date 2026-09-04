import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/attempt.dart';
import 'package:chaos_control/services/analytics/dto_activity.dart';
import 'package:sqflite/sqflite.dart';

/// Репозиторий для аналитических запросов
class AnalyticsRepository {
  Database get db => DB.db!;

  // ================ БАЗОВЫЕ ЗАПРОСЫ ================

  /// Получить агрегированные данные по дням
  Future<List<DtoActivity>> getDailyExpTime({
    int? startDate,
    int? endDate,
    String? skillId,
    String? classId,
  }) async {
    final conditions = <String>[];
    final args = <dynamic>[];

    if (startDate != null) {
      conditions.add('${Attempt.cDate} >= ?');
      args.add(startDate);
    }

    if (endDate != null) {
      conditions.add('${Attempt.cDate} <= ?');
      args.add(endDate);
    }

    final whereClause = conditions.isNotEmpty
        ? 'WHERE ${conditions.join(' AND ')}'
        : '';

    final query =
        '''
      SELECT 
        ${Attempt.cDate},
        COALESCE(SUM(${Attempt.cEfforts}), 0) AS ${DtoActivity.cExp}
      FROM ${Attempt.tn}
      $whereClause
      GROUP BY ${Attempt.cDate}
      ORDER BY ${Attempt.cDate} DESC
    ''';

    final result = await db.rawQuery(query, args);
    return result.map((row) => DtoActivity.fromMap(row)).toList();
  }


}
