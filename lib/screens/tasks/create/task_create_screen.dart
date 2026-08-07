import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_game/widgets/select_date_time.dart';
import 'package:provider/provider.dart';
import 'task_create_model.dart';

class TaskCreateScreen extends StatefulWidget {
  const TaskCreateScreen({super.key});
  @override
  State<TaskCreateScreen> createState() => _TaskCreateScreenState();
}

class _TaskCreateScreenState extends State<TaskCreateScreen> {

  Future _selectDateTime(BuildContext context) async {
    var model = context.read<TaskCreateModel>();
    var selectedDateTime = await selectDateTime(context, model.newTask.datetime ?? DateTime.now());
    if (selectedDateTime != null) {
      model.selectDateTime(selectedDateTime);
    }
  }

  Future _saveTask(BuildContext context) async {
    var error = await context.read<TaskCreateModel>().saveTask();
    if (error != null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $error'),
        ));
      }
      return;
    }
    if (context.mounted) Navigator.pop(context, true);
  }


  @override
  Widget build(BuildContext context) {

    var formKey = context.select<TaskCreateModel,GlobalKey<FormState>>((model) => model.formKey);
    var dateTime = context.select<TaskCreateModel,DateTime?>((model) => model.newTask.datetime);

    var savebtn = ElevatedButton (
      onPressed: () => _saveTask(context),
      child: const Text('Добавить задачу'),
    );

    var titleWidget = TextFormField(
      onSaved: (val) => context.read<TaskCreateModel>().selectTitle(val ?? ""),
      decoration: InputDecoration(labelText: "Название"),
    );

    var descWidget = TextFormField(
      onSaved: (val) => context.read<TaskCreateModel>().selectDesc(val ?? ""),
      decoration: InputDecoration(labelText: "Описание"),
    );

    var dateTimeWidget = InkWell(
      onTap: () => _selectDateTime(context),
      child: InputDecorator(
        decoration: InputDecoration(labelText: 'Дедлайн'),
        child: dateTime == null ? Text('') : Text(DateFormat("dd.MM.yyyy HH:mm").format(dateTime)),
      ),
    );

    var form = Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: titleWidget,
          ),
          
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: descWidget,
          ),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: dateTimeWidget,
          ),

        ],
      ),
    );


    return Scaffold(
      appBar: AppBar(
        title: Text("Новая задача"), 
        leading: IconButton(
          onPressed: () => Navigator.pop(context, false), 
          icon: Icon(Icons.arrow_back)
        ),
      ),
      body: Column(children: [
        form,
        savebtn
      ],)
    );
  }
}