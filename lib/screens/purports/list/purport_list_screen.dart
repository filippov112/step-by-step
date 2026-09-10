import 'package:chaos_control/screens/purports/list/widgets/appbar.dart';
import 'package:chaos_control/screens/purports/list/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/purports/list/purport_list_model.dart';
import 'package:chaos_control/screens/purports/list/widgets/filters.dart';
import 'package:chaos_control/screens/home/widgets/bottom_menu.dart';
import 'package:chaos_control/screens/home/widgets/left_menu.dart';
import 'package:provider/provider.dart';

class PurportListScreen extends StatefulWidget {
  const PurportListScreen({super.key});

  @override
  State<PurportListScreen> createState() => _PurportListScreenState();
}

class _PurportListScreenState extends State<PurportListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PurportListModel>().loadData();
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
      appBar: PurportListAppbar(searchController: _searchController),
      body: const PurportListList(),
      endDrawer: const PurportListFilters(),
      drawer: const MainMenuDrawer(),
      bottomNavigationBar: const MainBottomMenu(),
    );
  }
}
