import 'package:chaos_control/screens/targets/list/widgets/appbar.dart';
import 'package:chaos_control/screens/targets/list/widgets/bottom_filter.dart';
import 'package:chaos_control/screens/targets/list/widgets/filters.dart';
import 'package:chaos_control/screens/targets/list/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/targets/list/target_list_model.dart';
import 'package:chaos_control/screens/home/widgets/bottom_menu.dart';
import 'package:chaos_control/screens/home/widgets/left_menu.dart';
import 'package:provider/provider.dart';

class TargetListScreen extends StatefulWidget {
  const TargetListScreen({super.key});

  @override
  State<TargetListScreen> createState() => _TargetListScreenState();
}

class _TargetListScreenState extends State<TargetListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TargetListModel>().loadData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TargetListAppbar(searchController: _searchController),
      body: Column(
          children: [
            Expanded(child: const TargetListList()),
            const TargetListBottomFilters(),
          ],
        ),
      endDrawer: const TargetListFilters(),
      drawer: const MainMenuDrawer(),
      bottomNavigationBar: const MainBottomMenu(),
    );
  }
}
