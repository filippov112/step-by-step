import 'package:chaos_control/screens/projects/detail/widgets/tabs.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/projects/detail/project_detail_model.dart';
import 'package:chaos_control/screens/projects/detail/widgets/header.dart';
import 'package:chaos_control/screens/projects/form/project_form_screen.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;
  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen>
    with SingleTickerProviderStateMixin {
  late ProjectDetailModel model;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    model = context.read<ProjectDetailModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setClass(widget.project);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var record = context.select<ProjectDetailModel, Project>(
      (model) => model.project,
    );

    var deleteThis = model.deleteThis;

    return EntityScreen(
      title: 'Проект',
      editCallback: () => _edit(model, record),
      deleteCallback: () => _deleteThis(deleteThis),
      child: Column(
        children: [
          // Шапка
          const ProjectDetailHeader(),

          // Панель вкладок
          ProjectDetailTabs(controller: _tabController),
        ],
      ),
    );
  }

  void _edit(ProjectDetailModel model, Project cls) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProjectFormScreen(project: cls)),
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
