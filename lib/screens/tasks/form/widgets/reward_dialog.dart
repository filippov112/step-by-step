import 'package:flutter/material.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/task_reward.dart';
import 'package:life_game/screens/tasks/form/task_form_model.dart';
import 'package:life_game/screens/tasks/form/widgets/reward_tile.dart';
import 'package:life_game/widgets/common/empty_list_screen.dart';
import 'package:provider/provider.dart';

// Форма поиска и выбора наград за задачи в виде опыта и времени
class RewardDialog extends StatefulWidget {
  final String taskId;
  final List<TaskReward> selectedRewards;
  final Function(List<TaskReward>) onConfirm;

  const RewardDialog({
    super.key,
    required this.taskId,
    required this.selectedRewards,
    required this.onConfirm,
  });

  @override
  State<RewardDialog> createState() => _RewardDialogState();
}

class _RewardDialogState extends State<RewardDialog> {
  List<TaskReward> _selected = [];
  
  Set<String> _selectedSkillsId = {};
  Set<String> _selectedClassesId = {};
  
  Skill? currentSkill;
  Class? currentClass;
  TaskReward? currentReward;
  
  String _query = '';
  int tabIndex = 0;
  
  int? currentRowIndexRewards;
  int? currentRowIndexSkills;
  int? currentRowIndexClasses;
  
  List<Skill> _filteredSkills = [];
  List<Skill> _allSkills = [];
  
  List<Class> _allClasses = [];
  List<Class> _filteredClasses = [];

