import 'package:step_by_step/screens/profile/detail/profile_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:step_by_step/models/profile.dart';
import 'package:step_by_step/widgets/common/custom_card_block.dart';
import 'package:step_by_step/widgets/common/custom_image_icon.dart';
import 'package:step_by_step/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';

// Шапка: аватар, имя, возраст
class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select<ProfileDetailModel,Profile?>((m) => m.user);
    final focusColor = Theme.of(context).focusColor;

    var avaterWidget = CustomImageIcon(user?.icon, 
      altIcon: Icons.person,
      borderWidth: 2,
      width: 80,
      height: 80,
      borderColor: focusColor,
      boxShadow: BoxShadow(color: focusColor, blurRadius: 12, blurStyle: BlurStyle.outer),
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
      padding: const EdgeInsets.all(16),
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