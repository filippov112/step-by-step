import 'package:flutter/material.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/screens/classes/form/widgets/icon.dart';
import 'package:life_game/screens/classes/form/widgets/tags.dart';
import 'package:life_game/widgets/form/multiline_input.dart';
import 'package:life_game/widgets/form/singleline_input.dart';
import 'package:life_game/screens/classes/form/class_form_model.dart';
import 'package:life_game/screens/classes/form/widgets/skills.dart';
import 'package:life_game/widgets/dialogs/confirm_dialog.dart';
import 'package:life_game/widgets/screens/entity_screen.dart';
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
      deleteCallback:  widget.record == null ? () {} :  () => _delete(delete),
      formKey: _formKey,
      children: [
        // Иконка
        const ClassFormIcon(),
        const SizedBox(height: 12),

        // Название
        SinglelineInput(
          isRequired: true,
          requiredErrorText: 'Введите название',
          title: 'Название',
          controller: titleController,
        ),
        const SizedBox(height: 12),

        // Описание
        CustomMultilineTextInput(title: 'Описание', controller: descController),
        const SizedBox(height: 12),

        // Теги
        const ClassFormTags(),
        const SizedBox(height: 12),

        // Навыки
        const ClassFormSkills(),
      ],
    );
  }

  Future _save(Future<bool> Function() save) async {
    if (!_formKey.currentState!.validate()) return;

    model.setTitle(titleController.text);
    model.setDescription(descController.text);
    var result = await save();
    if (mounted) {
      Navigator.pop(context, result);
    }
  }

  Future _delete(Future Function() delete) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await delete();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }
}
