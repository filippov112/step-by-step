import 'package:chaos_control/models/enums/wall_status.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/wall.dart';
import 'package:chaos_control/screens/walls/detail/wall_detail_model.dart';
import 'package:chaos_control/screens/walls/detail/widgets/description.dart';
import 'package:chaos_control/screens/walls/detail/widgets/title.dart';
import 'package:chaos_control/screens/walls/detail/widgets/status.dart';
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

class _WallDetailsScreenState extends State<WallDetailsScreen> {
  late WallDetailModel model;

  @override
  void initState() {
    super.initState();
    model = context.read<WallDetailModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setTask(widget.wall);
    });
  }

  @override
  Widget build(BuildContext context) {
    var task = context.select<WallDetailModel, Wall>((model) => model.wall);
    var status = context.select<WallDetailModel, WallStatus>(
      (model) => model.wall.status,
    );
    var setStatus = model.setStatus;
    var deleteWall = model.deleteWall;

    return EntityScreen(
      title: 'Стена',
      editCallback: () => _edit(model, task),
      deleteCallback: () => _deleteWall(deleteWall),
      floatingButton: FloatingActionButton(
              onPressed: () => setStatus(),
              tooltip: 'Разрушить',
              backgroundColor: Theme.of(context).focusColor,
              child: Icon(
                status == WallStatus.destroyed ? Icons.task_alt_outlined : Icons.circle_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
      child: Column(
        children: [
          // Заголовок
          Padding(
            padding: const EdgeInsets.all(16),
            child: const WallDetailTitle(),
          ),

          // Описание
          Expanded(
            child: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: ListView(
                children: [
                  const WallDetailStatus(),
                  const Divider(),
                  const WallDetailDesc(),
                ],
              ),
            ),
          ),
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
