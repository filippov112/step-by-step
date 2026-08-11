import 'package:flutter/material.dart';

// Боковая вкладка (Scaffold.endDrawer) с фильтрами для экранов-списков
class FiltersDrawer extends StatefulWidget {
  final Iterable<Widget> filters;
  const FiltersDrawer({
    super.key,
    required this.filters
  });

  @override
  State<FiltersDrawer> createState() => _FiltersDrawerState();
}

class _FiltersDrawerState extends State<FiltersDrawer> {

  @override
  Widget build(BuildContext context) {

    

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:EdgeInsetsGeometry.all(16), 
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(), 
                  icon: Icon(Icons.arrow_forward_ios)
                )
              ],
            ),
          ),
          ...widget.filters

        ],
      )
    );
  }
}