import 'package:chaos_control/screens/profile/detail/profile_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/widgets/common/custom_card_block.dart';
import 'package:chaos_control/widgets/common/custom_image_icon.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

// Шапка: аватар, имя, возраст
class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select<ProfileDetailModel,Profile?>((m) => m.user);

    var avaterWidget = CustomImageIcon(user?.icon, 
      altIcon: Icons.person,
      borderWidth: 2,
      width: 80,
      height: 80,
      borderColor: Theme.of(context).focusColor,
      radius: const BorderRadius.all(Radius.circular(40)),
    );

    var nameWidget = CustomText(
      user?.name ?? '',
      size: 24,
      overflow: TextOverflow.visible,
      weight: const FontWeight(500),
      lines:2,
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
              ],
            ),
          ),
        ],
      )
    );
  }
}