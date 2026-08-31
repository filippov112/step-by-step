import 'package:flutter/material.dart';
import 'package:chaos_control/models/wall_reward.dart';
import 'package:chaos_control/screens/walls/form/widgets/reward_tile.dart';
import 'package:chaos_control/widgets/common/empty_list_screen.dart';

// Форма поиска и выбора наград за задачи в виде опыта и времени
class RewardDialog extends StatefulWidget {
  final String taskId;
  final List<Reward> selectedRewards;
  final Function(List<Reward>) onConfirm;

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
  List<Reward> _selected = [];
  Reward? currentReward;
  int? currentRowIndexRewards;
  
  var expController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedRewards);
  }

  @override
  void dispose() {
    expController.dispose();
    super.dispose();
  }

  void _selectReward(Reward reward, int index) {
    setState(() {
      currentRowIndexRewards = index;
      currentReward = reward;
      expController.text = reward.efforts.toString();
    });
  }


  void _addReward() {
    _removeReward();
    if (expController.text.isEmpty) return;
    var exp = expController.text.isEmpty ? 0 : int.parse(expController.text);

    setState(() {
      currentReward = Reward.create(
        taskId: widget.taskId, 
        efforts: exp, 
      );
      _selected.add(currentReward!);
    });
  }

  void _removeReward() {
    if (currentReward == null) return;
    setState(() {
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
          
          SelectedRewardsPanel(
            rewards: _selected, 
            currentRowIndex: currentRowIndexRewards, 
            clickCallback: _selectReward,
          ),
         
          
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(8,0,8,0), 
            child: Row(children: [
              
              Expanded(child: TextFormField(
                controller: expController,
                decoration: const InputDecoration(labelText: 'Опыт'),
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


class SelectedRewardsPanel extends StatelessWidget {
  final int? currentRowIndex;
  final List<Reward> rewards;
  final Function(Reward, int) clickCallback;

  const SelectedRewardsPanel({
    super.key,
    required this.rewards,
    required this.currentRowIndex,
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
          Reward reward = rewards[index];
          
          return RewardTile(
            isClass: true,
            title: '', 
            exp: reward.efforts, 
            time: 0, 
            selected: true,
            focused: currentRowIndex == index,
            clickCallback: () => clickCallback(reward, index)
          );
        },
      )
    );
  }
}
