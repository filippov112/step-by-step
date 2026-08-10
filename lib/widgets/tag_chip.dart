import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {

  final String title;

  const TagChip({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return  Chip(
      backgroundColor: Theme.of(context).dividerColor,
      padding: EdgeInsetsGeometry.all(3),
      label: Text('#$title', style: TextStyle(fontWeight: FontWeight.normal)),
      side: BorderSide.none,
    );
  }
  
}