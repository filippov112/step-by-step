import 'package:chaos_control/screens/settings/setting_list_model.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScaffold extends StatelessWidget {
  final String title;
  final Iterable<Widget> children;
  final Widget? bottomBar, drawer;
  final VoidCallback cancelCallback;

  const SettingsScaffold({
    super.key,
    required this.title,
    required this.children,
    this.bottomBar,
    this.drawer,
    required this.cancelCallback
  });

  @override
  Widget build(BuildContext context) {
    final model = context.read<SettingListModel>();
    final hasChanged = context.select<SettingListModel,bool>((m) => m.hasChanged);
    final saveButton = hasChanged ? IconButton(onPressed: model.save, icon: Icon(Icons.save)) : null;
    final cancelButton = hasChanged ? IconButton(onPressed: cancelCallback, icon: Icon(Icons.cancel)) : null;

    return Scaffold(
      appBar: AppBar(title: CustomText(title), actions: [
        ?cancelButton, ?saveButton
      ],),
      drawer: drawer,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [...children],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}
