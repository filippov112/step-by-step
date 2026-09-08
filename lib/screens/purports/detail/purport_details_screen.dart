import 'package:flutter/material.dart';
import 'package:chaos_control/models/purport.dart';
import 'package:chaos_control/screens/purports/detail/purport_details_model.dart';
import 'package:chaos_control/screens/purports/detail/widgets/desc.dart';
import 'package:chaos_control/screens/purports/detail/widgets/header.dart';
import 'package:chaos_control/screens/purports/form/purport_form_screen.dart';
import 'package:chaos_control/widgets/dialogs/confirm_dialog.dart';
import 'package:provider/provider.dart';

class PurportDetailScreen extends StatefulWidget {
  final Purport purport;
  const PurportDetailScreen({super.key, required this.purport});

  @override
  State<PurportDetailScreen> createState() =>
      _PurportDetailScreenState();
}

class _PurportDetailScreenState extends State<PurportDetailScreen> {
  late PurportDetailsModel model;

  @override
  void initState() {
    super.initState();
    model = context.read<PurportDetailsModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.setPurport(widget.purport);
    });
  }

  @override
  Widget build(BuildContext context) {
    var purport = context.select<PurportDetailsModel, Purport>(
      (model) => model.purport,
    );
    var date = context.select<PurportDetailsModel, DateTime?>(
      (model) => model.purport.date,
    );
    var setDone = model.setDone;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Смысл'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _edit(purport),
            tooltip: 'Редактировать',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteThis,
            tooltip: 'Удалить',
          ),
        ],
      ),

      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [const PurportDetailHeader(), const PurportDetailDesc()],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: (date == null)
          ? FloatingActionButton(
              onPressed: setDone,
              tooltip: 'Подтвердить получение',
              child: const Icon(Icons.task_alt),
            )
          : null,
    );
  }

  Future _edit(Purport purport) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PurportFormScreen(purport: purport),
      ),
    ).then((_) async {
      if (context.mounted) {
        var checkExist = await model.checkExist();
        if (!checkExist) {
          _close();
        } else {
          setState(() {});
        }
      }
    });
  }

  void _close() {
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future _deleteThis() async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await model.deleteThis();
      _close();
    }
  }
}