  var expController = TextEditingController();
  var timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedRewards);
    _selectedSkillsId = _selected.map((e) => e.skillId).where((e) => e != null).map((e) => e ?? '').toSet();
    _selectedClassesId = _selected.map((e) => e.classId).where((e) => e != null).map((e) => e ?? '').toSet();
    
    _allSkills = _getAllSkills();
    _filteredSkills = _allSkills.toList();

    _allClasses = _getAllClasses();
    _filteredClasses = _allClasses.toList();
  }

  @override
  void dispose() {
    expController.dispose();
    timeController.dispose();
    super.dispose();
  }

  List<Skill> _getAllSkills() {
    final viewModel = context.read<TaskFormModel>();
    return viewModel.allSkills;
  }

  List<Class> _getAllClasses() {
    final viewModel = context.read<TaskFormModel>();
    return viewModel.allClasses;
  }

  void _applyFilter() {
    if (_query.isEmpty) {
      _filteredSkills = _allSkills.toList();
      _filteredClasses = _allClasses.toList();
    } else {
      _filteredSkills = _allSkills.where((skill) =>
        skill.title.toLowerCase().contains(_query.toLowerCase())
      ).toList();
      _filteredClasses = _allClasses.where((cls) =>
        cls.title.toLowerCase().contains(_query.toLowerCase())
      ).toList();
    }
    setState(() {});
  }

  void _selectReward(Skill? skill, Class? cls, TaskReward reward, int index) {
    setState(() {
      currentRowIndexSkills = null;
      currentRowIndexClasses = null;
      currentRowIndexRewards = index;
      currentSkill = skill;
      currentClass = cls;

      currentReward = reward;
      timeController.text = reward.time.toString();
      expController.text = reward.experience.toString();
    });
  }

  void _selectSkill(Skill? skill, TaskReward? reward, int index) {
    setState(() {
      currentRowIndexSkills = index;
      currentRowIndexRewards = null;
      currentRowIndexClasses = null;
      currentSkill = skill;
      currentClass = null;

      if (reward != null) {
        currentReward = reward;
        timeController.text = reward.time.toString();
        expController.text = reward.experience.toString();
      } else {
        currentReward = null;
      }
    });
  }

  void _selectClass(Class? cls, TaskReward? reward, int index) {
    setState(() {
      currentRowIndexSkills = null;
      currentRowIndexRewards = null;
      currentRowIndexClasses = index;
      currentSkill = null;
      currentClass = cls;
      
      if (reward != null) {
        currentReward = reward;
        timeController.text = reward.time.toString();
        expController.text = reward.experience.toString();
      } else {
        currentReward = null;
      }
    });
  }

  void _addReward() {
    _removeReward();
    if (expController.text.isEmpty && timeController.text.isEmpty) return;
    if (currentSkill == null && currentClass == null) return;

    var exp = expController.text.isEmpty ? 0 : int.parse(expController.text);
    var time = timeController.text.isEmpty ? 0 : int.parse(timeController.text);

    setState(() {
      if (currentSkill != null && !_selectedSkillsId.contains(currentSkill!.id)) 
      {
        currentReward = TaskReward.create(
          skillId: currentSkill!.id, 
          taskId: widget.taskId, 
          experience: exp, 
          time: time
        );
        _selected.add(currentReward!);
        _selectedSkillsId.add(currentSkill!.id);
      } else 
      if (currentClass != null && !_selectedClassesId.contains(currentClass!.id)) 
      {
        currentReward = TaskReward.create(
          classId: currentClass!.id, 
          taskId: widget.taskId, 
          experience: exp, 
          time: time
        );
        _selected.add(currentReward!);
        _selectedClassesId.add(currentClass!.id);
      }
    });
  }

  void _removeReward() {

    if (currentReward == null) return;

    setState(() {
      if (_selectedSkillsId.contains(currentReward!.skillId)) {
        _selectedSkillsId.remove(currentReward!.skillId);
      } else 
      if (_selectedClassesId.contains(currentReward!.classId)) {
        _selectedClassesId.remove(currentReward!.classId);
      }
      _selected.remove(currentReward);
      currentReward = null;
    });
  }

  void _saveRewards() {
    widget.onConfirm(_selected);
    Navigator.of(context).pop();
  }

  void _clearRewards() {
    setState(() {
      _selected.clear();
      _selectedSkillsId.clear();
      _selectedClassesId.clear();
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
              NavigationDestination(icon: Icon(Icons.star_border), label: 'Навыки'),
              NavigationDestination(icon: Icon(Icons.school_outlined), label: 'Классы')
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
          
          if (tabIndex == 0) SelectedRewardsPanel(
            rewards: _selected, 
            currentRowIndex: currentRowIndexRewards, 
            allClasses: _allClasses, 
            allSkills: _allSkills, 
            clickCallback: _selectReward,
          ),
          if (tabIndex == 1) SearchSkillsPanel(
            currentRowIndex: currentRowIndexSkills, 
            selectedRewards: _selected, 
            filteredList: _filteredSkills, 
            selectedIdSet: _selectedSkillsId, 
            clickCallback: _selectSkill,
            ),
          if (tabIndex == 2) SearchClassesPanel(
            currentRowIndex: currentRowIndexClasses, 
            selectedRewards: _selected, 
            filteredList: _filteredClasses, 
            selectedIdSet: _selectedClassesId, 
            clickCallback: _selectClass,
          ),
          
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(8,0,8,0), 
            child: Row(children: [
              
              Expanded(child: TextFormField(
                controller: expController,
                decoration: const InputDecoration(labelText: 'Опыт'),
                keyboardType: TextInputType.number,
              ),), 
              
              SizedBox(width: 8,),
              
              Expanded(child: TextFormField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Время (минуты)'),
                keyboardType: TextInputType.number,
              ),),
              
            ],)
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(8), 
            child: Row(children: [
              Expanded(child: ElevatedButton(onPressed: _removeReward, child: Text('Удалить')),),
              const SizedBox(width: 8),
              Expanded(child: ElevatedButton(onPressed: _addReward, child: Text('Добавить')),)
            ],)
          ),
          Padding(
            padding:EdgeInsetsGeometry.fromLTRB(8,0,8,8), 
            child: Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: _clearRewards, child: Text('Очистить'),),),
                const SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: _saveRewards, child: Text('Готово'),),),
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
  final List<TaskReward> selectedRewards;
  final List<Skill> filteredList;
  final Set<String> selectedIdSet;
  final Function(Skill?, TaskReward?, int) clickCallback;
  
  const SearchSkillsPanel({
    super.key, 
    required this.currentRowIndex,
    required this.selectedRewards,
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
                  int exp = 0;
                  int time = 0;
                  TaskReward? reward;
                  if (isSelected) {
                    reward = selectedRewards.firstWhere((rew) => rew.skillId == skill.id);
                    time = reward.time;
                    exp = reward.experience;
                  }
                  return RewardTile(
                    isClass: false,
                    title: skill.title, 
                    exp: exp, 
                    time: time, 
                    selected: isSelected, 
                    focused: currentRowIndex == index,
                    clickCallback: () => clickCallback(skill, reward, index)
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


class SearchClassesPanel extends StatelessWidget {
  final int? currentRowIndex;
  final List<TaskReward> selectedRewards;
  final List<Class> filteredList;
  final Set<String> selectedIdSet;
  final Function(Class?, TaskReward?, int) clickCallback;
  
  const SearchClassesPanel({
    super.key, 
    required this.currentRowIndex,
    required this.selectedRewards,
    required this.filteredList, 
    required this.selectedIdSet, 
    required this.clickCallback
  });
  
  @override
  Widget build(BuildContext context) {
    return Expanded(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          Expanded(
            child: filteredList.isEmpty
          ? ListView(children: [
              EmptyListScreen(
                title: 'Классы не найдены', 
                subtitle: 'Попробуйте изменить запрос или добавьте класс', 
                icon: Icons.school_outlined
              )
            ],)
          : Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  Class class_ = filteredList[index];
                  final isSelected = selectedIdSet.contains(class_.id);
                  int exp = 0;
                  int time = 0;
                  TaskReward? reward;
                  if (isSelected) {
                    reward = selectedRewards.firstWhere((rew) => rew.classId == class_.id);
                    time = reward.time;
                    exp = reward.experience;
                  }
                  return RewardTile(
                    isClass: true,
                    title: class_.title, 
                    exp: exp, 
                    time: time, 
                    selected: isSelected, 
                    focused: currentRowIndex == index,
                    clickCallback: () => clickCallback(class_, reward, index)
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


class SelectedRewardsPanel extends StatelessWidget {

  final int? currentRowIndex;
  final List<TaskReward> rewards;
  final List<Class> allClasses;
  final List<Skill> allSkills;
  final Function(Skill?, Class?, TaskReward, int) clickCallback;

  const SelectedRewardsPanel({
    super.key,
    required this.rewards,
    required this.currentRowIndex,
    required this.allClasses,
    required this.allSkills,
    required this.clickCallback
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(child: 
      rewards.isEmpty
      ? ListView(children: [
          EmptyListScreen(
            title: 'Награды не добавлены', 
            subtitle: 'Выберите навык или класс и укажите кол-во опыта/времени', 
            icon: Icons.card_giftcard
          )
      ],)
      : ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8),
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          TaskReward reward = rewards[index];
          Skill? skill;
          Class? class_;
          if (reward.classId != null) {
            class_ = allClasses.firstWhere((cls) => cls.id == reward.classId);
          } else {
            skill = allSkills.firstWhere((skl) => skl.id == reward.skillId);
          }
          bool isClass = class_ != null;
          
          return RewardTile(
            isClass: isClass,
            title: isClass ? class_.title : skill?.title ?? '', 
            exp: reward.experience, 
            time: reward.time, 
            selected: true,
            focused: currentRowIndex == index,
            clickCallback: () => clickCallback(skill, class_, reward, index)
          );
        },
      )
    );
  }
}
