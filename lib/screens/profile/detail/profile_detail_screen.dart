import 'package:chaos_control/screens/profile/detail/widgets/chars.dart';
import 'package:chaos_control/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/models/profile.dart';
import 'package:chaos_control/screens/profile/detail/profile_detail_model.dart';
import 'package:chaos_control/screens/profile/detail/widgets/spirit.dart';
import 'package:chaos_control/screens/profile/detail/widgets/activity.dart';
import 'package:chaos_control/screens/profile/detail/widgets/info.dart';
import 'package:chaos_control/screens/profile/form/profile_form_model.dart';
import 'package:chaos_control/screens/profile/form/profile_form_screen.dart';
import 'package:chaos_control/widgets/filters/filter_section.dart';
import 'package:chaos_control/widgets/filters/filters_drawer.dart';
import 'package:chaos_control/widgets/common/app_bar_list.dart';
import 'package:chaos_control/screens/home/widgets/bottom_menu.dart';
import 'package:chaos_control/screens/home/widgets/left_menu.dart';
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
    final user =
        context.select<ProfileDetailModel, Profile?>((model) => model.user) ??
        Profile();


    final StatPeriod selectedPeriod = context
        .select<ProfileDetailModel, StatPeriod>((model) => model.selectedPeriod);
    final setPeriodFilter = context.read<ProfileDetailModel>().setPeriodFilter;



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
      endDrawer: FiltersDrawer(
        filters: [
          FilterSection(
            title: 'Глубина анализа',
            icon: Icons.calendar_month,
            children: DropdownButtonFormField<StatPeriod>(
              items: [
                const DropdownMenuItem(
                  value: StatPeriod.threeMonth,
                  child: Text('3 месяца'),
                ),
                const DropdownMenuItem(
                  value: StatPeriod.oneMonth,
                  child: Text('1 месяц'),
                ),
                const DropdownMenuItem(
                  value: StatPeriod.oneWeek,
                  child: Text('1 неделя'),
                ),
                const DropdownMenuItem(
                  value: StatPeriod.oneDay,
                  child: Text('1 день'),
                ),
              ],
              initialValue: selectedPeriod,
              onChanged: (v) => setPeriodFilter(v ?? StatPeriod.oneMonth),
            ),
          ),
        ],
      ),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // Карточка
                ProfileInfo(user: user),

                // Опыт
                const ProfileDetailSpirit(),
                
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
