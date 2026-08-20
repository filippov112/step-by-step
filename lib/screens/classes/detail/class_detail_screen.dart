// lib/widgets/achievement_details.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/models/enums/skill_rang.dart';
import 'package:life_game/models/skill.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/classes/detail/class_detail_model.dart';
import 'package:life_game/screens/classes/form/class_form_screen.dart';
import 'package:life_game/services/exp_calculator.dart';
import 'package:life_game/widgets/common/confirm_dialog.dart';
import 'package:life_game/widgets/common/custom_image_icon.dart';
import 'package:life_game/widgets/common/custom_text.dart';
import 'package:life_game/widgets/common/tag_chip.dart';
import 'package:provider/provider.dart';
import 'package:life_game/widgets/common/entity_appbar.dart';



class ClassDetailScreen extends StatefulWidget {
  final Class record;
  const ClassDetailScreen({super.key, required this.record});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {

  late ClassDetailModel model;
  
  @override
  void initState() {
    super.initState();
    model = context.read<ClassDetailModel>();
    model.setClass(widget.record);
  }

  @override
  Widget build(BuildContext context) {

    var record = context.select<ClassDetailModel,Class>((model) => model.record);

    var description = context.select<ClassDetailModel,String>((model) => model.record.description);
    var title = context.select<ClassDetailModel,String>((model) => model.record.title);
    var icon = context.select<ClassDetailModel,String?>((model) => model.record.icon);
    var tags = context.select<ClassDetailModel,List<Tag>>((model) => model.tags);

    var deleteThis = model.deleteThis;

    return Scaffold(
      appBar: buildAppBar(
        'Класс', 
        editCallback: () => _edit(model, record), 
        deleteCallback: () => _deleteThis(deleteThis)
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children:[ 
          
          Expanded(
            child: ListView(
              children: [
                Padding(padding: EdgeInsetsGeometry.all(16), child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    Center(child: CustomImageIcon(
                        icon, 
                        icon: Icons.emoji_events, 
                        width: 60, height: 60,
                        // color: rarity.color,
                        borderWidth: 2,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Заголовок с иконкой
                    CustomText(
                      title, 
                      size: 22, 
                      align: TextAlign.center, 
                      lines: null,
                      weight: FontWeight.bold,
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 16),

                    // Прогресс
                    _buildProgressCard(model),

                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),

                    // Описание
                    if (description.isNotEmpty)
                      Container(
                        height: 150,
                        padding: EdgeInsets.only(bottom: 16),
                        child: ListView(
                          children: [
                            CustomText(
                              description, 
                              lines: null, 
                              overflow: TextOverflow.visible
                            ),
                          ],
                        ), 
                      ),
                
                      // Теги
                      if (tags.isNotEmpty) ...{
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tags.map((tag) =>TagChip(title: tag.title)).toList(),
                        ),
                      },

                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),

                      CustomText('Навыки', 
                        size: 18, 
                        color: Theme.of(context).colorScheme.onSurface, 
                        padding: EdgeInsets.fromLTRB(0,0,8,8),
                      ),

                      _buildSkillsCard(model),
                  ],
                ) ,)
              ],
            ),
          )
        ]
      ),
    );
  }

  Widget _buildProgressCard(ClassDetailModel viewModel) {

    final int exp = ExpCalculator.getRemains(viewModel.record.experience) ;
    final int expLevel = ExpCalculator.getLevel(viewModel.record.experience) ;
    final int expReq = ExpCalculator.getRequirements(viewModel.record.experience);
    final expProgress = (exp / expReq).clamp(0.0, 1.0);

    final int time = ExpCalculator.getRemains(viewModel.record.time) ;
    final int timeLevel = ExpCalculator.getLevel(viewModel.record.time) ;
    final int timeReq = ExpCalculator.getRequirements(viewModel.record.time);
    final timeProgress = (time / timeReq).clamp(0.0, 1.0);
    
    return Column(children: [
      CustomText('Экспертность', 
        size: 18, 
        color: Theme.of(context).colorScheme.onSurface, 
        padding: EdgeInsets.fromLTRB(0,0,8,8)
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

  void _edit(ClassDetailModel model, Class cls) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassFormScreen(record: cls),
      ),
    ).then((_) async {
      if (context.mounted) {
        var checkExist = await model.checkExist();
        if (!checkExist && context.mounted) {
          Navigator.pop(context);
          return;
        }
      }
    });
  }

  Future _deleteThis(Future Function() deleteThis) async {
    if (await showConfirmDialog(context) == true && context.mounted) {
      await deleteThis();
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Widget _buildSkillsCard(ClassDetailModel viewModel) {
    var conditions = viewModel.skills.map((condition) {
      return _buildSkillTile(viewModel, condition);
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


  Widget _buildSkillTile(ClassDetailModel viewModel, Skill skill) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsetsGeometry.all(10),
        leading: Container(
          width: 40,
          height: 40,
          margin: EdgeInsetsGeometry.fromLTRB(8,0,0,0),
          decoration: BoxDecoration(
            color: skill.rang.color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              skill.rang.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: skill.rang.color,
              ),
            ),
          ),
        ),
        title: Text(
          skill.title,
          style: TextStyle(
            decoration: null,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }
}