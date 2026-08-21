import 'package:flutter/material.dart';
import 'package:life_game/models/class_skill.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/screens/classes/form/class_form_model.dart';
import 'package:life_game/screens/classes/form/widgets/skill_tile.dart';
import 'package:life_game/widgets/common/empty_list_screen.dart';
import 'package:provider/provider.dart';

// Форма поиска и выбора навыков для связи с классом
class SkillDialog extends StatefulWidget {
  final String classId;
  final List<ClassSkill> selectedSkills;
  final Function(List<ClassSkill>) onConfirm;

  const SkillDialog({
    super.key,
    required this.classId,
    required this.selectedSkills,
    required this.onConfirm,
  });

  @override
  State<SkillDialog> createState() => _SkillDialogState();
}

class _SkillDialogState extends State<SkillDialog> {
  List<ClassSkill> _selected = [];
  Set<String> _selectedSkillsId = {};
  Skill? currentSkill;
  ClassSkill? currentClassSkill;
  
  String _query = '';
  int tabIndex = 0;
  
  int? currentRowIndexClassSkills;
  int? currentRowIndexSkills;
  
  List<Skill> _filteredSkills = [];
  List<Skill> _allSkills = [];


  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedSkills);
    _selectedSkillsId = _selected.map((e) => e.skillId).toSet();

    _allSkills = _getAllSkills();
    _filteredSkills = _allSkills.toList();
  }

  List<Skill> _getAllSkills() {
    final viewModel = context.read<ClassFormModel>();
    return viewModel.allSkills;
  }

  void _applyFilter() {
    if (_query.isEmpty) {
      _filteredSkills = _allSkills.toList();
    } else {
      _filteredSkills = _allSkills.where((skill) =>
        skill.title.toLowerCase().contains(_query.toLowerCase())
      ).toList();
    }
    setState(() {});
  }

  void _selectClassSkill(Skill? skill, ClassSkill cs, int index) {
    setState(() {
      currentRowIndexSkills = null;
      currentRowIndexClassSkills = index;
      currentSkill = skill;
      currentClassSkill = cs;
    });
  }

  void _selectSkill(Skill? skill, ClassSkill? cs, int index) {
    setState(() {
      currentRowIndexSkills = index;
      currentRowIndexClassSkills = null;
      currentSkill = skill;

      if (cs != null) {
        currentClassSkill = cs;
      } else {
        currentClassSkill = null;
      }
    });
  }


  void _addClassSkill() {
    _removeClassSkill();
    if (currentSkill == null || _selectedSkillsId.contains(currentSkill!.id)) return;

    setState(() {
      currentClassSkill = ClassSkill(
        skillId: currentSkill!.id, 
        classId: widget.classId, 
      );
      _selected.add(currentClassSkill!);
      _selectedSkillsId.add(currentSkill!.id);
    });
  }

  void _removeClassSkill() {
    if (currentClassSkill == null || !_selectedSkillsId.contains(currentClassSkill!.skillId)) return;
    setState(() {
      _selectedSkillsId.remove(currentClassSkill!.skillId);
      _selected.remove(currentClassSkill);
      currentClassSkill = null;
    });
  }

  void _save() {
    widget.onConfirm(_selected);
    Navigator.of(context).pop();
  }

  void _clear() {
    setState(() {
      _selected.clear();
      _selectedSkillsId.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        children: [
          
          NavigationBar(
            onDestinationSelected: (index) => setState(() => tabIndex = index),
            selectedIndex: tabIndex,
            destinations: [
              NavigationDestination(icon: Icon(Icons.card_giftcard), label: 'Добавленные'),
              NavigationDestination(icon: Icon(Icons.star_border), label: 'Поиск'),
            ]
          ),
          
          const Divider(),

          if (tabIndex != 0) 
            // Поиск
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:4),
              child: 
              TextField(
                decoration: InputDecoration(
                  hintText: 'Поиск...',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onChanged: (value) {
                  _query = value;
                  _applyFilter();
                },
              ),
            ),
          
          if (tabIndex == 0) SelectedClassSkillsPanel(
            selectedClassSkills: _selected, 
            currentRowIndex: currentRowIndexClassSkills, 
            allSkills: _allSkills, 
            clickCallback: _selectClassSkill,
          ),
          if (tabIndex == 1) SearchSkillsPanel(
            currentRowIndex: currentRowIndexSkills, 
            selectedClassSkills: _selected, 
            filteredList: _filteredSkills, 
            selectedIdSet: _selectedSkillsId, 
            clickCallback: _selectSkill,
            ),
          
          Padding(
            padding: EdgeInsetsGeometry.all(8), 
            child: Row(children: [
              Expanded(child: ElevatedButton(onPressed: _removeClassSkill, child: Text('Удалить')),),
              const SizedBox(width: 8),
              Expanded(child: ElevatedButton(onPressed: _addClassSkill, child: Text('Добавить')),)
            ],)
          ),
          Padding(
            padding:EdgeInsetsGeometry.fromLTRB(8,0,8,8), 
            child: Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: _clear, child: Text('Очистить'),),),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: _save, child: Text('Готово'),),),
              ],
            ),
          ),
        ],
      ),
    );
    
  }

}

