import 'package:chaos_control/models/project.dart';
import 'package:chaos_control/screens/projects/detail/project_detail_screen.dart';
import 'package:chaos_control/screens/projects/list/widgets/appbar.dart';
import 'package:chaos_control/screens/projects/list/widgets/list.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_list.dart';
import 'package:chaos_control/widgets/common/tree_list/tree_record.dart';
import 'package:flutter/material.dart';
import 'package:chaos_control/screens/projects/form/project_form_screen.dart';
import 'package:chaos_control/screens/projects/list/project_list_model.dart';
import 'package:chaos_control/screens/projects/list/widgets/filters.dart';
import 'package:chaos_control/widgets/common/app_bar_list.dart';
import 'package:chaos_control/widgets/common/custom_floating_action_button.dart';
import 'package:chaos_control/widgets/common/search_string.dart';
import 'package:chaos_control/screens/home/widgets/bottom_menu.dart';
import 'package:chaos_control/screens/home/widgets/left_menu.dart';
import 'package:provider/provider.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  final TextEditingController _searchController = TextEditingController();
  late ProjectListModel model;

  @override
  void initState() {
    super.initState();
    model = context.read<ProjectListModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      model.loadData();
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
      appBar: ProjectListAppbar(searchController: _searchController),
      body: const ProjectListList(),

      floatingActionButton: model.isSelectionMode
          ? null
          : CustomFloatingActionButton(
              openFormCreate: _create,
              tooltip: 'Создать проект',
            ),

      endDrawer: ProjectListFilters(),
      drawer: const MainMenuDrawer(),
      bottomNavigationBar: const MainBottomMenu(),
    );
  }

  

  void _create() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProjectFormScreen()),
    ).then((_) {
      if (context.mounted) model.loadData();
    });
  }
}
