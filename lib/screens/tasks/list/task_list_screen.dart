import 'package:flutter/material.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/widgets/app_drawer.dart';
import 'package:life_game/widgets/bottom_menu.dart';
import 'package:life_game/widgets/custom_floating_action_button.dart';
import 'package:life_game/widgets/empty_list_screen.dart';
import 'package:provider/provider.dart';
import '../form/task_form_screen.dart';
import 'widgets/task_tile.dart';
import 'task_list_model.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    var tasks = context.select<TaskListModel,List<Task>>((taskList) => taskList.tasks);
    var completeTask = context.select<TaskListModel,Function(Task,bool?)>((taskList) => taskList.completeTask);

    Future openFormCreate() async {
      var model = context.read<TaskListModel>();
      bool added = await Navigator.push(context, MaterialPageRoute(builder: (_) => TaskFormScreen()));
      if (added) {
        model.load();
      }
    }

    return FutureBuilder(
      future: context.read<TaskListModel>().load(), // Ваша асинхронная функция
      builder: (BuildContext context, AsyncSnapshot snapshot) {
       
        return Scaffold(
          drawer: AppDrawer(),
          appBar: AppBar(
            title: const Text('Задачи'),
          ),
          body: tasks.isEmpty ? EmptyListScreen(
              title: "Задачи не найдены", 
              subtitle: "Создайте свою первую задачу или измените параметры поиска", 
              icon: Icons.task_alt
            )
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, i) => TaskTile(task: tasks[i], completeTask: completeTask,)
            ),
          floatingActionButton: CustomFloatingActionButton(openFormCreate: openFormCreate, tooltip: "Добавить задачу"),
          
          // FloatingActionButton(
          //   heroTag: UniqueKey(),
          //   onPressed: openFormCreate,
          //   tooltip: "Добавить задачу",
          //   child: const Icon(Icons.add),
          // ),
          bottomNavigationBar: BottomMenu(),
        );

      },
    );
        
    
     
  }
}