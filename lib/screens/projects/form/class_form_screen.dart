import 'package:flutter/material.dart';
import 'package:chaos_control/models/class.dart';
import 'package:chaos_control/screens/projects/form/widgets/icon.dart';
import 'package:chaos_control/widgets/form/multiline_input.dart';
import 'package:chaos_control/widgets/form/singleline_input.dart';
import 'package:chaos_control/screens/projects/form/class_form_model.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class ClassFormScreen extends StatefulWidget {
  final Class? record;

  const ClassFormScreen({super.key, this.record});

  @override
  State<ClassFormScreen> createState() => _ClassFormScreenState();
}

class _ClassFormScreenState extends State<ClassFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late ClassFormModel model;
  late TextEditingController titleController;
  late TextEditingController descController;

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    model = context.read<ClassFormModel>();
    titleController = TextEditingController(text: widget.record?.title);
    descController = TextEditingController(text: widget.record?.description);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setClass(widget.record);
    });
  }

  @override
  Widget build(BuildContext context) {
    var save = model.save;
    var delete = model.delete;

    return EntityScreen(
      title: 'Класс',
      saveCallback: () => _save(save),
      deleteCallback: widget.record == null ? null : () => _delete(delete),
      formKey: _formKey,
      children: [
        // Иконка
        const ClassFormIcon(),
        const SizedBox(height: 12),

        // Название
        SinglelineInput(
          requiredErrorText: 'Введите название',
          header: 'Название',
          controller: titleController,
          setText: model.setTitle,
        ),
        const SizedBox(height: 12),

        // Описание
        CustomMultilineTextInput(
          header: 'Описание',
          controller: descController,
          setText: model.setDescription,
        ),
      ],
    );
  }

  Future _save(Future<bool> Function() save) async {
    if (!_formKey.currentState!.validate()) return;
    var result = await save();
    if (mounted) {
      Navigator.pop(context, result);
    }
  }

  void _close() {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future _delete(Future Function() delete) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await delete();
      _close();
    }
  }
}
