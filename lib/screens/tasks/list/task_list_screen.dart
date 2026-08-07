import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/widgets/bottom_menu.dart';
import 'package:provider/provider.dart';
import '../create/task_create_screen.dart';
import 'widgets/task_tile.dart';
import 'task_list_model.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {

  @override
  Widget build(BuildContext context) {
    
    var tasks = context.select<TaskListModel,List<Task>>((taskList) => taskList.tasks);
    var completeTask = context.select<TaskListModel,Function(Task,bool?)>((taskList) => taskList.completeTask);

    Future openFormCreate() async {
      var vm = context.read<TaskListModel>();
      bool added = await Navigator.push(context, MaterialPageRoute(builder: (_) => TaskCreateScreen()));
      if (added) {
        vm.load();
      }
    }

    return FutureBuilder(
      future: context.read<TaskListModel>().load(), // Ваша асинхронная функция
      builder: (BuildContext context, AsyncSnapshot snapshot) {
       
        return Scaffold(
          body:ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, i) => TaskTile(task: tasks[i], completeTask: completeTask,)
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: openFormCreate,
            tooltip: "Добавить задачу",
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BottomMenu(),
        );

      },
    );
        
    
     
  }
}