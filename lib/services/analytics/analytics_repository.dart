import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/barrier.dart';
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
        COALESCE(SUM(${Barrier.cControl} + ${Barrier.cPerseverance} + ${Barrier.cCourage} + ${Barrier.cDurability} + ${Barrier.cCreativity}), 0) AS ${DtoActivity.cExp}
      FROM ${Barrier.tn}
      $whereClause
      GROUP BY ${Barrier.cDate}
      ORDER BY ${Barrier.cDate} DESC
    ''';

    final result = await db.rawQuery(query, args);
    return result.map((row) => DtoActivity.fromMap(row)).toList();
  }


}
