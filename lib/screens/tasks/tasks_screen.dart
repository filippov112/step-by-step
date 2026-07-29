import 'package:flutter/material.dart';
import 'package:life_game/screens/tasks/widgets/task_tile.dart';
import 'package:life_game/services/tasks_controller.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  // Тут входящие параметры виджета - final string title; Объявление полей всегда с final.

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // ViewModel - команды, свойства

  TasksController controller = TasksController();

  @override
  void initState() {
    super.initState();
    controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListenableBuilder(
        listenable: controller.tasks,
        builder: (context, child) => ListView.builder(
          itemCount: controller.tasks.value.length,
          itemBuilder: (context, i) => TaskTile(task: controller.tasks.value[i],)
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addTask,
        tooltip: "Добавить задачу",
        child: const Icon(Icons.add),
      ),
    );
  }
}