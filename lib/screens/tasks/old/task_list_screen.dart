// import 'package:flutter/material.dart';
// import 'package:life_game/screens/tasks/form/task_form_screen.dart';
// import 'package:life_game/screens/tasks/task_provider.dart';
// import 'package:provider/provider.dart';

// class TaskListScreen extends StatefulWidget {
//   const TaskListScreen({super.key});

//   @override
//   State<TaskListScreen> createState() => _TaskListScreenState();
// }

// class _TaskListScreenState extends State<TaskListScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _selectedFilter = 'all';
//   String _selectedSort = 'datetime';
  
//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(() {
//       context.read<TaskProvider>().setSearchQuery(_searchController.text);
//     });
//   }
  
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: 
//       // AppBar(
//       //   title: const Text('Мои задачи'),
//       //   actions: [
//       //   ],
//       //   bottom: 
        
//       //   //   PreferredSize(
//       //   //   preferredSize: const Size.fromHeight(120),
//       //   //   child: _buildSearchAndFilters(),
//       //   // ),
//       // ),
//       body: Consumer<TaskProvider>(
//         builder: (context, taskProvider, child) {
//           if (!taskProvider.isInitialized && taskProvider.tasks.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }
          
//           if (taskProvider.tasks.isEmpty) {
//             return 
//             // Center(
//             //   child: Column(
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     children: [
//             //       Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
//             //       const SizedBox(height: 16),
//             //       Text(
//             //         'Нет задач',
//             //         style: TextStyle(fontSize: 20, color: Colors.grey[600]),
//             //       ),
//             //       const SizedBox(height: 8),
//             //       Text(
//             //         'Создайте свою первую задачу!',
//             //         style: TextStyle(color: Colors.grey[500]),
//             //       ),
//             //     ],
//             //   ),
//             // );
//           }
          
//           return ListView.builder(
//             padding: const EdgeInsets.all(8),
//             itemCount: taskProvider.tasks.length,
//             itemBuilder: (context, index) {
//               final task = taskProvider.tasks[index];
//               return _buildTaskCard(context, task);
//             },
//           );
//         },
//       ),
//       floatingActionButton: 

//       // FloatingActionButton(
//       //   onPressed: () {
//       //     Navigator.push(
//       //       context,
//       //       MaterialPageRoute(
//       //         builder: (context) => const TaskFormScreen(),
//       //       ),
//       //     ).then((_) {
//       //       // Обновляем список при возврате
//       //       context.read<TaskProvider>().loadTasks();
//       //     });
//       //   },
//       //   child: const Icon(Icons.add),
//       //   backgroundColor: Colors.deepPurple,
//       // ),
//     );
//   }
  
// }