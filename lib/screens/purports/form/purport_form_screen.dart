import 'package:flutter/material.dart';
import 'package:chaos_control/models/purport.dart';
import 'package:chaos_control/screens/purports/form/purport_form_model.dart';
import 'package:chaos_control/screens/purports/form/widgets/date.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:chaos_control/screens/purports/form/widgets/icon.dart';
import 'package:chaos_control/screens/purports/form/widgets/rarity.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class PurportFormScreen extends StatefulWidget {
  final Purport? purport;

  const PurportFormScreen({super.key, this.purport});

  @override
  State<PurportFormScreen> createState() => _PurportFormScreenState();
}

class _PurportFormScreenState extends State<PurportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late PurportFormModel model;
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
    model = context.read<PurportFormModel>();
    titleController = TextEditingController();
    descController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setPurport(widget.purport);
      titleController.text = widget.purport?.title ?? '';
      descController.text = widget.purport?.description ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final savePurport = model.savePurport;
    final deletePurport = model.deletePurport;

    return EntityScreen(
      title: 'Смысл',
      formKey: _formKey,
      saveCallback: () => _savePurport(savePurport),
      deleteCallback: widget.purport == null
          ? null
          : () => _delete(deletePurport),
      children: [
        // Иконка
        const PurportFormIcon(),
        const SizedBox(height: 12),

        // Название
        CustomTextInput(
          requiredErrorText: 'Введите название',
          header: 'Название',
          icon: Icons.title,
          controller: titleController,
          setText: model.setTitle,
        ),
        const SizedBox(height: 12),

        // Описание
        CustomTextInput(
          header: 'Описание',
          controller: descController,
          icon: Icons.description,
          setText: model.setDescription,
        ),
        const SizedBox(height: 12),

        // Дата
        const PurportFormDate(),
        const SizedBox(height: 12),

        // Редкость
        const PurportFormRarity(),
        const SizedBox(height: 12),
      ],
    );
  }

  Future _savePurport(Future<bool> Function() savePurport) async {
    if (!_formKey.currentState!.validate()) return;
    var result = await savePurport();
    if (mounted) {
      Navigator.pop(context, result);
    }
  }

  void _close() {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future _delete(Future Function() deletePurport) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await deletePurport();
      _close();
    }
  }
}
