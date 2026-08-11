// import 'package:flutter/material.dart';
// import 'package:life_game/screens/tasks/task_provider.dart';

// String _selectedFilter = 'all';

// Widget _buildFilterChip(String label, String value) {
//     final isSelected = _selectedFilter == value;
//     return Padding(
//       padding: const EdgeInsets.only(right: 4),
//       child: FilterChip(
//         label: Text(label),
//         selected: isSelected,
//         onSelected: (selected) {
//           setState(() {
//             _selectedFilter = selected ? value : 'all';
//           });
//           context.read<TaskProvider>().setFilter(_selectedFilter);
//         },
//         backgroundColor: Colors.white.withOpacity(0.1),
//         selectedColor: Colors.white.withOpacity(0.3),
//         labelStyle: TextStyle(
//           color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
//           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//         ),
//         shape: StadiumBorder(
//           side: BorderSide(
//             color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
//           ),
//         ),
//       ),
//     );
//   }
  