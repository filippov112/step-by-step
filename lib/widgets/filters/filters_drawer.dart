import 'package:flutter/material.dart';

// Боковая вкладка (Scaffold.endDrawer) с фильтрами для экранов-списков
class FiltersDrawer extends StatefulWidget {
  final Iterable<Widget> filters;
  final Widget? buttons;
  const FiltersDrawer({
    super.key,
    this.buttons,
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
            padding:EdgeInsetsGeometry.all(8), 
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(), 
                  icon: Icon(Icons.arrow_forward_ios)
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
            children: [...widget.filters],
          )
          ),
          if (widget.buttons != null) 
            Padding(
              padding: EdgeInsetsGeometry.all(8), 
              child: widget.buttons
            )
      ],)
    );
  }

  


  
}