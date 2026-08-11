import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {

  final String title;
  final VoidCallback? callback;

  const TagChip({super.key, required this.title, this.callback});

  @override
  Widget build(BuildContext context) {
    return  Chip(
      backgroundColor: Theme.of(context).dividerColor,
      padding: EdgeInsetsGeometry.all(3),
      label: Text('#$title', style: TextStyle(fontWeight: FontWeight.normal)),
      side: BorderSide.none,
      onDeleted: callback,
      deleteIcon: Icon( Icons.close, size: 16, ),
    );
  }
  
}