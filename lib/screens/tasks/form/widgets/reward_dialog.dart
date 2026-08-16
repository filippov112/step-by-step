import 'package:flutter/material.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/task_reward.dart';
import 'package:life_game/screens/tasks/form/task_form_model.dart';
import 'package:life_game/themes/solo_leveling_theme.dart';
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
  List<String> _selectedId = [];
  Skill? currentSkill;
  TaskReward? currentReward;
  String _query = '';
  int tabIndex = 0;
  int? currentRowIndexRewards;
  int? currentRowIndexSkills;
  List<Skill> _filtered = [];
  List<Skill> _allSkills = [];

  var expController = TextEditingController();
  var timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedRewards);
    _selectedId = _selected.map((e) => e.skillId).toList();
    _filtered = _getAll();
    _allSkills = _getAll();
  }

  @override
  void dispose() {
    expController.dispose();
    timeController.dispose();
    super.dispose();
  }

  List<Skill> _getAll() {
    final viewModel = context.read<TaskFormModel>();
    return viewModel.allSkills;
  }

  void _applyFilter() {
    if (_query.isEmpty) {
      _filtered = _allSkills.toList();
    } else {
      _filtered = _allSkills.where((skill) =>
        skill.title.toLowerCase().contains(_query.toLowerCase())
      ).toList();
    }
    setState(() {});
  }

  void _selectSkillReward(Skill skill, TaskReward? reward, int index) {
    setState(() {
      currentRowIndexSkills = null;
      currentRowIndexRewards = index;
      currentSkill = skill;
      if (reward != null) {
        currentReward = reward;
        timeController.text = reward.time.toString();
        expController.text = reward.experience.toString();
      } else {
        currentReward = null;
      }
    });
  }

  void _selectSkillSkills(Skill skill, TaskReward? reward, int index) {
    setState(() {
      currentRowIndexSkills = index;
      currentRowIndexRewards = null;
      currentSkill = skill;
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
    setState(() {
      if (currentSkill != null && 
        !_selectedId.contains(currentSkill!.id) && 
        (expController.text.isNotEmpty || timeController.text.isNotEmpty)) 
      {
        currentReward = TaskReward.create(
          skillId: currentSkill!.id, 
          taskId: widget.taskId, 
          experience: expController.text.isEmpty ? 0 : int.parse(expController.text), 
          time: timeController.text.isEmpty ? 0 : int.parse(timeController.text)
        );
        _selected.add(currentReward!);
        _selectedId.add(currentSkill!.id);
      }
    });
  }

  void _removeReward() {
    setState(() {
      if (currentReward != null && _selectedId.contains(currentReward!.skillId)) {
        _selected.remove(currentReward);
        _selectedId.remove(currentReward!.skillId);
        currentReward = null;
      }
    });
  }

  void _saveRewards() {
    widget.onConfirm(_selected);
    Navigator.of(context).pop();
  }

  void _clearRewards() {
    setState(() {
      _selected.clear();
      _selectedId.clear();
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
              NavigationDestination(icon: Icon(Icons.star_border), label: 'Навыки')
            ]
          ),
          
          const Divider(),
          
          Expanded(
            child: tabIndex == 1 ? buildSearchPanel() : buildRewardsPanel()     
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


  Widget buildSearchPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Поиск
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:4),
          child: 
          TextField(
            decoration: InputDecoration(
              hintText: 'Поиск навыков...',
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            onChanged: (value) {
              _query = value;
              _applyFilter();
            },
          ),
        ),

        Expanded(
          child: _filtered.isEmpty
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
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                Skill skill = _filtered[index];
                final isSelected = _selectedId.contains(skill.id);
                int exp = 0;
                int time = 0;
                TaskReward? reward;
                if (isSelected) {
                  reward = _selected.firstWhere((rew) => rew.skillId == skill.id);
                  time = reward.time;
                  exp = reward.experience;
                }
                return buildTile(
                  context,
                  title: skill.title, 
                  exp: exp, 
                  time: time, 
                  selected: isSelected, 
                  focused: currentRowIndexSkills == index,
                  clickCallback: () =>_selectSkillSkills(skill, reward, index)
                );
              },
            )
          ) 
        )
        
      ],
    );
  }

  Widget buildRewardsPanel() {
    return _selected.isEmpty
    ? ListView(children: [
        EmptyListScreen(
          title: 'Награды не добавлены', 
          subtitle: 'Выберите навык и укажите кол-во опыта/времени', 
          icon: Icons.card_giftcard
        )
    ],)
    : ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8),
        itemCount: _selected.length,
        itemBuilder: (context, index) {
          TaskReward reward = _selected[index];
          Skill skill = _allSkills.firstWhere((skl) => skl.id == reward.skillId);
          
          return buildTile(
            context,
            title: skill.title, 
            exp: reward.experience, 
            time: reward.time, 
            selected: true,
            focused: currentRowIndexRewards == index,
            clickCallback: () =>_selectSkillReward(skill, reward, index)
          );
        },
      );
  }
}

Widget buildTile(
  BuildContext context,
  {
    required String title,
    required int exp,
    required int time,
    required bool selected,
    required bool focused,
    VoidCallback? clickCallback
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Container(
      decoration: BoxDecoration(
        color: focused ? Theme.of(context).focusColor.withValues(alpha:0.5) : 
          selected ? Theme.of(context).dividerColor.withValues(alpha: 0.5) 
            : Theme.of(context).dividerColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: InkWell(
        canRequestFocus: true,
        enableFeedback: clickCallback != null,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        onTap: clickCallback,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(title),),
              SizedBox(width: 8,),
              if (selected)
                Text('$exp / $time')
            ],
          ),
        ),
      ),
    )
  );
}