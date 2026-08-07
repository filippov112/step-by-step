import 'dart:io';
import 'package:flutter/material.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/screens/user/view/user_view_model.dart';
import 'package:life_game/widgets/custom_progress_bar.dart';
import 'package:provider/provider.dart';


class UserViewScreen extends StatelessWidget {
  const UserViewScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    User? user = context.select<UserViewModel,User?>((model) => model.user);

    return FutureBuilder(
      future: context.read<UserViewModel>().loadUser(),

      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Шапка: аватар, имя, возраст
                Row(
                  children: [
                    // Аватар с обводкой
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: FileImage(File(user?.icon ?? "")),
                        onBackgroundImageError: (_, _) => const Icon(Icons.person, size: 40),
                        child: user?.icon == null
                            ? const Icon(Icons.person, size: 40)
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'LVL ${user?.level}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              ]
                          ),
                          
                          const SizedBox(height: 4),
                          Text(
                            user?.name ?? "",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(offset: Offset(1, 1), blurRadius: 4),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.cake, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                user?.age ?? "",
                                style: const TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
                
                const SizedBox(height: 20),
                // Опыт
                CustomProgressBar(
                  label: 'Опыт',
                  value: user?.experience.toDouble() ?? 0,
                  maxValue: user?.maxExperience.toDouble() ?? 0,
                  icon: Icons.stars,
                  showAsPercent: false, // показываем X / Y
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
