import 'package:step_by_step/screens/profile/detail/widgets/chars.dart';
import 'package:step_by_step/screens/profile/detail/widgets/filters.dart';
import 'package:step_by_step/screens/profile/detail/widgets/level.dart';
import 'package:step_by_step/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:step_by_step/screens/profile/detail/profile_detail_model.dart';
import 'package:step_by_step/screens/profile/detail/widgets/activity.dart';
import 'package:step_by_step/screens/profile/detail/widgets/info.dart';
import 'package:step_by_step/screens/profile/form/profile_form_model.dart';
import 'package:step_by_step/screens/profile/form/profile_form_screen.dart';
import 'package:step_by_step/widgets/common/app_bar_list.dart';
import 'package:step_by_step/screens/home/widgets/bottom_menu.dart';
import 'package:step_by_step/screens/home/widgets/left_menu.dart';
import 'package:provider/provider.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  ProfileDetailModel? model;

  @override
  void initState() {
    super.initState();
    model = context.read<ProfileDetailModel>();
    reload();
  }

  void reload() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model?.loadData();
    });
  }

  Future _navigateToEdit(BuildContext context) async {
    if (model?.user == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileFormScreen(profile: model?.user)),
    ).then((result) {
      reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainMenuDrawer(),
      appBar: ListAppBar(
        title: '',
        actions: [
          Consumer<ProfileFormModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _navigateToEdit(context),
                tooltip: 'Редактировать',
              );
            },
          ),
        ],
      ),
      endDrawer: const ProfileDetailFilters(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // Карточка
                const ProfileInfo(),

                // Опыт
                const ProfileDetailLevel(),
                
                // Активность
                const ProfileDetailActivity(),

                // Характеристики
                const ProfileDetailChars(),
                
                OutlinedButton(onPressed: model?.recalcStats, child: CustomText('Перерасчет', noShadow: true,))
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: MainBottomMenu(),
    );
  }
}
