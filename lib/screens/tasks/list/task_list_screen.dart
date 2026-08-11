import 'package:flutter/material.dart';
import 'package:life_game/models/enums/task_difficulty.dart';
import 'package:life_game/models/enums/task_priority.dart';
import 'package:life_game/screens/tasks/detail/task_detail_screen.dart';
import 'package:life_game/screens/tasks/form/task_form_screen.dart';
import 'package:life_game/screens/tasks/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:life_game/models/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  String _selectedSort = 'datetime';
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      context.read<TaskProvider>().setSearchQuery(_searchController.text);
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои задачи'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TaskProvider>().loadTasks();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: _buildSearchAndFilters(),
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          if (!taskProvider.isInitialized && taskProvider.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (taskProvider.tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Нет задач',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Создайте свою первую задачу!',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: taskProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.tasks[index];
              return _buildTaskCard(context, task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormScreen(),
            ),
          ).then((_) {
            // Обновляем список при возврате
            context.read<TaskProvider>().loadTasks();
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
  
  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.deepPurple,
      child: Column(
        children: [
          // Поиск
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Поиск задач...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            ),
          ),
          const SizedBox(height: 8),
          // Фильтры и сортировка
          Row(
            children: [
              // Фильтры
              _buildFilterChip('Все', 'all'),
              _buildFilterChip('Активные', 'active'),
              _buildFilterChip('Выполненные', 'completed'),
              _buildFilterChip('Просроченные', 'overdue'),
              const Spacer(),
              // Сортировка
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort, color: Colors.white),
                onSelected: (value) {
                  setState(() {
                    _selectedSort = value;
                  });
                  context.read<TaskProvider>().setSortBy(value);
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'datetime',
                    child: Text('По дате'),
                  ),
                  const PopupMenuItem(
                    value: 'priority',
                    child: Text('По приоритету'),
                  ),
                  const PopupMenuItem(
                    value: 'difficulty',
                    child: Text('По сложности'),
                  ),
                  const PopupMenuItem(
                    value: 'title',
                    child: Text('По названию'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? value : 'all';
          });
          context.read<TaskProvider>().setFilter(_selectedFilter);
        },
        backgroundColor: Colors.white.withOpacity(0.1),
        selectedColor: Colors.white.withOpacity(0.3),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTaskCard(BuildContext context, Task task) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: 2,
      child: ListTile(
        leading: Checkbox(
          value: task.done,
          onChanged: (_) {
            context.read<TaskProvider>().toggleTaskStatus(task.id);
          },
          activeColor: Colors.deepPurple,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.done ? TextDecoration.lineThrough : null,
            color: task.done ? Colors.grey : Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty)
              Text(
                task.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            Row(
              children: [
                _buildStatusChip(task),
                const SizedBox(width: 4),
                _buildPriorityChip(task),
                const SizedBox(width: 4),
                _buildDifficultyChip(task),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailScreen(taskId: task.id),
              ),
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(taskId: task.id),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildStatusChip(Task task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: task.statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: task.statusColor.withOpacity(0.3)),
      ),
      child: Text(
        task.statusText,
        style: TextStyle(
          fontSize: 10,
          color: task.statusColor,
        ),
      ),
    );
  }
  
  Widget _buildPriorityChip(Task task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: task.priority.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: task.priority.color.withOpacity(0.3)),
      ),
      child: Text(
        task.priority.displayName,
        style: TextStyle(
          fontSize: 10,
          color: task.priority.color,
        ),
      ),
    );
  }
  
  Widget _buildDifficultyChip(Task task) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: task.difficulty.color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: task.difficulty.color.withOpacity(0.3)),
      ),
      child: Text(
        task.difficulty.displayName,
        style: TextStyle(
          fontSize: 10,
          color: task.difficulty.color,
        ),
      ),
    );
  }
}