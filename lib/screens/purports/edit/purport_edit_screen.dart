import 'package:chaos_control/models/other/image.dart';
import 'package:chaos_control/widgets/form/custom_icon_picker.dart';
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
    final save = model.save;
    final delete = model.delete;
    final iconData = context.select<PurportEditModel, CustomImageData?>(
      (m) => m.purport?.icon,
    );

    // Иконка
    final iconField = Center(
      child: CustomIconPicker(
        selectedIcon: iconData,
        setIcon: model.setIcon,
        size: 100,
        borderWidth: 3,
      ),
    );

    // Название
    final nameField = CustomTextInput(
      requiredErrorText: 'Введите название',
      header: 'Название',
      initialValue: model.title,
      icon: Icons.title,
      setText: model.setTitle,
    );

    // Группа
    final groupField = CustomTextInput(
      header: 'Группа',
      initialValue: model.group,
      icon: Icons.folder,
      setText: model.setGroup,
      lines: 1,
      customValidator: Purport.groupValidator,
    );

    // Описание
    final descField = CustomTextInput(
      header: 'Смысл',
      initialValue: model.desc,
      icon: Icons.mode_standby,
      setText: model.setTarget,
      lines: 4,
    );

    return EntityScreen(
      title: '',
      saveCallback: () => _save(save),
      deleteCallback: () => _delete(delete),
      formKey: _formKey,
      children: [
        iconField,
        const SizedBox(height: 12),

        nameField,
        const SizedBox(height: 12),

        groupField,
        const SizedBox(height: 12),

        descField,
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
