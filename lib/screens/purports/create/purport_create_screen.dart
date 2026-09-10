import 'package:chaos_control/screens/purports/create/purport_create_model.dart';
import 'package:chaos_control/widgets/dialogs/bottom_modal_form.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:provider/provider.dart';


class PurportCreateScreen extends StatefulWidget {
  final String group;
  const PurportCreateScreen({super.key, required this.group});

  @override
  State<PurportCreateScreen> createState() => _PurportCreateScreenState();
}

class _PurportCreateScreenState extends State<PurportCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  late PurportCreateModel model;

  @override
  void initState() {
    super.initState();
    model = context.read<PurportCreateModel>();
    model.group = widget.group;
    model.init();
  }

  @override
  Widget build(BuildContext context) {
    final saveCallback = model.save;
    final group = context.select<PurportCreateModel, String>((m) => m.group);

    final nameField = CustomTextInput(
      requiredErrorText: 'Введите название',
      header: 'Название',
      icon: Icons.title,
      setText: model.setTitle,
    );
    final groupField = CustomTextInput(
      header: 'Группа',
      initialValue: group,
      icon: Icons.folder,
      setText: model.setGroup,
      lines: 1,
      customValidator: model.groupValidator,
    );
    final descField = CustomTextInput(
      header: 'Описание',
      icon: Icons.mode_standby,
      setText: model.setTarget,
      lines: 4,
    );

    return BottomModalForm(
      title: 'Новый смысл',
      expanded: true,
      confirmCallback: () => _save(saveCallback),
      formKey: _formKey,
      children: [
        // Название
        nameField,
        const SizedBox(height: 12),
        
        // Описание
        descField,
        const SizedBox(height: 12),

        // Группа
        groupField,
        const SizedBox(height: 12),
      ],
    );
  }

  Future _save(Future<bool> Function() saveCallback) async {
    if (!mounted || _formKey.currentState == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    var result = await saveCallback();
    if (mounted) {
      Navigator.pop(context, result);
    }
  }
}
