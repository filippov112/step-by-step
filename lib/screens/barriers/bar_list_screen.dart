import 'package:chaos_control/screens/barriers/widgets/form.dart';
import 'package:chaos_control/screens/barriers/widgets/open_button.dart';
import 'package:chaos_control/screens/barriers/widgets/appbar.dart';
import 'package:chaos_control/screens/barriers/widgets/filters.dart';
import 'package:chaos_control/screens/barriers/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/barriers/bar_list_model.dart';
import 'package:chaos_control/screens/home/widgets/bottom_menu.dart';
import 'package:chaos_control/screens/home/widgets/left_menu.dart';
import 'package:provider/provider.dart';

class BarrierListScreen extends StatefulWidget {
  const BarrierListScreen({super.key});

  @override
  State<BarrierListScreen> createState() => _BarrierListScreenState();
}

class _BarrierListScreenState extends State<BarrierListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BarrierListModel>().loadData();
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
      appBar: BarrierListAppbar(searchController: _searchController),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Expanded(child: BarrierList(),),
         
          BarrierForm(),
        ],
      ),
      endDrawer: const BarrierListFilters(),
      drawer: const MainMenuDrawer(),
      bottomNavigationBar: const MainBottomMenu(),
    );
  }
}
