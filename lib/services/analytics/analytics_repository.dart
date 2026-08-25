import 'package:life_game/data/db.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/models/task_reward.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/class_skill.dart';
import 'package:life_game/services/analytics/dto_exp_time.dart';
import 'package:life_game/services/analytics/dto_tasks.dart';
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
      conditions.add('${TaskReward.cDate} >= ?');
      args.add(startDate);
    }

    if (endDate != null) {
      conditions.add('${TaskReward.cDate} <= ?');
      args.add(endDate);
    }

    if (skillId != null) {
      conditions.add('${TaskReward.cSkillId} = ?');
      args.add(skillId);
    }

    if (classId != null) {
      conditions.add('${TaskReward.cClassId} = ?');
      args.add(classId);
    }

    final whereClause = conditions.isNotEmpty
        ? 'WHERE ${conditions.join(' AND ')}'
        : '';

    final query =
        '''
      SELECT 
        ${TaskReward.cDate},
        COALESCE(SUM(${TaskReward.cTime}), 0) AS ${DtoExpTime.cTime},
        COALESCE(SUM(${TaskReward.cExperience}), 0) AS ${DtoExpTime.cExp}
      FROM ${TaskReward.tn}
      $whereClause
      GROUP BY ${TaskReward.cDate}
      ORDER BY ${TaskReward.cDate} DESC
    ''';

    final result = await db.rawQuery(query, args);
    return result.map((row) => DtoExpTime.fromMap(row)).toList();
  }

  /// Получить агрегированные данные по дням
  Future<List<DtoTasks>> getDailyTasks({int? startDate, int? endDate}) async {
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
        COUNT(${Task.cId}) AS ${DtoTasks.cTasks}
      FROM ${Task.tn}
      $whereClause
      GROUP BY ${Task.cDate}
      ORDER BY ${Task.cDate} DESC
    ''';

    final result = await db.rawQuery(query, args);
    return result.map((row) => DtoTasks.fromMap(row)).toList();
  }

  /// Получить прогресс по дням (кумулятивные суммы)
  Future<List<Map<String, dynamic>>> getCumulativeProgress({
    int? startDate,
    int? endDate,
  }) async {
    final conditions = <String>[];
    final args = <dynamic>[];

    if (startDate != null) {
      conditions.add('${TaskReward.cDate} >= ?');
      args.add(startDate);
    }

    if (endDate != null) {
      conditions.add('${TaskReward.cDate} <= ?');
      args.add(endDate);
    }

    final whereClause = conditions.isNotEmpty
        ? 'WHERE ${conditions.join(' AND ')}'
        : '';

    final query =
        '''
      WITH daily_totals AS (
        SELECT 
          ${TaskReward.cDate},
          SUM(${TaskReward.cExperience}) AS daily_exp,
          SUM(${TaskReward.cTime}) AS daily_time
        FROM ${TaskReward.tn}
        $whereClause
        GROUP BY ${TaskReward.cDate}
      )
      SELECT 
        ${TaskReward.cDate},
        daily_exp,
        daily_time,
        SUM(daily_exp) OVER (ORDER BY ${TaskReward.cDate}) AS cumulative_exp,
        SUM(daily_time) OVER (ORDER BY ${TaskReward.cDate}) AS cumulative_time
      FROM daily_totals
      ORDER BY ${TaskReward.cDate}
    ''';

    return await db.rawQuery(query, args);
  }

  // ================ АНАЛИТИКА ПО НАВЫКАМ ================

  /// Получить аналитику по навыкам
  Future<List<Map<String, dynamic>>> getSkillAnalytics({
    int? startDate,
    int? endDate,
    String? skillId,
  }) async {
    final conditions = <String>[];
    final args = <dynamic>[];

    if (startDate != null) {
      conditions.add('r.${TaskReward.cDate} >= ?');
      args.add(startDate);
    }

    if (endDate != null) {
      conditions.add('r.${TaskReward.cDate} <= ?');
      args.add(endDate);
    }

    if (skillId != null) {
      conditions.add('r.${TaskReward.cSkillId} = ?');
      args.add(skillId);
    }

    conditions.add('r.${TaskReward.cSkillId} IS NOT NULL');

    final whereClause = conditions.isNotEmpty
        ? 'WHERE ${conditions.join(' AND ')}'
        : '';

    final query =
        '''
      SELECT 
        s.${Skill.cId} AS skill_id,
        s.${Skill.cTitle} AS skill_title,
        COUNT(r.${TaskReward.cId}) AS task_count,
        COALESCE(SUM(r.${TaskReward.cExperience}), 0) AS total_experience,
        COALESCE(SUM(r.${TaskReward.cTime}), 0) AS total_time
      FROM ${TaskReward.tn} r
      INNER JOIN ${Skill.tn} s ON r.${TaskReward.cSkillId} = s.${Skill.cId}
      $whereClause
      GROUP BY s.${Skill.cId}
      ORDER BY total_experience DESC
    ''';

    return await db.rawQuery(query, args);
  }

  /// Получить ежедневную разбивку по навыкам
  Future<List<Map<String, dynamic>>> getDailySkillAnalytics({
    int? startDate,
    int? endDate,
    String? skillId,
  }) async {
    final conditions = <String>[];
    final args = <dynamic>[];

    if (startDate != null) {
      conditions.add('r.${TaskReward.cDate} >= ?');
      args.add(startDate);
    }

    if (endDate != null) {
      conditions.add('r.${TaskReward.cDate} <= ?');
      args.add(endDate);
    }

    if (skillId != null) {
      conditions.add('r.${TaskReward.cSkillId} = ?');
      args.add(skillId);
    }

    conditions.add('r.${TaskReward.cSkillId} IS NOT NULL');

    final whereClause = conditions.isNotEmpty
        ? 'WHERE ${conditions.join(' AND ')}'
        : '';

    final query =
        '''
      SELECT 
        r.${TaskReward.cDate},
        s.${Skill.cId} AS skill_id,
        s.${Skill.cTitle} AS skill_title,
        COUNT(r.${TaskReward.cId}) AS task_count,
        COALESCE(SUM(r.${TaskReward.cExperience}), 0) AS total_experience,
        COALESCE(SUM(r.${TaskReward.cTime}), 0) AS total_time
      FROM ${TaskReward.tn} r
      INNER JOIN ${Skill.tn} s ON r.${TaskReward.cSkillId} = s.${Skill.cId}
      $whereClause
      GROUP BY r.${TaskReward.cDate}, s.${Skill.cId}
      ORDER BY r.${TaskReward.cDate} DESC, total_experience DESC
    ''';

    return await db.rawQuery(query, args);
  }

  // ================ АНАЛИТИКА ПО КЛАССАМ ================

  /// Получить аналитику по классам с учетом распределения навыков
  Future<List<Map<String, dynamic>>> getClassAnalytics({
    int? startDate,
    int? endDate,
    String? classId,
  }) async {
    final conditions = <String>[];
    final args = <dynamic>[];

    // ВНИМАНИЕ: В CTE нельзя использовать параметры в WHERE,
    // поэтому добавляем условия в основной запрос

    final dateCondition = <String>[];
    final dateArgs = <dynamic>[];

    if (startDate != null) {
      dateCondition.add('date >= ?');
      dateArgs.add(startDate);
    }

    if (endDate != null) {
      dateCondition.add('date <= ?');
      dateArgs.add(endDate);
    }

    String classCondition = '';
    if (classId != null) {
      classCondition = 'AND class_id = ?';
      dateArgs.add(classId);
    }

    final dateWhere = dateCondition.isNotEmpty
        ? 'AND ${dateCondition.join(' AND ')}'
        : '';

    final query =
        '''
      WITH class_rewards_union AS (
        SELECT 
          c.${Class.cId} AS class_id,
          c.${Class.cTitle} AS class_title,
          r.${TaskReward.cId} AS reward_id,
          r.${TaskReward.cDate} AS date,
          r.${TaskReward.cExperience} AS experience,
          r.${TaskReward.cTime} AS time,
          'direct' AS source_type
        FROM ${Class.tn} c
        INNER JOIN ${TaskReward.tn} r ON c.${Class.cId} = r.${TaskReward.cClassId}
        WHERE r.${TaskReward.cClassId} IS NOT NULL
        
        UNION ALL
        
        SELECT 
          c.${Class.cId} AS class_id,
          c.${Class.cTitle} AS class_title,
          r.${TaskReward.cId} AS reward_id,
          r.${TaskReward.cDate} AS date,
          r.${TaskReward.cExperience} AS experience,
          r.${TaskReward.cTime} AS time,
          'from_skill' AS source_type
        FROM ${Class.tn} c
        INNER JOIN ${ClassSkill.tn} cs ON c.${Class.cId} = cs.${ClassSkill.cClassId}
        INNER JOIN ${TaskReward.tn} r ON cs.${ClassSkill.cSkillId} = r.${TaskReward.cSkillId}
        WHERE r.${TaskReward.cSkillId} IS NOT NULL
      )
      SELECT 
        class_id,
        class_title,
        COUNT(DISTINCT reward_id) AS task_count,
        COALESCE(SUM(experience), 0) AS total_experience,
        COALESCE(SUM(time), 0) AS total_time,
        COALESCE(SUM(CASE WHEN source_type = 'direct' THEN experience ELSE 0 END), 0) AS direct_experience,
        COALESCE(SUM(CASE WHEN source_type = 'from_skill' THEN experience ELSE 0 END), 0) AS from_skills_experience,
        COALESCE(SUM(CASE WHEN source_type = 'direct' THEN time ELSE 0 END), 0) AS direct_time,
        COALESCE(SUM(CASE WHEN source_type = 'from_skill' THEN time ELSE 0 END), 0) AS from_skills_time
      FROM class_rewards_union
      WHERE 1=1 $dateWhere $classCondition
      GROUP BY class_id
      ORDER BY total_experience DESC
    ''';

    return await db.rawQuery(query, dateArgs);
  }

  /// Получить ежедневную разбивку по классам
  Future<List<Map<String, dynamic>>> getDailyClassAnalytics({
    int? startDate,
    int? endDate,
    String? classId,
  }) async {
    // Добавляем условия в основной запрос после CTE
    final dateCondition = <String>[];
    final dateArgs = <dynamic>[];

    if (startDate != null) {
      dateCondition.add('date >= ?');
      dateArgs.add(startDate);
    }

    if (endDate != null) {
      dateCondition.add('date <= ?');
      dateArgs.add(endDate);
    }

    String classCondition = '';
    if (classId != null) {
      classCondition = 'AND class_id = ?';
      dateArgs.add(classId);
    }

    final dateWhere = dateCondition.isNotEmpty
        ? 'AND ${dateCondition.join(' AND ')}'
        : '';

    final query =
        '''
      WITH class_rewards_union AS (
        SELECT 
          c.${Class.cId} AS class_id,
          c.${Class.cTitle} AS class_title,
          r.${TaskReward.cDate} AS date,
          r.${TaskReward.cExperience} AS experience,
          r.${TaskReward.cTime} AS time,
          'direct' AS source_type
        FROM ${Class.tn} c
        INNER JOIN ${TaskReward.tn} r ON c.${Class.cId} = r.${TaskReward.cClassId}
        WHERE r.${TaskReward.cClassId} IS NOT NULL
        
        UNION ALL
        
        SELECT 
          c.${Class.cId} AS class_id,
          c.${Class.cTitle} AS class_title,
          r.${TaskReward.cDate} AS date,
          r.${TaskReward.cExperience} AS experience,
          r.${TaskReward.cTime} AS time,
          'from_skill' AS source_type
        FROM ${Class.tn} c
        INNER JOIN ${ClassSkill.tn} cs ON c.${Class.cId} = cs.${ClassSkill.cClassId}
        INNER JOIN ${TaskReward.tn} r ON cs.${ClassSkill.cSkillId} = r.${TaskReward.cSkillId}
        WHERE r.${TaskReward.cSkillId} IS NOT NULL
      )
      SELECT 
        class_id,
        class_title,
        date,
        COUNT(*) AS task_count,
        COALESCE(SUM(experience), 0) AS total_experience,
        COALESCE(SUM(time), 0) AS total_time,
        COALESCE(SUM(CASE WHEN source_type = 'direct' THEN experience ELSE 0 END), 0) AS direct_experience,
        COALESCE(SUM(CASE WHEN source_type = 'from_skill' THEN experience ELSE 0 END), 0) AS from_skills_experience,
        COALESCE(SUM(CASE WHEN source_type = 'direct' THEN time ELSE 0 END), 0) AS direct_time,
        COALESCE(SUM(CASE WHEN source_type = 'from_skill' THEN time ELSE 0 END), 0) AS from_skills_time
      FROM class_rewards_union
      WHERE 1=1 $dateWhere $classCondition
      GROUP BY class_id, date
      ORDER BY date DESC, total_experience DESC
    ''';

    return await db.rawQuery(query, dateArgs);
  }

  /// Получить детальную аналитику по конкретному классу
  Future<Map<String, dynamic>> getClassDetailAnalytics({
    required String classId,
    int? startDate,
    int? endDate,
  }) async {
    final args = <dynamic>[];
    final conditions = <String>[];

    if (startDate != null) {
      conditions.add('r.${TaskReward.cDate} >= ?');
      args.add(startDate);
    }

    if (endDate != null) {
      conditions.add('r.${TaskReward.cDate} <= ?');
      args.add(endDate);
    }

    final whereClause = conditions.isNotEmpty
        ? 'AND ${conditions.join(' AND ')}'
        : '';

    // Добавляем условия и для основного запроса, и для подзапросов
    final query =
        '''
      WITH class_total AS (
        SELECT 
          c.${Class.cId} AS class_id,
          c.${Class.cTitle} AS class_title,
          COALESCE(SUM(r.${TaskReward.cExperience}), 0) AS total_exp,
          COALESCE(SUM(r.${TaskReward.cTime}), 0) AS total_time,
          COUNT(DISTINCT r.${TaskReward.cId}) AS total_tasks
        FROM ${Class.tn} c
        LEFT JOIN ${TaskReward.tn} r ON (
          r.${TaskReward.cClassId} = c.${Class.cId} 
          OR r.${TaskReward.cSkillId} IN (
            SELECT cs.${ClassSkill.cSkillId} 
            FROM ${ClassSkill.tn} cs 
            WHERE cs.${ClassSkill.cClassId} = c.${Class.cId}
          )
        )
        WHERE c.${Class.cId} = ?
        $whereClause
      ),
      skill_contributions AS (
        SELECT 
          s.${Skill.cId} AS skill_id,
          s.${Skill.cTitle} AS skill_title,
          COALESCE(SUM(r.${TaskReward.cExperience}), 0) AS exp_from_skill,
          COALESCE(SUM(r.${TaskReward.cTime}), 0) AS time_from_skill,
          COUNT(DISTINCT r.${TaskReward.cId}) AS tasks_from_skill
        FROM ${Skill.tn} s
        INNER JOIN ${ClassSkill.tn} cs ON s.${Skill.cId} = cs.${ClassSkill.cSkillId}
        INNER JOIN ${TaskReward.tn} r ON s.${Skill.cId} = r.${TaskReward.cSkillId}
        WHERE cs.${ClassSkill.cClassId} = ?
        $whereClause
        GROUP BY s.${Skill.cId}
        ORDER BY exp_from_skill DESC
      ),
      direct_class AS (
        SELECT 
          COALESCE(SUM(r.${TaskReward.cExperience}), 0) AS direct_exp,
          COALESCE(SUM(r.${TaskReward.cTime}), 0) AS direct_time,
          COUNT(DISTINCT r.${TaskReward.cId}) AS direct_tasks
        FROM ${TaskReward.tn} r
        WHERE r.${TaskReward.cClassId} = ?
        $whereClause
      )
      SELECT 
        ct.class_id,
        ct.class_title,
        ct.total_exp,
        ct.total_time,
        ct.total_tasks,
        dc.direct_exp,
        dc.direct_time,
        dc.direct_tasks,
        (
          SELECT json_group_array(
            json_object(
              'skill_id', skill_id,
              'skill_title', skill_title,
              'experience', exp_from_skill,
              'time', time_from_skill,
              'tasks', tasks_from_skill
            )
          ) 
          FROM skill_contributions
        ) AS skill_contributions
      FROM class_total ct
      CROSS JOIN direct_class dc
    ''';
    var finalArgs = <dynamic>[
      classId,
      ...args,
      classId,
      ...args,
      classId,
      ...args,
    ];
    final result = await db.rawQuery(query, finalArgs);
    return result.isNotEmpty ? result.first : {};
  }

  // ================ СВОДНЫЕ ЗАПРОСЫ ================

  /// Получить сводную статистику за период
  Future<Map<String, int>> getSummaryStats({
    int? startDate,
    int? endDate,
    String? skillId,
    String? classId,
  }) async {
    final conditions = <String>[];
    final args = <dynamic>[];

    if (startDate != null) {
      conditions.add('${TaskReward.cDate} >= ?');
      args.add(startDate);
    }

    if (endDate != null) {
      conditions.add('${TaskReward.cDate} <= ?');
      args.add(endDate);
    }

    if (skillId != null) {
      conditions.add('${TaskReward.cSkillId} = ?');
      args.add(skillId);
    }

    if (classId != null) {
      conditions.add('${TaskReward.cClassId} = ?');
      args.add(classId);
    }

    final whereClause = conditions.isNotEmpty
        ? 'WHERE ${conditions.join(' AND ')}'
        : '';

    final query =
        '''
      SELECT 
        COALESCE(SUM(${TaskReward.cTime}), 0) AS total_time,
        COALESCE(SUM(${TaskReward.cExperience}), 0) AS total_experience,
        COALESCE(COUNT(${TaskReward.cId}), 0) AS task_count,
        COUNT(CASE WHEN ${TaskReward.cSkillId} IS NOT NULL THEN 1 END) AS skill_tasks,
        COUNT(CASE WHEN ${TaskReward.cClassId} IS NOT NULL THEN 1 END) AS class_tasks
      FROM ${TaskReward.tn}
      $whereClause
    ''';

    final result = await db.rawQuery(query, args);
    if (result.isEmpty) {
      return {
        'total_time': 0,
        'total_experience': 0,
        'task_count': 0,
        'skill_tasks': 0,
        'class_tasks': 0,
      };
    }

    final row = result.first;
    return {
      'total_time': (row['total_time'] as int?) ?? 0,
      'total_experience': (row['total_experience'] as int?) ?? 0,
      'task_count': (row['task_count'] as int?) ?? 0,
      'skill_tasks': (row['skill_tasks'] as int?) ?? 0,
      'class_tasks': (row['class_tasks'] as int?) ?? 0,
    };
  }

  /// Получить распределение наград по типам
  Future<Map<String, dynamic>> getRewardDistribution({
    int? startDate,
    int? endDate,
  }) async {
    final conditions = <String>[];
    final args = <dynamic>[];

    if (startDate != null) {
      conditions.add('${TaskReward.cDate} >= ?');
      args.add(startDate);
    }

    if (endDate != null) {
      conditions.add('${TaskReward.cDate} <= ?');
      args.add(endDate);
    }

    final whereClause = conditions.isNotEmpty
        ? 'WHERE ${conditions.join(' AND ')}'
        : '';

    final query =
        '''
      SELECT 
        COUNT(*) AS total_count,
        COUNT(CASE WHEN ${TaskReward.cSkillId} IS NOT NULL AND ${TaskReward.cClassId} IS NULL THEN 1 END) AS skill_only_count,
        COUNT(CASE WHEN ${TaskReward.cSkillId} IS NULL AND ${TaskReward.cClassId} IS NOT NULL THEN 1 END) AS class_only_count,
        COUNT(CASE WHEN ${TaskReward.cSkillId} IS NOT NULL AND ${TaskReward.cClassId} IS NOT NULL THEN 1 END) AS both_count,
        COALESCE(SUM(CASE WHEN ${TaskReward.cSkillId} IS NOT NULL THEN ${TaskReward.cExperience} ELSE 0 END), 0) AS skill_exp,
        COALESCE(SUM(CASE WHEN ${TaskReward.cClassId} IS NOT NULL THEN ${TaskReward.cExperience} ELSE 0 END), 0) AS class_exp
      FROM ${TaskReward.tn}
      $whereClause
    ''';

    final result = await db.rawQuery(query, args);
    return result.isNotEmpty ? result.first : {};
  }
}
