// import 'package:flutter/material.dart';
// import 'package:life_game/models/task.dart';
// import 'package:life_game/screens/tasks/detail/task_detail_screen.dart';
// import 'package:life_game/screens/tasks/task_provider.dart';
// import 'package:provider/provider.dart';

// Widget _buildTaskCard(BuildContext context, Task task) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//       elevation: 2,
//       child: ListTile(
//         leading: Checkbox(
//           value: task.done,
//           onChanged: (_) {
//             context.read<TaskProvider>().toggleTaskStatus(task.id);
//           },
//           activeColor: Colors.deepPurple,
//         ),
//         title: Text(
//           task.title,
//           style: TextStyle(
//             decoration: task.done ? TextDecoration.lineThrough : null,
//             color: task.done ? Colors.grey : Colors.black87,
//           ),
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (task.description.isNotEmpty)
//               Text(
//                 task.description,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[600],
//                 ),
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             Row(
//               children: [
//                 _buildStatusChip(task),
//                 const SizedBox(width: 4),
//                 _buildPriorityChip(task),
//                 const SizedBox(width: 4),
//                 _buildDifficultyChip(task),
//               ],
//             ),
//           ],
//         ),
//         trailing: IconButton(
//           icon: const Icon(Icons.arrow_forward_ios, size: 16),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => TaskDetailScreen(taskId: task.id),
//               ),
//             );
//           },
//         ),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => TaskDetailScreen(taskId: task.id),
//             ),
//           );
//         },
//       ),
//     );
//   }
  