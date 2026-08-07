import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/screens/tasks/create/create_task_screen.dart';
import 'package:life_game/screens/tasks/list/widgets/task_tile.dart';
import 'package:life_game/screens/tasks/list/task_list_vm.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  // Тут входящие параметры виджета - final string title; Объявление полей всегда с final.

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // ViewModel - команды, свойства

  TaskListVM vm = TaskListVM();

  @override
  void initState() {
    super.initState();
    vm.load();
  }

  Future _openFormCreate() async {
    bool added = await Navigator.push(context, MaterialPageRoute(builder: (_) => CreateTaskScreen()));
    if (added) {
      vm.load();
    }
  }

  Future _completeTask(Task task, bool? val) async {
    task.done = val ?? false;
    await vm.update(task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListenableBuilder(
        listenable: vm.tasks,
        builder: (context, child) => ListView.builder(
          itemCount: vm.tasks.value.length,
          itemBuilder: (context, i) => TaskTile(task: vm.tasks.value[i], completeTask: _completeTask,)
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFormCreate,
        tooltip: "Добавить задачу",
        child: const Icon(Icons.add),
      ),
    );
  }
}