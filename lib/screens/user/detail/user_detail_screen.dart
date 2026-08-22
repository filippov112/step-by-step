import 'package:flutter/material.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/screens/user/detail/user_detail_model.dart';
import 'package:life_game/screens/user/detail/widgets/experience.dart';
import 'package:life_game/screens/user/detail/widgets/time.dart';
import 'package:life_game/screens/user/detail/widgets/user_activity.dart';
import 'package:life_game/screens/user/detail/widgets/user_info.dart';
import 'package:life_game/screens/user/form/user_form_model.dart';
import 'package:life_game/screens/user/form/user_form_screen.dart';
import 'package:life_game/widgets/filters/filter_section.dart';
import 'package:life_game/widgets/filters/filters_drawer.dart';
import 'package:life_game/widgets/common/app_bar_list.dart';
import 'package:life_game/screens/home/widgets/bottom_menu.dart';
import 'package:life_game/screens/home/widgets/left_menu.dart';
import 'package:provider/provider.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  UserDetailModel? model;

  @override
  void initState() {
    super.initState();
    model = context.read<UserDetailModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model?.loadData();
    });
  }

  Future _navigateToEdit(BuildContext context) async {
    if (model?.user == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserFormScreen(isEdit: true)),
    ).then((result) async {
      await model?.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user =
        context.select<UserDetailModel, User?>((model) => model.user) ??
        User(dateBirth: DateTime(2000));


    final StatPeriod selectedPeriod = context
        .select<UserDetailModel, StatPeriod>((model) => model.selectedPeriod);
    final setPeriodFilter = context.read<UserDetailModel>().setPeriodFilter;



    return Scaffold(
      drawer: MainMenuDrawer(),
      appBar: buildMainAppBar<User>(
        context,
        title: 'Профиль',
        isRootWidgetTree: true,
        isSelectionMode: false,
        selectAll: () {},
        selectedIds: [],
        filteredList: [],
        deleteSelected: () {},
        clearSelection: () {},
        actions: [
          Consumer<UserFormModel>(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Userinfo(user: user),

                // Активность
                const UserDetailActivity(),

                // Опыт
                const UserDetailExp(),

                // Время
                const UserDetailTime(),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: MainBottomMenu(),
    );
  }
}
