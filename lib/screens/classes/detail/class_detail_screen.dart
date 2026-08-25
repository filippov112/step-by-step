import 'package:flutter/material.dart';
import 'package:chaos_control/models/class.dart';
import 'package:chaos_control/screens/classes/detail/class_detail_model.dart';
import 'package:chaos_control/screens/classes/detail/widgets/desc.dart';
import 'package:chaos_control/screens/classes/detail/widgets/icon.dart';
import 'package:chaos_control/screens/classes/detail/widgets/progress.dart';
import 'package:chaos_control/screens/classes/detail/widgets/skills.dart';
import 'package:chaos_control/screens/classes/detail/widgets/tags.dart';
import 'package:chaos_control/screens/classes/detail/widgets/title.dart';
import 'package:chaos_control/screens/classes/form/class_form_screen.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class ClassDetailScreen extends StatefulWidget {
  final Class record;
  const ClassDetailScreen({super.key, required this.record});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  late ClassDetailModel model;

  @override
  void initState() {
    super.initState();
    model = context.read<ClassDetailModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setClass(widget.record);
    });
  }

  @override
  Widget build(BuildContext context) {
    var record = context.select<ClassDetailModel, Class>(
      (model) => model.record,
    );

    var deleteThis = model.deleteThis;

    return EntityScreen(
      title: 'Класс',
      editCallback: () => _edit(model, record),
      deleteCallback: () => _deleteThis(deleteThis),
      children: [
        // Иконка
        const ClassDetailIcon(),
        const SizedBox(height: 12),

        // Заголовок
        const ClassDetailTitle(),
        const SizedBox(height: 16),

        // Прогресс
        const ClassDetailProgress(),
        const SizedBox(height: 12),

        // Описание
        const ClassDetailDesc(),
        const SizedBox(height: 12),

        // Теги
        const ClassDetailTags(),
        const SizedBox(height: 12),

        // Навыки
        const ClassDetailSkills(),
      ],
    );
  }

  void _edit(ClassDetailModel model, Class cls) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClassFormScreen(record: cls)),
    ).then((_) async {
      if (context.mounted) {
        var checkExist = await model.checkExist();
        if (!checkExist) {
          _close();
        }
      }
    });
  }

  void _close() {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future _deleteThis(Future Function() deleteThis) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await deleteThis();
      _close();
    }
  }
}