class SearchSkillsPanel extends StatelessWidget {
  final int? currentRowIndex;
  final List<ClassSkill> selectedClassSkills;
  final List<Skill> filteredList;
  final Set<String> selectedIdSet;
  final Function(Skill?, ClassSkill?, int) clickCallback;
  
  const SearchSkillsPanel({
    super.key, 
    required this.currentRowIndex,
    required this.selectedClassSkills,
    required this.filteredList, 
    required this.selectedIdSet, 
    required this.clickCallback
  });
  
  @override
  Widget build(BuildContext context) {
    return Expanded( child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          Expanded(
            child: filteredList.isEmpty
          ? ListView(children: [
              EmptyListScreen(
                title: 'Навыки не найдены', 
                subtitle: 'Попробуйте изменить запрос или добавьте навык', 
                icon: Icons.star_border
              )
            ],)
          : Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  Skill skill = filteredList[index];
                  final isSelected = selectedIdSet.contains(skill.id);

                  ClassSkill? cs;
                  if (isSelected) {
                    cs = selectedClassSkills.firstWhere((rew) => rew.skillId == skill.id);
                  }
                  return SkillTile(
                    title: skill.title,
                    selected: isSelected, 
                    focused: currentRowIndex == index,
                    clickCallback: () => clickCallback(skill, cs, index)
                  );
                },
              )
            ) 
          )
        ],
      )
    );
  }

}

class SelectedClassSkillsPanel extends StatelessWidget {

  final int? currentRowIndex;
  final List<ClassSkill> selectedClassSkills;
  final List<Skill> allSkills;
  final Function(Skill?, ClassSkill, int) clickCallback;

  const SelectedClassSkillsPanel({
    super.key,
    required this.selectedClassSkills,
    required this.currentRowIndex,
    required this.allSkills,
    required this.clickCallback
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(child: 
      selectedClassSkills.isEmpty
      ? ListView(children: [
          EmptyListScreen(
            title: 'Навыки не добавлены', 
            subtitle: 'Выберите навык во вкладке поиска', 
            icon: Icons.star_outline
          )
      ],)
      : ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8),
        itemCount: selectedClassSkills.length,
        itemBuilder: (context, index) {
          ClassSkill cs = selectedClassSkills[index];
          Skill skill = allSkills.firstWhere((skl) => skl.id == cs.skillId);
          
          return SkillTile(
            title: skill.title, 
            selected: true,
            focused: currentRowIndex == index,
            clickCallback: () => clickCallback(skill, cs, index)
          );
        },
      )
    );
  }
}
