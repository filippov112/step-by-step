import 'package:flutter/material.dart';
import 'package:life_game/models/user.dart';
import 'package:life_game/screens/user/detail/user_detail_model.dart';
import 'package:life_game/screens/user/detail/widgets/user_activity.dart';
import 'package:life_game/screens/user/detail/widgets/user_progress.dart';
import 'package:life_game/screens/user/detail/widgets/user_info.dart';
import 'package:life_game/screens/user/form/user_form_model.dart';
import 'package:life_game/screens/user/form/user_form_screen.dart';
import 'package:life_game/services/exp_calculator.dart';
import 'package:life_game/widgets/filters/filter_section.dart';
import 'package:life_game/widgets/filters/filters_drawer.dart';
import 'package:life_game/widgets/common/app_bar_list.dart';
import 'package:life_game/screens/home/widgets/bottom_menu.dart';
import 'package:life_game/screens/home/widgets/left_menu.dart';
import 'package:provider/provider.dart';
import 'package:snap_chart/snap_chart.dart';

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
    User user =
        context.select<UserDetailModel, User?>((model) => model.user) ??
        User(dateBirth: DateTime(2000));

    final Map<DateTime, int> tasks = context
        .select<UserDetailModel, Map<DateTime, int>>((model) => model.tasks);
    final Map<DateTime, int> experiences = context
        .select<UserDetailModel, Map<DateTime, int>>(
          (model) => model.experiences,
        );
    final Map<DateTime, int> times = context
        .select<UserDetailModel, Map<DateTime, int>>((model) => model.times);
    final int maxExp = context.select<UserDetailModel, int>(
      (model) => model.maxExp,
    );
    final int maxTime = context.select<UserDetailModel, int>(
      (model) => model.maxTime,
    );
    final int deltaExp = context.select<UserDetailModel, int>(
      (model) => model.deltaExp,
    );
    final int deltaTime = context.select<UserDetailModel, int>(
      (model) => model.deltaTime,
    );
    final int maxTasksCount = context.select<UserDetailModel, int>(
      (model) => model.maxTasksCount,
    );
    final DateTime firstDay = context.select<UserDetailModel, DateTime>(
      (model) => model.firstDay,
    );
    final DateTime lastDay = context.select<UserDetailModel, DateTime>(
      (model) => model.lastDay,
    );
    final List<SnapSpot> progressExpData = context
        .select<UserDetailModel, List<SnapSpot>>(
          (model) => model.progressExpData,
        );
    final List<SnapSpot> progressTimeData = context
        .select<UserDetailModel, List<SnapSpot>>(
          (model) => model.progressTimeData,
        );

    final StatPeriod selectedPeriod = context
        .select<UserDetailModel, StatPeriod>((model) => model.selectedPeriod);
    final setPeriodFilter = context.read<UserDetailModel>().setPeriodFilter;

    var expWidget = UserProgress(
      level: ExpCalculator.getLevel(user.experience),
      deltaValue: deltaExp.toDouble(),
      currentValue: ExpCalculator.getRemains(user.experience).toDouble(),
      title: 'Эксперт',
      nextLevel: ExpCalculator.getRequirements(user.experience).toDouble(),
      icon: Icons.wb_incandescent,
      data: progressExpData,
      firstDay: firstDay,
      lastDay: lastDay,
    );

    var timeWidget = UserProgress(
      level: ExpCalculator.getLevel(user.time),
      deltaValue: deltaTime.toDouble(),
      currentValue: ExpCalculator.getRemains(user.time).toDouble(),
      title: 'Мастер',
      nextLevel: ExpCalculator.getRequirements(user.time).toDouble(),
      icon: Icons.schedule_outlined,
      data: progressTimeData,
      firstDay: firstDay,
      lastDay: lastDay,
    );

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

                UserActivity(
                  tasks: tasks,
                  experiences: experiences,
                  times: times,
                  maxExp: maxExp,
                  maxTime: maxTime,
                  deltaExp: deltaExp,
                  deltaTime: deltaTime,
                  maxTasksCount: maxTasksCount,
                  firstDay: firstDay,
                  lastDay: lastDay,
                ),

                // Опыт
                expWidget,

                // Время
                timeWidget,
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: MainBottomMenu(),
    );
  }
}
