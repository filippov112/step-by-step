import 'package:life_game/models/task.dart';
import 'package:life_game/tools/datetime.dart';

/// Модель для агрегированных данных по дате
class DtoTasks {
  static const cTasks = 'total_tasks';

  final int date;
  final int countTasks;

  DateTime? get dateTime => DateTool.joinDateTime(date: date);
  
  DtoTasks({required this.date, required this.countTasks});

  factory DtoTasks.fromMap(Map<String, dynamic> map) {
    return DtoTasks(
      date: map[Task.cDate] as int,
      countTasks: map[cTasks] as int? ?? 0,
    );
  }
}
