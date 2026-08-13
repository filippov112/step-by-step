import 'package:flutter/material.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({
    super.key, 
    required this.title, 
    required this.children, 
    required this.icon
  });

  final String title;
  final Widget children;
  final IconData icon;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            leading: Icon(icon),
            children: [
              Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    children
                  ],
                )
              ),
            ],
          ),
          // Divider(color: SoloLevelingTheme.steelBlue,)
        ],
      ),
    );
  }
}