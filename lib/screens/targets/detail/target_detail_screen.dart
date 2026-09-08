import 'package:chaos_control/screens/tasks/widgets/add_task_button.dart';
import 'package:chaos_control/screens/targets/detail/widgets/tabs.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/target.dart';
import 'package:chaos_control/screens/targets/detail/target_detail_model.dart';
import 'package:chaos_control/screens/targets/detail/widgets/header.dart';
import 'package:chaos_control/screens/targets/edit/target_edit_screen.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class TargetDetailScreen extends StatefulWidget {
  final Target target;
  const TargetDetailScreen({super.key, required this.target});

  @override
  State<TargetDetailScreen> createState() => _TargetDetailScreenState();
}

class _TargetDetailScreenState extends State<TargetDetailScreen>
    with SingleTickerProviderStateMixin {
  late TargetDetailModel model;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    model = context.read<TargetDetailModel>();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setTarget(widget.target);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trg = context.select<TargetDetailModel, Target>((m) => m.target);
    final currentTabIndex = context.select<TargetDetailModel, int>(
      (m) => m.currentTabIndex,
    );
    final visibilityForm = context.select<TargetDetailModel, bool>(
      (m) => m.visibilityTaskForm,
    );
    final isSelectionMode = context.select<TargetDetailModel, bool>(
      (m) => m.isSelectionMode,
    );
    

    void editCallback() => _edit(model, trg);
    Future<dynamic> deleteCallback() => _deleteTarget(model.deleteTarget);

    final floatingButton = currentTabIndex == 0
        ? (visibilityForm || isSelectionMode ? null : const TargetDetailAddTaskButton())
        : null;

    return EntityScreen(
      title: 'Цель',
      editCallback: editCallback,
      deleteCallback: deleteCallback,
      floatingButton: floatingButton,
      child: Column(
        children: [
          // Заголовок
          const TargetDetailHeader(),

          // Вкладки
          TargetDetailTabs(controller: _tabController),
        ],
      ),
    );
  }

  void _edit(TargetDetailModel model, Target task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TargetEditScreen(target: task)),
    ).then((_) async {
      if (context.mounted) {
        var checkExist = await model.checkExist();
        if (!checkExist) {
          _close();
          return;
        }
      }
    });
  }

  Future _deleteTarget(Future Function() deleteTask) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await deleteTask();
      _close();
    }
  }

  void _close() {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
