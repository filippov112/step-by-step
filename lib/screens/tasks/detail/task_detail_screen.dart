// lib/screens/tasks/task_details_screen.dart
import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/screens/tasks/detail/task_detail_model.dart';
import 'package:life_game/screens/tasks/detail/widgets/description.dart';
import 'package:life_game/screens/tasks/detail/widgets/header.dart';
import 'package:life_game/screens/tasks/detail/widgets/subtasks.dart';
import 'package:life_game/screens/tasks/form/task_form_screen.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
import 'package:life_game/widgets/common/confirm_dialog.dart';
import 'package:life_game/widgets/common/entity_appbar.dart';
import 'package:provider/provider.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {

  late TaskDetailModel model;
  var expController = ExpansibleController();
  
  @override
  void initState() {
    super.initState();
    model = context.read<TaskDetailModel>();
    model.setLoading(true);
    model.setTask(widget.task);
  }

  @override
  void dispose() {
    expController.dispose();
    super.dispose();
  }
  
  Future<void> _loadSubtasks() async {
    model.setLoading(true);
    await model.loadSubtasks();
  }

  @override
  Widget build(BuildContext context) {

    var childrenCount = context.select<TaskDetailModel,Map<String,int>>((model) => model.childTasksCount);
    var childrenDoneCount = context.select<TaskDetailModel,Map<String,int>>((model) => model.childDoneTasksCount);
    var isLoading = context.select<TaskDetailModel,bool>((model) => model.isLoading);
    var subtasks = context.select<TaskDetailModel,List<Task>>((model) => model.subtasks);
    var task = context.select<TaskDetailModel,Task>((model) => model.task);

    var description = context.select<TaskDetailModel,String>((model) => model.task.description);
    var title = context.select<TaskDetailModel,String>((model) => model.task.title);
    var datetime = context.select<TaskDetailModel,DateTime?>((model) => model.task.datetime);
    var priority = context.select<TaskDetailModel,TaskPriority>((model) => model.task.priority);
    var difficulty = context.select<TaskDetailModel,TaskDifficulty>((model) => model.task.difficulty);
    var allTags = context.select<TaskDetailModel,List<Tag>>((model) => model.allTags);
    var done = context.select<TaskDetailModel,bool>((model) => model.task.done);
    var isOverdue = context.select<TaskDetailModel,bool>((model) => model.task.isOverdue);

    var setDone = model.setDone;
    var deleteThisTask = model.deleteThisTask;

    return Scaffold(
      appBar: buildAppBar(
        'Задача', 
        editCallback: () => _editTask(model, task), 
        deleteCallback: () => _deleteThisTask(deleteThisTask)
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Шапка
          Padding(
            padding: const EdgeInsets.all(16),
            child: buildHeader(title: title),
          ),
          // Шапка списка подзадач
          buildSubtaskSection(
            context,
            expController: expController,
            onExpansionChanged: () => setState(() {}),
            subtasks: subtasks, 
          ),
          
          Divider(),

          Expanded(
            child: expController.isExpanded ? 
            
            buildSubtaskBlock(
              context, 
              model: model, 
              expController: expController, 
              onExpansionChanged: () => setState(() {}), 
              subtasks: subtasks, 
              isLoading: isLoading, 
              childrenCount: childrenCount, 
              childrenDoneCount: childrenDoneCount
            ) :
            
            buildTaskInfo(
              context,
              description: description, 
              done: done, 
              datetime: datetime, 
              isOverdue: isOverdue, 
              priority: priority, 
              difficulty: difficulty, 
              allTags: allTags
            ),
          ),
        ],
      ),
      floatingActionButton: expController.isExpanded ? FloatingActionButton(
        onPressed: () => _createSubtask(task),
        tooltip: 'Добавить подзадачу',
        child: const Icon(Icons.add),
      ) : 
      FloatingActionButton(
        onPressed: () => setDone(),
        tooltip: 'Добавить подзадачу',
        backgroundColor: Theme.of(context).focusColor,
        child: Icon(done ? Icons.task_alt_outlined : Icons.circle_outlined, color: Theme.of(context).primaryColor),
      )
      ,
    );
  }

  Future<void> _createSubtask(Task currentTask) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(parent:currentTask),
      ),
    );
    
    if (result == true) {
      await _loadSubtasks();
    }
  }

  void _editTask(TaskDetailModel model, Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskFormScreen(task: task),
      ),
    ).then((_) async {
      if (context.mounted) {
        var checkExistTask = await model.checkExist();
        if (!checkExistTask && context.mounted) {
          Navigator.pop(context);
          return;
        }
        model.loadSubtasks();
      }
    });
  }

  Future _deleteThisTask(Future Function() deleteTask) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await deleteTask();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}