// lib/widgets/achievement_details.dart
import 'package:flutter/material.dart';
import 'package:life_game/models/class.dart';
import 'package:life_game/models/tag.dart';
import 'package:life_game/screens/classes/detail/class_detail_model.dart';
import 'package:life_game/screens/classes/form/class_form_screen.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomImageIcon(
                      icon, 
                      icon: Icons.emoji_events, 
                      width: 60, height: 60,
                      // color: rarity.color,
                      borderWidth: 2,
                    ),

                    // Заголовок с иконкой
          
                    const SizedBox(height: 16),
                
                    CustomText(
                      title, 
                      size: 16, 
                      align: TextAlign.center, 
                      lines: null,
                      weight: FontWeight.bold,
                      overflow: TextOverflow.visible,
                    ),

                    const SizedBox(height: 16),
                    // Описание
                    if (description.isNotEmpty)
                      SizedBox(
                        height: 400,
                        child: ListView(children: [
                          CustomText(
                            description, 
                            lines: null, 
                            overflow: TextOverflow.visible
                          ),
                        ],), 
                      ),
                
                      // Теги
                      if (tags.isNotEmpty) ...{
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: tags.map((tag) =>TagChip(title: tag.title)).toList(),
                        ),
                      },
                  
                      
                  
                  ],
                ) ,)
              ],
            ),
          )
        ]
      ),
    );
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
}