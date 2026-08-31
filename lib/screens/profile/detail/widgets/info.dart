import 'package:flutter/material.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';

// Шапка: аватар, имя, возраст
class ProfileInfo extends StatelessWidget {
  final Profile user;
  const ProfileInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {

    var avaterWidget = CustomImageIcon(user.icon, 
      altIcon: Icons.person,
      borderWidth: 2,
      width: 80,
      height: 80,
      borderColor: Theme.of(context).focusColor,
      radius: const BorderRadius.all(Radius.circular(40)),
    );

    var nameWidget = CustomText(
      user.name,
      size: 24,
      weight: FontWeight.bold,
      shadow: const Shadow(offset: Offset(1, 1), blurRadius: 4),
    );

    var ageWidget = Row(
      children: [
        const Icon(Icons.watch_later_sharp, size: 16),
        const SizedBox(width: 6),
        CustomText(
          user.age,
          size: 16, expanded: true,
        )
      ],
    );

    return CustomCardBlock(
      child: Row(
        children: [
          // Аватар с обводкой
          avaterWidget,
          const SizedBox(width: 16),
          // Имя и возраст
          Expanded( child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                nameWidget,
                const SizedBox(height: 4),
                ageWidget
              ],
            ),
          ),
        ],
      )
    );
  }
}