// import 'package:flutter/material.dart';





// final TextEditingController _searchController = TextEditingController();


// Widget _buildSearchAndFilters() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       color: Colors.deepPurple,
//       child: Column(
//         children: [
//           // // Поиск
//           // TextField(
//           //   controller: _searchController,
//           //   style: const TextStyle(color: Colors.white),
//           //   decoration: InputDecoration(
//           //     hintText: 'Поиск задач...',
//           //     hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
//           //     prefixIcon: const Icon(Icons.search, color: Colors.white),
//           //     border: OutlineInputBorder(
//           //       borderRadius: BorderRadius.circular(8),
//           //       borderSide: BorderSide.none,
//           //     ),
//           //     filled: true,
//           //     fillColor: Colors.white.withValues(alpha: 0.2),
//           //     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
//           //   ),
//           // ),
//           // const SizedBox(height: 8),
//           // Фильтры и сортировка
//           Row(
//             children: [
//               // Фильтры
//               _buildFilterChip('Все', 'all'),
//               _buildFilterChip('Активные', 'active'),
//               _buildFilterChip('Выполненные', 'completed'),
//               _buildFilterChip('Просроченные', 'overdue'),
//               const Spacer(),
//               // Сортировка
//               PopupMenuButton<String>(
//                 icon: const Icon(Icons.sort, color: Colors.white),
//                 onSelected: (value) {
//                   setState(() {
//                     _selectedSort = value;
//                   });
//                   context.read<TaskProvider>().setSortBy(value);
//                 },
//                 itemBuilder: (context) => [
//                   const PopupMenuItem(
//                     value: 'datetime',
//                     child: Text('По дате'),
//                   ),
//                   const PopupMenuItem(
//                     value: 'priority',
//                     child: Text('По приоритету'),
//                   ),
//                   const PopupMenuItem(
//                     value: 'difficulty',
//                     child: Text('По сложности'),
//                   ),
//                   const PopupMenuItem(
//                     value: 'title',
//                     child: Text('По названию'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
  