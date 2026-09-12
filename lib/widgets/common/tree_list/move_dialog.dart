import 'package:chaos_control/widgets/form/checkbox.dart';
import 'package:chaos_control/widgets/form/text_input.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';

// Диалог подтверждения действий
Future<(String, bool)?> showMoveDialog(
  BuildContext context, {
  required String currentAddress,
  required Future Function(String, bool) callback,
}) async {
  return await showDialog<(String, bool)>(
    context: context,
    builder: (context) =>
        MoveDialog(currentGroup: currentAddress, callback: callback),
  );
}

class MoveDialog extends StatefulWidget {
  final String currentGroup;
  final Future Function(String, bool) callback;
  const MoveDialog({
    super.key,
    required this.currentGroup,
    required this.callback,
  });

  @override
  State<StatefulWidget> createState() => MoveDialogState();
}

class MoveDialogState extends State<MoveDialog> {
  String group = '';
  bool isSaveStructure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    group = widget.currentGroup;
  }

  String? groupValidator(String? text) {
    if (text == null || text.isEmpty) return null;
    var parts = text.split('/');
    if (parts.any((e) => e.isEmpty)) return 'Части группы не могут быть пустыми';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final content = Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextInput(
            header: "Новая группа ('/'')",
            icon: Icons.folder,
            customValidator: groupValidator,
            initialValue: widget.currentGroup,
            setText: (v) => setState(() {
              group = v ?? '';
            }),
          ),
          const SizedBox(height: 8),
          CustomCheckbox(
            initValue: isSaveStructure,
            backColor: Colors.transparent,
            setValue: (v) => setState(() {
              isSaveStructure = v;
            }),

            label: 'Сохранить структуру',
          ),
        ],
      ),
    );

    final actions = Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText('Отмена', noShadow: true),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() != true) return;
              await widget.callback(group, isSaveStructure);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const CustomText('Переместить', noShadow: true),
          ),
        ),
      ],
    );

    return AlertDialog(
      insetPadding: EdgeInsets.all(8),

      title: const CustomText('Перемещение', size: 16, weight: FontWeight.bold),
      content: content,
      actions: [actions],
    );
  }
}
