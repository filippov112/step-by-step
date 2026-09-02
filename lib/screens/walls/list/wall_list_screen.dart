import 'package:chaos_control/screens/walls/list/widgets/appbar.dart';
import 'package:chaos_control/screens/walls/list/widgets/filters.dart';
import 'package:chaos_control/screens/walls/list/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/walls/list/wall_list_model.dart';
import 'package:chaos_control/screens/home/widgets/bottom_menu.dart';
import 'package:chaos_control/screens/home/widgets/left_menu.dart';
import 'package:provider/provider.dart';

class WallListScreen extends StatefulWidget {
  const WallListScreen({super.key});

  @override
  State<WallListScreen> createState() => _WallListScreenState();
}

class _WallListScreenState extends State<WallListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WallListModel>().loadData();
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
      appBar: WallListAppbar(searchController: _searchController),
      body: const WallListList(),
      endDrawer: const WallListFilters(),
      drawer: const MainMenuDrawer(),
      bottomNavigationBar: const MainBottomMenu(),
    );
  }
}
