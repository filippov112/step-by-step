import 'package:flutter/material.dart';
import 'package:chaos_control/models/purport.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:chaos_control/screens/purports/edit/purport_edit_model.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class PurportEditScreen extends StatefulWidget {
  final Purport purport;

  const PurportEditScreen({super.key, required this.purport});

  @override
  State<PurportEditScreen> createState() => _PurportEditScreenState();
}

class _PurportEditScreenState extends State<PurportEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late PurportEditModel model;

  @override
  void initState() {
    super.initState();
    model = context.read<PurportEditModel>();
    model.init(widget.purport);
  }

  @override
  Widget build(BuildContext context) {
    var save = model.save;
    var delete = model.delete;

    return EntityScreen(
      title: 'Проект',
      saveCallback: () => _save(save),
      deleteCallback: () => _delete(delete),
      formKey: _formKey,
      children: [

        // Название
        CustomTextInput(
          requiredErrorText: 'Введите название',
          header: 'Название',
          initialValue: model.title,
          icon: Icons.title,
          setText: model.setTitle,
        ),
        const SizedBox(height: 12),

        // Группа
        CustomTextInput(
          header: 'Группа',
          initialValue: model.group,
          icon: Icons.folder,
          setText: model.setGroup,
          lines:1,
          customValidator: model.groupValidator,
        ),
        const SizedBox(height: 12),

        // Описание
        CustomTextInput(
          header: 'Смысл',
          initialValue: model.desc,
          icon: Icons.mode_standby,
          setText: model.setTarget,
          lines:4
        ),
        const SizedBox(height: 12),

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
