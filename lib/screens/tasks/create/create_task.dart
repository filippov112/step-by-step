import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_game/models/task.dart';
import 'package:life_game/services/tasks_controller.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  // ViewModel - команды, свойства
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool _saving = false;

  String _title = "";
  String? _description;
  DateTime _selectedDateTime = DateTime.now();
  int _exp = 0;

  TasksController? _controller;
  _CreateTaskState() {
    _controller = TasksController();
  }

  Future<DateTime?> _selectDate() async {
    // 1. Выбор даты
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return _selectedDateTime;

    // 2. Выбор времени
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null) {
      setState(() {
        _selectedDateTime = DateTime(date.year, date.month, date.day);
      });
      return _selectedDateTime;
    }

    // 3. Объединение
    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
    return _selectedDateTime;
  }
  
  void _submit() {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      setState(() {
        form.save();
        var record = TaskModel(title: _title, description: _description, dateTime: _selectedDateTime, exp: _exp);   
        try {
          _controller!.addTask(record);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Сохранено')),
          );
          Navigator.pop(context);
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка: $e'),
              backgroundColor: Colors.red,
            ),
          );
        } finally {
          if (mounted) setState(() => _saving = false);
        }
      });
    }
  }

  void _cancel() {
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    var savebtn = ElevatedButton (
      onPressed: _saving ? null : _submit, // null → кнопка неактивна
      child: _saving 
        ? const SizedBox(
            width: 20, 
            height: 20, 
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Text('Добавить задачу'),
    );

    var form = Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  onSaved: (val) => _title = val ?? "",
                  decoration: InputDecoration(labelText: "Название"),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  onSaved: (val) => _description = val,
                  decoration: InputDecoration(labelText: "Описание"),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: InputDecoration(labelText: 'Дедлайн'),
                    child: Text(DateFormat("dd.MM.yyyy HH:mm").format(_selectedDateTime)),
                  ),
                )
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(),
                  onSaved: (val) => _exp = int.tryParse(val ?? "0") ?? 0,
                  decoration: InputDecoration(labelText: "Опыт"),
                ),
              ),

            ],
          ),
        );


    return Scaffold(
      appBar: AppBar(
        title: Text("Новая задача"), 
        leading: IconButton(onPressed: _cancel, icon: Icon(Icons.arrow_back)),
        backgroundColor: Color.fromARGB(255, 0, 114, 28),
      ),
      body: Column(children: [
        form,
        savebtn
      ],)
    );
  }
}