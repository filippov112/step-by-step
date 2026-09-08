import 'package:chaos_control/data/db.dart';
import 'package:chaos_control/models/task.dart';
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
      conditions.add('${Task.cDate} >= ?');
      args.add(startDate);
    }

    if (endDate != null) {
      conditions.add('${Task.cDate} <= ?');
      args.add(endDate);
    }

    final whereClause = conditions.isNotEmpty
        ? 'WHERE ${conditions.join(' AND ')}'
        : '';

    final query =
        '''
      SELECT 
        ${Task.cDate},
        COALESCE(SUM(${Task.cControl} + ${Task.cPerseverance} + ${Task.cCourage} + ${Task.cDurability} + ${Task.cCreativity}), 0) AS ${DtoActivity.cExp}
      FROM ${Task.tn}
      $whereClause
      GROUP BY ${Task.cDate}
      ORDER BY ${Task.cDate} DESC
    ''';

    final result = await db.rawQuery(query, args);
    return result.map((row) => DtoActivity.fromMap(row)).toList();
  }


}
