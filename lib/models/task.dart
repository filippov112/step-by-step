class TaskModel {
  final String title;
  final String? description;
  final DateTime dateTime;
  final int exp;

  TaskModel({required this.title, this.description, required this.dateTime, required this.exp});
}

