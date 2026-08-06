import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/user_profile.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.character});
  
  final UserProfileModel character;
  // Тут входящие параметры виджета - final string title; Объявление полей всегда с final.

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ViewModel - команды, свойства

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: const Color(0xFF1A1A2E),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Шапка: аватар, имя, возраст
            _buildHeader(context),
            const SizedBox(height: 20),
            // Мана
            _buildStatBar(
              label: 'Мана',
              value: widget.character.mana.toDouble(),
              maxValue: widget.character.maxMana.toDouble(),
              icon: Icons.bolt,
              color: Colors.blueAccent,
              backgroundColor: Colors.blue.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            // Опыт
            _buildStatBar(
              label: 'Опыт',
              value: widget.character.experience.toDouble(),
              maxValue: widget.character.maxExperience.toDouble(),
              icon: Icons.stars,
              color: Colors.amber,
              backgroundColor: Colors.amber.withValues(alpha: 0.2),
              showAsPercent: false, // показываем X / Y
            ),

            const SizedBox(height: 40),
    
            
            // Статистика (6 параметров)
            const Text(
              '📊 СТАТИСТИКА',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            _buildStatRow(
              label: 'Восст. маны',
              value: widget.character.manaRegeneration,
              icon: Icons.timeline,
              color: Colors.tealAccent,
            ),
            _buildStatRow(
              label: 'Интеллект',
              value: widget.character.intelligence,
              icon: Icons.psychology,
              color: Colors.purpleAccent,
            ),
            _buildStatRow(
              label: 'Сила',
              value: widget.character.strength,
              icon: Icons.fitness_center,
              color: Colors.redAccent,
            ),
            _buildStatRow(
              label: 'Здоровье',
              value: widget.character.health,
              icon: Icons.favorite,
              color: Colors.greenAccent,
            ),
            _buildStatRow(
              label: 'Выносливость',
              value: widget.character.endurance,
              icon: Icons.directions_run,
              color: Colors.orangeAccent,
            ),
            _buildStatRow(
              label: 'Макс. мана',
              value: widget.character.maxMana.toInt(),
              icon: Icons.auto_awesome,
              color: Colors.cyanAccent,
            ),
          ],
        ),
      ),
    );
  }

  // ---- Шапка ----
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Аватар с обводкой
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.orange, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: FileImage(File(widget.character.icon ?? "")),
            onBackgroundImageError: (_, _) => const Icon(Icons.person, size: 40),
            child: widget.character.icon == null
                ? const Icon(Icons.person, size: 40, color: Colors.white)
                : null,
          ),
        ),
        const SizedBox(width: 16),
        // Имя и возраст
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.red],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'LVL ${widget.character.level}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ]
              ),
              
              const SizedBox(height: 4),
              Text(
                widget.character.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 4),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.cake, size: 16, color: Colors.white70),
                  const SizedBox(width: 6),
                  Text(
                    widget.character.age,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  )
                ],
              ),
            ],
          ),
      ],
    );
  }

  // ---- Прогресс-бар с иконкой и числом ----
  Widget _buildStatBar({
    required String label,
    required double value,
    required double maxValue,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    bool showAsPercent = true,
  }) {
    final percent = maxValue > 0 ? (value / maxValue).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const Spacer(),
            Text(
              showAsPercent
                  ? '${(percent * 100).toInt()}%'
                  : '${value.toInt()} / ${maxValue.toInt()}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 10,
            backgroundColor: backgroundColor,
            color: color,
          ),
        ),
      ],
    );
  }

  // ---- Строка статистики (иконка + название + значение) ----
  Widget _buildStatRow({
    required String label,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
