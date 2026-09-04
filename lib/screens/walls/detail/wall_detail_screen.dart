import 'package:chaos_control/screens/walls/detail/widgets/add_attempt_button.dart';
import 'package:chaos_control/screens/walls/detail/widgets/change_status_button.dart';
import 'package:chaos_control/screens/walls/detail/widgets/tabs.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:chaos_control/screens/walls/detail/widgets/header.dart';
import 'package:chaos_control/screens/walls/edit/wall_edit_screen.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class WallDetailsScreen extends StatefulWidget {
  final Wall wall;
  const WallDetailsScreen({super.key, required this.wall});

  @override
  State<WallDetailsScreen> createState() => _WallDetailsScreenState();
}

class _WallDetailsScreenState extends State<WallDetailsScreen>
    with SingleTickerProviderStateMixin {
  late WallDetailModel model;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    model = context.read<WallDetailModel>();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setWall(widget.wall);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wll = context.select<WallDetailModel, Wall>((m) => m.wall);
    final currentTabIndex = context.select<WallDetailModel, int>(
      (m) => m.currentTabIndex,
    );
    final visibilityForm = context.select<WallDetailModel, bool>(
      (m) => m.visibilityAttemptForm,
    );

    void editCallback() => _edit(model, wll);
    Future<dynamic> deleteCallback() => _deleteWall(model.deleteWall);

    final floatingButton = currentTabIndex == 0
        ? (visibilityForm ? null : const WallDetailAddAttemptButton())
        : const WallDetailChangeStatusButton();

    return EntityScreen(
      title: 'Стена',
      editCallback: editCallback,
      deleteCallback: deleteCallback,
      floatingButton: floatingButton,
      child: Column(
        children: [
          // Заголовок
          const WallDetailHeader(),

          // Вкладки
          WallDetailTabs(controller: _tabController),
        ],
      ),
    );
  }

  void _edit(WallDetailModel model, Wall task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WallEditScreen(wall: task)),
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

  Future _deleteWall(Future Function() deleteTask) async {
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
