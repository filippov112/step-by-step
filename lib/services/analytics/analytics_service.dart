import 'dart:convert';

import 'package:life_game/services/analytics/analytics_repository.dart';

class AnalyticsService {
  final AnalyticsRepository _repo = AnalyticsRepository();

  Future<void> showClassAnalytics() async {
    // Аналитика по всем классам с учетом распределения навыков
    final classStats = await _repo.getClassAnalytics();

    for (var stat in classStats) {
      print('Класс: ${stat['class_title']}');
      print('  Всего опыта: ${stat['total_experience']}');
      print('  От класса: ${stat['direct_experience']}');
      print('  От навыков: ${stat['from_skills_experience']}');
      print('  Задач: ${stat['task_count']}');
      print('');
    }

    // Детальная аналитика по конкретному классу
    final detail = await _repo.getClassDetailAnalytics(
      classId: 'class_1',
      startDate: 19723,
      endDate: 19723 + 30,
    );

    print('Детали класса: ${detail['class_title']}');
    print('Общий опыт: ${detail['total_exp']}');
    print('От класса: ${detail['direct_exp']}');
    print('От навыков: ${detail['from_skills_exp']}');

    // Вклад каждого навыка
    final skills = jsonDecode(detail['skill_contributions']);
    for (var skill in skills) {
      print('  Навык ${skill['skill_title']}: +${skill['experience']} опыта');
    }
  }
}
