import 'dart:io';

import 'package:flutter/material.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/screens/skills/detail/skill_detail_screen.dart';
import 'package:life_game/screens/skills/form/skill_form_screen.dart';
import 'package:life_game/screens/skills/list/skill_list_model.dart';
import 'package:provider/provider.dart';
import 'package:life_game/widgets/app_drawer.dart';
import 'package:life_game/widgets/bottom_menu.dart';
import 'package:life_game/models/enums/skill_rang.dart';


class SkillListScreen extends StatefulWidget {
  const SkillListScreen({super.key});

  @override
  State<SkillListScreen> createState() => _SkillListScreenState();
}

class _SkillListScreenState extends State<SkillListScreen> {
  late SkillListModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SkillListModel();
    _viewModel.loadSkills();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Навыки'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _navigateToForm(context),
              tooltip: 'Создать навык',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _viewModel.loadSkills(),
              tooltip: 'Обновить',
            ),
          ],
        ),
        drawer: const AppDrawer(currentRoute: '/skills'),
        body: Consumer<SkillListModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (viewModel.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.loadSkills(),
                      child: const Text('Попробовать снова'),
                    ),
                  ],
                ),
              );
            }
            
            if (viewModel.skills.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_border, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    const Text(
                      'Нет навыков',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Создайте свой первый навык',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _navigateToForm(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Создать навык'),
                    ),
                  ],
                ),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: viewModel.skills.length,
              itemBuilder: (context, index) {
                final skill = viewModel.skills[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    leading: _buildSkillIcon(skill.icon),
                    title: Text(
                      skill.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ранг: ${skill.rang.name}'),
                        Text('Уровень: ${skill.level}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _navigateToForm(context, skill: skill),
                          tooltip: 'Редактировать',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(context, skill.id),
                          tooltip: 'Удалить',
                        ),
                      ],
                    ),
                    onTap: () => _navigateToDetail(context, skill.id),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: const BottomMenu(),
      ),
    );
  }

  Widget _buildSkillIcon(String iconPath) {
    if (iconPath.isEmpty) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.star_border, color: Colors.grey),
      );
    }
    
    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(iconPath),
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.broken_image, color: Colors.grey),
            );
          },
        ),
      );
    } catch (e) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }
  }

  void _confirmDelete(BuildContext context, String skillId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удаление навыка'),
        content: const Text('Вы уверены, что хотите удалить этот навык?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _viewModel.deleteSkill(skillId).then((success) {
                if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_viewModel.error ?? 'Ошибка удаления'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _navigateToForm(BuildContext context, {Skill? skill}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillFormScreen(skill: skill),
      ),
    ).then((result) {
      if (result == true) {
        _viewModel.loadSkills();
      }
    });
  }

  void _navigateToDetail(BuildContext context, String skillId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillDetailScreen(skillId: skillId),
      ),
    );
  }
}