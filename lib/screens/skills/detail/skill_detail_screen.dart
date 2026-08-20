// lib/screens/skills/skill_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_game/models/skill_condition.dart';
import 'package:life_game/screens/skills/detail/skill_detail_model.dart';
import 'package:life_game/screens/skills/form/skill_form_screen.dart';
import 'package:life_game/services/exp_calculator.dart';
import 'package:life_game/widgets/common/custom_image_icon.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:life_game/models/enums/skill_rang.dart';

class SkillDetailScreen extends StatefulWidget {
  final String skillId;
  
  const SkillDetailScreen({super.key, required this.skillId});

  @override
  State<SkillDetailScreen> createState() => _SkillDetailScreenState();
}

class _SkillDetailScreenState extends State<SkillDetailScreen> {
  late SkillDetailModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SkillDetailModel();
    _viewModel.loadSkill(widget.skillId);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const CustomText('Навык'),
          actions: [
            Consumer<SkillDetailModel>(
              builder: (context, viewModel, child) {
                if (viewModel.skill == null) return const SizedBox();
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _navigateToEdit(context),
                  tooltip: 'Редактировать',
                );
              },
            ),
          ],
        ),
        body: Consumer<SkillDetailModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (viewModel.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => viewModel.loadSkill(widget.skillId),
                      child: const Text('Попробовать снова'),
                    ),
                  ],
                ),
              );
            }
            
            if (viewModel.skill == null) {
              return const Center(child: Text('Навык не найден'));
            }
            
            final skill = viewModel.skill!;

            var descriptionsCard = _buildDescriptionsCard(viewModel);
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // Иконка
                  Center(
                    child: CustomImageIcon(
                      skill.icon, 
                      icon: Icons.star_border, 
                      width:64, height: 64, 
                      color: skill.rang.color
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Заголовок
                  Card(
                    margin: const EdgeInsetsGeometry.all(0),
                    child: CustomText(
                      skill.title,
                      size: 20,
                      weight: const FontWeight(500),
                      height: 1.15,
                      lines: null,
                      overflow: TextOverflow.visible,
                      padding: const EdgeInsets.all(16),
                      align: TextAlign.center,
                    ),
                  ),
                   
                  const SizedBox(height: 12),
                  
                  // Прогресс
                  _buildProgressCard(viewModel),
                  
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  
                  // Кнопка повышения ранга
                  if (viewModel.canUpgradeRank()) ...{
                    _buildUpgradeButton(viewModel),
                    const SizedBox(height: 12),
                  },
                    
                  // Описания для рангов
                  if (descriptionsCard != null) ...{
                    descriptionsCard,
                    const SizedBox(height: 12),
                  },

                  // Условия
                  if (viewModel.conditions.isNotEmpty) ...{
                    _buildConditionsCard(viewModel)
                  },
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressCard(SkillDetailModel viewModel) {
    final SkillRang rang = viewModel.skill?.rang ?? SkillRang.F;
    
    final int exp = ExpCalculator.getRemains(viewModel.skill?.experience ?? 0) ;
    final int expLevel = ExpCalculator.getLevel(viewModel.skill?.experience ?? 0) ;
    final int expReq = ExpCalculator.getRequirements(viewModel.skill?.experience ?? 0);
    final expProgress = (exp / expReq).clamp(0.0, 1.0);

    final int time = ExpCalculator.getRemains(viewModel.skill?.time ?? 0) ;
    final int timeLevel = ExpCalculator.getLevel(viewModel.skill?.time ?? 0) ;
    final int timeReq = ExpCalculator.getRequirements(viewModel.skill?.time ?? 0);
    final timeProgress = (exp / expReq).clamp(0.0, 1.0);
    
    return Column(children: [
        Card(
        margin: EdgeInsetsGeometry.all(0),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText('Ранг:'),
                  Container(
                    margin: EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: rang.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: CustomText(
                      rang.name,
                      size: 16,
                      color: rang.color,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      CustomText('Экспертность', 
        size: 18, 
        color: Theme.of(context).colorScheme.onSurface, 
        padding: EdgeInsets.fromLTRB(0,16,8,8)
      ),

      Card(
        margin: EdgeInsetsGeometry.all(0),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText('Накоплено:'),
                  CustomText('${NumberFormat('#,##0', 'en_US').format(exp)} EXP', 
                    weight: FontWeight.bold, expanded: true, padding: EdgeInsets.only(left:12), align: TextAlign.right,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText('Осталось:'),
                  CustomText('${NumberFormat('#,##0', 'en_US').format(expReq - exp)} EXP', 
                    weight: FontWeight.bold, expanded: true, padding: EdgeInsets.only(left:12), align: TextAlign.right,
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    '${NumberFormat('#,##0', 'en_US').format(expLevel)} LVL',
                    weight: FontWeight.bold
                  ),
                  CustomText('${NumberFormat("#0.00").format(expProgress * 100)}%'),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: expProgress,
                minHeight: 8,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
        ),
      ),

      CustomText('Мастерство', 
        size: 18, 
        color: Theme.of(context).colorScheme.onSurface, 
        padding: EdgeInsets.fromLTRB(0,16,8,8)
      ),

      Card(
        margin: EdgeInsetsGeometry.all(0),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText('Накоплено:'),
                  CustomText('${NumberFormat('#,##0', 'en_US').format(time)} MIN', 
                    weight: FontWeight.bold, expanded: true, padding: EdgeInsets.only(left:12), align: TextAlign.right,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText('Осталось:'),
                  CustomText('${NumberFormat('#,##0', 'en_US').format(timeReq - time)} MIN', 
                    weight: FontWeight.bold, expanded: true, padding: EdgeInsets.only(left:12), align: TextAlign.right,
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    '${NumberFormat('#,##0', 'en_US').format(timeLevel)} LVL',
                    weight: FontWeight.bold
                  ),
                  CustomText('${NumberFormat("#0.00").format(timeProgress * 100)}%'),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: timeProgress,
                minHeight: 8,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          ),
        ),
      ),
    ],);
  }

  Widget? _buildDescriptionsCard(SkillDetailModel viewModel) {
    var descs = SkillRang.values.where((rang) => _checkDescriptionTile(viewModel, rang)).map((rang) => _buildDescriptionTile(viewModel, rang));
    List<Widget> descList = [];
    for(var desc in descs) {
      descList.add(desc);
      descList.add(Divider());
    }
    if (descs.isEmpty) {
      return null;
    } 
    descList.removeLast();   

    return Card(
      margin: EdgeInsetsGeometry.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...descList,
          ],
        ),
      ),
    );
  }

  Widget _buildConditionsCard(SkillDetailModel viewModel) {
    var conditions = viewModel.conditions.map((condition) {
                      return _buildConditionTile(viewModel, condition);
                    });

    return Card(
      margin: EdgeInsetsGeometry.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...conditions
          ],
        ),
      ),
    );
  }


  Widget _buildUpgradeButton(SkillDetailModel viewModel) {
    final nextRang = viewModel.getNextRangForUpgrade();
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: ElevatedButton.icon(
        onPressed: () => _confirmUpgrade(context, viewModel),
        icon: const Icon(Icons.arrow_upward),
        label: Text(
          'Повысить ранг до ${nextRang?.name ?? ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDescriptionTile(SkillDetailModel viewModel, SkillRang rang) {
    final description = viewModel.getDescriptionForRang(rang) ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        titleTextStyle: TextStyle(fontWeight: FontWeight.normal),
        titleAlignment: ListTileTitleAlignment.top,
        leading: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(rang.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: rang.color)),
        ]),
        title: Text(description, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }

  Widget _buildConditionTile(SkillDetailModel viewModel, SkillCondition condition) {
    final isCompleted = viewModel.completedConditions[condition.id] ?? false;
    
    return Card(
      child: ListTile(
        contentPadding: EdgeInsetsGeometry.all(10),
        leading: Container(
          width: 40,
          height: 40,
          margin: EdgeInsetsGeometry.fromLTRB(8,0,0,0),
          decoration: BoxDecoration(
            color: condition.rang.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              condition.rang.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: condition.rang.color,
              ),
            ),
          ),
        ),
        title: Text(
          condition.description.isNotEmpty ? condition.description : 'Без описания',
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Theme.of(context).textTheme.titleSmall?.color : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        subtitle: condition.date != null
            ? Text('Выполнено: ${condition.date!.day}.${condition.date!.month}.${condition.date!.year}',
              style: Theme.of(context).textTheme.titleSmall
            )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: isCompleted,
              onChanged: (_) => viewModel.toggleConditionCompletion(condition.id),
            ),
          ],
        ),
        onTap: () => viewModel.toggleConditionCompletion(condition.id),
      ),
    );
  }


  bool _checkDescriptionTile(SkillDetailModel viewModel, SkillRang rang) {
    final description = viewModel.getDescriptionForRang(rang);
    return description != null && description.isNotEmpty;
  }

  Future _confirmUpgrade(BuildContext context, SkillDetailModel viewModel) async {
    await viewModel.upgradeRank();
  }

  Future _navigateToEdit(BuildContext context) async {
    if (_viewModel.skill == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SkillFormScreen(skill: _viewModel.skill),
      ),
    ).then((result) async {
      if (result == true) {
        
        bool result = await _viewModel.loadSkill(widget.skillId);
        if (!result && context.mounted) {
          Navigator.pop(context);
        }
      }
    });
  }
}