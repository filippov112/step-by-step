import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/wall_reward.dart';
import 'package:chaos_control/services/analytics/dto_exp_time.dart';
import 'package:sqflite/sqflite.dart';

/// Репозиторий для аналитических запросов
class AnalyticsRepository {
  Database get db => DB.db!;

  // ================ БАЗОВЫЕ ЗАПРОСЫ ================

  /// Получить агрегированные данные по дням
  Future<List<DtoExpTime>> getDailyExpTime({
    int? startDate,
    int? endDate,
    String? skillId,
    String? classId,
  }) async {
    final conditions = <String>[];
    final args = <dynamic>[];

    if (startDate != null) {
      conditions.add('${Reward.cDate} >= ?');
      args.add(startDate);
    }

    if (endDate != null) {
      conditions.add('${Reward.cDate} <= ?');
      args.add(endDate);
    }

    final whereClause = conditions.isNotEmpty
        ? 'WHERE ${conditions.join(' AND ')}'
        : '';

    final query =
        '''
      SELECT 
        ${Reward.cDate},
        COALESCE(SUM(${Reward.cEfforts}), 0) AS ${DtoExpTime.cExp}
      FROM ${Reward.tn}
      $whereClause
      GROUP BY ${Reward.cDate}
      ORDER BY ${Reward.cDate} DESC
    ''';

    final result = await db.rawQuery(query, args);
    return result.map((row) => DtoExpTime.fromMap(row)).toList();
  }


}
