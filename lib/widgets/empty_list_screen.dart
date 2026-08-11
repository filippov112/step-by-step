import 'package:flutter/material.dart';

// Заглушка пустого списка элементов
class EmptyListScreen extends StatelessWidget {
  const EmptyListScreen({super.key, 
    required this.title, required this.subtitle, required this.icon});

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return 
    Padding(
      padding: EdgeInsetsGeometry.all(25),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64),
            const SizedBox(height: 16),
            Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center
            ),
            const SizedBox(height: 8),
            Text(subtitle, 
              style: Theme.of(context).textTheme.titleSmall, 
              textAlign: TextAlign.center
            ),
          ],
        )
      ),
    );
    
  }
  
}