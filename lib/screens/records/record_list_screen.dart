import 'package:chaos_control/screens/records/record_form_screen.dart';
import 'package:chaos_control/screens/records/widgets/appbar.dart';
import 'package:chaos_control/screens/records/widgets/filters.dart';
import 'package:chaos_control/screens/records/widgets/list.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/records/record_list_model.dart';
import 'package:chaos_control/screens/home/widgets/bottom_menu.dart';
import 'package:chaos_control/screens/home/widgets/left_menu.dart';
import 'package:provider/provider.dart';

class RecordListScreen extends StatefulWidget {
  const RecordListScreen({super.key});

  @override
  State<RecordListScreen> createState() => _RecordListScreenState();
}

class _RecordListScreenState extends State<RecordListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecordListModel>().loadData();
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
      appBar: RecordListAppbar(searchController: _searchController),
      body: Stack(
        children: [
          RecordList(),
          Column(
            children: [
              const Expanded(child: SizedBox()),
              RecordForm(),
            ],
          ),
        ],
      ),
      endDrawer: const RecordListFilters(),
      drawer: const MainMenuDrawer(),
      bottomNavigationBar: const MainBottomMenu(),
    );
  }
}
