import 'package:chaos_control/screens/purports/detail/widgets/tabs.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/purport.dart';
import 'package:chaos_control/screens/purports/detail/purport_detail_model.dart';
import 'package:chaos_control/screens/purports/detail/widgets/header.dart';
import 'package:chaos_control/screens/purports/edit/purport_edit_screen.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:chaos_control/widgets/screens/entity_screen.dart';
import 'package:provider/provider.dart';

class PurportDetailScreen extends StatefulWidget {
  final Purport purport;
  const PurportDetailScreen({super.key, required this.purport});

  @override
  State<PurportDetailScreen> createState() => _PurportDetailScreenState();
}

class _PurportDetailScreenState extends State<PurportDetailScreen>
    with SingleTickerProviderStateMixin {
  late PurportDetailModel model;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    model = context.read<PurportDetailModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.init(widget.purport);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var record = context.select<PurportDetailModel, Purport?>(
      (model) => model.purport,
    );

    var deleteThis = model.deleteThis;

    return EntityScreen(
      title: 'Смысл',
      editCallback: () => _edit(model, record),
      deleteCallback: () => _deleteThis(deleteThis),
      child: Column(
        children: [
          // Шапка
          const PurportDetailHeader(),

          // Панель вкладок
          PurportDetailTabs(controller: _tabController),
        ],
      ),
    );
  }

  void _edit(PurportDetailModel model, Purport? pur) async {
    if (pur == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PurportEditScreen(purport: pur)),
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
